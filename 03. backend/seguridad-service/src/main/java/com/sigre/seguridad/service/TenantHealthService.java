package com.sigre.seguridad.service;

import com.sigre.seguridad.dto.TenantDisponibilidadDto;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Monitoreo de disponibilidad de BDs tenant.
 * <ul>
 *   <li>Arranque (worker): avisa a cada empresa si su BD está online y, si todas
 *       están activas, envía resumen profesional a soporte (SOPORTE/EMAILS).</li>
 *   <li>Periódico (cada 30 min): notifica recuperación a la empresa y desconexión a soporte.</li>
 * </ul>
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

    /**
     * Chequeo de arranque: establece baseline, notifica a cada tenant online y,
     * si todos están activos, envía resumen a soporte. Si hay caídos, alerta a soporte.
     */
    public void verificarArranqueYNotificar() {
        List<TenantDato> tenants = listarTenantsActivos();
        if (tenants.isEmpty()) {
            log.warn("[tenant-health] Arranque: no hay empresas activas para monitorear");
            return;
        }

        List<TenantDisponibilidadDto> resultados = new ArrayList<>();
        for (TenantDato t : tenants) {
            boolean enLinea = probarConexion(t);
            ultimoEstadoConocido.put(t.id(), enLinea);
            resultados.add(new TenantDisponibilidadDto(
                    t.id(), t.razonSocial(), t.dbName(), t.dbHost(), t.dbPort(), enLinea));
            if (enLinea) {
                emailService.enviarBaseDatosDisponible(
                        correosNotificacion(t), t.razonSocial(), t.dbName());
            }
        }

        boolean todosActivos = resultados.stream().allMatch(TenantDisponibilidadDto::disponible);
        if (todosActivos) {
            log.info("[tenant-health] Arranque: {} tenants activos — notificando a soporte", resultados.size());
            emailService.enviarResumenTenantsArranque(resultados);
        } else {
            List<TenantDisponibilidadDto> caidos = resultados.stream()
                    .filter(r -> !r.disponible())
                    .toList();
            log.warn("[tenant-health] Arranque: {}/{} tenants sin BD disponible", caidos.size(), resultados.size());
            for (TenantDisponibilidadDto c : caidos) {
                emailService.enviarAlertaDesconexionTenant(c);
            }
        }
    }

    /**
     * Chequeo periódico: recuperación → correo a usuarios de la empresa;
     * desconexión (online→offline) → alerta a soporte.
     */
    public void verificarYNotificar() {
        for (TenantDato t : listarTenantsActivos()) {
            boolean enLinea = probarConexion(t);
            Boolean anterior = ultimoEstadoConocido.put(t.id(), enLinea);

            boolean transicionAOnline = enLinea && anterior != null && !anterior;
            if (transicionAOnline) {
                log.info("[tenant-health] '{}' volvió a estar en línea", t.razonSocial());
                emailService.enviarBaseDatosDisponible(correosNotificacion(t), t.razonSocial(), t.dbName());
            }

            boolean transicionAOffline = !enLinea && anterior != null && anterior;
            if (transicionAOffline) {
                log.warn("[tenant-health] '{}' dejó de estar disponible", t.razonSocial());
                emailService.enviarAlertaDesconexionTenant(new TenantDisponibilidadDto(
                        t.id(), t.razonSocial(), t.dbName(), t.dbHost(), t.dbPort(), false));
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
