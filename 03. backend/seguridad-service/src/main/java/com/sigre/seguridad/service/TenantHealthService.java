package com.sigre.seguridad.service;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Detecta cuándo la BD de un tenant vuelve a estar en línea (transición caído→disponible)
 * y avisa por correo a los administradores de esa empresa. Nadie vigilaba esto antes: el
 * panel "Sesiones BD" del admin solo muestrea bajo demanda (cuando alguien abre la pantalla).
 *
 * El estado "último conocido" se guarda en memoria (no en BD): un reinicio del servicio
 * pierde el historial y simplemente vuelve a tomar una foto base sin enviar correo en el
 * primer chequeo tras reiniciar, para no spamear si el tenant ya estaba en línea de antes.
 */
@Slf4j
@Service
public class TenantHealthService {

    private final JdbcTemplate jdbcTemplate;
    private final EmailService emailService;
    private final Map<Long, Boolean> ultimoEstadoConocido = new ConcurrentHashMap<>();

    @Value("${spring.datasource.username}")
    private String provisioningDbUsername;

    @Value("${spring.datasource.password}")
    private String provisioningDbPassword;

    @Value("${app.tenant.jdbc-ssl-mode:require}")
    private String jdbcSslMode;

    public TenantHealthService(JdbcTemplate jdbcTemplate, EmailService emailService) {
        this.jdbcTemplate = jdbcTemplate;
        this.emailService = emailService;
    }

    private record TenantDato(long id, String razonSocial, String dbName, String dbHost, int dbPort, String correoContacto) {}

    /** Revisa todos los tenants activos; envía correo a correo_contacto + todos los usuarios de los que acaban de volver en línea. */
    public void verificarYNotificar() {
        for (TenantDato t : listarTenantsActivos()) {
            boolean enLinea = probarConexion(t);
            Boolean anterior = ultimoEstadoConocido.put(t.id(), enLinea);
            boolean transicionAOnline = enLinea && anterior != null && !anterior;
            if (transicionAOnline) {
                log.info("[tenant-health] '{}' volvió a estar en línea", t.razonSocial());
                List<String> destinatarios = correosNotificacion(t);
                emailService.enviarBaseDatosDisponible(destinatarios, t.razonSocial(), t.dbName());
            }
        }
    }

    private List<TenantDato> listarTenantsActivos() {
        return jdbcTemplate.query(
                """
                SELECT id, razon_social, db_name, db_host, db_port, correo_contacto
                FROM master.empresa
                WHERE flag_estado = '1'
                ORDER BY id
                """,
                (rs, row) -> new TenantDato(
                        rs.getLong("id"),
                        rs.getString("razon_social"),
                        rs.getString("db_name"),
                        rs.getString("db_host"),
                        rs.getInt("db_port"),
                        rs.getString("correo_contacto")));
    }

    private boolean probarConexion(TenantDato t) {
        String url = String.format(Locale.ROOT, "jdbc:postgresql://%s:%d/%s?sslmode=%s",
                t.dbHost(), t.dbPort(), t.dbName(), jdbcSslMode);
        HikariConfig cfg = new HikariConfig();
        cfg.setJdbcUrl(url);
        cfg.setUsername(provisioningDbUsername);
        cfg.setPassword(provisioningDbPassword);
        cfg.setMaximumPoolSize(1);
        cfg.setPoolName("health-pg-" + t.id());
        cfg.setConnectionTimeout(8_000);
        try (HikariDataSource ds = new HikariDataSource(cfg)) {
            new JdbcTemplate(ds).queryForObject("SELECT 1", Integer.class);
            return true;
        } catch (Exception e) {
            log.debug("[tenant-health] '{}' no disponible: {}", t.razonSocial(), e.toString());
            return false;
        }
    }

    /**
     * Destinatarios del aviso: correo_contacto de la empresa (si tiene) + el correo de
     * TODOS los usuarios activos asociados a ella (no solo administradores) — a pedido
     * explícito, para que se entere cualquiera con cuenta en esa empresa.
     */
    private List<String> correosNotificacion(TenantDato t) {
        Set<String> destinatarios = new LinkedHashSet<>();
        if (t.correoContacto() != null && !t.correoContacto().isBlank()) {
            destinatarios.add(t.correoContacto().trim());
        }
        destinatarios.addAll(correosUsuariosDeEmpresa(t.id()));
        return List.copyOf(destinatarios);
    }

    private List<String> correosUsuariosDeEmpresa(long empresaId) {
        return jdbcTemplate.queryForList(
                """
                SELECT DISTINCT u.email
                FROM auth.usuario u
                JOIN auth.usuario_empresa ue ON ue.usuario_id = u.id
                WHERE ue.empresa_id = ?
                  AND ue.flag_estado = '1'
                  AND u.flag_estado = '1'
                  AND u.email IS NOT NULL AND u.email <> ''
                """,
                String.class, empresaId);
    }
}
