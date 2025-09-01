package com.sigre.asistencia.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.sigre.asistencia.dto.MarcacionRequest;
import com.sigre.asistencia.dto.MarcacionResponse;
import com.sigre.asistencia.entity.AsistenciaHt580;
import com.sigre.asistencia.entity.RacionesSeleccionadas;
import com.sigre.asistencia.entity.TicketAsistencia;
import com.sigre.asistencia.repository.AsistenciaHt580Repository;
import com.sigre.asistencia.repository.RacionesSeleccionadasRepository;
import com.sigre.asistencia.repository.TicketAsistenciaRepository;
import com.sigre.asistencia.service.ValidacionTrabajadorService.ResultadoValidacion;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

/**
 * Servicio principal para manejo de tickets de asistencia
 * Implementa cola de alta concurrencia con procesamiento asíncrono
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class TicketAsistenciaService {
    
    private final TicketAsistenciaRepository ticketRepository;
    private final ValidacionTrabajadorService validacionService;
    private final AsistenciaHt580Repository asistenciaRepository;
    private final RacionesSeleccionadasRepository racionesRepository;
    private final NotificacionErrorService notificacionService; // Para envío de emails de error
    private final ObjectMapper objectMapper;
    
    /**
     * Método principal: Crear ticket de forma INMEDIATA (alta concurrencia)
     * Retorna ticket al frontend sin esperar procesamiento
     */
    @Transactional
    public MarcacionResponse crearTicketMarcacion(MarcacionRequest request) {
        try {
            log.info("🎫 Creando ticket para código: {} | IP: {}", request.getCodigoInput(), request.getDireccionIp());
            
            // PASO 1: Validación inmediata del trabajador
            ResultadoValidacion validacion = validacionService.validarCodigo(request.getCodigoInput());
            
            if (!validacion.isValido()) {
                log.warn("❌ Validación fallida para código: {} | Error: {}", request.getCodigoInput(), validacion.getMensajeError());
                return MarcacionResponse.error(validacion.getMensajeError(), request.getCodigoInput());
            }
            
            // PASO 2: Crear ticket en la cola
            TicketAsistencia ticket = TicketAsistencia.builder()
                    .codigoInput(request.getCodigoInput())
                    .tipoInput(validacion.getTipoInput())
                    .codTrabajador(validacion.getTrabajador().getCodTrabajador())
                    .nombreTrabajador(validacion.getTrabajador().getNombreCompleto())
                    .tipoMarcaje(request.getTipoMarcaje())
                    .tipoMovimiento(request.getTipoMovimiento())
                    .direccionIp(request.getDireccionIp())
                    .racionesSeleccionadas(convertirRacionesAJson(request.getRacionesSeleccionadas()))
                    .fechaMarcacion(request.getFechaMarcacion() != null ? request.getFechaMarcacion() : LocalDateTime.now())
                    .estadoProcesamiento("PENDIENTE")
                    .usuarioSistema("work")
                    .intentosProcesamiento(0)
                    .build();
            
            // GUARDAR TICKET INMEDIATAMENTE
            ticket = ticketRepository.save(ticket);
            log.info("✅ Ticket {} creado exitosamente para trabajador: {} - {}", 
                    ticket.getTicketId(), ticket.getCodTrabajador(), ticket.getNombreTrabajador());
            
            // PASO 3: Lanzar procesamiento asíncrono (no esperar)
            procesarTicketAsync(ticket.getTicketId());
            
            // PASO 4: Retornar respuesta INMEDIATA al frontend
            return MarcacionResponse.exitoso(
                    ticket.getTicketId(),
                    ticket.getNombreTrabajador(),
                    ticket.getCodTrabajador()
            );
            
        } catch (Exception e) {
            log.error("❌ Error crítico al crear ticket para código: {}", request.getCodigoInput(), e);
            
            // Enviar notificación por email del error crítico
            try {
                notificacionService.enviarErrorTicket(request.getCodigoInput(), e.getMessage());
            } catch (Exception emailError) {
                log.error("❌ Error adicional al enviar notificación de email", emailError);
            }
            
            return MarcacionResponse.error(
                    "Error interno del sistema. Se ha notificado al administrador.",
                    request.getCodigoInput()
            );
        }
    }
    
    /**
     * Procesamiento asíncrono del ticket (NO BLOQUEA al frontend)
     */
    @Async
    @Transactional
    public CompletableFuture<Void> procesarTicketAsync(Long ticketId) {
        try {
            log.info("🔄 Iniciando procesamiento asíncrono del ticket: {}", ticketId);
            
            TicketAsistencia ticket = ticketRepository.findById(ticketId)
                    .orElseThrow(() -> new RuntimeException("Ticket no encontrado: " + ticketId));
            
            // Marcar como procesando
            ticket.marcarComoProcesando();
            ticketRepository.save(ticket);
            
            // PASO 1: Crear registro de asistencia
            String idAsistencia = crearRegistroAsistencia(ticket);
            
            // PASO 2: Crear registros de raciones (si aplica)
            String idsRaciones = crearRegistrosRaciones(ticket, idAsistencia);
            
            // PASO 3: Marcar ticket como completado
            ticket.marcarComoCompletado(idAsistencia, idsRaciones);
            ticketRepository.save(ticket);
            
            log.info("✅ Ticket {} procesado exitosamente | Asistencia: {} | Raciones: {}", 
                    ticketId, idAsistencia, idsRaciones != null ? idsRaciones : "ninguna");
            
        } catch (Exception e) {
            log.error("❌ Error procesando ticket {}", ticketId, e);
            
            // Marcar ticket como error
            try {
                TicketAsistencia ticket = ticketRepository.findById(ticketId).orElse(null);
                if (ticket != null) {
                    ticket.marcarComoError(e.getMessage());
                    ticketRepository.save(ticket);
                    
                    // Enviar notificación por email del error
                    notificacionService.enviarErrorProcesamiento(ticket, e.getMessage());
                }
            } catch (Exception updateError) {
                log.error("❌ Error adicional actualizando estado del ticket", updateError);
            }
        }
        
        return CompletableFuture.completedFuture(null);
    }
    
    /**
     * Crear registro en asistencia_ht580
     */
    private String crearRegistroAsistencia(TicketAsistencia ticket) {
        try {
            // Generar RECKEY único
            String reckey = generarReckeyUnico();
            
            AsistenciaHt580 asistencia = AsistenciaHt580.builder()
                    .reckey(reckey)
                    .codOrigen("01") // Código origen para marcaciones web
                    .codigo(ticket.getCodTrabajador())
                    .flagInOut(determinarFlagInOut(ticket.getTipoMovimiento()))
                    .fechaRegistro(LocalDateTime.now())
                    .fechaMovimiento(ticket.getFechaMarcacion())
                    .codUsuario(ticket.getUsuarioSistema())
                    .direccionIp(ticket.getDireccionIp())
                    .flagVerifyType("1") // Web validation
                    .turno(determinarTurno(ticket.getFechaMarcacion()))
                    .lecturaPda(null) // No aplica para web
                    .build(); // Campos de sync solo están en sync-service, no en asistencia-service
            
            asistencia = asistenciaRepository.save(asistencia);
            log.info("✅ Asistencia creada: {} para trabajador: {}", reckey, ticket.getCodTrabajador());
            
            return reckey;
            
        } catch (Exception e) {
            log.error("❌ Error creando registro de asistencia para ticket: {}", ticket.getTicketId(), e);
            throw new RuntimeException("Error creando registro de asistencia", e);
        }
    }
    
    /**
     * Crear registros en raciones_seleccionadas (si aplica)
     */
    private String crearRegistrosRaciones(TicketAsistencia ticket, String idAsistencia) {
        try {
            if (ticket.getRacionesSeleccionadas() == null || ticket.getRacionesSeleccionadas().trim().isEmpty()) {
                log.info("ℹ️ No hay raciones para procesar en ticket: {}", ticket.getTicketId());
                return null;
            }
            
            List<MarcacionRequest.RacionSeleccionada> raciones = 
                    objectMapper.readValue(ticket.getRacionesSeleccionadas(), 
                            objectMapper.getTypeFactory().constructCollectionType(List.class, MarcacionRequest.RacionSeleccionada.class));
            
            List<String> idsGenerados = new ArrayList<>();
            
            for (MarcacionRequest.RacionSeleccionada racionDto : raciones) {
                RacionesSeleccionadas racion = RacionesSeleccionadas.builder()
                        .codTrabajador(ticket.getCodTrabajador())
                        .tipoRacion(racionDto.getTipoRacion())
                        .fecha(LocalDateTime.parse(racionDto.getFechaServicio()).toLocalDate()) // Parse String ISO y truncar a fecha
                        .direccionIp(ticket.getDireccionIp())
                        .codUsuario(ticket.getUsuarioSistema())
                        .fechaRegistro(LocalDateTime.now())
                        .idAsistenciaReferencia(idAsistencia) // Referencia al registro de asistencia
                        .flagEstado("1") // Activo
                        .build();
                
                racion = racionesRepository.save(racion);
                idsGenerados.add(racion.getIdRacionComedor().toString());
                
                log.info("✅ Ración {} creada para trabajador: {} | Fecha servicio: {}", 
                        racionDto.getTipoRacion(), ticket.getCodTrabajador(), 
                        LocalDateTime.parse(racionDto.getFechaServicio()).toLocalDate());
            }
            
            String resultado = String.join(",", idsGenerados);
            log.info("✅ {} raciones creadas exitosamente para ticket: {}", idsGenerados.size(), ticket.getTicketId());
            
            return resultado;
            
        } catch (Exception e) {
            log.error("❌ Error creando registros de raciones para ticket: {}", ticket.getTicketId(), e);
            throw new RuntimeException("Error creando registros de raciones", e);
        }
    }
    
    /**
     * Generar RECKEY único para asistencia_ht580
     */
    private String generarReckeyUnico() {
        String reckey;
        do {
            reckey = UUID.randomUUID().toString().replace("-", "").substring(0, 12).toUpperCase();
        } while (asistenciaRepository.existsByReckey(reckey));
        
        return reckey;
    }
    
    /**
     * Determinar flag IN/OUT según tipo de movimiento
     */
    private String determinarFlagInOut(String tipoMovimiento) {
        switch (tipoMovimiento) {
            case "INGRESO_PLANTA":
            case "INGRESO_AREA":
            case "INGRESO_COMEDOR":
                return "E"; // Entrada
            case "SALIDA_PLANTA":
            case "SALIDA_AREA":
            case "SALIDA_COMEDOR":
                return "S"; // Salida
            default:
                return "E"; // Por defecto entrada
        }
    }
    
    /**
     * Determinar turno según hora
     */
    private String determinarTurno(LocalDateTime fecha) {
        int hora = fecha.getHour();
        if (hora >= 6 && hora < 14) {
            return "MAÑANA";
        } else if (hora >= 14 && hora < 22) {
            return "TARDE";
        } else {
            return "NOCHE";
        }
    }
    
    /**
     * Convertir lista de raciones a JSON
     */
    private String convertirRacionesAJson(List<MarcacionRequest.RacionSeleccionada> raciones) {
        try {
            if (raciones == null || raciones.isEmpty()) {
                return null;
            }
            return objectMapper.writeValueAsString(raciones);
        } catch (Exception e) {
            log.error("Error convirtiendo raciones a JSON", e);
            return null;
        }
    }
}
