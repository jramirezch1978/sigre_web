package com.sigre.asistencia.controller;

import com.sigre.asistencia.dto.TrabajadorResponseDto;
import com.sigre.asistencia.service.TrabajadorService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/trabajadores")
@RequiredArgsConstructor
@Slf4j
public class TrabajadorController {
    
    private final TrabajadorService trabajadorService;
    
    /**
     * Buscar trabajador por código, DNI o tarjeta
     */
    @GetMapping("/buscar/{codigo}")
    public ResponseEntity<?> buscarTrabajador(@PathVariable String codigo) {
        log.info("Buscando trabajador por código: {}", codigo);
        
        try {
            Optional<TrabajadorResponseDto> trabajador = trabajadorService.buscarTrabajadorPorCodigo(codigo);
            
            if (trabajador.isPresent()) {
                return ResponseEntity.ok(trabajador.get());
            } else {
                return ResponseEntity.notFound().build();
            }
            
        } catch (Exception e) {
            log.error("Error al buscar trabajador: {}", codigo, e);
            return ResponseEntity.internalServerError()
                    .body("Error interno al buscar trabajador: " + e.getMessage());
        }
    }
    
    /**
     * Validar si un trabajador puede marcar asistencia
     */
    @GetMapping("/validar/{codTrabajador}")
    public ResponseEntity<?> validarTrabajador(@PathVariable String codTrabajador) {
        log.info("Validando trabajador: {}", codTrabajador);
        
        try {
            boolean puedeMarcar = trabajadorService.puedeMarcarAsistencia(codTrabajador);
            
            return ResponseEntity.ok()
                    .body(new ValidacionResponse(puedeMarcar, 
                          puedeMarcar ? "Trabajador habilitado" : "Trabajador no habilitado para marcar asistencia"));
            
        } catch (Exception e) {
            log.error("Error al validar trabajador: {}", codTrabajador, e);
            return ResponseEntity.internalServerError()
                    .body("Error interno al validar trabajador: " + e.getMessage());
        }
    }
    
    /**
     * Health check específico para trabajadores
     */
    @GetMapping("/health")
    public ResponseEntity<String> healthCheck() {
        return ResponseEntity.ok("Trabajador Service is running - " + 
                java.time.LocalTime.now().format(java.time.format.DateTimeFormatter.ofPattern("hh:mm:ss a")));
    }
    
    // Clase interna para respuesta de validación
    public static class ValidacionResponse {
        private boolean valido;
        private String mensaje;
        
        public ValidacionResponse(boolean valido, String mensaje) {
            this.valido = valido;
            this.mensaje = mensaje;
        }
        
        public boolean isValido() { return valido; }
        public void setValido(boolean valido) { this.valido = valido; }
        public String getMensaje() { return mensaje; }
        public void setMensaje(String mensaje) { this.mensaje = mensaje; }
    }
}
