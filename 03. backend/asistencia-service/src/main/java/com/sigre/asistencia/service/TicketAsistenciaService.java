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
import com.sigre.asistencia.repository.TurnoRepository;
import com.sigre.asistencia.service.ValidacionTrabajadorService.ResultadoValidacion;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
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
    
    @Autowired
    private TurnoRepository turnoRepository;
    
    @Autowired(required = false) // Opcional - no bloquear si no está configurado
    private NotificacionErrorService notificacionService;
    
    @Autowired
    private ObjectMapper objectMapper;
    
    @Autowired
    private ValidacionHorarioService validacionHorarioService;
    
    @Value("${asistencia.auto-cierre.horas-limite:13}")
    private int autoCierreHoras;
    
    @Value("${asistencia.marcacion.tiempo-minimo-minutos:15}")
    private int tiempoMinimoMinutos;
    
    @Value("${asistencia.sistema.cod-usuario:work}")
    private String codUsuarioSistema;
    
    /**
     * Método principal: Crear ticket de forma INMEDIATA (alta concurrencia)
     * Retorna ticket al frontend sin esperar procesamiento
     */
    @Transactional
    public MarcacionResponse crearTicketMarcacion(MarcacionRequest request) {
        long inicioTiempo = System.currentTimeMillis();
        LocalDateTime ahora = LocalDateTime.now(); // ✅ MOVER DECLARACIÓN AL INICIO
        
        try {
            log.info("🎫 Creando ticket para código: {} | Movimiento: {} | IP: {}", 
                    request.getCodigoInput(), request.getTipoMovimiento(), request.getDireccionIp());
            
            // 🔍 DEBUG FECHA - Mostrar fecha recibida del frontend
            log.info("🔍 DEBUG FECHA - getFechaMarcacion() del request: '{}'", request.getFechaMarcacion());
            log.info("🔍 DEBUG FECHA - Hora actual backend: {}", ahora);
            
            // 🔍 DEBUG FECHA - Mostrar conversión de fecha
            LocalDateTime fechaConvertida = convertirFechaMarcacion(request.getFechaMarcacion(), ahora);
            log.info("🔍 DEBUG FECHA - Fecha después de conversión: {}", fechaConvertida);
            log.info("🔍 DEBUG FECHA - ¿Son iguales? Frontend vs Backend: {} vs {} = {}", 
                    request.getFechaMarcacion(), ahora, 
                    fechaConvertida.equals(ahora) ? "IGUALES" : "DIFERENTES");
            
            // PASO 1: Validación inmediata del trabajador
            long inicioValidacion = System.currentTimeMillis();
            ResultadoValidacion validacion = validacionService.validarCodigo(request.getCodigoInput());
            long tiempoValidacion = System.currentTimeMillis() - inicioValidacion;
            log.info("⏱️ Validación completada en: {} ms", tiempoValidacion);
            
            if (!validacion.isValido()) {
                log.warn("❌ Validación fallida para código: {} | Error: {}", request.getCodigoInput(), validacion.getMensajeError());
                return MarcacionResponse.error(validacion.getMensajeError(), request.getCodigoInput());
            }
            
            // PASO 1.5: Validar horario permitido para el movimiento (SEGURIDAD BACKEND)
            // Los horarios vienen desde el frontend (appsettings.json)
            ValidacionHorarioService.ResultadoValidacionHorario validacionHorario = 
                validacionHorarioService.validarHorarioMovimiento(
                    request.getTipoMovimiento(), 
                    fechaConvertida,
                    request.getHorariosPermitidos()
                );
            
            if (!validacionHorario.isValido()) {
                log.warn("❌ Movimiento fuera de horario permitido | Tipo: {} | Error: {}", 
                        request.getTipoMovimiento(), validacionHorario.getMensajeError());
                return MarcacionResponse.error(validacionHorario.getMensajeError(), request.getCodigoInput());
            }
            
            // PASO 1.6: Verificar y manejar auto-cierre de marcaciones antiguas
            // Nota: Validación de tiempo mínimo ya se hizo en /validar-codigo
            long inicioAutoCierre = System.currentTimeMillis();
            this.procesarAutoCierreSiEsNecesario(validacion.getTrabajador().getCodTrabajador());
            long tiempoAutoCierre = System.currentTimeMillis() - inicioAutoCierre;
            log.info("⏱️ Verificación auto-cierre completada en: {} ms", tiempoAutoCierre);
            
            // PASO 2: Generar número de ticket único
            long inicioGeneracion = System.currentTimeMillis();
            String numeroTicket = generadorNumeroService.generarNumeroTicket(request.getCodOrigen());
            long tiempoGeneracion = System.currentTimeMillis() - inicioGeneracion;
            log.info("⏱️ Número de ticket generado en: {} ms | Ticket: {}", tiempoGeneracion, numeroTicket);
            
            // PASO 3: Crear ticket en la cola
            TicketAsistencia ticket = TicketAsistencia.builder()
                    .numeroTicket(numeroTicket) // PK generada
                    .codigoInput(request.getCodigoInput())
                    .tipoInput(validacion.getTipoInput())
                    .codOrigen(request.getCodOrigen())
                    .codTrabajador(validacion.getTrabajador().getCodTrabajador())
                    .nombreTrabajador(validacion.getTrabajador().getNombreCompleto())
                    .tipoMarcaje(request.getTipoMarcaje()) // ✅ Controller ya envía número 1-2
                    .tipoMovimiento(request.getTipoMovimiento()) // ✅ Controller ya envía número 1-8
                    .direccionIp(request.getDireccionIp())
                    .racionesSeleccionadas(convertirRacionesAJson(request.getRacionesSeleccionadas()))
                    .fechaMarcacion(fechaConvertida) // ✅ Usar fecha ya convertida y loggeada
                    .estadoProcesamiento("P") // P = Pendiente
                    .usuarioSistema(codUsuarioSistema.length() > 6 ? codUsuarioSistema.substring(0, 6) : codUsuarioSistema) // ✅ CHAR(6) límite
                    .intentosProcesamiento(0)
                    .fechaCreacion(ahora) // Setear explícitamente para evitar null
                    .build();
            
            // Debug logging eliminado - problema de tipoMovimiento resuelto
            
            
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
     * NUEVA LÓGICA: Solo marcación 01 calcula turno, las demás heredan turno y reckey_ref
     */
    private String crearRegistroAsistencia(TicketAsistencia ticket) {
        try {
            String tipoMovimiento = ticket.getTipoMovimiento();
            String turnoAsignado;
            String reckeyRef = null;
            
            // LÓGICA SEGÚN TIPO DE MOVIMIENTO
            if ("1".equals(tipoMovimiento)) {
                // TIPO 01 (INGRESO_PLANTA): Calcular turno normalmente
                turnoAsignado = turnoService.determinarTurnoActual(ticket.getFechaMarcacion());
                reckeyRef = null; // No tiene referencia
                
                log.info("📍 Tipo 01 - INGRESO_PLANTA | Turno calculado: {}", turnoAsignado);
                
            } else {
                // TODOS LOS DEMÁS TIPOS (02-10): Heredar turno de la última marcación 01
                Optional<AsistenciaHt580> ultimaMarcacion01 = asistenciaRepository.findUltimaMarcacion01ByTrabajador(ticket.getCodTrabajador());
                
                if (ultimaMarcacion01.isEmpty()) {
                    String error = String.format(
                        "No se encontró una marcación de INGRESO_PLANTA (tipo 01) previa para el trabajador %s. " +
                        "Debe marcar primero el ingreso antes de registrar otros movimientos.",
                        ticket.getCodTrabajador()
                    );
                    log.error("❌ {}", error);
                    throw new RuntimeException(error);
                }
                
                // Heredar turno de la última marcación 01
                turnoAsignado = ultimaMarcacion01.get().getTurno();
                
                // Determinar reckey_ref según el tipo de movimiento
                if ("4".equals(tipoMovimiento)) {
                    // REGRESO_ALMORZAR: buscar última marcación 03
                    reckeyRef = asistenciaRepository.findUltimaMarcacionByTipoAndTrabajador(ticket.getCodTrabajador(), "3")
                        .map(AsistenciaHt580::getReckey)
                        .orElse(ultimaMarcacion01.get().getReckey()); // Fallback a marcación 01
                    log.info("📍 Tipo 04 - REGRESO_ALMORZAR | Turno heredado: {} | Ref a marcación 03", turnoAsignado);
                    
                } else if ("6".equals(tipoMovimiento)) {
                    // RETORNO_COMISION: buscar última marcación 05
                    reckeyRef = asistenciaRepository.findUltimaMarcacionByTipoAndTrabajador(ticket.getCodTrabajador(), "5")
                        .map(AsistenciaHt580::getReckey)
                        .orElse(ultimaMarcacion01.get().getReckey());
                    log.info("📍 Tipo 06 - RETORNO_COMISION | Turno heredado: {} | Ref a marcación 05", turnoAsignado);
                    
                } else if ("8".equals(tipoMovimiento)) {
                    // SALIDA_PRODUCCION: buscar última marcación 07
                    reckeyRef = asistenciaRepository.findUltimaMarcacionByTipoAndTrabajador(ticket.getCodTrabajador(), "7")
                        .map(AsistenciaHt580::getReckey)
                        .orElse(ultimaMarcacion01.get().getReckey());
                    log.info("📍 Tipo 08 - SALIDA_PRODUCCION | Turno heredado: {} | Ref a marcación 07", turnoAsignado);
                    
                } else if ("10".equals(tipoMovimiento)) {
                    // REGRESO_CENAR: buscar última marcación 09
                    reckeyRef = asistenciaRepository.findUltimaMarcacionByTipoAndTrabajador(ticket.getCodTrabajador(), "9")
                        .map(AsistenciaHt580::getReckey)
                        .orElse(ultimaMarcacion01.get().getReckey());
                    log.info("📍 Tipo 10 - REGRESO_CENAR | Turno heredado: {} | Ref a marcación 09", turnoAsignado);
                    
                } else {
                    // TIPOS 02, 03, 05, 07, 09: Referenciar a la última marcación 01
                    reckeyRef = ultimaMarcacion01.get().getReckey();
                    log.info("📍 Tipo {} | Turno heredado: {} | Ref a última marcación 01", tipoMovimiento, turnoAsignado);
                }
            }
            
            // ✅ VALIDACIÓN ANTI-DUPLICADOS - Verificar índice único
            // IX_ASISTENCIA_HT5801: COD_ORIGEN + CODIGO + FLAG_IN_OUT + FEC_MOVIMIENTO + TURNO
            boolean existeDuplicado = asistenciaRepository.existeDuplicado(
                    ticket.getCodOrigen(),
                    ticket.getCodTrabajador(),
                    ticket.getTipoMovimiento(),
                    ticket.getFechaMarcacion().toLocalDate(),
                    turnoAsignado
            );
            
            if (existeDuplicado) {
                String mensajeError = String.format(
                    "❌ DUPLICADO RECHAZADO: Ya existe una marcación para trabajador %s, origen %s, tipo %s, fecha %s, turno %s",
                    ticket.getCodTrabajador(),
                    ticket.getCodOrigen(),
                    ticket.getTipoMovimiento(),
                    ticket.getFechaMarcacion().toLocalDate(),
                    turnoAsignado
                );
                log.warn(mensajeError);
                throw new RuntimeException("Ya existe una marcación idéntica. No se permiten duplicados.");
            }
            
            // Generar RECKEY único
            String reckey = generarReckeyUnico();
            
            AsistenciaHt580 asistencia = AsistenciaHt580.builder()
                    .reckey(reckey)
                    .codOrigen(ticket.getCodOrigen())
                    .codigo(ticket.getCodTrabajador())
                    .flagInOut(ticket.getTipoMovimiento())
                    .fechaRegistro(LocalDateTime.now())  // Cuando se guarda en BD
                    .fecMarcacion(ticket.getFechaMarcacion())  // ✅ Fecha y hora exacta de marcación
                    .fechaMovimiento(ticket.getFechaMarcacion().toLocalDate())  // Solo fecha (índice único)
                    .codUsuario(codUsuarioSistema)
                    .direccionIp(ticket.getDireccionIp())
                    .flagVerifyType("1")
                    .tipoMarcacion(ticket.getTipoMarcaje())
                    .turno(turnoAsignado)  // Turno calculado o heredado
                    .lecturaPda(ticket.getCodigoInput())
                    .reckeyRef(reckeyRef)  // Referencia a marcación relacionada
                    .build();
            
            // 🔍 DEBUG ASISTENCIA - Mostrar fechas que se van a guardar  
            log.info("🔍 DEBUG ASISTENCIA - fechaMovimiento que se guardará: {}", asistencia.getFechaMovimiento());
            log.info("🔍 DEBUG ASISTENCIA - fechaRegistro que se guardará: {}", asistencia.getFechaRegistro());
            log.info("🔍 DEBUG ASISTENCIA - Turno asignado: {} | Reckey_ref: {}", asistencia.getTurno(), asistencia.getReckeyRef());
            
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
                String codTrabajador = ticket.getCodTrabajador();
                String tipoRacion = racionDto.getTipoRacion();
                LocalDate fecha = parsearFechaISO(racionDto.getFechaServicio());
                
                // PASO 1: Verificar si ya existe la ración (constraint único)
                Optional<RacionesSeleccionadas> racionExistenteOpt = racionesRepository
                        .findByCodTrabajadorAndFechaAndTipoRacionAndFlagEstado(
                                codTrabajador, fecha, tipoRacion, "1");
                
                if (racionExistenteOpt.isPresent()) {
                    // Ya existe - NO insertar, usar el existente
                    RacionesSeleccionadas racionExistente = racionExistenteOpt.get();
                    log.info("⚠️ Ración {} ya existe para trabajador {} en fecha {} - ID: {}", 
                            tipoRacion, codTrabajador, fecha, racionExistente.getIdRacionComedor());
                    
                    // Crear asociación con el registro existente
                    TicketRacionGenerada asociacion = TicketRacionGenerada.builder()
                            .numeroTicket(ticket.getNumeroTicket())
                            .racionComedorId(racionExistente.getIdRacionComedor())
                            .build();
                    
                    ticketRacionRepository.save(asociacion);
                    racionesCreadas++;
                    
                } else {
                    // No existe - Crear registro nuevo
                    RacionesSeleccionadas racion = RacionesSeleccionadas.builder()
                            .codTrabajador(codTrabajador)
                            .tipoRacion(tipoRacion)
                            .fecha(fecha)
                            .direccionIp(ticket.getDireccionIp())
                            .codUsuario(ticket.getUsuarioSistema())
                            .fechaRegistro(LocalDateTime.now())
                            .idAsistenciaReferencia(idAsistencia)
                            .flagEstado("1")
                            .build();
                    
                    racion = racionesRepository.save(racion);
                    
                    // Crear asociación en tabla intermedia
                    TicketRacionGenerada asociacion = TicketRacionGenerada.builder()
                            .numeroTicket(ticket.getNumeroTicket())
                            .racionComedorId(racion.getIdRacionComedor())
                            .build();
                    
                    ticketRacionRepository.save(asociacion);
                    racionesCreadas++;
                    
                    log.info("✅ Ración {} creada NUEVA | Trabajador: {} | Fecha: {} | ID: {}", 
                            tipoRacion, codTrabajador, fecha, racion.getIdRacionComedor());
                }
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
    
    // Método eliminado: determinarFlagInOut() ya no se usa, ahora FLAG_IN_OUT contiene números 1-8
    
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
    
    /**
     * Procesar auto-cierre de marcaciones antiguas - MÉTODO ÚNICO
     * Según prompt-ajustes-movimientos.txt: Si hay marcación tipo 1 antigua, crear salida tipo 2
     * DIRECTO en asistencia_ht580 (no tickets) con hora final del turno correspondiente
     * SÍNCRONO para evitar bloqueos - optimizado para múltiple concurrencia
     */
    public synchronized void procesarAutoCierreSiEsNecesario(String codTrabajador) {
        try {
            long inicioTiempo = System.currentTimeMillis();
            
            // Buscar última marcación del trabajador (ordenado por fecha de REGISTRO)
            AsistenciaHt580 ultimaAsistencia = asistenciaRepository
                    .findTopByCodigoOrderByFechaRegistroDesc(codTrabajador)
                    .orElse(null);
            
            if (ultimaAsistencia == null) {
                log.debug("🔄 Sin marcaciones previas para trabajador: {}", codTrabajador);
                return;
            }
            
            // Verificar si es marcación tipo 1 (ingreso) usando FLAG_IN_OUT
            String flagInOut = ultimaAsistencia.getFlagInOut();
            if (flagInOut == null || !"1".equals(flagInOut.trim())) {
                log.debug("🔄 Último movimiento no es ingreso (flag={}) para trabajador {}, sin auto-cierre", 
                         flagInOut, codTrabajador);
                return;
            }
            
            // Calcular horas transcurridas desde la fecha/hora de marcación (no registro)
            long horasTranscurridas = java.time.Duration.between(
                    ultimaAsistencia.getFecMarcacion(), 
                    LocalDateTime.now()
            ).toHours();
            
            if (horasTranscurridas < autoCierreHoras) {
                log.debug("🔄 Marcación reciente ({} h < {} h límite) para trabajador {}, sin auto-cierre", 
                         horasTranscurridas, autoCierreHoras, codTrabajador);
                return;
            }
            
            log.info("🚨 Auto-cierre necesario | Trabajador: {} | Horas: {}/{} | Registro: {}", 
                    codTrabajador, horasTranscurridas, autoCierreHoras, ultimaAsistencia.getFechaRegistro());
            
            // Determinar hora de cierre del turno usando fecha de movimiento y turno de la marcación 01
            LocalDateTime horaCierre = this.calcularHoraCierreTurno(
                    ultimaAsistencia.getFechaMovimiento(), 
                    ultimaAsistencia.getTurno()
            );
            
            // Crear registro de salida automática tipo 2 DIRECTO en asistencia_ht580
            LocalDateTime ahoraPrecisa = LocalDateTime.now();
            
            AsistenciaHt580 salidaAutomatica = AsistenciaHt580.builder()
                    .reckey(UUID.randomUUID().toString().replace("-", "").substring(0, 12))
                    .codOrigen(ultimaAsistencia.getCodOrigen())
                    .codigo(codTrabajador)
                    .fechaRegistro(ahoraPrecisa)  // Cuando se guarda en BD
                    .fecMarcacion(horaCierre)  // ✅ Fecha y hora de cierre del turno
                    .fechaMovimiento(horaCierre.toLocalDate())  // Solo fecha
                    .tipoMarcacion(ultimaAsistencia.getTipoMarcacion())
                    .flagInOut("2") // Movimiento tipo 2 = Salida de planta
                    .codUsuario(codUsuarioSistema)
                    .direccionIp("AUTO-CLOSE")
                    .flagVerifyType("1")
                    .turno(ultimaAsistencia.getTurno())
                    .reckeyRef(ultimaAsistencia.getReckey())  // Referenciar a la marcación 01 que se está cerrando
                    .flagEstado("1")
                    .observaciones(String.format("Auto-cierre - %d horas transcurridas", horasTranscurridas))
                    .build();
            
            log.info("🔍 Creando auto-cierre | Ingreso anterior: {} | Nueva salida: {} | Fecha registro: {}", 
                    ultimaAsistencia.getFechaRegistro(), ahoraPrecisa, ahoraPrecisa);
            
            // GUARDAR DIRECTO en asistencia_ht580 (no en tickets)
            salidaAutomatica = asistenciaRepository.save(salidaAutomatica);
            
            // VERIFICAR que la nueva salida es ahora el último movimiento
            AsistenciaHt580 verificacionUltimoMovimiento = asistenciaRepository
                    .findTopByCodigoOrderByFechaRegistroDesc(codTrabajador)
                    .orElse(null);
            
            long tiempoTotal = System.currentTimeMillis() - inicioTiempo;
            
            if (verificacionUltimoMovimiento != null && 
                verificacionUltimoMovimiento.getReckey().equals(salidaAutomatica.getReckey())) {
                log.info("✅ Auto-cierre ejecutado | Trabajador: {} | NUEVO último movimiento: tipo {} | RECKEY: {} | Tiempo: {} ms", 
                        codTrabajador, verificacionUltimoMovimiento.getFlagInOut(), salidaAutomatica.getReckey(), tiempoTotal);
            } else {
                log.warn("⚠️ Auto-cierre ejecutado pero NO es el último movimiento | Trabajador: {} | RECKEY creado: {} | Último actual: {} | Tiempo: {} ms", 
                        codTrabajador, salidaAutomatica.getReckey(), 
                        verificacionUltimoMovimiento != null ? verificacionUltimoMovimiento.getReckey() + " (tipo " + verificacionUltimoMovimiento.getFlagInOut() + ")" : "NULL",
                        tiempoTotal);
            }
            
            if (tiempoTotal > 500) {
                log.warn("⚠️ Auto-cierre lento ({} ms > 500ms objetivo) para trabajador: {}", tiempoTotal, codTrabajador);
            } else {
                log.info("⚡ Auto-cierre rápido ({} ms < 500ms) para trabajador: {}", tiempoTotal, codTrabajador);
            }
            
        } catch (Exception e) {
            log.error("❌ Error ejecutando auto-cierre para trabajador {}: {}", codTrabajador, e.getMessage(), e);
            // No lanzar excepción - el auto-cierre es opcional, no debe bloquear marcación actual
        }
    }
    
    /**
     * Calcular fecha y hora de cierre del turno
     * 
     * @param fechaMovimientoIngreso Fecha de movimiento de la marcación 01 (LocalDate)
     * @param codigoTurno Código del turno de la marcación 01
     * @return Fecha y hora de cierre calculada
     */
    private LocalDateTime calcularHoraCierreTurno(LocalDate fechaMovimientoIngreso, String codigoTurno) {
        try {
            // Buscar información del turno en la tabla
            Optional<com.sigre.asistencia.entity.Turno> turnoOpt = turnoRepository.findById(codigoTurno);
            
            if (turnoOpt.isEmpty()) {
                String error = String.format("No se encontró turno %s en la base de datos", codigoTurno);
                log.error("❌ {}", error);
                throw new RuntimeException(error);
            }
            
            com.sigre.asistencia.entity.Turno turno = turnoOpt.get();
            
            if (turno.getHoraInicioNorm() == null || turno.getHoraFinalNorm() == null) {
                String error = String.format("Turno %s no tiene horas configuradas", codigoTurno);
                log.error("❌ {}", error);
                throw new RuntimeException(error);
            }
            
            java.time.LocalTime horaInicio = turno.getHoraInicioNorm().toLocalTime();
            java.time.LocalTime horaFin = turno.getHoraFinalNorm().toLocalTime();
            
            LocalDateTime fechaHoraCierre;
            
            // Determinar si es turno nocturno (cruza medianoche)
            if (horaFin.isBefore(horaInicio)) {
                // TURNO NOCTURNO: hora_fin < hora_inicio
                // El cierre es al DÍA SIGUIENTE de la marcación 01
                fechaHoraCierre = fechaMovimientoIngreso.plusDays(1).atTime(horaFin);
                log.info("🌙 Turno nocturno {} | Fecha ingreso: {} | Hora fin: {} | Cierre: {} (día siguiente)", 
                        codigoTurno, fechaMovimientoIngreso, horaFin, fechaHoraCierre);
            } else {
                // TURNO NORMAL: hora_fin > hora_inicio
                // El cierre es el MISMO DÍA de la marcación 01
                fechaHoraCierre = fechaMovimientoIngreso.atTime(horaFin);
                log.info("☀️ Turno normal {} | Fecha ingreso: {} | Hora fin: {} | Cierre: {} (mismo día)", 
                        codigoTurno, fechaMovimientoIngreso, horaFin, fechaHoraCierre);
            }
            
            return fechaHoraCierre;
            
        } catch (Exception e) {
            log.error("❌ Error calculando hora de cierre: {}", e.getMessage(), e);
            throw new RuntimeException("Error al calcular hora de cierre del turno: " + e.getMessage());
        }
    }
    
    /**
     * Proceso programado cada 30 minutos para auto-cierre masivo
     * Busca TODAS las marcaciones tipo 1 con antigüedad >= horas configuradas
     */
    @Scheduled(fixedRate = 30 * 60 * 1000) // 30 minutos en milisegundos
    @Transactional
    public void procesarAutoCierreMasivo() {
        try {
            log.info("🕐 INICIANDO proceso programado de auto-cierre masivo (cada 30 min)");
            
            long inicioTiempo = System.currentTimeMillis();
            
            // PASO 1: Obtener ÚLTIMOS movimientos de TODOS los trabajadores
            List<AsistenciaHt580> ultimosMovimientos = asistenciaRepository.findUltimosMovimientosPorTrabajador();
            
            if (ultimosMovimientos.isEmpty()) {
                log.info("✅ No hay trabajadores con marcaciones para procesar");
                return;
            }
            
            log.info("🔍 Revisando últimos movimientos de {} trabajadores", ultimosMovimientos.size());
            
            int procesadas = 0;
            int revisadas = 0;
            
            for (AsistenciaHt580 ultimoMovimiento : ultimosMovimientos) {
                try {
                    revisadas++;
                    
                    // PASO 2: Verificar SI el último movimiento es tipo 1 (ingreso) usando FLAG_IN_OUT
                    String flagInOut = ultimoMovimiento.getFlagInOut();
                    if (flagInOut == null || !"1".equals(flagInOut.trim())) {
                        log.debug("⏭️ Trabajador {} - último movimiento no es ingreso (flag={}), omitir", 
                                 ultimoMovimiento.getCodigo(), flagInOut);
                        continue;
                    }
                    
                    // PASO 3: Verificar SI han pasado >= autoCierreHoras horas (usar fecha de REGISTRO)
                    long horasTranscurridas = java.time.Duration.between(
                            ultimoMovimiento.getFechaRegistro(), 
                            LocalDateTime.now()
                    ).toHours();
                    
                    if (horasTranscurridas < autoCierreHoras) {
                        log.debug("⏭️ Trabajador {} - marcación reciente ({} horas < {} límite), omitir", 
                                 ultimoMovimiento.getCodigo(), horasTranscurridas, autoCierreHoras);
                        continue;
                    }
                    
                    // PASO 4: Procesar auto-cierre para este trabajador usando MÉTODO ÚNICO
                    log.info("🚨 Procesando auto-cierre programado | Trabajador: {} | Horas: {}/{}", 
                            ultimoMovimiento.getCodigo(), horasTranscurridas, autoCierreHoras);
                    
                    // Usar el MISMO método que la marcación inmediata
                    this.procesarAutoCierreSiEsNecesario(ultimoMovimiento.getCodigo());
                    procesadas++;
                    
                } catch (Exception e) {
                    log.error("❌ Error procesando auto-cierre para trabajador {}: {}", 
                            ultimoMovimiento.getCodigo(), e.getMessage());
                }
            }
            
            long tiempoTotal = System.currentTimeMillis() - inicioTiempo;
            log.info("✅ Proceso auto-cierre masivo completado | Procesadas: {}/{} trabajadores revisados | Tiempo: {} ms", 
                    procesadas, revisadas, tiempoTotal);
            
        } catch (Exception e) {
            log.error("❌ Error en proceso programado de auto-cierre masivo: {}", e.getMessage(), e);
        }
    }
    
    // Métodos duplicados eliminados: ahora solo se usa procesarAutoCierreSiEsNecesario(String codTrabajador)
    
    // Método eliminado: validarTiempoMinimoEntreMarcaciones() - ahora se hace en /validar-codigo
    
    /**
     * Mapear tipo de movimiento del frontend (string) a número (1-10) para FLAG_IN_OUT
     */
    private String mapearTipoMovimientoANumero(String tipoMovimiento) {
        if (tipoMovimiento == null) return "1"; // Por defecto ingreso
        
        return switch (tipoMovimiento.trim()) {
            case "INGRESO_PLANTA" -> "1";
            case "SALIDA_PLANTA" -> "2";
            case "SALIDA_ALMORZAR" -> "3";
            case "REGRESO_ALMORZAR" -> "4";
            case "SALIDA_COMISION" -> "5";
            case "RETORNO_COMISION" -> "6";
            case "INGRESO_PRODUCCION" -> "7";
            case "SALIDA_PRODUCCION" -> "8";
            case "SALIDA_CENAR" -> "9";
            case "REGRESO_CENAR" -> "10";
            default -> {
                log.warn("⚠️ Tipo movimiento no reconocido: '{}', usando 1 por defecto", tipoMovimiento);
                yield "1";
            }
        };
    }
    
    /**
     * Determinar tipo de marcación numérico para campo obligatorio
     */
    private String determinarTipoMarcacion(String tipoMarcaje) {
        if (tipoMarcaje == null) return "1"; // Por defecto puerta principal
        
        return switch (tipoMarcaje.trim()) {
            case "puerta-principal" -> "1";
            case "area-produccion" -> "2";
            default -> {
                log.warn("⚠️ Tipo marcaje no reconocido: '{}', usando 1 por defecto", tipoMarcaje);
                yield "1";
            }
        };
    }
    
    /**
     * Convertir fecha de marcación de String a LocalDateTime
     * Solución para problemas de zona horaria: el frontend envía la fecha como string
     * en formato "dd/MM/yyyy HH:mm:ss" (formato local, sin conversión UTC)
     */
    private LocalDateTime convertirFechaMarcacion(String fechaMarcacionString, LocalDateTime fechaPorDefecto) {
        if (fechaMarcacionString == null || fechaMarcacionString.trim().isEmpty()) {
            log.warn("⚠️ Fecha de marcación nula o vacía, usando fecha actual del servidor");
            return fechaPorDefecto;
        }
        
        log.info("🔍 DEBUG Fecha - String recibido: '{}'", fechaMarcacionString);
        log.info("🔍 DEBUG Fecha - Fecha por defecto: {}", fechaPorDefecto);
        
        try {
            // Parsear formato: dd/MM/yyyy HH:mm:ss (formato estándar del frontend)
            java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
            LocalDateTime fechaParseada = LocalDateTime.parse(fechaMarcacionString.trim(), formatter);
            
            log.info("🕐 Fecha de marcación convertida: '{}' -> {}", fechaMarcacionString, fechaParseada);
            
            // Verificar si la fecha parseada es lógica (no en el pasado lejano ni futuro lejano)
            if (fechaParseada.isBefore(LocalDateTime.now().minusDays(1)) || 
                fechaParseada.isAfter(LocalDateTime.now().plusDays(1))) {
                log.warn("⚠️ Fecha parseada fuera de rango lógico: {}, usando fecha del servidor", fechaParseada);
                return fechaPorDefecto;
            }
            
            return fechaParseada;
            
        } catch (Exception e) {
            log.error("❌ Error parseando fecha de marcación: '{}', usando fecha del servidor. Error: {}", 
                     fechaMarcacionString, e.getMessage());
            return fechaPorDefecto;
        }
    }
}
