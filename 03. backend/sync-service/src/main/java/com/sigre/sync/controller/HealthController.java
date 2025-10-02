package com.sigre.sync.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Controller personalizado para health checks simples
 * Este endpoint puede ser usado por Portainer u otros monitores
 */
@RestController
@RequestMapping("/api")
@Slf4j
public class HealthController {

    /**
     * Health check simple que NO toca bases de datos
     * Solo verifica que la aplicación esté viva
     */
    @GetMapping("/health")
    public ResponseEntity<?> health() {
        try {
            // Verificación básica de salud
            long currentTime = System.currentTimeMillis();

            // Verificar memoria básica (opcional)
            Runtime runtime = Runtime.getRuntime();
            long freeMemory = runtime.freeMemory();
            long totalMemory = runtime.totalMemory();

            return ResponseEntity.ok()
                    .body(new HealthResponse(
                            "UP",
                            currentTime,
                            "Application is running normally",
                            String.format("%.2f%%", ((double)(totalMemory - freeMemory) / totalMemory) * 100)
                    ));

        } catch (Exception e) {
            log.error("Error en health check personalizado: {}", e.getMessage());
            return ResponseEntity.status(503)
                    .body(new HealthResponse("DOWN", System.currentTimeMillis(), e.getMessage(), "N/A"));
        }
    }

    /**
     * Health check aún más simple para monitores básicos
     */
    @GetMapping("/ping")
    public ResponseEntity<String> ping() {
        return ResponseEntity.ok("pong");
    }

    /**
     * Clase para respuesta del health check
     */
    public static class HealthResponse {
        private String status;
        private long timestamp;
        private String message;
        private String memoryUsage;

        public HealthResponse(String status, long timestamp, String message, String memoryUsage) {
            this.status = status;
            this.timestamp = timestamp;
            this.message = message;
            this.memoryUsage = memoryUsage;
        }

        // Getters
        public String getStatus() { return status; }
        public long getTimestamp() { return timestamp; }
        public String getMessage() { return message; }
        public String getMemoryUsage() { return memoryUsage; }
    }
}
