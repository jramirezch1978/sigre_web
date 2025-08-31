package com.sigre.sync.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class EmailNotificationService {
    
    @Autowired(required = false)
    private JavaMailSender mailSender;
    
    @Value("${spring.mail.notifications.recipients:jramirez@npssac.com.pe}")
    private List<String> recipients;
    
    @Value("${spring.mail.notifications.subject:[SIGRE] Reporte de Sincronización}")
    private String subject;
    
    @Value("${spring.mail.notifications.enabled:true}")
    private boolean emailEnabled;
    
    @Value("${spring.mail.smtp.from:facturacion.electronica@franevi.com}")
    private String fromEmail;
    
    /**
     * Enviar reporte de sincronización por email
     */
    public void enviarReporteSincronizacion(SyncReport report) {
        if (!emailEnabled || mailSender == null) {
            log.info("📧 Notificaciones por email deshabilitadas o no configuradas");
            return;
        }
        
        try {
            String contenido = construirContenidoEmail(report);
            
            for (String recipient : recipients) {
                enviarEmail(recipient, subject, contenido);
            }
            
            log.info("📧 Reporte de sincronización enviado a {} destinatarios", recipients.size());
            
        } catch (Exception e) {
            log.error("❌ Error al enviar reporte de sincronización por email", e);
        }
    }
    
    /**
     * Enviar email individual
     */
    private void enviarEmail(String to, String subject, String content) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(to);
            message.setSubject(subject);
            message.setText(content);
            
            mailSender.send(message);
            log.debug("📧 Email enviado exitosamente a: {}", to);
            
        } catch (Exception e) {
            log.error("❌ Error al enviar email a: {}", to, e);
        }
    }
    
    /**
     * Construir contenido del email con resumen detallado
     */
    private String construirContenidoEmail(SyncReport report) {
        StringBuilder content = new StringBuilder();
        
        content.append("=== REPORTE DE SINCRONIZACIÓN SIGRE ===\n\n");
        content.append("Fecha y Hora: ").append(report.getFechaHora().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"))).append("\n");
        content.append("Duración Total: ").append(report.getDuracionMinutos()).append(" minutos\n");
        content.append("Estado General: ").append(report.isExitoso() ? "✅ EXITOSO" : "❌ CON ERRORES").append("\n\n");
        
        // Tabla de resumen detallado con errores
        content.append("📊 RESUMEN DETALLADO DE SINCRONIZACIÓN:\n\n");
        content.append(String.format("%-25s | %-11s | %-12s | %-11s | %-8s | %-12s | %-12s | %-10s\n", 
                "NOMBRE DE TABLA", "INSERTADOS", "ACTUALIZADOS", "ELIMINADOS", "ERRORES", "BASE ORIGEN", "BASE DESTINO", "ESTADO"));
        content.append("-".repeat(120)).append("\n");
        
        // Remote → Local
        for (Map.Entry<String, SyncTableStats> entry : report.getEstadisticasDetalladas().entrySet()) {
            SyncTableStats stats = entry.getValue();
            if (stats.getDireccion().equals("REMOTE_TO_LOCAL")) {
                content.append(String.format("%-25s | %-11d | %-12d | %-11d | %-8d | %-12s | %-12s | %-10s\n",
                        entry.getKey(),
                        stats.getRegistrosInsertados(),
                        stats.getRegistrosActualizados(),
                        stats.getRegistrosEliminados(),
                        stats.getRegistrosErrores(),
                        "bd_remota",
                        "bd_local",
                        stats.isExitoso() ? "✅ OK" : "❌ ERROR"));
            }
        }
        
        // Local → Remote  
        for (Map.Entry<String, SyncTableStats> entry : report.getEstadisticasDetalladas().entrySet()) {
            SyncTableStats stats = entry.getValue();
            if (stats.getDireccion().equals("LOCAL_TO_REMOTE")) {
                content.append(String.format("%-25s | %-11d | %-12d | %-11d | %-8d | %-12s | %-12s | %-10s\n",
                        entry.getKey(),
                        stats.getRegistrosInsertados(),
                        stats.getRegistrosActualizados(),
                        stats.getRegistrosEliminados(),
                        stats.getRegistrosErrores(),
                        "bd_local",
                        "bd_remota",
                        stats.isExitoso() ? "✅ OK" : "❌ ERROR"));
            }
        }
        content.append("\n");
        
        // Errores si los hay
        if (!report.getErrores().isEmpty()) {
            content.append("⚠️ ERRORES ENCONTRADOS:\n");
            for (String error : report.getErrores()) {
                content.append("  - ").append(error).append("\n");
            }
            content.append("\n");
        }
        
        content.append("Próxima sincronización: ").append(report.getProximaSincronizacion().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"))).append("\n\n");
        content.append("---\n");
        content.append("Sistema SIGRE - Módulo de Asistencia\n");
        content.append("Transmarina del PERU SAC\n");
        
        return content.toString();
    }
    
    // DTO para reporte de sincronización
    @lombok.Data
    @lombok.Builder
    public static class SyncReport {
        private LocalDateTime fechaHora;
        private long duracionMinutos;
        private boolean exitoso;
        private boolean remoteToLocalExitoso;
        private boolean localToRemoteExitoso;
        private Map<String, Integer> tablasSincronizadasRemoteToLocal;
        private Map<String, Integer> tablasSincronizadasLocalToRemote;
        private Map<String, SyncTableStats> estadisticasDetalladas;
        private List<String> errores;
        private LocalDateTime proximaSincronizacion;
    }
    
    // DTO para estadísticas detalladas por tabla con manejo de errores
    @lombok.Data
    @lombok.Builder
    public static class SyncTableStats {
        private String nombreTabla;
        private int registrosInsertados;
        private int registrosActualizados;
        private int registrosEliminados;
        private int registrosErrores;
        private String direccion; // REMOTE_TO_LOCAL o LOCAL_TO_REMOTE
        private String baseOrigen;
        private String baseDestino;
        private long duracionMs;
        private boolean exitoso;
        private List<String> erroresDetallados; // Lista de errores específicos
    }
}
