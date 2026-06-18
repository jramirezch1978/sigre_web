package com.sigre.sync.worker.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties(prefix = "app.activos-jobs")
public class ActivosJobsProperties {

    private boolean enabled = false;
    private String baseUrl = "http://localhost:9008";
    /** JWT de servicio con tenant definitivo para invocar jobs. */
    private String bearerToken;
    private Long empresaId;
    private String dbName;
    private boolean contabilizar = true;
    /** Cron Spring: default día 1 a las 02:00 */
    private String depreciacionCron = "0 0 2 1 * ?";
    /** Cron Spring: default día 1 a las 03:00 */
    private String devengoCron = "0 0 3 1 * ?";
}
