package com.sigre.seguridad.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;

/**
 * Persistencia de eventos en {@code auth.log_acceso} (BD security).
 *
 * <p>El INSERT se ejecuta en una conexión PROPIA tomada del pool
 * ({@code dataSource.getConnection()}), NO en la conexión de la transacción en
 * curso. Así, un fallo de auditoría nunca aborta la transacción de negocio
 * (login, selección de empresa, provisión, etc.) ni produce errores engañosos
 * como un falso "sesión expirada": si la auditoría falla, solo deja un WARN y el
 * flujo continúa con normalidad.</p>
 */
@Slf4j
@Service
public class LogAccesoService {

    private static final String INSERT_SQL = """
            INSERT INTO auth.log_acceso (usuario_id, empresa_id, evento, exito, flag_nivel, ip, ip_privada, sistema_operativo, user_agent, fecha_login)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
            """;

    private final DataSource dataSource;

    public LogAccesoService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    /**
     * Registra un evento de acceso. Nunca lanza ni afecta la transacción del que llama.
     *
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
        // Conexión independiente del pool: aislada de la transacción de negocio en curso.
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT_SQL)) {
            if (!con.getAutoCommit()) {
                con.setAutoCommit(true);
            }
            setLong(ps, 1, usuarioId);
            setLong(ps, 2, empresaId);
            ps.setString(3, evento);
            ps.setBoolean(4, exito);
            ps.setString(5, toFlagNivel(nivel));
            ps.setString(6, ip);
            ps.setString(7, ipPrivada);
            ps.setString(8, sistemaOperativo);
            ps.setString(9, userAgent);
            ps.executeUpdate();
        } catch (Exception e) {
            log.warn("No se pudo registrar auth.log_acceso evento={}: {}", evento, e.getMessage());
        }
    }

    private static void setLong(PreparedStatement ps, int idx, Long value) throws SQLException {
        if (value == null) {
            ps.setNull(idx, Types.BIGINT);
        } else {
            ps.setLong(idx, value);
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
