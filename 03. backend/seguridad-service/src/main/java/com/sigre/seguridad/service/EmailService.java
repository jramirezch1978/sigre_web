package com.sigre.seguridad.service;

import com.sigre.seguridad.dto.EmpresaRegistroEmailDto;
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
    public void enviarConfirmacionRegistroEmpresa(EmpresaRegistroEmailDto datos) {
        String subject = "SIGRE ERP - Registro de empresa " + safe(datos.getCodigo());
        enviarHtml(datos.getCorreoContacto(), subject, buildRegistroEmpresaHtml(datos));
    }

    private String buildRegistroEmpresaHtml(EmpresaRegistroEmailDto d) {
        return """
                <!DOCTYPE html>
                <html lang="es">
                <head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
                <body style="margin:0;padding:0;background:#eef2f6;font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;color:#2a3f54;">
                  <table role="presentation" width="100%%" cellspacing="0" cellpadding="0" style="background:#eef2f6;padding:24px 12px;">
                    <tr><td align="center">
                      <table role="presentation" width="640" cellspacing="0" cellpadding="0" style="max-width:640px;background:#ffffff;border-radius:8px;overflow:hidden;box-shadow:0 8px 24px rgba(42,63,84,0.12);">
                        <tr>
                          <td style="background:#2a3f54;padding:28px 32px;">
                            <div style="font-size:12px;letter-spacing:2px;text-transform:uppercase;color:#a7b1c2;margin-bottom:8px;">SIGRE ERP</div>
                            <h1 style="margin:0;font-size:24px;font-weight:600;color:#ffffff;">Registro de empresa completado</h1>
                            <p style="margin:10px 0 0;color:#c5d0dc;font-size:14px;line-height:1.5;">Su organización ha sido registrada correctamente en la plataforma empresarial SIGRE.</p>
                          </td>
                        </tr>
                        <tr>
                          <td style="padding:28px 32px 8px;">
                            <p style="margin:0 0 16px;font-size:15px;line-height:1.6;color:#526273;">
                              Estimado equipo de <strong>%s</strong>,<br>
                              confirmamos el alta de su empresa en SIGRE ERP. A continuación encontrará el resumen de la información registrada.
                            </p>
                          </td>
                        </tr>
                        %s
                        %s
                        %s
                        <tr>
                          <td style="padding:0 32px 28px;">
                            <p style="margin:0;font-size:13px;line-height:1.6;color:#73879c;">
                              Guarde este correo como comprobante del registro. Si detecta algún dato incorrecto, contacte al administrador del sistema para su actualización.
                            </p>
                          </td>
                        </tr>
                        <tr>
                          <td style="background:#f8fafc;padding:18px 32px;border-top:1px solid #e4e9f0;">
                            <p style="margin:0;font-size:11px;color:#95a5a6;line-height:1.5;">
                              Este mensaje fue generado automáticamente por SIGRE ERP. Por favor no responda a este correo.<br>
                              &copy; SIGRE ERP &mdash; Sistema Integrado de Gestión Empresarial
                            </p>
                          </td>
                        </tr>
                      </table>
                    </td></tr>
                  </table>
                </body>
                </html>
                """.formatted(
                escapeHtml(d.getRazonSocial()),
                buildSection("Datos generales", new String[][]{
                        {"Código interno", d.getCodigo()},
                        {"RUC", d.getRuc()},
                        {"Razón social", d.getRazonSocial()},
                        {"Nombre comercial", d.getNombreComercial()},
                        {"Sigla / tenant", d.getSigla()},
                        {"Fecha de registro", d.getFechaRegistro()}
                }),
                buildSection("Representante legal", new String[][]{
                        {"Representante legal", d.getRepresentanteLegal()},
                        {"DNI representante legal", d.getDniRepresentanteLegal()}
                }),
                buildSection("Dirección fiscal", new String[][]{
                        {"Dirección", d.getDireccionFiscal()},
                        {"Departamento", d.getDepartamento()},
                        {"Provincia", d.getProvincia()},
                        {"Distrito", d.getDistrito()},
                        {"Ubigeo", d.getUbigeo()},
                        {"Correo de contacto", d.getCorreoContacto()},
                        {"Teléfono / celular", d.getTelefonoContacto()}
                })
        );
    }

    private String buildSection(String title, String[][] rows) {
        return """
                <tr>
                  <td style="padding:8px 32px 12px;">
                    <table role="presentation" width="100%%" cellspacing="0" cellpadding="0" style="background:#f8fafc;border:1px solid #e4e9f0;border-radius:6px;">
                      <tr><td style="padding:14px 18px;border-bottom:1px solid #e4e9f0;font-size:13px;font-weight:700;color:#2a3f54;text-transform:uppercase;letter-spacing:0.04em;">%s</td></tr>
                      <tr><td style="padding:0 18px 14px;">%s</td></tr>
                    </table>
                  </td>
                </tr>
                """.formatted(escapeHtml(title), buildRows(rows));
    }

    private String buildRows(String[][] rows) {
        StringBuilder html = new StringBuilder("<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" style=\"margin-top:12px;\">");
        for (String[] row : rows) {
            String label = row[0];
            String value = row.length > 1 ? row[1] : null;
            html.append("""
                    <tr>
                      <td style="padding:10px 0;border-bottom:1px solid #edf1f5;width:38%%;font-size:12px;font-weight:600;color:#73879c;vertical-align:top;">%s</td>
                      <td style="padding:10px 0;border-bottom:1px solid #edf1f5;font-size:14px;color:#2a3f54;vertical-align:top;">%s</td>
                    </tr>
                    """.formatted(escapeHtml(label), formatValue(value)));
        }
        html.append("</table>");
        return html.toString();
    }

    private String formatValue(String value) {
        if (value == null || value.isBlank()) {
            return "<span style=\"color:#aab2bd;\">—</span>";
        }
        return escapeHtml(value.trim());
    }

    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }

    private String safe(String value) {
        return value != null ? value : "";
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
