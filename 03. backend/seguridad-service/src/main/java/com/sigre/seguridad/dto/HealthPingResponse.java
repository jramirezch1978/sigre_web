package com.sigre.seguridad.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Respuesta de {@code GET /api/auth/health/ping} — métricas de BD medidas en el servidor
 * (equivalente REST del SOAP {@code ImplHealth.ping} de FastSales).
 * La latencia total cliente↔servidor la calcula la app móvil alrededor de la llamada HTTP.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class HealthPingResponse {

    private boolean ok;

    /** Tiempo en ms para obtener una conexión del pool (DataSource.getConnection). */
    private Long dbConnectionMs;

    /** Tiempo en ms de {@code SELECT 1} sobre esa conexión. */
    private Long dbQueryMs;

    /** Mensaje breve si {@code ok=false}. */
    private String mensaje;
}
