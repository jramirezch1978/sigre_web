package com.sigre.seguridad.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;

/**
 * Persistencia de eventos en {@code auth.log_acceso} (BD security).
 */
@Slf4j
@Service
public class LogAccesoService {

    private final JdbcTemplate jdbcTemplate;

    public LogAccesoService(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    /**
     * @param nivel {@code INFO}, {@code WARN} o {@code ERROR} (columna {@code auth.log_acceso.nivel})
     */
    public void registrar(
            Long usuarioId,
            Long empresaId,
            String evento,
            boolean exito,
            String nivel,
            String ip,
            String ipPrivada,
            String sistemaOperativo,
            String userAgent) {
        try {
            jdbcTemplate.update(
                    """
                    INSERT INTO auth.log_acceso (usuario_id, empresa_id, evento, exito, nivel, ip, ip_privada, sistema_operativo, user_agent, fecha_login)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
                    """,
                    usuarioId,
                    empresaId,
                    evento,
                    exito,
                    nivel != null ? nivel : "INFO",
                    ip,
                    ipPrivada,
                    sistemaOperativo,
                    userAgent);
        } catch (Exception e) {
            log.warn("No se pudo registrar auth.log_acceso evento={}: {}", evento, e.getMessage());
        }
    }
}
