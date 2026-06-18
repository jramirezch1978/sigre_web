package com.sigre.sync.worker.service;

import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import com.sigre.sync.worker.config.SchemaSyncNotificationProperties;
import com.sigre.sync.worker.dto.SchemaSyncResponse;
import com.sigre.sync.worker.entity.SchemaSyncCronLog;
import com.sigre.sync.worker.repository.SchemaSyncCronLogRepository;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Objects;

@Slf4j
@Service
public class SchemaSyncEmailNotifier {

    private final SchemaSyncCronLogRepository cronLogRepository;
    private final SchemaSyncNotificationProperties notificationProperties;
    private final ObjectProvider<JavaMailSender> mailSenderProvider;

    public SchemaSyncEmailNotifier(SchemaSyncCronLogRepository cronLogRepository,
                                   SchemaSyncNotificationProperties notificationProperties,
                                   ObjectProvider<JavaMailSender> mailSenderProvider) {
        this.cronLogRepository = cronLogRepository;
        this.notificationProperties = notificationProperties;
        this.mailSenderProvider = mailSenderProvider;
    }

    public void notifyIfNeeded(String executionId, SchemaSyncResponse.Summary summary, boolean dryRun) {
        if (!notificationProperties.isEnabled() || summary == null) {
            return;
        }
        if (summary.getChangedTenants() <= 0 && summary.getFailedTenants() <= 0) {
            return;
        }

        List<SchemaSyncNotificationProperties.Recipient> recipients = notificationProperties.getRecipients()
                .stream()
                .filter(Objects::nonNull)
                .filter(r -> r.getEmail() != null && !r.getEmail().isBlank())
                .toList();

        if (recipients.isEmpty()) {
            log.warn("[{}] Notificacion email omitida: no hay destinatarios configurados", executionId);
            return;
        }

        JavaMailSender mailSender = mailSenderProvider.getIfAvailable();
        if (mailSender == null) {
            log.warn("[{}] Notificacion email omitida: JavaMailSender no configurado", executionId);
            return;
        }

        List<SchemaSyncCronLog> logs = cronLogRepository.findByExecutionIdOrderByIdAsc(executionId);
        String subject = buildSubject(executionId, summary, dryRun);
        String html = buildHtmlBody(executionId, summary, dryRun, logs);

        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, false, "UTF-8");
            if (notificationProperties.getFrom() != null && !notificationProperties.getFrom().isBlank()) {
                helper.setFrom(notificationProperties.getFrom());
            }
            String[] recipientEmails = recipients.stream()
                    .map(SchemaSyncNotificationProperties.Recipient::getEmail)
                    .toArray(String[]::new);
            helper.setTo(recipientEmails);
            helper.setSubject(subject);
            helper.setText(html, true);
            mailSender.send(mimeMessage);
            log.info("[{}] Notificacion email HTML enviada a {}", executionId,
                    recipients.stream().map(SchemaSyncNotificationProperties.Recipient::getEmail).toList());
        } catch (Exception ex) {
            if (isDailySendLimitError(ex)) {
                log.warn("[{}] Notificacion email omitida por limite diario del proveedor SMTP: {}",
                        executionId, ex.getMessage());
                return;
            }
            log.error("[{}] Error enviando notificacion email: {}", executionId, ex.getMessage(), ex);
        }
    }

    private boolean isDailySendLimitError(Throwable throwable) {
        Throwable current = throwable;
        while (current != null) {
            String message = current.getMessage();
            if (message != null) {
                String normalized = message.toLowerCase();
                if (normalized.contains("daily user sending limit exceeded")
                        || normalized.contains("550-5.4.5")
                        || normalized.contains("550 5.4.5")) {
                    return true;
                }
            }
            current = current.getCause();
        }
        return false;
    }

    private String buildSubject(String executionId, SchemaSyncResponse.Summary summary, boolean dryRun) {
        String status = summary.getFailedTenants() > 0 ? "FALLIDO" : "OK";
        return String.format("%s [%s] %s | %d tenants | %s",
                notificationProperties.getSubjectPrefix(),
                dryRun ? "DRY-RUN" : "SYNC",
                status,
                summary.getTotalTenants(),
                executionId.substring(0, 8));
    }

    private String buildHtmlBody(String executionId, SchemaSyncResponse.Summary summary, boolean dryRun,
                                  List<SchemaSyncCronLog> logs) {
        StringBuilder h = new StringBuilder();
        String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
        boolean hasFailed = summary.getFailedTenants() > 0;
        String headerColor = hasFailed ? "#dc3545" : "#28a745";
        String headerText = hasFailed ? "SINCRONIZACION CON ERRORES" : "SINCRONIZACION EXITOSA";

        h.append("<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body style='font-family:Segoe UI,Arial,sans-serif;margin:0;padding:20px;background:#f5f5f5;'>");
        h.append("<div style='max-width:900px;margin:0 auto;background:#fff;border-radius:8px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,0.1);'>");

        h.append("<div style='background:").append(headerColor).append(";color:#fff;padding:20px 30px;'>");
        h.append("<h2 style='margin:0;font-size:20px;'>").append(headerText).append("</h2>");
        h.append("<p style='margin:5px 0 0;opacity:0.9;font-size:13px;'>Restaurant.pe ERP - Schema Sync (ms-worker)</p>");
        h.append("</div>");

        h.append("<div style='padding:20px 30px;'>");

        h.append("<table style='width:100%;border-collapse:collapse;margin-bottom:20px;font-size:13px;'>");
        h.append("<tr><td style='padding:6px 12px;background:#f8f9fa;font-weight:bold;width:160px;'>Execution ID</td><td style='padding:6px 12px;'>").append(executionId).append("</td></tr>");
        h.append("<tr><td style='padding:6px 12px;background:#f8f9fa;font-weight:bold;'>Fecha</td><td style='padding:6px 12px;'>").append(now).append("</td></tr>");
        h.append("<tr><td style='padding:6px 12px;background:#f8f9fa;font-weight:bold;'>Modo</td><td style='padding:6px 12px;'>").append(dryRun ? "DRY-RUN" : "EJECUCION").append("</td></tr>");
        h.append("<tr><td style='padding:6px 12px;background:#f8f9fa;font-weight:bold;'>Tenants</td><td style='padding:6px 12px;'>").append(summary.getTotalTenants()).append(" total, ");
        h.append("<span style='color:#28a745;font-weight:bold;'>").append(summary.getOkTenants()).append(" OK</span>");
        if (summary.getFailedTenants() > 0) {
            h.append(", <span style='color:#dc3545;font-weight:bold;'>").append(summary.getFailedTenants()).append(" fallidos</span>");
        }
        h.append(", ").append(summary.getChangedTenants()).append(" con cambios</td></tr>");
        if (summary.getPlannedStatements() > 0) {
            h.append("<tr><td style='padding:6px 12px;background:#f8f9fa;font-weight:bold;'>DDL</td><td style='padding:6px 12px;'>").append(summary.getAppliedStatements()).append(" / ").append(summary.getPlannedStatements()).append(" sentencias aplicadas</td></tr>");
        }
        h.append("</table>");

        List<SchemaSyncCronLog> ddlLogs = logs.stream()
                .filter(l -> l.getTenantDbName() != null && !l.getTenantDbName().isBlank())
                .filter(l -> !"DATO".equals(l.getObjectType()))
                .filter(l -> l.isFailed() || l.isChanged())
                .toList();

        List<SchemaSyncCronLog> dataLogs = logs.stream()
                .filter(l -> l.getTenantDbName() != null && !l.getTenantDbName().isBlank())
                .filter(l -> "DATO".equals(l.getObjectType()))
                .toList();

        if (!ddlLogs.isEmpty()) {
            h.append("<h3 style='color:#333;border-bottom:2px solid #007bff;padding-bottom:5px;'>DDL (Fases 1-4)</h3>");
            h.append("<table style='width:100%;border-collapse:collapse;font-size:12px;margin-bottom:20px;'>");
            h.append("<tr style='background:#343a40;color:#fff;'><th style='padding:8px;text-align:left;'>Empresa</th><th style='padding:8px;'>Fase</th><th style='padding:8px;'>Objeto</th><th style='padding:8px;'>Estado</th><th style='padding:8px;'>Detalle</th></tr>");
            int row = 0;
            for (SchemaSyncCronLog l : ddlLogs) {
                String bg = row++ % 2 == 0 ? "#fff" : "#f8f9fa";
                String statusColor = l.isFailed() ? "#dc3545" : "#28a745";
                String statusText = l.isFailed() ? "ERROR" : "OK";
                h.append("<tr style='background:").append(bg).append(";'>");
                h.append("<td style='padding:6px 8px;'>").append(nvl(l.getNombreEmpresa())).append("</td>");
                h.append("<td style='padding:6px 8px;text-align:center;'>").append(nvl(l.getFase())).append("</td>");
                h.append("<td style='padding:6px 8px;'>").append(nvl(l.getSchemaObject())).append("</td>");
                h.append("<td style='padding:6px 8px;text-align:center;color:").append(statusColor).append(";font-weight:bold;'>").append(statusText).append("</td>");
                h.append("<td style='padding:6px 8px;font-size:11px;'>").append(nvl(l.isFailed() ? l.getErrorDetail() : l.getObjectsSummary())).append("</td>");
                h.append("</tr>");
            }
            h.append("</table>");
        }

        if (!dataLogs.isEmpty()) {
            h.append("<h3 style='color:#333;border-bottom:2px solid #17a2b8;padding-bottom:5px;'>Datos Maestros (Fase 5)</h3>");

            String currentTenant = "";
            for (SchemaSyncCronLog l : dataLogs) {
                String tenant = nvl(l.getNombreEmpresa());
                if (!tenant.equals(currentTenant)) {
                    if (!currentTenant.isEmpty()) {
                        h.append("</table>");
                    }
                    currentTenant = tenant;
                    h.append("<h4 style='margin:15px 0 5px;color:#495057;font-size:14px;'>")
                            .append(tenant).append(" <span style='font-weight:normal;color:#6c757d;font-size:12px;'>(")
                            .append(nvl(l.getTenantDbName())).append(")</span></h4>");
                    h.append("<table style='width:100%;border-collapse:collapse;font-size:12px;margin-bottom:10px;'>");
                    h.append("<tr style='background:#17a2b8;color:#fff;'><th style='padding:6px 8px;text-align:left;'>Tabla</th><th style='padding:6px 8px;text-align:center;'>Registros</th><th style='padding:6px 8px;text-align:center;'>Estado</th></tr>");
                }
                String statusColor = l.isFailed() ? "#dc3545" : "#28a745";
                String statusText = l.isFailed() ? "ERROR" : "OK";
                String regText = l.isFailed() ? nvl(l.getErrorDetail()) : nvl(l.getObjectsSummary());
                h.append("<tr style='border-bottom:1px solid #dee2e6;'>");
                h.append("<td style='padding:5px 8px;'>").append(nvl(l.getSchemaObject())).append("</td>");
                h.append("<td style='padding:5px 8px;text-align:center;'>").append(regText).append("</td>");
                h.append("<td style='padding:5px 8px;text-align:center;color:").append(statusColor).append(";font-weight:bold;'>").append(statusText).append("</td>");
                h.append("</tr>");
            }
            if (!currentTenant.isEmpty()) {
                h.append("</table>");
            }
        }

        if (ddlLogs.isEmpty() && dataLogs.isEmpty()) {
            h.append("<p style='color:#6c757d;'>Sin cambios DDL ni datos maestros en esta ejecucion.</p>");
        }

        h.append("<hr style='border:none;border-top:1px solid #dee2e6;margin:20px 0;'>");
        h.append("<p style='font-size:11px;color:#6c757d;margin:0;'>Este correo fue generado automaticamente por ms-worker. No responder.</p>");
        h.append("</div></div></body></html>");

        return h.toString();
    }

    private String nvl(String value) {
        return value == null ? "" : value;
    }
}
