package com.sigre.asistencia;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.event.EventListener;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import lombok.extern.slf4j.Slf4j;

@SpringBootApplication
@EnableDiscoveryClient
@EnableAsync
@EnableScheduling
@Slf4j
public class AsistenciaServiceApplication {

    private final JdbcTemplate jdbcTemplate;
    
    public AsistenciaServiceApplication(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    public static void main(String[] args) {
        SpringApplication.run(AsistenciaServiceApplication.class, args);
    }
    
    /**
     * Inicializar campos de sincronización en registros existentes
     * Se ejecuta una sola vez al iniciar la aplicación
     */
    @EventListener(ApplicationReadyEvent.class)
    public void inicializarCamposSincronizacion() {
        try {
            log.info("🔧 INICIANDO actualización de campos de sincronización para registros existentes...");
            
            // Actualizar registros existentes que no tienen estado_sync
            String updateSql = """
                UPDATE asistencia_ht580 
                SET estado_sync = 'P', 
                    intentos_sync = 0 
                WHERE estado_sync IS NULL
            """;
            
            int registrosActualizados = jdbcTemplate.update(updateSql);
            
            if (registrosActualizados > 0) {
                log.info("✅ ACTUALIZACIÓN COMPLETADA - {} registros de asistencia marcados como pendientes de sincronización", 
                        registrosActualizados);
                log.info("📡 El sync-service procesará estos registros en el próximo ciclo (cada 5 min)");
            } else {
                log.info("✅ Todos los registros ya tienen campos de sincronización configurados");
            }
            
        } catch (Exception e) {
            log.error("❌ Error inicializando campos de sincronización: {}", e.getMessage(), e);
            log.warn("⚠️ Los registros existentes no se sincronizarán hasta resolver este error");
        }
    }
}