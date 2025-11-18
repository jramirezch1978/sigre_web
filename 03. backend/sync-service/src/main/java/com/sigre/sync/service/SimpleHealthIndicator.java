package com.sigre.sync.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.stereotype.Component;

/**
 * Health indicator personalizado que NO toca las bases de datos
 * Solo verifica que la aplicación esté viva y funcionando
 */
@Component("customHealthIndicator")
@Slf4j
public class SimpleHealthIndicator implements HealthIndicator {

    @Override
    public Health health() {
        try {
            // Health check simple que solo verifica que la JVM esté funcionando
            // NO toca bases de datos ni conexiones remotas
            long currentTime = System.currentTimeMillis();

            // Verificar que tengamos memoria suficiente (básico)
            Runtime runtime = Runtime.getRuntime();
            long freeMemory = runtime.freeMemory();
            long totalMemory = runtime.totalMemory();
            double memoryUsage = ((double) (totalMemory - freeMemory) / totalMemory) * 100;

            // Si la memoria usada es mayor al 95%, marcar como DOWN
            if (memoryUsage > 95) {
                return Health.down()
                        .withDetail("memory", String.format("%.2f%% used", memoryUsage))
                        .withDetail("status", "High memory usage")
                        .build();
            }

            // Health check exitoso - aplicación viva
            return Health.up()
                    .withDetail("status", "Application is running")
                    .withDetail("timestamp", currentTime)
                    .withDetail("memory", String.format("%.2f%% used", memoryUsage))
                    .build();

        } catch (Exception e) {
            log.warn("Error en health check personalizado: {}", e.getMessage(), e);
            return Health.down()
                    .withDetail("error", e.getMessage())
                    .build();
        }
    }
}
