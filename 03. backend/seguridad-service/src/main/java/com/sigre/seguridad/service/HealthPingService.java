package com.sigre.seguridad.service;

import com.sigre.seguridad.dto.HealthPingResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Ping de salud del microservicio hacia la BD security (master).
 * Mide por separado préstamo de conexión del pool y ejecución de {@code SELECT 1},
 * igual que el SOAP legacy {@code ImplHealth.ping}.
 */
@Slf4j
@Service
public class HealthPingService {

    private final DataSource dataSource;

    public HealthPingService(@Qualifier("dataSource") DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public HealthPingResponse ping() {
        long tConn0 = System.nanoTime();
        try (Connection connection = dataSource.getConnection()) {
            long dbConnectionMs = nanosToMs(System.nanoTime() - tConn0);

            long tQuery0 = System.nanoTime();
            try (Statement st = connection.createStatement();
                 ResultSet rs = st.executeQuery("SELECT 1")) {
                if (!rs.next()) {
                    return HealthPingResponse.builder()
                            .ok(false)
                            .dbConnectionMs(dbConnectionMs)
                            .dbQueryMs(nanosToMs(System.nanoTime() - tQuery0))
                            .mensaje("SELECT 1 no devolvió filas")
                            .build();
                }
            }
            long dbQueryMs = nanosToMs(System.nanoTime() - tQuery0);

            return HealthPingResponse.builder()
                    .ok(true)
                    .dbConnectionMs(dbConnectionMs)
                    .dbQueryMs(dbQueryMs)
                    .build();
        } catch (Exception ex) {
            log.warn("[health-ping] Fallo midiendo BD: {}", ex.getMessage());
            return HealthPingResponse.builder()
                    .ok(false)
                    .mensaje(ex.getMessage() != null ? ex.getMessage() : "Error de base de datos")
                    .build();
        }
    }

    private static long nanosToMs(long nanos) {
        return Math.max(0L, nanos / 1_000_000L);
    }
}
