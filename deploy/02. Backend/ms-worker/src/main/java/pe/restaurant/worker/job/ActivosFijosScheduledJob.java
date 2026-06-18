package pe.restaurant.worker.job;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import pe.restaurant.worker.client.ActivosFijosJobsClient;
import pe.restaurant.worker.client.dto.ActivosDepreciacionJobRequest;
import pe.restaurant.worker.config.ActivosJobsProperties;

import java.time.LocalDate;

@Slf4j
@Component
@RequiredArgsConstructor
@ConditionalOnProperty(name = "app.activos-jobs.enabled", havingValue = "true")
public class ActivosFijosScheduledJob {

    private final ActivosFijosJobsClient activosFijosJobsClient;
    private final ActivosJobsProperties properties;

    @Scheduled(cron = "${app.activos-jobs.depreciacion-cron:0 0 2 1 * ?}")
    public void ejecutarDepreciacionMasiva() {
        LocalDate periodo = LocalDate.now().minusMonths(1);
        ActivosDepreciacionJobRequest request = new ActivosDepreciacionJobRequest();
        request.setAnio(periodo.getYear());
        request.setMes(periodo.getMonthValue());
        try {
            var resp = activosFijosJobsClient.depreciacionMasiva(request, properties.isContabilizar());
            log.info("Job AF depreciación masiva OK: procesados={}, contabilizados={}",
                    resp.getData() != null ? resp.getData().getProcesados() : 0,
                    resp.getData() != null ? resp.getData().getContabilizados() : 0);
        } catch (Exception e) {
            log.error("Job AF depreciación masiva falló: {}", e.getMessage(), e);
        }
    }

    @Scheduled(cron = "${app.activos-jobs.devengo-cron:0 0 3 1 * ?}")
    public void ejecutarDevengoPrimaMasivo() {
        LocalDate periodo = LocalDate.now().minusMonths(1);
        try {
            var resp = activosFijosJobsClient.devengoPrimaMasivo(
                    periodo.getYear(), periodo.getMonthValue(), properties.isContabilizar());
            log.info("Job AF devengo prima masivo OK: procesados={}, contabilizados={}",
                    resp.getData() != null ? resp.getData().getProcesados() : 0,
                    resp.getData() != null ? resp.getData().getContabilizados() : 0);
        } catch (Exception e) {
            log.error("Job AF devengo prima masivo falló: {}", e.getMessage(), e);
        }
    }
}
