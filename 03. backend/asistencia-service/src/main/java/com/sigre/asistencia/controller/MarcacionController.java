package com.sigre.asistencia.controller;

import com.sigre.asistencia.dto.MarcacionRequest;
import com.sigre.asistencia.dto.MarcacionResponse;
import com.sigre.asistencia.entity.AsistenciaHt580;
import com.sigre.asistencia.repository.AsistenciaHt580Repository;
import com.sigre.asistencia.service.TicketAsistenciaService;
import com.sigre.asistencia.service.ValidacionTrabajadorService;
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
    
    @Value("${asistencia.auto-cierre.horas-limite:13}")
    private int autoCierreHoras;
    
    @Value("${asistencia.marcacion.tiempo-minimo-minutos:15}")
    private int tiempoMinimoMinutos;
    
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
                    .tipoMovimiento(tipoMovimientoNumerico)  // ✅ NÚMERO 1-8
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
            if (request.getFechaMarcacion() == null) {
                request.setFechaMarcacion(LocalDateTime.now());
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
            
            var resultado = validacionService.validarCodigo(request.getCodigo());
            
            if (!resultado.isValido()) {
                return ResponseEntity.ok(ValidarCodigoResponse.builder()
                        .valido(false)
                        .mensajeError(resultado.getMensajeError())
                        .build());
            }
            
            // ✅ Trabajador válido - LÓGICA INTELIGENTE: auto-cierre vs tiempo mínimo
            String codTrabajador = resultado.getTrabajador().getCodTrabajador();
            
            // PASO 1: Obtener último movimiento del trabajador
            AsistenciaHt580 ultimaAsistencia = asistenciaRepository
                    .findTopByCodigoOrderByFechaRegistroDesc(codTrabajador)
                    .orElse(null);
            
            boolean seProcesaAutoCierre = false;
            
            if (ultimaAsistencia != null) {
                // Verificar tipo de movimiento
                String flagInOut = ultimaAsistencia.getFlagInOut();
                boolean esIngreso = "1".equals(flagInOut != null ? flagInOut.trim() : "");
                
                if (esIngreso) {
                    // PASO 2a: Es ingreso - verificar si >= 13h para auto-cierre
                    long horasTranscurridas = java.time.Duration.between(
                            ultimaAsistencia.getFechaRegistro(), 
                            LocalDateTime.now()
                    ).toHours();
                    
                    if (horasTranscurridas >= autoCierreHoras) {
                        // ✅ AUTO-CIERRE necesario
                        log.info("🔄 Ejecutando auto-cierre | Trabajador: {} | Horas: {}/{}", 
                                codTrabajador, horasTranscurridas, autoCierreHoras);
                        
                        try {
                            ticketService.procesarAutoCierreSiEsNecesario(codTrabajador);
                            seProcesaAutoCierre = true;
                            log.info("✅ Auto-cierre completado | Trabajador: {}", codTrabajador);
                        } catch (Exception e) {
                            log.error("❌ Error en auto-cierre | Trabajador: {}: {}", codTrabajador, e.getMessage());
                        }
                    } else {
                        // PASO 2b: Es ingreso pero < 13h - validar tiempo mínimo
                        long minutosTranscurridos = java.time.Duration.between(
                                ultimaAsistencia.getFechaRegistro(), 
                                LocalDateTime.now()
                        ).toMinutes();
                        
                        log.info("⏰ Ingreso reciente | Trabajador: {} | Horas: {}/{} | Validando tiempo mínimo: {} min", 
                                codTrabajador, horasTranscurridas, autoCierreHoras, minutosTranscurridos);
                        
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
                    // PASO 2c: NO es ingreso - validar tiempo mínimo siempre
                    long minutosTranscurridos = java.time.Duration.between(
                            ultimaAsistencia.getFechaRegistro(), 
                            LocalDateTime.now()
                    ).toMinutes();
                    
                    log.info("⏰ Último movimiento NO es ingreso (tipo {}) | Trabajador: {} | Validando tiempo mínimo: {} min", 
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
            
            // ✅ DETERMINAR ÚLTIMO MOVIMIENTO PARA FRONTEND (después del auto-cierre si aplicó)
            AsistenciaHt580 ultimoMovimientoFinal = ultimaAsistencia;
            
            if (seProcesaAutoCierre) {
                // Si se procesó auto-cierre, obtener el NUEVO último movimiento
                ultimoMovimientoFinal = asistenciaRepository
                        .findTopByCodigoOrderByFechaRegistroDesc(codTrabajador)
                        .orElse(ultimaAsistencia);
                        
                log.info("🔄 Obteniendo último movimiento DESPUÉS del auto-cierre | Trabajador: {}", codTrabajador);
            }
            
            int numeroUltimoMovimiento = 0; // Por defecto = sin movimientos
            if (ultimoMovimientoFinal != null && ultimoMovimientoFinal.getFlagInOut() != null) {
                try {
                    numeroUltimoMovimiento = Integer.parseInt(ultimoMovimientoFinal.getFlagInOut().trim());
                    log.info("📋 Último movimiento FINAL para frontend | Trabajador: {} | Tipo: {} | Fecha: {} | Auto-cierre aplicado: {}", 
                            codTrabajador, numeroUltimoMovimiento, ultimoMovimientoFinal.getFechaRegistro(), seProcesaAutoCierre);
                } catch (NumberFormatException e) {
                    log.warn("⚠️ FLAG_IN_OUT no válido: '{}'", ultimoMovimientoFinal.getFlagInOut());
                    numeroUltimoMovimiento = 0;
                }
            }
            
            // TODO OK - retornar trabajador válido + último movimiento actualizado
            return ResponseEntity.ok(ValidarCodigoResponse.builder()
                    .valido(true)
                    .nombreTrabajador(resultado.getTrabajador().getNombreCompleto())
                    .codigoTrabajador(resultado.getTrabajador().getCodTrabajador())
                    .tipoInput(resultado.getTipoInput())
                    .ultimoMovimiento(numeroUltimoMovimiento) // ✅ AGREGADO
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
    
    // DTOs para validación de código
    @lombok.Data
    public static class ValidarCodigoRequest {
        private String codigo;
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
     * Mapear tipo de movimiento del frontend (string) a número (1-8)
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
            default -> {
                log.warn("⚠️ Tipo movimiento no reconocido: '{}', usando 1 por defecto", tipoMovimiento);
                yield "1";
            }
        };
    }
}
