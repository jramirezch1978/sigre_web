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
     * @param nivel severidad del evento: {@code INFO}, {@code WARN} o {@code ERROR}.
     *              Se persiste como flag de un caracter en {@code auth.log_acceso.flag_nivel}
     *              (I = INFO, W = WARN, E = ERROR).
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
                    INSERT INTO auth.log_acceso (usuario_id, empresa_id, evento, exito, flag_nivel, ip, ip_privada, sistema_operativo, user_agent, fecha_login)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
                    """,
                    usuarioId,
                    empresaId,
                    evento,
                    exito,
                    toFlagNivel(nivel),
                    ip,
                    ipPrivada,
                    sistemaOperativo,
                    userAgent);
        } catch (Exception e) {
            log.warn("No se pudo registrar auth.log_acceso evento={}: {}", evento, e.getMessage());
        }
    }

    /**
     * Normaliza la severidad (texto o flag) al flag de un caracter de {@code auth.log_acceso.flag_nivel}.
     */
    private static String toFlagNivel(String nivel) {
        if (nivel == null) {
            return "I";
        }
        return switch (nivel.trim().toUpperCase()) {
            case "WARN", "WARNING", "W" -> "W";
            case "ERROR", "E" -> "E";
            default -> "I"; // INFO
        };
    }
}
