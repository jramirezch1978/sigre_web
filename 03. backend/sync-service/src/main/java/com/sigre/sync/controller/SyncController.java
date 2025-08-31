package com.sigre.sync.controller;

import com.sigre.sync.service.SyncSchedulerService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/sync")
@RequiredArgsConstructor
@Slf4j
public class SyncController {
    
    private final SyncSchedulerService syncScheduler;
    
    /**
     * Obtener estado actual de sincronización
     */
    @GetMapping("/status")
    public ResponseEntity<SyncSchedulerService.SyncStatus> getSyncStatus() {
        return ResponseEntity.ok(syncScheduler.getSyncStatus());
    }
    
    /**
     * Forzar sincronización manual
     */
    @PostMapping("/force")
    public ResponseEntity<String> forceSyncronization() {
        try {
            // TODO: Implementar sincronización manual
            return ResponseEntity.ok("Sincronización manual iniciada");
        } catch (Exception e) {
            log.error("Error al forzar sincronización", e);
            return ResponseEntity.internalServerError().body("Error: " + e.getMessage());
        }
    }
    
    /**
     * Health check
     */
    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Sync Service is running - " + 
                java.time.LocalTime.now().format(java.time.format.DateTimeFormatter.ofPattern("hh:mm:ss a")));
    }
}
