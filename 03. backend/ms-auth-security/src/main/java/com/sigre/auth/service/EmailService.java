package com.sigre.auth.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;

    private static final String FROM = "no-reply@npssac.com.pe";

    @Async
    public void enviarCodigoRecuperacion(String destinatario, String codigo) {
        String subject = "SIGRE - Código de recuperación de contraseña";

        String body = """
                <html>
                <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                  <div style="background: #1a237e; color: white; padding: 20px; text-align: center;">
                    <h2>SIGRE ERP</h2>
                  </div>
                  <div style="padding: 30px; background: #f5f5f5;">
                    <h3>Código de recuperación</h3>
                    <p>Has solicitado restablecer tu contraseña. Tu código de verificación es:</p>
                    <div style="text-align: center; margin: 20px 0;">
                      <span style="font-family:'Courier New',Courier,monospace;font-size:28px;font-weight:bold;letter-spacing:6px;background:#fff;padding:15px 30px;border-radius:8px;border:2px solid #1a237e;display:inline-block;">%s</span>
                    </div>
                    <p>Este código es válido por <strong>5 minutos</strong>.</p>
                    <p style="color: #888; font-size: 12px;">Si no solicitaste este cambio, ignora este correo.</p>
                  </div>
                </body>
                </html>
                """.formatted(codigo);

        enviarHtml(destinatario, subject, body);
    }

    @Async
    public void enviarAlertaBloqueo(String destinatarioUsuario, String destinatarioAdmin,
                                    String username, String ip, String userAgent,
                                    String ipPrivada, String sistemaOperativo) {
        String subject = "SIGRE - Cuenta bloqueada por seguridad";
        String body = """
                <html>
                <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                  <div style="background: #b71c1c; color: white; padding: 20px; text-align: center;">
                    <h2>Alerta de Seguridad</h2>
                  </div>
                  <div style="padding: 30px; background: #f5f5f5;">
                    <h3>Cuenta bloqueada: %s</h3>
                    <p>La cuenta ha sido bloqueada por <strong>24 horas</strong> debido a 3 intentos fallidos de inicio de sesión.</p>
                    <table style="width: 100%%; border-collapse: collapse; margin-top: 15px;">
                      <tr><td style="padding: 8px; border-bottom: 1px solid #ddd;"><strong>IP Pública:</strong></td><td style="padding: 8px; border-bottom: 1px solid #ddd;">%s</td></tr>
                      <tr><td style="padding: 8px; border-bottom: 1px solid #ddd;"><strong>IP Privada:</strong></td><td style="padding: 8px; border-bottom: 1px solid #ddd;">%s</td></tr>
                      <tr><td style="padding: 8px; border-bottom: 1px solid #ddd;"><strong>Sistema Operativo:</strong></td><td style="padding: 8px; border-bottom: 1px solid #ddd;">%s</td></tr>
                      <tr><td style="padding: 8px; border-bottom: 1px solid #ddd;"><strong>User Agent:</strong></td><td style="padding: 8px; border-bottom: 1px solid #ddd;">%s</td></tr>
                    </table>
                  </div>
                </body>
                </html>
                """.formatted(username, ip, ipPrivada, sistemaOperativo, userAgent);

        if (destinatarioUsuario != null) {
            enviarHtml(destinatarioUsuario, subject, body);
        }
        if (destinatarioAdmin != null) {
            enviarHtml(destinatarioAdmin, subject, body);
        }
    }

    private void enviarHtml(String to, String subject, String htmlBody) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setFrom(FROM);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlBody, true);
            mailSender.send(message);
            log.info("Email enviado a {}: {}", to, subject);
        } catch (Exception e) {
            log.error("Error enviando email a {}: {}", to, e.getMessage());
        }
    }
}
