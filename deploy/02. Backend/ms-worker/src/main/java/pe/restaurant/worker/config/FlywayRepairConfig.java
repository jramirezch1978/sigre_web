package pe.restaurant.worker.config;

import lombok.extern.slf4j.Slf4j;
import org.flywaydb.core.Flyway;
import org.springframework.boot.autoconfigure.flyway.FlywayMigrationStrategy;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Slf4j
@Configuration
public class FlywayRepairConfig {

    @Bean
    public FlywayMigrationStrategy flywayMigrationStrategy() {
        return flyway -> {
            log.info("Flyway: ejecutando repair antes de migrate...");
            flyway.repair();
            log.info("Flyway: repair completado, ejecutando migrate...");
            flyway.migrate();
            log.info("Flyway: migrate completado.");
        };
    }
}
