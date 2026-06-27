package com.sigre.worker.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.List;
import java.util.Map;

/**
 * Procesa el ciclo de vida de las licencias demo:
 *  - Vencimiento (15 días): marca la licencia como vencida (V) y desactiva la
 *    empresa y sus usuarios demo.
 *  - Eliminación de BD (20 días): hace DROP DATABASE del tenant y marca la
 *    licencia como eliminada (E).
 */
@Slf4j
@Service
public class LicenciaWorker {

    /** BDs que NUNCA deben eliminarse, aunque por error queden referenciadas. */
    private static final List<String> BD_PROTEGIDAS = List.of(
            "postgres", "template0", "template1", "sigre_security", "sigre_template");

    private final JdbcTemplate security;
    private final JdbcTemplate admin;
    private final RestClient restClient = RestClient.create();

    @Value("${worker.seguridad.base-url:http://seguridad-service:9001}")
    private String seguridadBaseUrl;
    @Value("${worker.seguridad.provision-secret:}")
    private String provisionSecret;

    // Observabilidad (solo lectura, expuesta por WorkerEstadoController).
    private volatile java.time.OffsetDateTime ultimaCorridaVencimiento;
    private volatile java.time.OffsetDateTime ultimaCorridaEliminacion;
    private volatile java.time.OffsetDateTime ultimaCorridaRenovacion;
    private volatile int ultimoVencidas;
    private volatile int ultimoBdEliminadas;
    private volatile int ultimoAvisosRenovacion;

    public LicenciaWorker(JdbcTemplate securityJdbcTemplate,
                          @Qualifier("adminJdbcTemplate") JdbcTemplate adminJdbcTemplate) {
        this.security = securityJdbcTemplate;
        this.admin = adminJdbcTemplate;
    }

    public java.time.OffsetDateTime getUltimaCorridaVencimiento() { return ultimaCorridaVencimiento; }
    public java.time.OffsetDateTime getUltimaCorridaEliminacion() { return ultimaCorridaEliminacion; }
    public java.time.OffsetDateTime getUltimaCorridaRenovacion() { return ultimaCorridaRenovacion; }
    public int getUltimoVencidas() { return ultimoVencidas; }
    public int getUltimoBdEliminadas() { return ultimoBdEliminadas; }
    public int getUltimoAvisosRenovacion() { return ultimoAvisosRenovacion; }

    /** Vencimiento de licencias: desactiva empresa + usuarios demo cuando expira la vigencia. */
    @Scheduled(cron = "${worker.licencias.cron-vencimiento:0 10 * * * *}")
    public void vencerLicencias() {
        this.ultimaCorridaVencimiento = java.time.OffsetDateTime.now();
        List<Map<String, Object>> vencidas = security.queryForList(
                "SELECT id, empresa_id FROM auth.licencia WHERE estado = 'A' AND fecha_vencimiento <= now()");
        this.ultimoVencidas = vencidas.size();
        if (vencidas.isEmpty()) {
            return;
        }
        log.info("[worker] Licencias por vencer: {}", vencidas.size());
        for (Map<String, Object> lic : vencidas) {
            long licId = ((Number) lic.get("id")).longValue();
            long empresaId = ((Number) lic.get("empresa_id")).longValue();
            try {
                security.update("""
                        UPDATE auth.usuario SET flag_estado = '0'
                        WHERE flag_demo = '1'
                          AND id IN (SELECT usuario_id FROM auth.usuario_empresa WHERE empresa_id = ?)
                        """, empresaId);
                security.update("UPDATE auth.usuario_empresa SET flag_estado = '0' WHERE empresa_id = ?", empresaId);
                security.update("UPDATE master.empresa SET flag_estado = '0' WHERE id = ?", empresaId);
                security.update("UPDATE auth.licencia SET estado = 'V', fecha_baja = now() WHERE id = ?", licId);
                log.info("[worker] Licencia {} vencida; empresa {} y usuarios demo desactivados", licId, empresaId);
            } catch (Exception e) {
                log.error("[worker] Error venciendo licencia {} (empresa {}): {}", licId, empresaId, e.getMessage());
            }
        }
    }

    /** Eliminación de la BD del tenant pasados los días configurados. */
    @Scheduled(cron = "${worker.licencias.cron-eliminacion:0 20 * * * *}")
    public void eliminarBasesDeDatos() {
        this.ultimaCorridaEliminacion = java.time.OffsetDateTime.now();
        List<Map<String, Object>> aEliminar = security.queryForList("""
                SELECT l.id AS lic_id, e.id AS emp_id, e.db_name AS db_name
                FROM auth.licencia l
                JOIN master.empresa e ON e.id = l.empresa_id
                WHERE l.bd_eliminada = false AND l.fecha_eliminacion_bd <= now()
                """);
        this.ultimoBdEliminadas = aEliminar.size();
        if (aEliminar.isEmpty()) {
            return;
        }
        log.info("[worker] Tenants por eliminar: {}", aEliminar.size());
        for (Map<String, Object> row : aEliminar) {
            long licId = ((Number) row.get("lic_id")).longValue();
            String dbName = (String) row.get("db_name");
            try {
                if (esEliminable(dbName)) {
                    admin.execute(
                            "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '"
                                    + dbName + "' AND pid <> pg_backend_pid()");
                    admin.execute("DROP DATABASE IF EXISTS \"" + dbName + "\"");
                    log.info("[worker] BD '{}' eliminada (licencia {})", dbName, licId);
                } else {
                    log.warn("[worker] BD '{}' NO elegible para eliminar (licencia {}); solo se marca", dbName, licId);
                }
                security.update("UPDATE auth.licencia SET bd_eliminada = true, estado = 'E' WHERE id = ?", licId);
            } catch (Exception e) {
                log.error("[worker] Error eliminando BD '{}' (licencia {}): {}", dbName, licId, e.getMessage());
            }
        }
    }

    /**
     * Aviso de renovación: dispara a diario el cálculo + correo en seguridad-service (que es
     * el dueño del motor de cálculo y del envío de correos). El worker solo agenda y delega.
     */
    @Scheduled(cron = "${worker.licencias.cron-renovacion:0 30 8 * * *}")
    public void avisarRenovaciones() {
        this.ultimaCorridaRenovacion = java.time.OffsetDateTime.now();
        try {
            Map<?, ?> resp = restClient.post()
                    .uri(seguridadBaseUrl + "/api/auth/seguridad/licencias/procesar-renovaciones")
                    .header("X-Provision-Secret", provisionSecret)
                    .retrieve()
                    .body(Map.class);
            Object data = resp != null ? resp.get("data") : null;
            if (data instanceof Map<?, ?> d && d.get("avisosEnviados") instanceof Number n) {
                this.ultimoAvisosRenovacion = n.intValue();
            }
            log.info("[worker] Avisos de renovación procesados por seguridad-service: {}", this.ultimoAvisosRenovacion);
        } catch (Exception e) {
            log.error("[worker] Error disparando avisos de renovación: {}", e.getMessage());
        }
    }

    /** Solo se eliminan BDs de tenants demo/empresa, nunca las protegidas del sistema. */
    private boolean esEliminable(String dbName) {
        if (dbName == null || !dbName.matches("^[a-z0-9_]+$")) {
            return false;
        }
        if (BD_PROTEGIDAS.contains(dbName)) {
            return false;
        }
        return dbName.startsWith("sigre_demo_") || dbName.startsWith("sigre_emp_");
    }
}
