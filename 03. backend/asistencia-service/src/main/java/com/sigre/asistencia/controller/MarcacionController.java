package com.sigre.asistencia.controller;

import com.sigre.asistencia.dto.MarcacionRequest;
import com.sigre.asistencia.dto.MarcacionResponse;
import com.sigre.asistencia.service.TicketAsistenciaService;
import com.sigre.asistencia.service.ValidacionTrabajadorService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;

/**
 * Controlador REST para marcaciones de asistencia
 * API asíncrona de alta concurrencia
 */
@RestController
@RequestMapping("/api/marcaciones")
@RequiredArgsConstructor
@Slf4j
@CrossOrigin(origins = "*") // Permitir CORS para el frontend
public class MarcacionController {
    
    private final TicketAsistenciaService ticketService;
    private final ValidacionTrabajadorService validacionService;
    
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
            
            // Validar request básico
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
            
            // Crear ticket (INMEDIATO - No bloquea)
            MarcacionResponse response = ticketService.crearTicketMarcacion(request);
            
            if (response.isError()) {
                log.warn("⚠️ Error en validación: {}", response.getMensajeError());
                return ResponseEntity.badRequest().body(response);
            }
            
            log.info("✅ Ticket {} creado exitosamente para trabajador: {}", 
                    response.getTicketId(), response.getNombreTrabajador());
            
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
    public ResponseEntity<?> validarCodigo(@RequestBody ValidarCodigoRequest request) {
        try {
            log.info("🔍 Validando código: {}", request.getCodigo());
            
            var resultado = validacionService.validarCodigo(request.getCodigo());
            
            if (resultado.isValido()) {
                return ResponseEntity.ok(ValidarCodigoResponse.builder()
                        .valido(true)
                        .nombreTrabajador(resultado.getTrabajador().getNombreCompleto())
                        .codigoTrabajador(resultado.getTrabajador().getCodTrabajador())
                        .tipoInput(resultado.getTipoInput())
                        .build());
            } else {
                return ResponseEntity.badRequest()
                        .body(ValidarCodigoResponse.builder()
                                .valido(false)
                                .mensajeError(resultado.getMensajeError())
                                .build());
            }
            
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
    }
}
