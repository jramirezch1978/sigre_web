package com.sigre.seguridad.service;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import com.sigre.seguridad.dto.DispositivoRegistradoResponse;
import com.sigre.seguridad.dto.RegistrarDispositivoRequest;
import com.sigre.seguridad.dto.seguridad.DispositivoAdminDto;
import com.sigre.seguridad.dto.seguridad.DispositivoLoginDto;
import com.sigre.seguridad.util.Ipv4;
import com.sigre.common.exception.BusinessException;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Dispositivos móviles — modelo alineado a SIGRE:
 * <ul>
 *   <li>{@code auth.dispositivo} ≈ {@code DEVICE_MOBILE}: maestro del equipo (sin nro_registro).</li>
 *   <li>{@code auth.dispositivo_login} ≈ {@code SEG_LOGIN_DEVICE}: sesiones con
 *       {@code nro_registro} autonumérico ({@code config.fn_siguiente_numerador('DISPOSITIVO')}).</li>
 * </ul>
 * Un mismo equipo puede tener muchas sesiones; el correlativo vive en la sesión.
 */
@Service
@RequiredArgsConstructor
public class DispositivoService {

    private static final String NUMERADOR_DISPOSITIVO = "DISPOSITIVO";

    private final JdbcTemplate jdbcTemplate;
    private final EmailService emailService;

    public record DispositivoRow(long id, String deviceId, boolean autorizado) {}

    private record UpsertResult(long id, boolean creado) {}

    /**
     * Alta del maestro por {@code device_id} + apertura/reutilización de sesión abierta
     * (como {@code registraDevice} de FastSales / SIGRE).
     * <p>
     * Si ya hay una sesión sin {@code fec_logout} para ese equipo, reutiliza su
     * {@code nro_registro}; si no, emite uno nuevo vía numerador.
     * Solo cuando se inserta un dispositivo nuevo se notifica a soporte por correo.
     */
    @Transactional
    public DispositivoRegistradoResponse registrar(RegistrarDispositivoRequest req) {
        UpsertResult upsert = upsertDispositivo(req);
        boolean autorizado = esAutorizado(upsert.id());

        Optional<String> nroAbierto = buscarNroSesionAbierta(req.getDeviceId());
        String nroRegistro = nroAbierto
                .map(nro -> {
                    actualizarIpsSesion(nro, req);
                    return nro;
                })
                .orElseGet(() -> abrirSesion(upsert.id(), req));

        if (upsert.creado()) {
            notificarNuevoDispositivoTrasCommit(req, nroRegistro, autorizado);
        }

        return DispositivoRegistradoResponse.builder()
                .nroRegistro(nroRegistro)
                .autorizado(autorizado)
                .build();
    }

    private void notificarNuevoDispositivoTrasCommit(
            RegistrarDispositivoRequest req, String nroRegistro, boolean autorizado) {
        Runnable enviar = () -> emailService.enviarAlertaNuevoDispositivo(
                req.getDeviceId(),
                nroRegistro,
                req.getNombreDispositivo(),
                req.getFabricante(),
                req.getModelo(),
                req.getSoftware(),
                req.getImei(),
                Ipv4.normalizeOrNull(req.getIpPublica()),
                Ipv4.normalizeOrNull(req.getIpPrivada()),
                autorizado);
        if (TransactionSynchronizationManager.isSynchronizationActive()) {
            AtomicBoolean done = new AtomicBoolean(false);
            TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                @Override
                public void afterCommit() {
                    if (done.compareAndSet(false, true)) {
                        enviar.run();
                    }
                }
            });
        } else {
            enviar.run();
        }
    }

    private UpsertResult upsertDispositivo(RegistrarDispositivoRequest req) {
        List<Long> ids = jdbcTemplate.query(
                "SELECT id FROM auth.dispositivo WHERE device_id = ?",
                (rs, rowNum) -> rs.getLong("id"),
                req.getDeviceId());
        if (!ids.isEmpty()) {
            long id = ids.get(0);
            jdbcTemplate.update(
                    """
                    UPDATE auth.dispositivo
                    SET nombre_dispositivo = ?,
                        fabricante = ?,
                        modelo = ?,
                        ip_publica = COALESCE(?, ip_publica),
                        ip_privada = COALESCE(?, ip_privada),
                        fec_modificacion = NOW()
                    WHERE id = ?
                    """,
                    req.getNombreDispositivo(), req.getFabricante(), req.getModelo(),
                    Ipv4.normalizeOrNull(req.getIpPublica()), Ipv4.normalizeOrNull(req.getIpPrivada()), id);
            return new UpsertResult(id, false);
        }

        Long id = jdbcTemplate.queryForObject(
                """
                INSERT INTO auth.dispositivo
                    (device_id, nombre_dispositivo, fabricante, modelo, ip_publica, ip_privada, flag_autorizado)
                VALUES (?, ?, ?, ?, ?, ?, '1')
                RETURNING id
                """,
                Long.class,
                req.getDeviceId(), req.getNombreDispositivo(), req.getFabricante(), req.getModelo(),
                Ipv4.normalizeOrNull(req.getIpPublica()), Ipv4.normalizeOrNull(req.getIpPrivada()));
        return new UpsertResult(id, true);
    }

    private boolean esAutorizado(long dispositivoId) {
        String flag = jdbcTemplate.queryForObject(
                "SELECT flag_autorizado FROM auth.dispositivo WHERE id = ?",
                String.class,
                dispositivoId);
        return "1".equals(flag);
    }

    private Optional<String> buscarNroSesionAbierta(String deviceId) {
        List<String> rows = jdbcTemplate.query(
                """
                SELECT nro_registro
                FROM auth.dispositivo_login
                WHERE device_id = ? AND fec_logout IS NULL
                ORDER BY fec_registro DESC
                LIMIT 1
                """,
                (rs, rowNum) -> rs.getString("nro_registro"),
                deviceId);
        return rows.isEmpty() ? Optional.empty() : Optional.of(rows.get(0));
    }

    private void actualizarIpsSesion(String nroRegistro, RegistrarDispositivoRequest req) {
        jdbcTemplate.update(
                """
                UPDATE auth.dispositivo_login
                SET ip_publica = COALESCE(?, ip_publica),
                    ip_privada = COALESCE(?, ip_privada),
                    imei = COALESCE(?, imei),
                    software = COALESCE(?, software),
                    nombre_dispositivo = COALESCE(?, nombre_dispositivo),
                    fabricante = COALESCE(?, fabricante),
                    modelo = COALESCE(?, modelo)
                WHERE nro_registro = ?
                """,
                Ipv4.normalizeOrNull(req.getIpPublica()), Ipv4.normalizeOrNull(req.getIpPrivada()),
                blankToNull(req.getImei()), blankToNull(req.getSoftware()),
                blankToNull(req.getNombreDispositivo()), blankToNull(req.getFabricante()),
                blankToNull(req.getModelo()), nroRegistro);
    }

    private String abrirSesion(long dispositivoId, RegistrarDispositivoRequest req) {
        String nroRegistro = siguienteNroRegistro();
        jdbcTemplate.update(
                """
                INSERT INTO auth.dispositivo_login
                    (nro_registro, dispositivo_id, device_id, imei, software,
                     nombre_dispositivo, fabricante, modelo, ip_publica, ip_privada, fec_registro)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
                """,
                nroRegistro, dispositivoId, req.getDeviceId(), req.getImei(), req.getSoftware(),
                req.getNombreDispositivo(), req.getFabricante(), req.getModelo(),
                Ipv4.normalizeOrNull(req.getIpPublica()), Ipv4.normalizeOrNull(req.getIpPrivada()));
        return nroRegistro;
    }

    private String siguienteNroRegistro() {
        try {
            String nro = jdbcTemplate.queryForObject(
                    "SELECT config.fn_siguiente_numerador(?)",
                    String.class,
                    NUMERADOR_DISPOSITIVO);
            if (nro == null || nro.isBlank()) {
                throw new BusinessException(
                        "No se pudo obtener el número de registro de la sesión del dispositivo",
                        HttpStatus.INTERNAL_SERVER_ERROR,
                        "NUMERADOR_DISPOSITIVO_VACIO");
            }
            return nro;
        } catch (BusinessException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new BusinessException(
                    "Numerador DISPOSITIVO no disponible. Ejecute create-security.",
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "NUMERADOR_DISPOSITIVO_NO_CONFIGURADO");
        }
    }

    public Optional<DispositivoRow> buscarPorNroRegistro(String nroRegistro) {
        List<DispositivoRow> rows = jdbcTemplate.query(
                """
                SELECT d.id, d.device_id, d.flag_autorizado
                FROM auth.dispositivo_login dl
                INNER JOIN auth.dispositivo d ON d.id = dl.dispositivo_id
                WHERE dl.nro_registro = ?
                """,
                (rs, rowNum) -> new DispositivoRow(
                        rs.getLong("id"),
                        rs.getString("device_id"),
                        "1".equals(rs.getString("flag_autorizado"))),
                nroRegistro);
        return rows.isEmpty() ? Optional.empty() : Optional.of(rows.get(0));
    }

    @Transactional
    public void registrarLogin(String nroRegistro, Long usuarioId) {
        OffsetDateTime ahora = OffsetDateTime.now();
        int updated = jdbcTemplate.update(
                """
                UPDATE auth.dispositivo_login
                SET usuario_id = ?, fec_login = ?, fec_logout = NULL
                WHERE nro_registro = ?
                """,
                usuarioId, ahora, nroRegistro);
        if (updated == 0) {
            throw new BusinessException(
                    "Sesión de dispositivo no encontrada",
                    HttpStatus.FORBIDDEN,
                    "DISPOSITIVO_NO_REGISTRADO");
        }
        jdbcTemplate.update(
                """
                UPDATE auth.dispositivo d
                SET fec_ultimo_login = ?, fec_modificacion = NOW()
                FROM auth.dispositivo_login dl
                WHERE dl.nro_registro = ? AND d.id = dl.dispositivo_id
                """,
                ahora, nroRegistro);
    }

    @Transactional
    public void registrarLogout(String nroRegistro) {
        jdbcTemplate.update(
                "UPDATE auth.dispositivo_login SET fec_logout = NOW() WHERE nro_registro = ? AND fec_logout IS NULL",
                nroRegistro);
    }

    /**
     * Cierra la sesión abierta del dispositivo (por nro o por device_id) y abre una nueva.
     * Usado cuando el usuario cancela empresa/sucursal en login: la sesión anterior “murió”.
     */
    @Transactional
    public DispositivoRegistradoResponse renovarSesion(RegistrarDispositivoRequest req, String nroRegistroActual) {
        if (nroRegistroActual != null && !nroRegistroActual.isBlank()) {
            registrarLogout(nroRegistroActual.trim());
        }
        if (req.getDeviceId() != null && !req.getDeviceId().isBlank()) {
            jdbcTemplate.update(
                    """
                    UPDATE auth.dispositivo_login
                    SET fec_logout = NOW()
                    WHERE device_id = ? AND fec_logout IS NULL
                    """,
                    req.getDeviceId());
        }
        return registrar(req);
    }

    public List<DispositivoLoginDto> listarLogins(long dispositivoId) {
        return jdbcTemplate.query(
                """
                SELECT dl.nro_registro, dl.usuario_id, u.nombre_completo AS usuario_nombre,
                       dl.imei, dl.software, dl.ip_publica, dl.ip_privada,
                       dl.fec_login, dl.fec_logout, dl.fec_registro
                FROM auth.dispositivo_login dl
                LEFT JOIN auth.usuario u ON u.id = dl.usuario_id
                WHERE dl.dispositivo_id = ?
                ORDER BY dl.fec_registro DESC
                """,
                (rs, rowNum) -> DispositivoLoginDto.builder()
                        .nroRegistro(rs.getString("nro_registro"))
                        .usuarioId(rs.getObject("usuario_id") != null ? rs.getLong("usuario_id") : null)
                        .usuarioNombre(rs.getString("usuario_nombre"))
                        .imei(rs.getString("imei"))
                        .software(rs.getString("software"))
                        .ipPublica(rs.getString("ip_publica"))
                        .ipPrivada(rs.getString("ip_privada"))
                        .fecLogin(rs.getObject("fec_login", OffsetDateTime.class))
                        .fecLogout(rs.getObject("fec_logout", OffsetDateTime.class))
                        .fecRegistro(rs.getObject("fec_registro", OffsetDateTime.class))
                        .build(),
                dispositivoId);
    }

    public List<DispositivoAdminDto> listar() {
        return jdbcTemplate.query(
                """
                SELECT d.id, d.device_id, d.fabricante, d.modelo, d.nombre_dispositivo,
                       d.ip_publica, d.ip_privada,
                       d.flag_autorizado, d.fec_registro, d.fec_ultimo_login,
                       u.nombre_completo AS usuario_nombre,
                       u.id AS usuario_id,
                       (SELECT dl.nro_registro
                          FROM auth.dispositivo_login dl
                         WHERE dl.dispositivo_id = d.id
                         ORDER BY dl.fec_registro DESC
                         LIMIT 1) AS ultimo_nro_registro
                FROM auth.dispositivo d
                LEFT JOIN LATERAL (
                    SELECT dl2.usuario_id
                    FROM auth.dispositivo_login dl2
                    WHERE dl2.dispositivo_id = d.id AND dl2.usuario_id IS NOT NULL
                    ORDER BY COALESCE(dl2.fec_login, dl2.fec_registro) DESC
                    LIMIT 1
                ) ult ON TRUE
                LEFT JOIN auth.usuario u ON u.id = ult.usuario_id
                ORDER BY d.fec_registro DESC
                """,
                (rs, rowNum) -> DispositivoAdminDto.builder()
                        .id(rs.getLong("id"))
                        .deviceId(rs.getString("device_id"))
                        .ultimoNroRegistro(rs.getString("ultimo_nro_registro"))
                        .fabricante(rs.getString("fabricante"))
                        .modelo(rs.getString("modelo"))
                        .nombreDispositivo(rs.getString("nombre_dispositivo"))
                        .ipPublica(rs.getString("ip_publica"))
                        .ipPrivada(rs.getString("ip_privada"))
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
                "UPDATE auth.dispositivo SET flag_autorizado = ?, fec_modificacion = NOW() WHERE id = ?",
                autorizado ? "1" : "0", id);
    }

    private static String blankToNull(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        return value.trim();
    }
}
