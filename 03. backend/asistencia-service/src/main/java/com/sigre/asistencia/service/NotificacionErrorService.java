package com.sigre.asistencia.service;

import com.sigre.asistencia.entity.TicketAsistencia;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.MimeMessage;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Servicio para envío de notificaciones de error por email
 * Usa la misma configuración y estructura que sync-service
 */
@Service
@Slf4j
public class NotificacionErrorService {
    
    @Autowired(required = false)
    private JavaMailSender mailSender;
    
    @Value("${spring.mail.smtp.from:facturacion.electronica@franevi.com}")
    private String fromEmail;
    
    @Value("${spring.mail.notifications.recipients:jramirez@npssac.com.pe,esilva@transmarina.com}")
    private String destinatarioEmails;
    
    @Value("${spring.mail.notifications.enabled:false}")
    private boolean emailEnabled;
    
    /**
     * Enviar notificación de error al crear ticket
     */
    public void enviarErrorTicket(String codigoInput, String mensajeError) {
        if (!emailEnabled || mailSender == null) {
            log.info("📧 Notificaciones por email deshabilitadas o no configuradas");
            return;
        }
        
        try {
            String asunto = "[SIGRE-ASISTENCIA] ERROR CRÍTICO - Creación de Ticket";
            String contenido = construirEmailErrorTicket(codigoInput, mensajeError);
            
            enviarEmailAMultiplesDestinatarios(asunto, contenido);
            log.info("📧 Email de error de ticket enviado a destinatarios configurados");
            
        } catch (Exception e) {
            log.error("❌ Error enviando notificación de error de ticket", e);
        }
    }
    
    public void enviarErrorProcesamiento(TicketAsistencia ticket, String mensajeError) {
        enviarErrorProcesamiento(ticket, mensajeError, null);
    }

    public void enviarErrorProcesamiento(TicketAsistencia ticket, String mensajeError, Throwable excepcion) {
        if (!emailEnabled || mailSender == null) {
            log.info("📧 Notificaciones por email deshabilitadas o no configuradas");
            return;
        }
        
        try {
            String asunto = "[SIGRE-ASISTENCIA] ERROR - Procesamiento de Ticket";
            String contenido = construirEmailErrorProcesamiento(ticket, mensajeError, excepcion);
            
            enviarEmailAMultiplesDestinatarios(asunto, contenido);
            log.info("📧 Email de error de procesamiento enviado para ticket: {}", ticket.getNumeroTicket());
            
        } catch (Exception e) {
            log.error("❌ Error enviando notificación de error de procesamiento", e);
        }
    }
    
    /**
     * Construir contenido HTML para error de ticket
     */
    private String construirEmailErrorTicket(String codigoInput, String mensajeError) {
        return String.format("""
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <title>Error Crítico - SIGRE Asistencia</title>
                    <style>
                        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
                        .container { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
                        .header { background: #d32f2f; color: white; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
                        .content { margin: 15px 0; }
                        .error-box { background: #ffebee; border: 1px solid #f44336; padding: 15px; border-radius: 5px; }
                        .footer { margin-top: 30px; font-size: 12px; color: #666; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <h2>🚨 ERROR CRÍTICO - Sistema de Asistencia</h2>
                        </div>
                        
                        <div class="content">
                            <h3>Error al Crear Ticket de Asistencia</h3>
                            
                            <p><strong>Fecha y Hora:</strong> %s</p>
                            <p><strong>Código Ingresado:</strong> %s</p>
                            
                            <div class="error-box">
                                <h4>Detalle del Error:</h4>
                                <p>%s</p>
                            </div>
                            
                            <p><strong>Acción Requerida:</strong> Revisar la configuración del sistema y verificar la conexión con la base de datos.</p>
                        </div>
                        
                        <div class="footer">
                            <p>Sistema SIGRE - Módulo de Asistencia<br/>
                            Transmarina del PERU SAC</p>
                        </div>
                    </div>
                </body>
                </html>
                """,
                LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")),
                codigoInput,
                mensajeError
        );
    }
    
    /**
     * Construir contenido HTML para error de procesamiento
     */
    private String construirEmailErrorProcesamiento(TicketAsistencia ticket, String mensajeError, Throwable excepcion) {
        // Extraer causa raíz
        String causaRaiz = "";
        if (excepcion != null) {
            Throwable causa = excepcion;
            while (causa.getCause() != null) {
                causa = causa.getCause();
            }
            if (!causa.getMessage().equals(mensajeError)) {
                causaRaiz = causa.getClass().getSimpleName() + ": " + causa.getMessage();
            }
        }

        // Construir stack trace filtrado (solo clases com.sigre)
        StringBuilder stackTrace = new StringBuilder();
        if (excepcion != null) {
            for (StackTraceElement ste : excepcion.getStackTrace()) {
                if (ste.getClassName().startsWith("com.sigre")) {
                    stackTrace.append(ste.getClassName()).append(".")
                              .append(ste.getMethodName()).append("(")
                              .append(ste.getFileName()).append(":")
                              .append(ste.getLineNumber()).append(")<br/>");
                }
            }
        }

        String seccionCausaRaiz = causaRaiz.isEmpty() ? "" : String.format("""
                            <div class="causa-box">
                                <h4>Causa Raíz:</h4>
                                <p>%s</p>
                            </div>
                            """, causaRaiz);

        String seccionStackTrace = stackTrace.length() == 0 ? "" : String.format("""
                            <div class="stack-box">
                                <h4>Pila de Llamadas:</h4>
                                <code style="font-size: 11px; line-height: 1.6;">%s</code>
                            </div>
                            """, stackTrace);

        return String.format("""
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <title>Error Procesamiento - SIGRE Asistencia</title>
                    <style>
                        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
                        .container { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
                        .header { background: #ff9800; color: white; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
                        .content { margin: 15px 0; }
                        .info-table { width: 100%%; border-collapse: collapse; margin: 15px 0; }
                        .info-table th, .info-table td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                        .info-table th { background-color: #f2f2f2; width: 180px; }
                        .error-box { background: #ffebee; border: 1px solid #f44336; padding: 15px; border-radius: 5px; margin: 10px 0; }
                        .causa-box { background: #fff3e0; border: 1px solid #ff9800; padding: 15px; border-radius: 5px; margin: 10px 0; }
                        .stack-box { background: #f5f5f5; border: 1px solid #bdbdbd; padding: 15px; border-radius: 5px; margin: 10px 0; overflow-x: auto; }
                        .footer { margin-top: 30px; font-size: 12px; color: #666; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <h2>⚠️ ERROR DE PROCESAMIENTO - Sistema de Asistencia</h2>
                        </div>
                        
                        <div class="content">
                            <h3>Error al Procesar Ticket de Asistencia</h3>
                            
                            <table class="info-table">
                                <tr><th>Ticket ID</th><td>%s</td></tr>
                                <tr><th>Trabajador</th><td>%s (%s)</td></tr>
                                <tr><th>Código Ingresado</th><td>%s</td></tr>
                                <tr><th>Tipo Marcaje</th><td>%s</td></tr>
                                <tr><th>Tipo Movimiento</th><td>%s</td></tr>
                                <tr><th>IP Dispositivo</th><td>%s</td></tr>
                                <tr><th>Fecha Marcación</th><td>%s</td></tr>
                                <tr><th>Intentos</th><td>%s</td></tr>
                            </table>
                            
                            <div class="error-box">
                                <h4>Detalle del Error:</h4>
                                <p>%s</p>
                            </div>
                            
                            %s
                            
                            %s
                            
                            <p><strong>Acción Requerida:</strong> Revisar el ticket en la base de datos y corregir manualmente si es necesario.</p>
                        </div>
                        
                        <div class="footer">
                            <p>Sistema SIGRE - Módulo de Asistencia<br/>
                            Transmarina del PERU SAC</p>
                        </div>
                    </div>
                </body>
                </html>
                """,
                ticket.getNumeroTicket(),
                ticket.getNombreTrabajador(),
                ticket.getCodTrabajador(),
                ticket.getCodigoInput(),
                ticket.getTipoMarcaje(),
                ticket.getTipoMovimiento() != null ? ticket.getTipoMovimiento() : "-",
                ticket.getDireccionIp(),
                ticket.getFechaMarcacion().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")),
                ticket.getIntentosProcesamiento(),
                mensajeError,
                seccionCausaRaiz,
                seccionStackTrace
        );
    }
    
    /**
     * Enviar email a múltiples destinatarios
     */
    private void enviarEmailAMultiplesDestinatarios(String subject, String htmlContent) {
        // Validación adicional de seguridad
        if (mailSender == null) {
            log.warn("⚠️ JavaMailSender no configurado, no se puede enviar email");
            return;
        }
        
        try {
            // Obtener lista de destinatarios desde configuración
            String[] destinatarios = destinatarioEmails.split(",");
            
            for (String destinatario : destinatarios) {
                String email = destinatario.trim();
                if (!email.isEmpty()) {
                    try {
                        enviarEmailHtml(email, subject, htmlContent);
                        log.info("📧 Email enviado exitosamente a: {}", email);
                    } catch (Exception e) {
                        log.error("❌ Error enviando email a: {}", email, e);
                    }
                }
            }
            
        } catch (Exception e) {
            log.error("❌ Error procesando lista de destinatarios: {}", destinatarioEmails, e);
        }
    }
    
    /**
     * Enviar email HTML individual
     */
    private void enviarEmailHtml(String to, String subject, String htmlContent) throws Exception {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
        
        helper.setFrom(fromEmail);
        helper.setTo(to);
        helper.setSubject(subject);
        helper.setText(htmlContent, true); // true = es HTML
        
        mailSender.send(message);
    }
}
