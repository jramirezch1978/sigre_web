package com.sigre.worker.controller;

import com.sigre.worker.service.LicenciaWorker;
import com.sigre.worker.service.TenantHealthWorker;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * API SOLO DE LECTURA del worker. No expone disparo manual de los jobs (corren
 * automáticos por @Scheduled); solo permite consultar el avance/estado de los
 * procesos en segundo plano (licencias demo y salud de tenants).
 */
@RestController
@RequestMapping("/api/worker")
public class WorkerEstadoController {

    private final JdbcTemplate security;
    private final LicenciaWorker worker;
    private final TenantHealthWorker tenantHealthWorker;

    public WorkerEstadoController(
            JdbcTemplate securityJdbcTemplate,
            LicenciaWorker worker,
            TenantHealthWorker tenantHealthWorker) {
        this.security = securityJdbcTemplate;
        this.worker = worker;
        this.tenantHealthWorker = tenantHealthWorker;
    }

    /** Últimas corridas del monitoreo de BDs tenant. */
    @GetMapping("/tenants/salud")
    public Map<String, Object> estadoSaludTenants() {
        Map<String, Object> r = new LinkedHashMap<>();
        r.put("ultimaCorridaArranque", tenantHealthWorker.getUltimaCorridaArranque());
        r.put("ultimaCorridaPeriodica", tenantHealthWorker.getUltimaCorridaPeriodica());
        return r;
    }

    /** Resumen del job de licencias: últimas corridas + conteos por estado. */
    @GetMapping("/licencias/estado")
    public Map<String, Object> estadoLicencias() {
        Map<String, Object> r = new LinkedHashMap<>();
        r.put("ultimaCorridaVencimiento", worker.getUltimaCorridaVencimiento());
        r.put("ultimaCorridaEliminacion", worker.getUltimaCorridaEliminacion());
        r.put("ultimaCorridaRenovacion", worker.getUltimaCorridaRenovacion());
        r.put("ultimoVencidas", worker.getUltimoVencidas());
        r.put("ultimoBdEliminadas", worker.getUltimoBdEliminadas());
        r.put("ultimoAvisosRenovacion", worker.getUltimoAvisosRenovacion());
        r.put("activas", contar("estado = 'A'"));
        r.put("vencidas", contar("estado = 'V'"));
        r.put("bdEliminadas", contar("estado = 'E'"));
        r.put("porVencer3dias", security.queryForObject(
                "SELECT COUNT(*) FROM auth.licencia WHERE estado = 'A' AND fecha_vencimiento <= now() + interval '3 days'",
                Integer.class));
        return r;
    }

    /** Detalle de licencias con días restantes (para monitoreo). */
    @GetMapping("/licencias")
    public List<Map<String, Object>> licencias() {
        return security.queryForList("""
                SELECT l.codigo_licencia, l.empresa_id, e.razon_social, l.tipo, l.estado,
                       l.fecha_inicio, l.fecha_vencimiento, l.fecha_eliminacion_bd, l.bd_eliminada,
                       GREATEST(0, CEIL(EXTRACT(EPOCH FROM (l.fecha_vencimiento - now())) / 86400))::int AS dias_restantes
                FROM auth.licencia l
                JOIN master.empresa e ON e.id = l.empresa_id
                ORDER BY l.fecha_inicio DESC
                """);
    }

    private int contar(String condicion) {
        Integer n = security.queryForObject("SELECT COUNT(*) FROM auth.licencia WHERE " + condicion, Integer.class);
        return n == null ? 0 : n;
    }
}
