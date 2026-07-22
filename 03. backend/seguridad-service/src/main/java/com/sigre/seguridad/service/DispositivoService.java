package com.sigre.seguridad.service;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.seguridad.dto.DispositivoRegistradoResponse;
import com.sigre.seguridad.dto.RegistrarDispositivoRequest;
import com.sigre.seguridad.dto.seguridad.DispositivoAdminDto;
import com.sigre.seguridad.dto.seguridad.DispositivoLoginDto;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Dispositivos móviles registrados (Hermes u otras apps nativas): permite loguear
 * vía /api/auth/login/mobile sin Cloudflare Turnstile, porque el equipo ya se
 * identificó una vez y quedó marcado como autorizado (o no) en {@code auth.dispositivo}.
 */
@Service
@RequiredArgsConstructor
public class DispositivoService {

    private final JdbcTemplate jdbcTemplate;

    public record DispositivoRow(long id, boolean autorizado) {}

    /** Alta idempotente por device_id: si ya existe, devuelve su nro_registro/autorizacion actuales. */
    @Transactional
    public DispositivoRegistradoResponse registrar(RegistrarDispositivoRequest req) {
        List<DispositivoRegistradoResponse> existentes = jdbcTemplate.query(
                "SELECT nro_registro, flag_autorizado FROM auth.dispositivo WHERE device_id = ?",
                (rs, rowNum) -> DispositivoRegistradoResponse.builder()
                        .nroRegistro(rs.getString("nro_registro"))
                        .autorizado("1".equals(rs.getString("flag_autorizado")))
                        .build(),
                req.getDeviceId());
        if (!existentes.isEmpty()) {
            return existentes.get(0);
        }

        long id = jdbcTemplate.queryForObject(
                """
                INSERT INTO auth.dispositivo
                    (device_id, nro_registro, imei, fabricante, modelo, nombre_dispositivo, software, flag_autorizado)
                VALUES (?, '', ?, ?, ?, ?, '1')
                RETURNING id
                """,
                Long.class,
                req.getDeviceId(), req.getImei(), req.getFabricante(),
                req.getModelo(), req.getNombreDispositivo(), req.getSoftware());

        String nroRegistro = "DM" + String.format("%010d", id);
        jdbcTemplate.update("UPDATE auth.dispositivo SET nro_registro = ? WHERE id = ?", nroRegistro, id);

        return DispositivoRegistradoResponse.builder()
                .nroRegistro(nroRegistro)
                .autorizado(true)
                .build();
    }

    public Optional<DispositivoRow> buscarPorNroRegistro(String nroRegistro) {
        List<DispositivoRow> rows = jdbcTemplate.query(
                "SELECT id, flag_autorizado FROM auth.dispositivo WHERE nro_registro = ?",
                (rs, rowNum) -> new DispositivoRow(rs.getLong("id"), "1".equals(rs.getString("flag_autorizado"))),
                nroRegistro);
        return rows.isEmpty() ? Optional.empty() : Optional.of(rows.get(0));
    }

    /**
     * Registra un inicio de sesión del dispositivo: actualiza el "último login" en
     * auth.dispositivo (lectura rápida) Y agrega una fila en auth.dispositivo_login
     * (historial completo) — equivalente a registerLogin() de FastSales.
     */
    @Transactional
    public void registrarLogin(long dispositivoId, Long usuarioId) {
        OffsetDateTime ahora = OffsetDateTime.now();
        jdbcTemplate.update(
                "UPDATE auth.dispositivo SET usuario_id = ?, fec_ultimo_login = ? WHERE id = ?",
                usuarioId, ahora, dispositivoId);
        jdbcTemplate.update(
                "INSERT INTO auth.dispositivo_login (dispositivo_id, usuario_id, fec_login) VALUES (?, ?, ?)",
                dispositivoId, usuarioId, ahora);
    }

    /** Historial completo de logins de un dispositivo (más reciente primero), para el admin. */
    public List<DispositivoLoginDto> listarLogins(long dispositivoId) {
        return jdbcTemplate.query(
                """
                SELECT dl.id, dl.usuario_id, u.nombre_completo AS usuario_nombre, dl.fec_login
                FROM auth.dispositivo_login dl
                LEFT JOIN auth.usuario u ON u.id = dl.usuario_id
                WHERE dl.dispositivo_id = ?
                ORDER BY dl.fec_login DESC
                """,
                (rs, rowNum) -> DispositivoLoginDto.builder()
                        .id(rs.getLong("id"))
                        .usuarioId(rs.getObject("usuario_id") != null ? rs.getLong("usuario_id") : null)
                        .usuarioNombre(rs.getString("usuario_nombre"))
                        .fecLogin(rs.getObject("fec_login", OffsetDateTime.class))
                        .build(),
                dispositivoId);
    }

    public List<DispositivoAdminDto> listar() {
        return jdbcTemplate.query(
                """
                SELECT d.id, d.device_id, d.nro_registro, d.imei, d.fabricante, d.modelo,
                       d.nombre_dispositivo, d.software, d.flag_autorizado,
                       d.usuario_id, u.nombre_completo AS usuario_nombre,
                       d.fec_registro, d.fec_ultimo_login
                FROM auth.dispositivo d
                LEFT JOIN auth.usuario u ON u.id = d.usuario_id
                ORDER BY d.fec_registro DESC
                """,
                (rs, rowNum) -> DispositivoAdminDto.builder()
                        .id(rs.getLong("id"))
                        .deviceId(rs.getString("device_id"))
                        .nroRegistro(rs.getString("nro_registro"))
                        .imei(rs.getString("imei"))
                        .fabricante(rs.getString("fabricante"))
                        .modelo(rs.getString("modelo"))
                        .nombreDispositivo(rs.getString("nombre_dispositivo"))
                        .software(rs.getString("software"))
                        .autorizado("1".equals(rs.getString("flag_autorizado")))
                        .usuarioId(rs.getObject("usuario_id") != null ? rs.getLong("usuario_id") : null)
                        .usuarioNombre(rs.getString("usuario_nombre"))
                        .fecRegistro(rs.getObject("fec_registro", OffsetDateTime.class))
                        .fecUltimoLogin(rs.getObject("fec_ultimo_login", OffsetDateTime.class))
                        .build());
    }

    @Transactional
    public void actualizarAutorizacion(long id, boolean autorizado) {
        jdbcTemplate.update(
                "UPDATE auth.dispositivo SET flag_autorizado = ? WHERE id = ?",
                autorizado ? "1" : "0", id);
    }
}
