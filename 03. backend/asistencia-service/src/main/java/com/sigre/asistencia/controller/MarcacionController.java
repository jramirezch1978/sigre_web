package com.sigre.asistencia.controller;

import com.sigre.asistencia.dto.MarcacionRequest;
import com.sigre.asistencia.dto.MarcacionResponse;
import com.sigre.asistencia.entity.AsistenciaHt580;
import com.sigre.asistencia.repository.AsistenciaHt580Repository;
import com.sigre.asistencia.service.TicketAsistenciaService;
import com.sigre.asistencia.service.ValidacionTrabajadorService;
import com.sigre.config.service.ConfiguracionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.Map;

/**
 * Controlador REST para marcaciones de asistencia
 * API asíncrona de alta concurrencia
 */
@RestController
@RequestMapping("/") // Ruta raíz - el API Gateway ya maneja /api/asistencia
@RequiredArgsConstructor
@Slf4j
// CORS manejado por API Gateway - no duplicar headers
public class MarcacionController {
    
    private final TicketAsistenciaService ticketService;
    private final ValidacionTrabajadorService validacionService;
    private final AsistenciaHt580Repository asistenciaRepository;
    private final ConfiguracionService configuracionService;
    
    @Value("${asistencia.auto-cierre.horas-limite:13}")
    private int autoCierreHoras;
    
    /**
     * API asíncrona para procesar marcaciones
     * Retorna ticket inmediatamente, procesamiento en background
     */
    @PostMapping("/procesar")
    public ResponseEntity<MarcacionResponse> procesarMarcacion(
            @RequestBody MarcacionRequest request,
            HttpServletRequest httpRequest) {
        
        try {
            log.info("📥 Nueva solicitud de marcación - Código: {} | Tipo: {} | IP: {}", 
                    request.getCodigoInput(), request.getTipoMarcaje(), request.getDireccionIp());
            
            // 🔍 DEBUG FRONTEND - Ver todos los valores que llegan del frontend
            log.info("🔍 DEBUG Frontend - codigoInput: '{}' (len={})", request.getCodigoInput(), request.getCodigoInput() != null ? request.getCodigoInput().length() : "null");
            log.info("🔍 DEBUG Frontend - codOrigen: '{}' (len={})", request.getCodOrigen(), request.getCodOrigen() != null ? request.getCodOrigen().length() : "null");
            log.info("🔍 DEBUG Frontend - tipoMarcaje: '{}' (len={})", request.getTipoMarcaje(), request.getTipoMarcaje() != null ? request.getTipoMarcaje().length() : "null");
            log.info("🔍 DEBUG Frontend - tipoMovimiento: '{}' (len={})", request.getTipoMovimiento(), request.getTipoMovimiento() != null ? request.getTipoMovimiento().length() : "null");
            log.info("🔍 DEBUG Frontend - direccionIp: '{}' (len={})", request.getDireccionIp(), request.getDireccionIp() != null ? request.getDireccionIp().length() : "null");
            log.info("🔍 DEBUG Frontend - fechaMarcacion RAW: '{}'", request.getFechaMarcacion());
            log.info("🔍 DEBUG Frontend - Hora actual backend: {}", LocalDateTime.now());
            
            // ✅ MAPEAR a números ANTES de enviar al service
            String tipoMarcajeNumerico = mapearTipoMarcajeANumero(request.getTipoMarcaje());
            String tipoMovimientoNumerico = mapearTipoMovimientoANumero(request.getTipoMovimiento());
            
            log.info("🔍 DEBUG Mapeo - tipoMarcaje: '{}' → '{}' (len={})", request.getTipoMarcaje(), tipoMarcajeNumerico, tipoMarcajeNumerico.length());
            log.info("🔍 DEBUG Mapeo - tipoMovimiento: '{}' → '{}' (len={})", request.getTipoMovimiento(), tipoMovimientoNumerico, tipoMovimientoNumerico.length());
            
            // Crear request con valores numéricos
            MarcacionRequest requestNumerico = MarcacionRequest.builder()
                    .codigoInput(request.getCodigoInput())
                    .codOrigen(request.getCodOrigen())
                    .tipoMarcaje(tipoMarcajeNumerico)  // ✅ NÚMERO 1-2
                    .tipoMovimiento(tipoMovimientoNumerico)  // ✅ NÚMERO 1-10
                    .direccionIp(request.getDireccionIp())
                    .fechaMarcacion(request.getFechaMarcacion())
                    .racionesSeleccionadas(request.getRacionesSeleccionadas())
                    .build();
            
            // Validar request básico (con request original)
            if (request.getCodigoInput() == null || request.getCodigoInput().trim().isEmpty()) {
                return ResponseEntity.badRequest()
                        .body(MarcacionResponse.error("Código de entrada requerido", ""));
            }
            
            if (request.getTipoMarcaje() == null || request.getTipoMovimiento() == null) {
                return ResponseEntity.badRequest()
                        .body(MarcacionResponse.error("Tipo de marcaje y movimiento requeridos", request.getCodigoInput()));
            }
            
            // Complementar información faltante
            if (request.getFechaMarcacion() == null || request.getFechaMarcacion().trim().isEmpty()) {
            // Si no viene fecha del frontend, usar la hora actual del servidor en formato String
            LocalDateTime ahora = LocalDateTime.now();
            String fechaFormateada = ahora.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
            request.setFechaMarcacion(fechaFormateada);
            }
            
            // Si no viene IP, intentar obtenerla del request
            if (request.getDireccionIp() == null || request.getDireccionIp().trim().isEmpty()) {
                request.setDireccionIp(obtenerIpReal(httpRequest));
            }
            
            // Crear ticket (INMEDIATO - No bloquea) con valores ya mapeados a números
            MarcacionResponse response = ticketService.crearTicketMarcacion(requestNumerico);
            
            if (response.isError()) {
                log.warn("⚠️ Error en validación: {}", response.getMensajeError());
                return ResponseEntity.badRequest().body(response);
            }
            
            log.info("✅ Ticket {} creado exitosamente para trabajador: {}", 
                    response.getNumeroTicket(), response.getNombreTrabajador());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("❌ Error crítico en endpoint de marcación", e);
            
            MarcacionResponse errorResponse = MarcacionResponse.error(
                    "Error interno del servidor. Se ha notificado al administrador.",
                    request != null ? request.getCodigoInput() : "N/A"
            );
            
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }
    
    /**
     * API para validar código antes de mostrar popups (opcional - para UX mejorada)
     */
    @PostMapping("/validar-codigo")
    public ResponseEntity<?> validarCodigoPost(@RequestBody ValidarCodigoRequest request) {
        try {
            log.info("🔍 [POST] Validando código: {}", request.getCodigo());
            
            // Leer tiempo mínimo desde tabla CONFIGURACION (patrón PowerBuilder: auto-insert si no existe)
            int tiempoMinimoMinutos = configuracionService.getParametroInt("ASISTENCIA_TIEMPO_MINIMO_MIN", 15);
            
            var resultado = validacionService.validarCodigo(request.getCodigo());
            
            if (!resultado.isValido()) {
                return ResponseEntity.ok(ValidarCodigoResponse.builder()
                        .valido(false)
                        .mensajeError(resultado.getMensajeError())
                        .build());
            }
            
            // ✅ Trabajador válido - LÓGICA INTELIGENTE: auto-cierre vs tiempo mínimo
            String codTrabajador = resultado.getTrabajador().getCodTrabajador();
            String codOrigen = request.getCodOrigen();
            
            // PASO 1: Obtener último movimiento del trabajador (por código Y origen, con filtros)
            AsistenciaHt580 ultimaAsistencia = asistenciaRepository
                    .findUltimaMarcacionConFiltrosByTrabajador(codTrabajador, codOrigen)
                    .orElse(null);
            
            boolean seProcesaAutoCierre = false;
            
            if (ultimaAsistencia != null) {
                // Verificar tipo de movimiento
                String flagInOut = ultimaAsistencia.getFlagInOut();
                boolean esIngreso = "1".equals(flagInOut != null ? flagInOut.trim() : "");
                
                if (esIngreso) {
                    // PASO 2a: Es ingreso a planta (tipo 1) - verificar solo auto-cierre
                    long horasTranscurridas = java.time.Duration.between(
                            ultimaAsistencia.getFecMarcacion(), 
                            LocalDateTime.now()
                    ).toHours();
                    
                    if (horasTranscurridas >= autoCierreHoras) {
                        log.info("🔄 Ejecutando auto-cierre | Trabajador: {} | Horas: {}/{}", 
                                codTrabajador, horasTranscurridas, autoCierreHoras);
                        
                        try {
                            ticketService.procesarAutoCierreSiEsNecesario(codTrabajador, codOrigen);
                            seProcesaAutoCierre = true;
                            log.info("✅ Auto-cierre completado | Trabajador: {}", codTrabajador);
                            
                            ultimaAsistencia = asistenciaRepository
                                    .findUltimaMarcacionConFiltrosByTrabajador(codTrabajador, codOrigen)
                                    .orElse(null);
                        } catch (Exception e) {
                            log.error("❌ Error en auto-cierre | Trabajador: {}: {}", codTrabajador, e.getMessage(), e);
                        }
                    }
                    // Después de tipo 1 NO se valida tiempo mínimo:
                    // el siguiente movimiento siempre es de tipo diferente (2,3,5,7,9)
                    // y el popup de movimientos ya controla la secuencia válida.
                    // Esto permite que tras marcar ingreso a planta, el trabajador
                    // pueda ingresar a producción sin esperar el tiempo mínimo.
                    log.info("✅ Tipo 1 (INGRESO_PLANTA) - Sin validación de tiempo mínimo (siguiente movimiento será de tipo diferente)");
                    
                } else {
                    // PASO 2b: NO es ingreso a planta - validar tiempo mínimo para TODOS los tipos
                    // Incluye tipo 7 (ingreso producción) para evitar doble marcación accidental
                    long minutosTranscurridos = java.time.Duration.between(
                            ultimaAsistencia.getFecMarcacion(), 
                            LocalDateTime.now()
                    ).toMinutes();
                    
                    log.info("⏰ Último movimiento tipo {} | Trabajador: {} | Validando tiempo mínimo: {} min", 
                            flagInOut, codTrabajador, minutosTranscurridos);
                    
                    if (minutosTranscurridos < tiempoMinimoMinutos) {
                        long minutosRestantes = tiempoMinimoMinutos - minutosTranscurridos;
                        
                        String mensajeTiempoMinimo = String.format(
                            "TIEMPO_MINIMO_ERROR|%s|%s|%d|%s|%d", 
                            codTrabajador, resultado.getTrabajador().getNombreCompleto(),
                            tiempoMinimoMinutos, ultimaAsistencia.getFechaRegistro().toString(), minutosRestantes
                        );
                        
                        return ResponseEntity.ok(ValidarCodigoResponse.builder()
                                .valido(false)
                                .mensajeError(mensajeTiempoMinimo)
                                .build());
                    }
                }
            } else {
                log.info("✅ Sin marcaciones previas | Trabajador: {}", codTrabajador);
            }
            
            // PUERTA PRINCIPAL: último movimiento filtrado (solo tipos 1 y 2)
            // Verificar si tiene tipo 7 pendiente para mostrar advertencia
            AsistenciaHt580 ultimoReal = asistenciaRepository
                    .findUltimoMovimientoReal(codTrabajador, codOrigen)
                    .orElse(null);
            
            int numeroUltimoMovimiento = 0;
            if (ultimoReal != null && "7".equals(ultimoReal.getFlagInOut().trim())) {
                numeroUltimoMovimiento = 7;
            } else if (ultimaAsistencia != null && ultimaAsistencia.getFlagInOut() != null) {
                try {
                    numeroUltimoMovimiento = Integer.parseInt(ultimaAsistencia.getFlagInOut().trim());
                } catch (NumberFormatException e) {
                    numeroUltimoMovimiento = 0;
                }
            }
            
            log.info("📋 Último movimiento para frontend | Trabajador: {} | Tipo: {}", 
                    codTrabajador, numeroUltimoMovimiento);

            return ResponseEntity.ok(ValidarCodigoResponse.builder()
                    .valido(true)
                    .nombreTrabajador(resultado.getTrabajador().getNombreCompleto())
                    .codigoTrabajador(resultado.getTrabajador().getCodTrabajador())
                    .tipoInput(resultado.getTipoInput())
                    .ultimoMovimiento(numeroUltimoMovimiento)
                    .build());
            
        } catch (Exception e) {
            log.error("❌ Error validando código: {}", request.getCodigo(), e);
            return ResponseEntity.internalServerError()
                    .body(ValidarCodigoResponse.builder()
                            .valido(false)
                            .mensajeError("Error interno del servidor")
                            .build());
        }
    }
    
    /**
     * Endpoint GET para testing y diagnóstico
     */
    @GetMapping("/validar-codigo")
    public ResponseEntity<?> validarCodigoGet() {
        log.info("📋 [GET] Endpoint de validación disponible - Use POST con JSON payload");
        
        return ResponseEntity.ok().body(Map.of(
            "mensaje", "Endpoint de validación disponible",
            "metodo", "POST",
            "payload", "{ \"codigo\": \"codigo-a-validar\" }",
            "ejemplo", "curl -X POST -H 'Content-Type: application/json' -d '{\"codigo\":\"12345678\"}' http://localhost:8084/validar-codigo"
        ));
    }
    

    /**
     * Obtener IP real del cliente (considerando proxies)
     */
    private String obtenerIpReal(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        
        // Si viene de Docker, puede ser una IP interna
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        
        log.debug("🌐 IP detectada: {} (Original: {})", ip, request.getRemoteAddr());
        return ip != null ? ip : "0.0.0.0";
    }
    
    /**
     * Endpoint separado para validar código en área de producción.
     * Usa findUltimoMovimientoReal (todos los tipos) para detectar 7 y 8.
     */
    @PostMapping("/validar-codigo-produccion")
    public ResponseEntity<?> validarCodigoProduccion(@RequestBody ValidarCodigoRequest request) {
        try {
            log.info("🔍 [POST] Validando código para PRODUCCIÓN: {}", request.getCodigo());

            var resultado = validacionService.validarCodigo(request.getCodigo());

            if (!resultado.isValido()) {
                return ResponseEntity.ok(ValidarCodigoResponse.builder()
                        .valido(false)
                        .mensajeError(resultado.getMensajeError())
                        .build());
            }

            String codTrabajador = resultado.getTrabajador().getCodTrabajador();
            String codOrigen = request.getCodOrigen();

            AsistenciaHt580 ultimoReal = asistenciaRepository
                    .findUltimoMovimientoReal(codTrabajador, codOrigen)
                    .orElse(null);

            int numeroUltimoMovimiento = 0;
            if (ultimoReal != null && ultimoReal.getFlagInOut() != null) {
                try {
                    numeroUltimoMovimiento = Integer.parseInt(ultimoReal.getFlagInOut().trim());
                } catch (NumberFormatException e) {
                    numeroUltimoMovimiento = 0;
                }
            }

            log.info("📋 Último movimiento PRODUCCIÓN | Trabajador: {} | Tipo: {}", codTrabajador, numeroUltimoMovimiento);

            if (numeroUltimoMovimiento != 1 && numeroUltimoMovimiento != 7) {
                String msg = numeroUltimoMovimiento == 8
                    ? "Ya marcó salida de producción. Para volver a ingresar al área de producción, primero debe marcar Ingreso a Planta desde \"Marcaje Puerta Principal\"."
                    : "No puede marcar en el área de producción. Primero debe marcar Ingreso a Planta desde \"Marcaje Puerta Principal\".";
                return ResponseEntity.ok(ValidarCodigoResponse.builder()
                        .valido(false)
                        .mensajeError(msg)
                        .build());
            }

            return ResponseEntity.ok(ValidarCodigoResponse.builder()
                    .valido(true)
                    .nombreTrabajador(resultado.getTrabajador().getNombreCompleto())
                    .codigoTrabajador(resultado.getTrabajador().getCodTrabajador())
                    .tipoInput(resultado.getTipoInput())
                    .ultimoMovimiento(numeroUltimoMovimiento)
                    .build());

        } catch (Exception e) {
            log.error("❌ Error validando código producción: {}", request.getCodigo(), e);
            return ResponseEntity.internalServerError()
                    .body(ValidarCodigoResponse.builder()
                            .valido(false)
                            .mensajeError("Error interno del servidor")
                            .build());
        }
    }

    @PostMapping("/forzar-autocierre")
    public ResponseEntity<?> forzarAutoCierreMasivo() {
        log.info("🔄 Forzando auto-cierre masivo manualmente");
        try {
            ticketService.procesarAutoCierreMasivo();
            return ResponseEntity.ok(Map.of("mensaje", "Auto-cierre masivo ejecutado exitosamente"));
        } catch (Exception e) {
            log.error("❌ Error en auto-cierre masivo forzado: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(Map.of("error", e.getMessage()));
        }
    }

    // DTOs para validación de código
    @lombok.Data
    public static class ValidarCodigoRequest {
        private String codigo;
        private String codOrigen;
        private String tipoMarcaje;
    }
    
    @lombok.Data
    @lombok.Builder
    @lombok.AllArgsConstructor
    @lombok.NoArgsConstructor
    public static class ValidarCodigoResponse {
        private boolean valido;
        private String nombreTrabajador;
        private String codigoTrabajador;
        private String tipoInput;
        private String mensajeError;
        private int ultimoMovimiento; // ✅ AGREGADO - Para filtrar movimientos sin llamada adicional
    }
    
    /**
     * Mapear tipo de marcaje del frontend (string) a número (1-2) 
     */
    private String mapearTipoMarcajeANumero(String tipoMarcaje) {
        if (tipoMarcaje == null) return "1";
        
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
     * Mapear tipo de movimiento del frontend (string) a número (1-10)
     */
    private String mapearTipoMovimientoANumero(String tipoMovimiento) {
        if (tipoMovimiento == null) return "1";
        
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
}
