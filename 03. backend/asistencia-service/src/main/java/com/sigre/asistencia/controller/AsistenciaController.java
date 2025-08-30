package com.sigre.asistencia.controller;

import com.sigre.asistencia.dto.AsistenciaRequestDto;
import com.sigre.asistencia.dto.AsistenciaResponseDto;
import com.sigre.asistencia.dto.RacionRequestDto;
import com.sigre.asistencia.service.AsistenciaService;
import com.sigre.asistencia.service.RacionesService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/asistencia")
@RequiredArgsConstructor
@Slf4j
public class AsistenciaController {
    
    private final AsistenciaService asistenciaService;
    private final RacionesService racionesService;
    
    /**
     * Registrar marcaje de asistencia
     */
    @PostMapping("/marcar")
    public ResponseEntity<?> marcarAsistencia(@Valid @RequestBody AsistenciaRequestDto request,
                                             @RequestHeader(value = "X-Forwarded-For", required = false) String xForwardedFor,
                                             @RequestHeader(value = "X-Real-IP", required = false) String xRealIp) {
        
        // Obtener IP real del cliente
        String clientIp = obtenerIpCliente(xForwardedFor, xRealIp);
        request.setDireccionIp(clientIp);
        
        log.info("Registrando marcaje - Trabajador: {} - Movimiento: {} - IP: {}", 
                request.getCodTrabajador(), request.getTipoMovimiento(), clientIp);
        
        try {
            AsistenciaResponseDto response = asistenciaService.registrarAsistencia(request);
            
            if (response.isExitoso()) {
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.badRequest().body(response);
            }
            
        } catch (Exception e) {
            log.error("Error al procesar marcaje de asistencia", e);
            return ResponseEntity.internalServerError()
                    .body(AsistenciaResponseDto.error("Error interno del servidor"));
        }
    }
    
    /**
     * Registrar selección de ración
     */
    @PostMapping("/raciones")
    public ResponseEntity<?> seleccionarRacion(@Valid @RequestBody RacionRequestDto request,
                                              @RequestHeader(value = "X-Forwarded-For", required = false) String xForwardedFor,
                                              @RequestHeader(value = "X-Real-IP", required = false) String xRealIp) {
        
        // Obtener IP real del cliente
        String clientIp = obtenerIpCliente(xForwardedFor, xRealIp);
        request.setDireccionIp(clientIp);
        
        log.info("Registrando ración - Trabajador: {} - Tipo: {} - IP: {}", 
                request.getCodTrabajador(), request.getTipoRacion(), clientIp);
        
        try {
            String resultado = racionesService.registrarRacion(request);
            
            if (resultado.startsWith("Error:")) {
                return ResponseEntity.badRequest().body(new RacionResponse(false, resultado));
            } else {
                return ResponseEntity.ok(new RacionResponse(true, resultado));
            }
            
        } catch (Exception e) {
            log.error("Error al procesar selección de ración", e);
            return ResponseEntity.internalServerError()
                    .body(new RacionResponse(false, "Error interno del servidor"));
        }
    }
    
    /**
     * Obtener raciones ya seleccionadas por un trabajador hoy
     */
    @GetMapping("/raciones/{codTrabajador}")
    public ResponseEntity<List<String>> getRacionesSeleccionadas(@PathVariable String codTrabajador) {
        log.info("Consultando raciones seleccionadas para trabajador: {}", codTrabajador);
        
        try {
            List<String> raciones = racionesService.getRacionesSeleccionadasHoy(codTrabajador);
            return ResponseEntity.ok(raciones);
            
        } catch (Exception e) {
            log.error("Error al consultar raciones seleccionadas para trabajador: {}", codTrabajador, e);
            return ResponseEntity.internalServerError().build();
        }
    }
    
    /**
     * Health check
     */
    @GetMapping("/health")
    public ResponseEntity<String> healthCheck() {
        return ResponseEntity.ok("Asistencia Service is running - " + 
                java.time.LocalTime.now().format(java.time.format.DateTimeFormatter.ofPattern("hh:mm:ss a")));
    }
    
    /**
     * Obtener IP real del cliente considerando proxies
     */
    private String obtenerIpCliente(String xForwardedFor, String xRealIp) {
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            // X-Forwarded-For puede contener múltiples IPs separadas por comas
            return xForwardedFor.split(",")[0].trim();
        } else if (xRealIp != null && !xRealIp.isEmpty()) {
            return xRealIp;
        } else {
            return "unknown";
        }
    }
    
    // Clase interna para respuesta de ración
    public static class RacionResponse {
        private boolean exitoso;
        private String mensaje;
        
        public RacionResponse(boolean exitoso, String mensaje) {
            this.exitoso = exitoso;
            this.mensaje = mensaje;
        }
        
        public boolean isExitoso() { return exitoso; }
        public void setExitoso(boolean exitoso) { this.exitoso = exitoso; }
        public String getMensaje() { return mensaje; }
        public void setMensaje(String mensaje) { this.mensaje = mensaje; }
    }
}
