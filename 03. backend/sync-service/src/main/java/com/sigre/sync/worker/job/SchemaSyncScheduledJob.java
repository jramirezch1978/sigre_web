package com.sigre.sync.worker.job;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.stereotype.Component;
import com.sigre.sync.worker.dto.SchemaSyncRequest;
import com.sigre.sync.worker.dto.SchemaSyncResponse;
import com.sigre.sync.worker.service.SchemaSyncService;

import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Job de sincronización de esquemas con reprogramación dinámica.
 * Al iniciar el ms-worker, se programa la primera ejecución tras N minutos
 * (leídos de app.schema-sync.schedule.interval-minutes vía config-server).
 * Al terminar cada ejecución, se reprograma automáticamente para N minutos después.
 *
 * Toda la auditoría (INICIO → PROCESANDO → TERMINADO/FALLIDO) se gestiona
 * dentro de {@link SchemaSyncService}.
 */
@Slf4j
@Component
@ConditionalOnProperty(name = "app.schema-sync.schedule.enabled", havingValue = "true")
public class SchemaSyncScheduledJob implements InitializingBean {

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    private final SchemaSyncService schemaSyncService;
    private final ThreadPoolTaskScheduler taskScheduler;

    @Value("${app.schema-sync.schedule.interval-minutes}")
    private int intervalMinutes;

    @Value("${app.schema-sync.schedule.dry-run:false}")
    private boolean dryRun;

    public SchemaSyncScheduledJob(SchemaSyncService schemaSyncService,
                                  ThreadPoolTaskScheduler taskScheduler) {
        this.schemaSyncService = schemaSyncService;
        this.taskScheduler = taskScheduler;
    }

    @Override
    public void afterPropertiesSet() {
        if (intervalMinutes <= 0) {
            throw new IllegalStateException(
                    "app.schema-sync.schedule.interval-minutes debe ser mayor a 0, valor actual: " + intervalMinutes);
        }
        log.info("Schema sync scheduled job inicializado. intervalMinutes={}, dryRun={}", intervalMinutes, dryRun);
        scheduleNext();
    }

    private void scheduleNext() {
        Instant nextRun = Instant.now().plus(Duration.ofMinutes(intervalMinutes));
        taskScheduler.schedule(this::runSync, nextRun);
        log.info("Proxima sincronizacion programada en {} minutos ({})",
                intervalMinutes, LocalDateTime.now().plusMinutes(intervalMinutes).format(FMT));
    }

    private void runSync() {
        log.info("Schema sync job iniciado. dryRun={}, intervalMinutes={}", dryRun, intervalMinutes);
        long start = System.currentTimeMillis();

        try {
            SchemaSyncRequest request = new SchemaSyncRequest();
            request.setDryRun(dryRun);
            request.setAllowDestructive(false);
            request.setFailFast(false);

            SchemaSyncResponse response = schemaSyncService.execute(request, "SCHEDULED_JOB");
            long durationMs = System.currentTimeMillis() - start;

            SchemaSyncResponse.Summary s = response.getSummary();
            log.info("Schema sync job finalizado. executionId={}, ok={}, failed={}, "
                            + "changed={}, durationMs={}",
                    response.getExecutionId(), s.getOkTenants(), s.getFailedTenants(),
                    s.getChangedTenants(), durationMs);

        } catch (Exception ex) {
            long durationMs = System.currentTimeMillis() - start;
            log.error("Schema sync job fallo en {}ms: {}", durationMs, ex.getMessage(), ex);
        } finally {
            scheduleNext();
        }
    }
}
