package com.sigre.seguridad.service;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.JwtTokenProvider;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Persistencia del JWT definitivo en {@code auth.tokens_session}: reutilización hasta expiración
 * e invalidación al cambiar de sucursal/empresa o por logout / inactividad.
 */
@Service
@RequiredArgsConstructor
public class TokensSessionService {

    private final JdbcTemplate jdbcTemplate;
    private final JwtTokenProvider jwtTokenProvider;

    public Optional<String> buscarJwtReutilizable(long usuarioId, long empresaId, long sucursalId) {
        List<TokenRow> rows = jdbcTemplate.query(
                """
                SELECT id, jwt_compacto FROM auth.tokens_session
                WHERE usuario_id = ? AND empresa_id = ? AND sucursal_id = ?
                  AND flag_estado = '1' AND expira_en > NOW()
                """,
                (rs, rowNum) -> new TokenRow(rs.getLong("id"), rs.getString("jwt_compacto")),
                usuarioId, empresaId, sucursalId);
        if (rows.isEmpty()) {
            return Optional.empty();
        }
        TokenRow r = rows.get(0);
        if (r.jwtCompacto == null || r.jwtCompacto.isBlank() || !jwtTokenProvider.validateToken(r.jwtCompacto)) {
            jdbcTemplate.update(
                    """
                    UPDATE auth.tokens_session SET flag_estado = '0', cerrado_en = NOW()
                    WHERE id = ?
                    """,
                    r.id);
            return Optional.empty();
        }
        return Optional.of(r.jwtCompacto);
    }

    private record TokenRow(long id, String jwtCompacto) {}

    /**
     * Inactiva todos los tokens definitivos activos del usuario para esa empresa (cambio de sucursal u nuevo token).
     */
    @Transactional
    public void inactivarActivosUsuarioEmpresa(long usuarioId, long empresaId) {
        jdbcTemplate.update(
                """
                UPDATE auth.tokens_session
                SET flag_estado = '0', cerrado_en = NOW()
                WHERE usuario_id = ? AND empresa_id = ? AND flag_estado = '1'
                """,
                usuarioId, empresaId);
    }

    /**
     * Inserta fila, devuelve id para claim {@code tokensSessionId}; el JWT se actualiza después de firmarlo.
     */
    @Transactional
    public long insertarSesionPendiente(long usuarioId, long empresaId, long sucursalId, OffsetDateTime expiraEn) {
        return jdbcTemplate.queryForObject(
                """
                INSERT INTO auth.tokens_session (usuario_id, empresa_id, sucursal_id, expira_en, flag_estado)
                VALUES (?, ?, ?, ?, '1')
                RETURNING id
                """,
                Long.class,
                usuarioId, empresaId, sucursalId, expiraEn);
    }

    public void guardarJwt(long tokensSessionId, String jwtCompacto) {
        jdbcTemplate.update(
                "UPDATE auth.tokens_session SET jwt_compacto = ? WHERE id = ?",
                jwtCompacto, tokensSessionId);
    }

    @Transactional
    public void inactivarPorId(long tokensSessionId, long usuarioId) {
        jdbcTemplate.update(
                """
                UPDATE auth.tokens_session
                SET flag_estado = '0', cerrado_en = NOW()
                WHERE id = ? AND usuario_id = ? AND flag_estado = '1'
                """,
                tokensSessionId, usuarioId);
    }

    public boolean sesionActivaParaToken(long usuarioId, long tokensSessionId) {
        Integer n = jdbcTemplate.queryForObject(
                """
                SELECT COUNT(*) FROM auth.tokens_session
                WHERE id = ? AND usuario_id = ? AND flag_estado = '1' AND expira_en > NOW()
                """,
                Integer.class,
                tokensSessionId, usuarioId);
        return n != null && n > 0;
    }

    /**
     * Sesión activa con empresa/sucursal para renovar access (refresh token).
     */
    public Optional<SesionActivaRow> findSesionActiva(long tokensSessionId, long usuarioId) {
        List<SesionActivaRow> rows = jdbcTemplate.query(
                """
                SELECT empresa_id, sucursal_id FROM auth.tokens_session
                WHERE id = ? AND usuario_id = ? AND flag_estado = '1' AND expira_en > NOW()
                """,
                (rs, rowNum) -> new SesionActivaRow(rs.getLong("empresa_id"), rs.getLong("sucursal_id")),
                tokensSessionId, usuarioId);
        return rows.isEmpty() ? Optional.empty() : Optional.of(rows.get(0));
    }

    public record SesionActivaRow(long empresaId, long sucursalId) {}

    @Transactional
    public void renovarExpiracionYJwt(long tokensSessionId, long usuarioId,
                                      OffsetDateTime nuevaExpira, String jwtCompacto) {
        int updated = jdbcTemplate.update(
                """
                UPDATE auth.tokens_session
                SET expira_en = ?, jwt_compacto = ?
                WHERE id = ? AND usuario_id = ? AND flag_estado = '1'
                """,
                nuevaExpira, jwtCompacto, tokensSessionId, usuarioId);
        if (updated == 0) {
            throw new BusinessException(
                    "Sesión cerrada o no encontrada. Inicie sesión nuevamente.",
                    HttpStatus.UNAUTHORIZED, "SESION_REVOADA");
        }
    }
}
