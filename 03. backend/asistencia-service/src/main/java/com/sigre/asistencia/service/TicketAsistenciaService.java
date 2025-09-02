package com.sigre.asistencia.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.sigre.asistencia.dto.MarcacionRequest;
import com.sigre.asistencia.dto.MarcacionResponse;
import com.sigre.asistencia.entity.AsistenciaHt580;
import com.sigre.asistencia.entity.RacionesSeleccionadas;
import com.sigre.asistencia.entity.TicketAsistencia;
import com.sigre.asistencia.entity.TicketRacionGenerada;
import com.sigre.asistencia.repository.AsistenciaHt580Repository;
import com.sigre.asistencia.repository.RacionesSeleccionadasRepository;
import com.sigre.asistencia.repository.TicketAsistenciaRepository;
import com.sigre.asistencia.repository.TicketRacionGeneradaRepository;
import com.sigre.asistencia.service.ValidacionTrabajadorService.ResultadoValidacion;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
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
@Slf4j
public class TicketAsistenciaService {
    
    @Autowired
    private TicketAsistenciaRepository ticketRepository;
    
    @Autowired
    private ValidacionTrabajadorService validacionService;
    
    @Autowired
    private AsistenciaHt580Repository asistenciaRepository;
    
    @Autowired
    private RacionesSeleccionadasRepository racionesRepository;
    
    @Autowired
    private TicketRacionGeneradaRepository ticketRacionRepository;
    
    @Autowired
    private GeneradorNumeroTicketService generadorNumeroService;
    
    @Autowired
    private TurnoService turnoService;
    
    @Autowired(required = false) // Opcional - no bloquear si no está configurado
    private NotificacionErrorService notificacionService;
    
    @Autowired
    private ObjectMapper objectMapper;
    
    /**
     * Método principal: Crear ticket de forma INMEDIATA (alta concurrencia)
     * Retorna ticket al frontend sin esperar procesamiento
     */
    @Transactional
    public MarcacionResponse crearTicketMarcacion(MarcacionRequest request) {
        long inicioTiempo = System.currentTimeMillis();
        try {
            log.info("🎫 Creando ticket para código: {} | IP: {}", request.getCodigoInput(), request.getDireccionIp());
            
            // PASO 1: Validación inmediata del trabajador
            long inicioValidacion = System.currentTimeMillis();
            ResultadoValidacion validacion = validacionService.validarCodigo(request.getCodigoInput());
            long tiempoValidacion = System.currentTimeMillis() - inicioValidacion;
            log.info("⏱️ Validación completada en: {} ms", tiempoValidacion);
            
            if (!validacion.isValido()) {
                log.warn("❌ Validación fallida para código: {} | Error: {}", request.getCodigoInput(), validacion.getMensajeError());
                return MarcacionResponse.error(validacion.getMensajeError(), request.getCodigoInput());
            }
            
            // PASO 2: Generar número de ticket único
            long inicioGeneracion = System.currentTimeMillis();
            String numeroTicket = generadorNumeroService.generarNumeroTicket(request.getCodOrigen());
            long tiempoGeneracion = System.currentTimeMillis() - inicioGeneracion;
            log.info("⏱️ Número de ticket generado en: {} ms | Ticket: {}", tiempoGeneracion, numeroTicket);
            
            // PASO 3: Crear ticket en la cola
            LocalDateTime ahora = LocalDateTime.now();
            TicketAsistencia ticket = TicketAsistencia.builder()
                    .numeroTicket(numeroTicket) // PK generada
                    .codigoInput(request.getCodigoInput())
                    .tipoInput(validacion.getTipoInput())
                    .codOrigen(request.getCodOrigen())
                    .codTrabajador(validacion.getTrabajador().getCodTrabajador())
                    .nombreTrabajador(validacion.getTrabajador().getNombreCompleto())
                    .tipoMarcaje(request.getTipoMarcaje())
                    .tipoMovimiento(request.getTipoMovimiento())
                    .direccionIp(request.getDireccionIp())
                    .racionesSeleccionadas(convertirRacionesAJson(request.getRacionesSeleccionadas()))
                    .fechaMarcacion(request.getFechaMarcacion() != null ? request.getFechaMarcacion() : ahora)
                    .estadoProcesamiento("P") // P = Pendiente
                    .usuarioSistema("work")
                    .intentosProcesamiento(0)
                    .fechaCreacion(ahora) // Setear explícitamente para evitar null
                    .build();
            
            // GUARDAR TICKET INMEDIATAMENTE
            long inicioGuardado = System.currentTimeMillis();
            ticket = ticketRepository.save(ticket);
            long tiempoGuardado = System.currentTimeMillis() - inicioGuardado;
            log.info("⏱️ Ticket guardado en BD en: {} ms | Ticket: {}", tiempoGuardado, ticket.getNumeroTicket());
            
            // PASO 4: Lanzar procesamiento asíncrono (NO ESPERAR)
            long inicioAsync = System.currentTimeMillis();
            procesarTicketAsync(ticket.getNumeroTicket());
            long tiempoAsync = System.currentTimeMillis() - inicioAsync;
            log.info("⏱️ Procesamiento asíncrono lanzado en: {} ms", tiempoAsync);
            
            // PASO 5: Retornar respuesta INMEDIATA al frontend
            long tiempoTotal = System.currentTimeMillis() - inicioTiempo;
            log.info("⚡ TICKET {} CREADO COMPLETAMENTE EN: {} ms", ticket.getNumeroTicket(), tiempoTotal);
            
            return MarcacionResponse.exitoso(
                    ticket.getNumeroTicket(),
                    ticket.getNombreTrabajador(),
                    ticket.getCodTrabajador()
            );
            
        } catch (Exception e) {
            log.error("❌ Error crítico al crear ticket para código: {}", request.getCodigoInput(), e);
            
            // Enviar notificación por email del error crítico (si está configurado)
            try {
                if (notificacionService != null) {
                    notificacionService.enviarErrorTicket(request.getCodigoInput(), e.getMessage());
                } else {
                    log.info("📧 NotificacionErrorService no configurado - error registrado en logs");
                }
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
    public CompletableFuture<Void> procesarTicketAsync(String numeroTicket) {
        try {
            log.info("🔄 Iniciando procesamiento asíncrono del ticket: {}", numeroTicket);
            
            TicketAsistencia ticket = ticketRepository.findById(numeroTicket)
                    .orElseThrow(() -> new RuntimeException("Ticket no encontrado: " + numeroTicket));
            
            // Marcar como procesando
            ticket.marcarComoProcesando();
            ticketRepository.save(ticket);
            
            // PASO 1: Crear registro de asistencia
            String idAsistencia = crearRegistroAsistencia(ticket);
            
            // PASO 2: Crear registros de raciones y asociaciones (si aplica)
            crearRegistrosRaciones(ticket, idAsistencia);
            
            // PASO 3: Marcar ticket como completado
            ticket.marcarComoCompletado(idAsistencia);
            ticketRepository.save(ticket);
            
            // PASO 4: Obtener información de raciones para logging
            List<Long> racionIds = ticketRacionRepository.findRacionIdsByNumeroTicket(numeroTicket);
            log.info("✅ Ticket {} procesado exitosamente | Asistencia: {} | Raciones: {}", 
                    numeroTicket, idAsistencia, racionIds.size() > 0 ? racionIds.toString() : "ninguna");
            
        } catch (Exception e) {
            log.error("❌ Error procesando ticket {}", numeroTicket, e);
            
            // Marcar ticket como error
            try {
                TicketAsistencia ticket = ticketRepository.findById(numeroTicket).orElse(null);
                if (ticket != null) {
                    ticket.marcarComoError(e.getMessage());
                    ticketRepository.save(ticket);
                    
                    // Enviar notificación por email del error (si está configurado)
                    if (notificacionService != null) {
                        notificacionService.enviarErrorProcesamiento(ticket, e.getMessage());
                    } else {
                        log.info("📧 NotificacionErrorService no configurado - error registrado en logs");
                    }
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
                    .turno(turnoService.determinarTurnoActual(ticket.getFechaMarcacion()))
                    .lecturaPda(null) // No aplica para web
                    .build(); // Campos de sync solo están en sync-service, no en asistencia-service
            
            asistencia = asistenciaRepository.save(asistencia);
            log.info("✅ Asistencia creada: {} para trabajador: {}", reckey, ticket.getCodTrabajador());
            
            return reckey;
            
        } catch (Exception e) {
            log.error("❌ Error creando registro de asistencia para ticket: {}", ticket.getNumeroTicket(), e);
            throw new RuntimeException("Error creando registro de asistencia", e);
        }
    }
    
    /**
     * Crear registros en raciones_seleccionadas y asociarlos al ticket via tabla intermedia
     */
    private void crearRegistrosRaciones(TicketAsistencia ticket, String idAsistencia) {
        try {
            if (ticket.getRacionesSeleccionadas() == null || ticket.getRacionesSeleccionadas().trim().isEmpty()) {
                log.info("ℹ️ No hay raciones para procesar en ticket: {}", ticket.getNumeroTicket());
                return;
            }
            
            List<MarcacionRequest.RacionSeleccionada> raciones = 
                    objectMapper.readValue(ticket.getRacionesSeleccionadas(), 
                            objectMapper.getTypeFactory().constructCollectionType(List.class, MarcacionRequest.RacionSeleccionada.class));
            
            int racionesCreadas = 0;
            
            for (MarcacionRequest.RacionSeleccionada racionDto : raciones) {
                // PASO 1: Crear registro de ración
                RacionesSeleccionadas racion = RacionesSeleccionadas.builder()
                        .codTrabajador(ticket.getCodTrabajador())
                        .tipoRacion(racionDto.getTipoRacion())
                        .fecha(parsearFechaISO(racionDto.getFechaServicio()))
                        .direccionIp(ticket.getDireccionIp())
                        .codUsuario(ticket.getUsuarioSistema())
                        .fechaRegistro(LocalDateTime.now())
                        .idAsistenciaReferencia(idAsistencia) // Referencia al registro de asistencia
                        .flagEstado("1") // Activo
                        .build();
                
                racion = racionesRepository.save(racion);
                
                // PASO 2: Crear asociación en tabla intermedia
                TicketRacionGenerada asociacion = TicketRacionGenerada.builder()
                        .numeroTicket(ticket.getNumeroTicket())
                        .racionComedorId(racion.getIdRacionComedor())
                        .build();
                
                ticketRacionRepository.save(asociacion);
                racionesCreadas++;
                
                log.info("✅ Ración {} creada y asociada | Trabajador: {} | Fecha: {} | ID: {}", 
                        racionDto.getTipoRacion(), ticket.getCodTrabajador(), 
                        parsearFechaISO(racionDto.getFechaServicio()),
                        racion.getIdRacionComedor());
            }
            
            log.info("✅ {} raciones creadas y asociadas exitosamente para ticket: {}", 
                    racionesCreadas, ticket.getNumeroTicket());
            
        } catch (Exception e) {
            log.error("❌ Error creando registros de raciones para ticket: {}", ticket.getNumeroTicket(), e);
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
     * Parsear fecha ISO desde frontend (maneja formato con 'Z')
     * Ejemplo: '2025-09-01T05:00:00.000Z' → LocalDate
     */
    private LocalDate parsearFechaISO(String fechaISO) {
        try {
            if (fechaISO == null || fechaISO.trim().isEmpty()) {
                return LocalDate.now();
            }
            
            // Manejar formato ISO con 'Z' (UTC)
            if (fechaISO.endsWith("Z")) {
                java.time.Instant instant = java.time.Instant.parse(fechaISO);
                return instant.atZone(java.time.ZoneId.systemDefault()).toLocalDate();
            }
            
            // Fallback: intentar parse directo
            return LocalDateTime.parse(fechaISO).toLocalDate();
            
        } catch (Exception e) {
            log.warn("⚠️ Error parseando fecha ISO '{}', usando fecha actual: {}", fechaISO, e.getMessage());
            return LocalDate.now();
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
