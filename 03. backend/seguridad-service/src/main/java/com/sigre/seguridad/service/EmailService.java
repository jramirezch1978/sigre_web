package com.sigre.seguridad.service;

import com.sigre.common.config.ConfigParametros;
import com.sigre.common.util.Constants;
import com.sigre.common.util.EmailListParser;
import com.sigre.seguridad.dto.EmpresaRegistroEmailDto;
import com.sigre.seguridad.dto.TenantDisponibilidadDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.MimeMessage;

import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;
    private final JdbcTemplate jdbcTemplate;

    private static final String FROM = "no-reply@npssac.com.pe";
    private static final DateTimeFormatter FMT_FECHA =
            DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss XXX").withLocale(Locale.forLanguageTag("es-PE"));

    /** Copia (CC) fija de todos los correos. Configurable en YAML (app.notificacion.email.cc). */
    @org.springframework.beans.factory.annotation.Value("${app.notificacion.email.cc:}")
    private String copiaFija;

    /**
     * Destinatarios TO de alertas de soporte. Preferencia: BD config.SOPORTE/EMAILS,
     * fallback YAML {@code app.notificacion.email.soporte}.
     */
    @org.springframework.beans.factory.annotation.Value(
            "${app.notificacion.email.soporte:" + Constants.NOTIFICACION_EMAIL_SOPORTE_DEFAULT + "}")
    private String emailsSoporteYaml;

    @Async
    public void enviarCodigoRecuperacion(String destinatario, String codigo) {
        enviarCodigoGenerico(
                destinatario,
                "SIGRE - Código de recuperación de contraseña",
                "Código de recuperación",
                "Has solicitado restablecer tu contraseña. Tu código de verificación es:",
                codigo);
    }

    @Async
    public void enviarCodigoConfirmacionEmail(String destinatario, String codigo) {
        enviarCodigoGenerico(
                destinatario,
                "SIGRE - Confirma tu correo electrónico",
                "Confirmación de correo",
                "Para confirmar o actualizar tu correo en Hermes/SIGRE, usa este código:",
                codigo);
    }

    private void enviarCodigoGenerico(
            String destinatario, String subject, String titulo, String mensaje, String codigo) {
        String body = """
                <html>
                <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                  <div style="background: #1a237e; color: white; padding: 20px; text-align: center;">
                    <h2>SIGRE ERP</h2>
                  </div>
                  <div style="padding: 30px; background: #f5f5f5;">
                    <h3>%s</h3>
                    <p>%s</p>
                    <div style="text-align: center; margin: 20px 0;">
                      <span style="font-family:'Courier New',Courier,monospace;font-size:28px;font-weight:bold;letter-spacing:6px;background:#fff;padding:15px 30px;border-radius:8px;border:2px solid #1a237e;display:inline-block;">%s</span>
                    </div>
                    <p>Este código es válido por <strong>%d minutos</strong>.</p>
                    <p style="color: #888; font-size: 12px;">Si no solicitaste este cambio, ignora este correo.</p>
                  </div>
                </body>
                </html>
                """.formatted(titulo, mensaje, codigo, AuthCodigoService.VALIDEZ_MINUTOS);
        enviarHtml(destinatario, subject, body);
    }

    @Async
    public void enviarConfirmacionRegistroEmpresa(EmpresaRegistroEmailDto datos) {
        String subject = "SIGRE ERP - Registro de empresa " + safe(datos.getCodigo());
        enviarHtml(datos.getCorreoContacto(), subject, buildRegistroEmpresaHtml(datos));
    }

    /** Correo con el número de licencia demo y su vigencia. */
    @Async
    public void enviarLicenciaDemo(String destinatario, String razonSocial, String codigoLicencia,
                                   String vencimiento, int dias) {
        if (destinatario == null || destinatario.isBlank()) {
            log.warn("No se envió correo de licencia demo: empresa sin correo de contacto");
            return;
        }
        String subject = "SIGRE ERP - Licencia Demo activada";
        String body = """
                <html><body style="font-family:'Segoe UI',Arial,sans-serif;max-width:640px;margin:0 auto;color:#2a3f54;">
                  <div style="background:#2a3f54;color:#fff;padding:24px 28px;border-radius:8px 8px 0 0;">
                    <div style="font-size:12px;letter-spacing:2px;text-transform:uppercase;color:#a7b1c2;">SIGRE ERP</div>
                    <h1 style="margin:6px 0 0;font-size:22px;">Licencia Demo activada</h1>
                  </div>
                  <div style="padding:28px;background:#f5f7fa;border-radius:0 0 8px 8px;">
                    <p>Estimado cliente de <strong>%s</strong>,</p>
                    <p>Su licencia <strong>Demo</strong> (edición Enterprise — todos los módulos) ha sido activada. Este es su número de licencia:</p>
                    <div style="text-align:center;margin:24px 0;">
                      <span style="font-family:'Courier New',monospace;font-size:26px;font-weight:bold;letter-spacing:4px;background:#fff;padding:16px 28px;border-radius:8px;border:2px solid #0d6efd;color:#0d6efd;display:inline-block;">%s</span>
                    </div>
                    <table style="width:100%%;border-collapse:collapse;font-size:14px;">
                      <tr><td style="padding:8px 0;color:#64748b;">Edición</td><td style="padding:8px 0;text-align:right;font-weight:600;">Enterprise (Demo)</td></tr>
                      <tr><td style="padding:8px 0;color:#64748b;">Duración</td><td style="padding:8px 0;text-align:right;font-weight:600;">%d días</td></tr>
                      <tr><td style="padding:8px 0;color:#64748b;">Vence</td><td style="padding:8px 0;text-align:right;font-weight:600;">%s</td></tr>
                      <tr><td style="padding:8px 0;color:#64748b;">Usuarios máximos</td><td style="padding:8px 0;text-align:right;font-weight:600;">5</td></tr>
                    </table>
                    <p style="color:#888;font-size:12px;margin-top:20px;">Al finalizar el período demo el acceso se desactivará automáticamente. Conserve este número de licencia.</p>
                  </div>
                </body></html>
                """.formatted(safe(razonSocial), safe(codigoLicencia), dias, safe(vencimiento));
        enviarHtml(destinatario, subject, body);
    }

    /** Aviso al responsable de la licencia: la licencia está por vencer y el costo de renovación. */
    @Async
    public void enviarRecordatorioRenovacion(String destinatario, String razonSocial, String codigoLicencia,
                                             String edicion, String vencimiento, int usuariosActivos,
                                             java.math.BigDecimal costoTotal) {
        if (destinatario == null || destinatario.isBlank()) {
            log.warn("No se envió aviso de renovación: licencia {} sin correo de responsable", codigoLicencia);
            return;
        }
        String subject = "SIGRE ERP - Su licencia está por vencer";
        String body = """
                <html><body style="font-family:'Segoe UI',Arial,sans-serif;max-width:640px;margin:0 auto;color:#2a3f54;">
                  <div style="background:#2a3f54;color:#fff;padding:24px 28px;border-radius:8px 8px 0 0;">
                    <div style="font-size:12px;letter-spacing:2px;text-transform:uppercase;color:#a7b1c2;">SIGRE ERP</div>
                    <h1 style="margin:6px 0 0;font-size:22px;">Su licencia está por vencer</h1>
                  </div>
                  <div style="padding:28px;background:#f5f7fa;border-radius:0 0 8px 8px;">
                    <p>Estimado responsable de <strong>%s</strong>,</p>
                    <p>Le recordamos que su licencia <strong>%s</strong> vence el <strong>%s</strong>.
                       Para mantener el servicio sin interrupciones, realice la renovación mensual antes de esa fecha.</p>
                    <table style="width:100%%;border-collapse:collapse;font-size:14px;background:#fff;border-radius:8px;overflow:hidden;">
                      <tr><td style="padding:10px 14px;color:#64748b;">Licencia</td><td style="padding:10px 14px;text-align:right;font-weight:600;font-family:'Courier New',monospace;">%s</td></tr>
                      <tr><td style="padding:10px 14px;color:#64748b;">Edición</td><td style="padding:10px 14px;text-align:right;font-weight:600;">%s</td></tr>
                      <tr><td style="padding:10px 14px;color:#64748b;">Usuarios activos</td><td style="padding:10px 14px;text-align:right;font-weight:600;">%d</td></tr>
                      <tr><td style="padding:12px 14px;color:#0d6efd;font-weight:700;border-top:2px solid #e4e9f0;">Costo de renovación (mensual)</td><td style="padding:12px 14px;text-align:right;font-weight:800;font-size:18px;color:#0d6efd;border-top:2px solid #e4e9f0;">USD %s</td></tr>
                    </table>
                    <p style="color:#888;font-size:12px;margin-top:20px;">El costo se calcula según la tarifa de su edición y la cantidad de usuarios activos que han iniciado sesión. No incluye impuestos.</p>
                  </div>
                </body></html>
                """.formatted(safe(razonSocial), safe(edicion), safe(vencimiento),
                safe(codigoLicencia), safe(edicion), usuariosActivos,
                costoTotal != null ? costoTotal.toPlainString() : "0.00");
        enviarHtml(destinatario, subject, body);
    }

    /**
     * Aviso a los administradores de la empresa de que su BD tenant volvió a estar en
     * línea (detectado por TenantHealthService/worker tras una caída). Uno por
     * destinatario (no se exponen los correos de los demás admins entre sí).
     */
    @Async
    public void enviarBaseDatosDisponible(java.util.List<String> destinatarios, String razonSocial, String dbName) {
        if (destinatarios == null || destinatarios.isEmpty()) {
            log.warn("No se envió aviso de BD disponible para '{}': sin administradores con correo.", razonSocial);
            return;
        }
        String subject = "SIGRE ERP - Base de datos disponible";
        String body = """
                <html><body style="font-family:'Segoe UI',Arial,sans-serif;max-width:640px;margin:0 auto;color:#2a3f54;">
                  <div style="background:#2a3f54;color:#fff;padding:24px 28px;border-radius:8px 8px 0 0;">
                    <div style="font-size:12px;letter-spacing:2px;text-transform:uppercase;color:#a7b1c2;">SIGRE ERP</div>
                    <h1 style="margin:6px 0 0;font-size:22px;">Base de datos disponible</h1>
                  </div>
                  <div style="padding:28px;background:#f5f7fa;border-radius:0 0 8px 8px;">
                    <p>Estimado administrador de <strong>%s</strong>,</p>
                    <p>Le informamos que la base de datos de su empresa (<code>%s</code>) ya se encuentra <strong>en línea</strong> y disponible para su uso.</p>
                    <p style="color:#888;font-size:12px;margin-top:20px;">Este es un aviso automático generado por el sistema de monitoreo de SIGRE ERP.</p>
                  </div>
                </body></html>
                """.formatted(safe(razonSocial), safe(dbName));
        for (String destinatario : destinatarios) {
            if (destinatario != null && !destinatario.isBlank()) {
                enviarHtml(destinatario, subject, body);
            }
        }
    }

    /**
     * Resumen profesional a soporte cuando, al arrancar el monitoreo (worker),
     * todas las BDs tenant están activas.
     */
    @Async
    public void enviarResumenTenantsArranque(List<TenantDisponibilidadDto> tenants) {
        List<String> soporte = correosSoporte();
        if (soporte.isEmpty()) {
            log.warn("No se envió resumen de arranque de tenants: listado SOPORTE vacío");
            return;
        }
        if (tenants == null || tenants.isEmpty()) {
            return;
        }
        String fecha = OffsetDateTime.now().format(FMT_FECHA);
        int total = tenants.size();
        String filas = buildFilasEstadoTenants(tenants);
        String subject = "SIGRE ERP — Monitoreo: " + total + " tenant(s) activo(s)";
        String body = """
                <!DOCTYPE html>
                <html lang="es">
                <head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
                <body style="margin:0;padding:0;background:#eef2f6;font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;color:#2a3f54;">
                  <table role="presentation" width="100%%" cellspacing="0" cellpadding="0" style="background:#eef2f6;padding:24px 12px;">
                    <tr><td align="center">
                      <table role="presentation" width="640" cellspacing="0" cellpadding="0" style="max-width:640px;background:#ffffff;border-radius:8px;overflow:hidden;box-shadow:0 8px 24px rgba(42,63,84,0.12);">
                        <tr>
                          <td style="background:#1b5e20;padding:28px 32px;">
                            <div style="font-size:12px;letter-spacing:2px;text-transform:uppercase;color:#a5d6a7;margin-bottom:8px;">SIGRE ERP · Soporte</div>
                            <h1 style="margin:0;font-size:22px;font-weight:600;color:#ffffff;">Tenants operativos</h1>
                            <p style="margin:10px 0 0;color:#c8e6c9;font-size:14px;line-height:1.5;">
                              El monitoreo del worker-service confirmó que todas las bases de datos de clientes están activos.
                            </p>
                          </td>
                        </tr>
                        <tr>
                          <td style="padding:24px 32px 8px;">
                            <p style="margin:0 0 8px;font-size:14px;line-height:1.6;color:#526273;">
                              Fecha de verificación: <strong>%s</strong><br>
                              Total de empresas activas: <strong>%d</strong>
                            </p>
                          </td>
                        </tr>
                        <tr>
                          <td style="padding:8px 32px 24px;">
                            <table role="presentation" width="100%%" cellspacing="0" cellpadding="0" style="border:1px solid #e4e9f0;border-radius:6px;overflow:hidden;">
                              <tr style="background:#f8fafc;">
                                <td style="padding:12px 14px;font-size:11px;font-weight:700;color:#73879c;text-transform:uppercase;">Empresa</td>
                                <td style="padding:12px 14px;font-size:11px;font-weight:700;color:#73879c;text-transform:uppercase;">Base de datos</td>
                                <td style="padding:12px 14px;font-size:11px;font-weight:700;color:#73879c;text-transform:uppercase;">Host</td>
                                <td style="padding:12px 14px;font-size:11px;font-weight:700;color:#73879c;text-transform:uppercase;text-align:right;">Estado</td>
                              </tr>
                              %s
                            </table>
                          </td>
                        </tr>
                        <tr>
                          <td style="background:#f8fafc;padding:18px 32px;border-top:1px solid #e4e9f0;">
                            <p style="margin:0;font-size:11px;color:#95a5a6;line-height:1.5;">
                              Aviso automático del monitoreo de tenants (worker-service → seguridad-service).<br>
                              Destinatarios: listado SOPORTE / EMAILS. No responda a este correo.
                            </p>
                          </td>
                        </tr>
                      </table>
                    </td></tr>
                  </table>
                </body>
                </html>
                """.formatted(escapeHtml(fecha), total, filas);
        for (String to : soporte) {
            enviarHtml(to, subject, body);
        }
    }

    /**
     * Alerta a soporte cuando la BD de un cliente deja de responder (arranque o monitoreo).
     */
    @Async
    public void enviarAlertaDesconexionTenant(TenantDisponibilidadDto tenant) {
        List<String> soporte = correosSoporte();
        if (soporte.isEmpty()) {
            log.warn("No se envió alerta de desconexión de tenant: listado SOPORTE vacío");
            return;
        }
        if (tenant == null) {
            return;
        }
        String fecha = OffsetDateTime.now().format(FMT_FECHA);
        String hostPuerto = nz(tenant.dbHost()) + ":" + tenant.dbPort();
        String subject = "SIGRE ERP — ALERTA: BD tenant no disponible — " + nz(tenant.razonSocial());
        String body = """
                <!DOCTYPE html>
                <html lang="es">
                <head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
                <body style="margin:0;padding:0;background:#eef2f6;font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;color:#2a3f54;">
                  <table role="presentation" width="100%%" cellspacing="0" cellpadding="0" style="background:#eef2f6;padding:24px 12px;">
                    <tr><td align="center">
                      <table role="presentation" width="640" cellspacing="0" cellpadding="0" style="max-width:640px;background:#ffffff;border-radius:8px;overflow:hidden;box-shadow:0 8px 24px rgba(42,63,84,0.12);">
                        <tr>
                          <td style="background:#b71c1c;padding:28px 32px;">
                            <div style="font-size:12px;letter-spacing:2px;text-transform:uppercase;color:#ffcdd2;margin-bottom:8px;">SIGRE ERP · Soporte</div>
                            <h1 style="margin:0;font-size:22px;font-weight:600;color:#ffffff;">Desconexión de base de datos</h1>
                            <p style="margin:10px 0 0;color:#ffcdd2;font-size:14px;line-height:1.5;">
                              El monitoreo detectó que la BD de un cliente no responde.
                            </p>
                          </td>
                        </tr>
                        <tr>
                          <td style="padding:28px 32px;">
                            <p style="margin:0 0 16px;font-size:14px;line-height:1.6;color:#526273;">
                              Detectado: <strong>%s</strong>
                            </p>
                            <table role="presentation" width="100%%" cellspacing="0" cellpadding="0" style="background:#fff8f8;border:1px solid #ffcdd2;border-radius:6px;">
                              <tr>
                                <td style="padding:14px 18px;border-bottom:1px solid #ffebee;font-size:12px;font-weight:600;color:#73879c;width:38%%;">Empresa</td>
                                <td style="padding:14px 18px;border-bottom:1px solid #ffebee;font-size:14px;font-weight:600;color:#2a3f54;">%s</td>
                              </tr>
                              <tr>
                                <td style="padding:14px 18px;border-bottom:1px solid #ffebee;font-size:12px;font-weight:600;color:#73879c;">Base de datos</td>
                                <td style="padding:14px 18px;border-bottom:1px solid #ffebee;font-size:14px;font-family:monospace;color:#2a3f54;">%s</td>
                              </tr>
                              <tr>
                                <td style="padding:14px 18px;border-bottom:1px solid #ffebee;font-size:12px;font-weight:600;color:#73879c;">Host / puerto</td>
                                <td style="padding:14px 18px;border-bottom:1px solid #ffebee;font-size:14px;font-family:monospace;color:#2a3f54;">%s</td>
                              </tr>
                              <tr>
                                <td style="padding:14px 18px;font-size:12px;font-weight:600;color:#73879c;">Estado</td>
                                <td style="padding:14px 18px;font-size:14px;font-weight:700;color:#b71c1c;">NO DISPONIBLE</td>
                              </tr>
                            </table>
                            <p style="margin:18px 0 0;font-size:13px;line-height:1.6;color:#73879c;">
                              Verifique conectividad, servicio PostgreSQL y credenciales del tenant. El monitoreo reintentará periódicamente.
                            </p>
                          </td>
                        </tr>
                        <tr>
                          <td style="background:#f8fafc;padding:18px 32px;border-top:1px solid #e4e9f0;">
                            <p style="margin:0;font-size:11px;color:#95a5a6;line-height:1.5;">
                              Alerta automática del monitoreo de tenants. Destinatarios: listado SOPORTE / EMAILS.
                            </p>
                          </td>
                        </tr>
                      </table>
                    </td></tr>
                  </table>
                </body>
                </html>
                """.formatted(
                escapeHtml(fecha),
                escapeHtml(nz(tenant.razonSocial())),
                escapeHtml(nz(tenant.dbName())),
                escapeHtml(hostPuerto));
        for (String to : soporte) {
            enviarHtml(to, subject, body);
        }
    }

    private String buildFilasEstadoTenants(List<TenantDisponibilidadDto> tenants) {
        StringBuilder html = new StringBuilder();
        boolean alt = false;
        for (TenantDisponibilidadDto t : tenants) {
            String bg = alt ? "#fafbfc" : "#ffffff";
            alt = !alt;
            String estadoColor = t.disponible() ? "#1b5e20" : "#b71c1c";
            String estadoTxt = t.disponible() ? "ACTIVO" : "CAÍDO";
            String host = nz(t.dbHost()) + ":" + t.dbPort();
            html.append("""
                    <tr style="background:%s;">
                      <td style="padding:12px 14px;font-size:13px;color:#2a3f54;border-top:1px solid #eef2f6;">%s</td>
                      <td style="padding:12px 14px;font-size:12px;font-family:monospace;color:#526273;border-top:1px solid #eef2f6;">%s</td>
                      <td style="padding:12px 14px;font-size:12px;font-family:monospace;color:#526273;border-top:1px solid #eef2f6;">%s</td>
                      <td style="padding:12px 14px;font-size:12px;font-weight:700;color:%s;text-align:right;border-top:1px solid #eef2f6;">%s</td>
                    </tr>
                    """.formatted(
                    bg,
                    escapeHtml(nz(t.razonSocial())),
                    escapeHtml(nz(t.dbName())),
                    escapeHtml(host),
                    estadoColor,
                    estadoTxt));
        }
        return html.toString();
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

    /** Direcciones de copia fija (separadas por coma o ;) configuradas en YAML. */
    private String[] copiaFijaArray() {
        if (copiaFija == null || copiaFija.isBlank()) {
            return new String[0];
        }
        return java.util.Arrays.stream(copiaFija.split("[,;]"))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .toArray(String[]::new);
    }

    /**
     * Alerta a soporte cuando se da de alta un dispositivo móvil nuevo (auth.dispositivo).
     * Destinatarios: listado SOPORTE (BD o YAML).
     */
    @Async
    public void enviarAlertaNuevoDispositivo(
            String deviceId,
            String nroRegistro,
            String nombreDispositivo,
            String fabricante,
            String modelo,
            String software,
            String imei,
            String ipPublica,
            String ipPrivada,
            boolean autorizado) {
        List<String> soporte = correosSoporte();
        if (soporte.isEmpty()) {
            log.warn("No se envió alerta de nuevo dispositivo: listado SOPORTE vacío");
            return;
        }
        String subject = "SIGRE - Nuevo dispositivo móvil registrado";
        String body = """
                <html><body style="font-family:'Segoe UI',Arial,sans-serif;max-width:640px;margin:0 auto;color:#2a3f54;">
                  <div style="background:#2a3f54;color:#fff;padding:24px 28px;border-radius:8px 8px 0 0;">
                    <div style="font-size:12px;letter-spacing:2px;text-transform:uppercase;color:#a7b1c2;">SIGRE ERP</div>
                    <h1 style="margin:6px 0 0;font-size:22px;">Nuevo dispositivo móvil</h1>
                  </div>
                  <div style="padding:28px;background:#f5f7fa;border-radius:0 0 8px 8px;">
                    <p>Se registró un <strong>nuevo dispositivo</strong> en <code>auth.dispositivo</code>.</p>
                    <table style="width:100%%;border-collapse:collapse;font-size:14px;background:#fff;border-radius:8px;overflow:hidden;">
                      <tr><td style="padding:10px 14px;color:#64748b;">Device ID</td><td style="padding:10px 14px;text-align:right;font-weight:600;font-family:monospace;">%s</td></tr>
                      <tr><td style="padding:10px 14px;color:#64748b;">Nro. sesión</td><td style="padding:10px 14px;text-align:right;font-weight:600;font-family:monospace;">%s</td></tr>
                      <tr><td style="padding:10px 14px;color:#64748b;">Nombre</td><td style="padding:10px 14px;text-align:right;font-weight:600;">%s</td></tr>
                      <tr><td style="padding:10px 14px;color:#64748b;">Fabricante</td><td style="padding:10px 14px;text-align:right;font-weight:600;">%s</td></tr>
                      <tr><td style="padding:10px 14px;color:#64748b;">Modelo</td><td style="padding:10px 14px;text-align:right;font-weight:600;">%s</td></tr>
                      <tr><td style="padding:10px 14px;color:#64748b;">Software</td><td style="padding:10px 14px;text-align:right;font-weight:600;">%s</td></tr>
                      <tr><td style="padding:10px 14px;color:#64748b;">IMEI</td><td style="padding:10px 14px;text-align:right;font-weight:600;">%s</td></tr>
                      <tr><td style="padding:10px 14px;color:#64748b;">IP pública</td><td style="padding:10px 14px;text-align:right;font-weight:600;">%s</td></tr>
                      <tr><td style="padding:10px 14px;color:#64748b;">IP privada</td><td style="padding:10px 14px;text-align:right;font-weight:600;">%s</td></tr>
                      <tr><td style="padding:10px 14px;color:#64748b;">Autorizado</td><td style="padding:10px 14px;text-align:right;font-weight:600;">%s</td></tr>
                    </table>
                    <p style="color:#888;font-size:12px;margin-top:20px;">Aviso automático de seguridad SIGRE. Revise /admin/dispositivos si debe revocar el equipo.</p>
                  </div>
                </body></html>
                """.formatted(
                escapeHtml(nz(deviceId)),
                escapeHtml(nz(nroRegistro)),
                escapeHtml(nz(nombreDispositivo)),
                escapeHtml(nz(fabricante)),
                escapeHtml(nz(modelo)),
                escapeHtml(nz(software)),
                escapeHtml(nz(imei)),
                escapeHtml(nz(ipPublica)),
                escapeHtml(nz(ipPrivada)),
                autorizado ? "Sí" : "No");
        for (String to : soporte) {
            enviarHtml(to, subject, body);
        }
    }

    /** Listado de soporte: BD config.SOPORTE/EMAILS, si no YAML/default. */
    public List<String> correosSoporte() {
        try {
            String fromDb = jdbcTemplate.queryForObject(
                    "SELECT config.fn_get_parametro_txt(?, ?, ?)",
                    String.class,
                    ConfigParametros.Modulo.SOPORTE,
                    ConfigParametros.EMAILS,
                    Constants.NOTIFICACION_EMAIL_SOPORTE_DEFAULT);
            List<String> parsed = EmailListParser.parse(fromDb);
            if (!parsed.isEmpty()) {
                return parsed;
            }
        } catch (Exception ex) {
            log.warn("No se pudo leer SOPORTE/EMAILS de config: {}", ex.getMessage());
        }
        return EmailListParser.parseOrDefault(emailsSoporteYaml, Constants.NOTIFICACION_EMAIL_SOPORTE_DEFAULT);
    }

    private static String nz(String value) {
        return (value == null || value.isBlank()) ? "—" : value.trim();
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
            String[] cc = copiaFijaArray();
            if (cc.length > 0) {
                helper.setCc(cc);
            }
            helper.setSubject(subject);
            helper.setText(htmlBody, true);
            mailSender.send(message);
            log.info("Email enviado a {}: {}", to, subject);
        } catch (Exception e) {
            log.error("Error enviando email a {}: {}", to, e.getMessage());
        }
    }
}
