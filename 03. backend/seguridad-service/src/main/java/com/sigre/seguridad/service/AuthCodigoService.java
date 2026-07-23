package com.sigre.seguridad.service;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;

import java.security.SecureRandom;
import java.time.Duration;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Emisión/validación de códigos por email (Strategy por {@link Proposito}).
 * Reutilizado por recuperación de contraseña y confirmación de email del perfil.
 */
@Service
@RequiredArgsConstructor
public class AuthCodigoService {

    public static final int VALIDEZ_MINUTOS = 5;
    public static final int REENVIO_SEGUNDOS = 30;

    public enum Proposito {
        RECUPERACION,
        CONFIRMACION_EMAIL
    }

    private static final String MAYUSCULAS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final String MINUSCULAS = "abcdefghijkmnopqrstuvwxyz";
    private static final String NUMEROS = "0123456789";

    private final JdbcTemplate jdbcTemplate;

    public record CodigoEmitido(String codigo, int validezSegundos, int reenvioSegundos, OffsetDateTime expiraEn) {}

    @Transactional
    public CodigoEmitido emitir(long usuarioId, Proposito proposito) {
        asegurarPuedeReenviar(usuarioId, proposito);

        jdbcTemplate.update(
                """
                UPDATE auth.codigo_recuperacion
                SET usado = TRUE
                WHERE usuario_id = ? AND proposito = ? AND usado = FALSE
                """,
                usuarioId, proposito.name());

        String codigo = generarCodigo();
        OffsetDateTime expiraEn = OffsetDateTime.now().plusMinutes(VALIDEZ_MINUTOS);
        jdbcTemplate.update(
                """
                INSERT INTO auth.codigo_recuperacion
                    (usuario_id, codigo, proposito, expira_en, usado, fec_creacion)
                VALUES (?, ?, ?, ?, FALSE, NOW())
                """,
                usuarioId, codigo, proposito.name(), expiraEn);

        return new CodigoEmitido(codigo, VALIDEZ_MINUTOS * 60, REENVIO_SEGUNDOS, expiraEn);
    }

    @Transactional(readOnly = true)
    public void validar(long usuarioId, String codigo, Proposito proposito) {
        Integer count = jdbcTemplate.queryForObject(
                """
                SELECT COUNT(*)::int FROM auth.codigo_recuperacion
                WHERE usuario_id = ? AND codigo = ? AND proposito = ?
                  AND usado = FALSE AND expira_en > NOW()
                """,
                Integer.class, usuarioId, codigo, proposito.name());
        if (count == null || count == 0) {
            throw new BusinessException(
                    "Código inválido o expirado",
                    HttpStatus.BAD_REQUEST, "CODIGO_INVALIDO");
        }
    }

    @Transactional
    public void consumir(long usuarioId, String codigo, Proposito proposito) {
        validar(usuarioId, codigo, proposito);
        jdbcTemplate.update(
                """
                UPDATE auth.codigo_recuperacion
                SET usado = TRUE
                WHERE usuario_id = ? AND codigo = ? AND proposito = ? AND usado = FALSE
                """,
                usuarioId, codigo, proposito.name());
    }

    private void asegurarPuedeReenviar(long usuarioId, Proposito proposito) {
        List<OffsetDateTime> rows = jdbcTemplate.query(
                """
                SELECT fec_creacion FROM auth.codigo_recuperacion
                WHERE usuario_id = ? AND proposito = ?
                ORDER BY fec_creacion DESC
                LIMIT 1
                """,
                (rs, i) -> rs.getObject("fec_creacion", OffsetDateTime.class),
                usuarioId, proposito.name());
        if (rows.isEmpty() || rows.get(0) == null) {
            return;
        }
        long elapsed = Duration.between(rows.get(0), OffsetDateTime.now()).getSeconds();
        if (elapsed < REENVIO_SEGUNDOS) {
            long falta = REENVIO_SEGUNDOS - elapsed;
            throw new BusinessException(
                    "Debe esperar " + falta + " segundo(s) para solicitar otro código",
                    HttpStatus.TOO_MANY_REQUESTS, "REENVIO_DEMASIADO_PRONTO");
        }
    }

    private String generarCodigo() {
        SecureRandom random = new SecureRandom();
        String codigo;
        do {
            List<Character> chars = new ArrayList<>(8);
            for (int i = 0; i < 4; i++) {
                chars.add(NUMEROS.charAt(random.nextInt(NUMEROS.length())));
            }
            for (int i = 0; i < 2; i++) {
                chars.add(MAYUSCULAS.charAt(random.nextInt(MAYUSCULAS.length())));
            }
            for (int i = 0; i < 2; i++) {
                chars.add(MINUSCULAS.charAt(random.nextInt(MINUSCULAS.length())));
            }
            Collections.shuffle(chars, random);
            StringBuilder sb = new StringBuilder(8);
            chars.forEach(sb::append);
            codigo = sb.toString();
        } while (codigoExiste(codigo));
        return codigo;
    }

    private boolean codigoExiste(String codigo) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*)::int FROM auth.codigo_recuperacion WHERE codigo = ? AND usado = FALSE",
                Integer.class, codigo);
        return count != null && count > 0;
    }
}
