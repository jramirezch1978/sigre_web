package com.sigre.seguridad.service;

import com.sigre.common.exception.BusinessException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.security.SecureRandom;
import java.time.OffsetDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

/**
 * Gestión de licencias del ERP (auth.licencia) y motor de cálculo de costo mensual.
 *
 * <p>Regla de precio (la misma que muestra la landing del frontend):
 * cada usuario cuesta {@code precio}/mes (por usuario y por empresa); el plan incluye
 * hasta {@code max_usuarios} a tarifa base y cada usuario adicional sobre ese límite
 * cuesta {@code precio + RECARGO_USUARIO_EXTRA}. El "tamaño" facturable es la cantidad
 * de usuarios <b>activos que han iniciado sesión</b> en la empresa.</p>
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LicenciaService {

    public static final int DEMO_DIAS_VIGENCIA = 15;
    public static final int DEMO_DIAS_ELIMINACION_BD = 20;
    public static final String EDICION_DEMO = "ENTERPRISE";
    public static final int DEMO_MAX_USUARIOS = 5;

    /** Recargo mensual por usuario que excede el límite incluido (debe coincidir con la landing). */
    public static final BigDecimal RECARGO_USUARIO_EXTRA = new BigDecimal("2");
    /** Días antes del vencimiento en que se envía el aviso de renovación. */
    public static final int DIAS_AVISO_RENOVACION = 7;

    private static final SecureRandom RANDOM = new SecureRandom();
    private static final char[] HEX = "0123456789ABCDEF".toCharArray();
    private static final DateTimeFormatter FMT_FECHA = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private final JdbcTemplate jdbcTemplate;
    private final EmailService emailService;

    /** Datos de la licencia recién creada (para correo/respuesta). */
    public record LicenciaDemo(String codigo, OffsetDateTime vencimiento, int diasVigencia) {}

    /** Desglose del costo mensual calculado por el motor. */
    public record CostoMensual(
            String edicionCodigo,
            BigDecimal precioBase,
            int maxIncluidos,
            int usuariosActivos,
            int usuariosIncluidos,
            int usuariosExtra,
            BigDecimal recargoPorUsuario,
            BigDecimal costoTotal) {}

    /** Datos de la licencia activa de una empresa. */
    public record LicenciaInfo(long id, String tipo, String edicionCodigo, int maxUsuarios,
                               OffsetDateTime fechaInicio, OffsetDateTime fechaVencimiento, String estado) {}

    /** Evaluación previa al alta de un usuario: si excede el límite de la edición y su costo. */
    public record AltaUsuarioEval(boolean esDemo, int maxUsuarios, int usuariosActivos,
                                  boolean excede, BigDecimal costoUsuarioAdicional) {}

    /** Código de 16 hex en grupos de 4: XXXX-XXXX-XXXX-XXXX (estilo Windows). */
    public String generarCodigo() {
        StringBuilder sb = new StringBuilder(19);
        for (int grupo = 0; grupo < 4; grupo++) {
            if (grupo > 0) {
                sb.append('-');
            }
            for (int i = 0; i < 4; i++) {
                sb.append(HEX[RANDOM.nextInt(16)]);
            }
        }
        return sb.toString();
    }

    /** Crea la licencia demo (Enterprise) para la empresa. Reintenta ante colisión de código. */
    @Transactional
    public LicenciaDemo crearLicenciaDemo(long empresaId, String correoResponsable) {
        OffsetDateTime inicio = OffsetDateTime.now();
        OffsetDateTime vencimiento = inicio.plusDays(DEMO_DIAS_VIGENCIA);
        OffsetDateTime eliminacionBd = inicio.plusDays(DEMO_DIAS_ELIMINACION_BD);

        for (int intento = 0; intento < 6; intento++) {
            String codigo = generarCodigo();
            try {
                jdbcTemplate.update("""
                        INSERT INTO auth.licencia (empresa_id, codigo_licencia, edicion_codigo, tipo,
                            max_usuarios, correo_responsable, fecha_inicio, fecha_vencimiento,
                            fecha_eliminacion_bd, estado, flag_estado)
                        VALUES (?, ?, ?, 'D', ?, ?, ?, ?, ?, 'A', '1')
                        """,
                        empresaId, codigo, EDICION_DEMO, DEMO_MAX_USUARIOS,
                        emptyToNull(correoResponsable), inicio, vencimiento, eliminacionBd);
                log.info("Licencia demo {} creada para empresa {} (vence {})", codigo, empresaId, vencimiento);
                return new LicenciaDemo(codigo, vencimiento, DEMO_DIAS_VIGENCIA);
            } catch (DuplicateKeyException e) {
                log.warn("Colisión de código de licencia {}, reintentando…", codigo);
            }
        }
        throw new IllegalStateException("No se pudo generar un código de licencia único tras varios intentos.");
    }

    /**
     * Motor de cálculo: costo mensual de la licencia ACTIVA de una empresa, según la edición
     * (plan de suscripción) y la cantidad de usuarios activos que han iniciado sesión.
     */
    public CostoMensual calcularCostoMensual(long empresaId) {
        String edicion = obtenerEdicionLicenciaActiva(empresaId);
        return calcularCostoPorEdicion(edicion, contarUsuariosActivosConAcceso(empresaId));
    }

    /** Cálculo puro a partir de la edición y la cantidad de usuarios facturables. */
    public CostoMensual calcularCostoPorEdicion(String edicionCodigo, int usuariosActivos) {
        Map<String, Object> plan = obtenerPlanPorEdicion(edicionCodigo);
        BigDecimal precio = plan != null && plan.get("precio") != null
                ? new BigDecimal(plan.get("precio").toString())
                : BigDecimal.ZERO;
        int maxIncluidos = plan != null && plan.get("max_usuarios") != null
                ? ((Number) plan.get("max_usuarios")).intValue()
                : usuariosActivos;

        int incluidos = Math.min(usuariosActivos, Math.max(maxIncluidos, 0));
        int extra = Math.max(0, usuariosActivos - Math.max(maxIncluidos, 0));

        BigDecimal costoIncluidos = precio.multiply(BigDecimal.valueOf(incluidos));
        BigDecimal costoExtra = precio.add(RECARGO_USUARIO_EXTRA).multiply(BigDecimal.valueOf(extra));
        BigDecimal total = costoIncluidos.add(costoExtra).setScale(2, RoundingMode.HALF_UP);

        return new CostoMensual(edicionCodigo, precio.setScale(2, RoundingMode.HALF_UP),
                maxIncluidos, usuariosActivos, incluidos, extra, RECARGO_USUARIO_EXTRA, total);
    }

    /**
     * Busca licencias de pago que vencen dentro de {@link #DIAS_AVISO_RENOVACION} días y aún no
     * se han avisado en este ciclo; calcula el costo de renovación y notifica al responsable.
     * Lo invoca worker-service de forma agendada (un disparo diario basta).
     *
     * @return cantidad de avisos enviados.
     */
    @Transactional
    public int procesarRenovacionesPorVencer(int diasAviso) {
        List<Map<String, Object>> porVencer = jdbcTemplate.queryForList("""
                SELECT l.id, l.empresa_id, l.edicion_codigo, l.codigo_licencia, l.fecha_vencimiento,
                       COALESCE(NULLIF(l.correo_responsable, ''), e.correo_contacto) AS correo,
                       e.razon_social
                FROM auth.licencia l
                JOIN master.empresa e ON e.id = l.empresa_id
                WHERE l.estado = 'A' AND l.tipo = 'P'
                  AND l.fecha_vencimiento > NOW()
                  AND l.fecha_vencimiento <= NOW() + (? * INTERVAL '1 day')
                  AND (l.fecha_aviso_renovacion IS NULL
                       OR l.fecha_aviso_renovacion < l.fecha_vencimiento - (? * INTERVAL '1 day'))
                """, diasAviso, diasAviso);

        int enviados = 0;
        for (Map<String, Object> lic : porVencer) {
            long licenciaId = ((Number) lic.get("id")).longValue();
            long empresaId = ((Number) lic.get("empresa_id")).longValue();
            String correo = (String) lic.get("correo");
            String razonSocial = (String) lic.get("razon_social");
            String edicion = (String) lic.get("edicion_codigo");
            String codigo = (String) lic.get("codigo_licencia");
            OffsetDateTime vencimiento = ((java.sql.Timestamp) lic.get("fecha_vencimiento"))
                    .toInstant().atOffset(OffsetDateTime.now().getOffset());

            if (correo == null || correo.isBlank()) {
                log.warn("Licencia {} por vencer sin correo de responsable/contacto; se omite aviso", codigo);
                continue;
            }

            CostoMensual costo = calcularCostoPorEdicion(edicion, contarUsuariosActivosConAcceso(empresaId));
            emailService.enviarRecordatorioRenovacion(correo, razonSocial, codigo, edicion,
                    vencimiento.format(FMT_FECHA), costo.usuariosActivos(), costo.costoTotal());
            jdbcTemplate.update("UPDATE auth.licencia SET fecha_aviso_renovacion = NOW() WHERE id = ?", licenciaId);
            enviados++;
            log.info("Aviso de renovación enviado: licencia {} (empresa {}) → {} | costo {} USD",
                    codigo, empresaId, correo, costo.costoTotal());
        }
        if (enviados > 0) {
            log.info("Renovaciones procesadas: {} aviso(s) enviado(s)", enviados);
        }
        return enviados;
    }

    /**
     * Evalúa si dar de alta un usuario más excedería el límite de la edición.
     * Demo: límite duro de {@value #DEMO_MAX_USUARIOS}. Pago: el siguiente usuario sobre
     * el límite tiene costo (precio + recargo) y debe confirmarse.
     */
    public AltaUsuarioEval evaluarAltaUsuario(long empresaId) {
        LicenciaInfo lic = obtenerLicenciaActiva(empresaId);
        boolean esDemo = lic != null && "D".equals(lic.tipo());
        int max = esDemo ? DEMO_MAX_USUARIOS
                : (lic != null ? maxUsuariosEdicion(lic.edicionCodigo()) : DEMO_MAX_USUARIOS);
        int activos = contarUsuariosActivos(empresaId);
        boolean excede = activos >= max;   // el siguiente usuario supera el límite incluido
        BigDecimal costo = BigDecimal.ZERO;
        if (excede && !esDemo && lic != null) {
            costo = precioEdicion(lic.edicionCodigo()).add(RECARGO_USUARIO_EXTRA).setScale(2, RoundingMode.HALF_UP);
        }
        return new AltaUsuarioEval(esDemo, max, activos, excede, costo);
    }

    /** Registra el cobro de un usuario en exceso para el periodo (mes) actual. Demo no cobra. */
    @Transactional
    public void registrarExcesoUsuario(long empresaId, long usuarioId) {
        LicenciaInfo lic = obtenerLicenciaActiva(empresaId);
        if (lic == null || "D".equals(lic.tipo())) {
            return;
        }
        BigDecimal monto = precioEdicion(lic.edicionCodigo()).add(RECARGO_USUARIO_EXTRA).setScale(2, RoundingMode.HALF_UP);
        jdbcTemplate.update("""
                INSERT INTO auth.licencia_usuario_exceso (licencia_id, usuario_id, periodo, monto, flag_estado)
                VALUES (?, ?, ?, ?, '1')
                ON CONFLICT (licencia_id, usuario_id, periodo) DO NOTHING
                """, lic.id(), usuarioId, YearMonth.now().toString(), monto);
        log.info("Exceso de usuario registrado: empresa {}, usuario {}, periodo {}, monto {}",
                empresaId, usuarioId, YearMonth.now(), monto);
    }

    /**
     * Amplía el vencimiento de una licencia DEMO. Solo el perfil ventas/licensing la invoca;
     * el tope es un mes desde el inicio (las demo no se renuevan, solo se amplían dentro del mes).
     */
    @Transactional
    public OffsetDateTime ampliarVencimientoDemo(long empresaId, OffsetDateTime nuevaFecha) {
        LicenciaInfo lic = obtenerLicenciaActiva(empresaId);
        if (lic == null || !"D".equals(lic.tipo())) {
            throw new BusinessException("La empresa no tiene una licencia demo activa.", HttpStatus.UNPROCESSABLE_ENTITY);
        }
        OffsetDateTime tope = lic.fechaInicio().plusMonths(1);
        if (nuevaFecha.isAfter(tope)) {
            throw new BusinessException("No se puede ampliar el demo más allá de un mes desde su inicio ("
                    + tope.format(FMT_FECHA) + ").", HttpStatus.BAD_REQUEST);
        }
        if (!nuevaFecha.isAfter(lic.fechaVencimiento())) {
            throw new BusinessException("La nueva fecha debe ser posterior al vencimiento actual.", HttpStatus.BAD_REQUEST);
        }
        OffsetDateTime nuevaElim = nuevaFecha.plusDays(DEMO_DIAS_ELIMINACION_BD - DEMO_DIAS_VIGENCIA);
        jdbcTemplate.update(
                "UPDATE auth.licencia SET fecha_vencimiento = ?, fecha_eliminacion_bd = ?, estado = 'A', fecha_baja = NULL WHERE id = ?",
                nuevaFecha, nuevaElim, lic.id());
        log.info("Licencia demo {} ampliada hasta {} (empresa {})", lic.id(), nuevaFecha, empresaId);
        return nuevaFecha;
    }

    /**
     * Renueva una licencia de pago un mes más, reactiva empresa/usuarios y recuenta los activos:
     * si persiste el exceso sobre el límite, registra el cobro para el nuevo periodo.
     */
    @Transactional
    public CostoMensual renovarLicencia(long empresaId, java.time.LocalDate fechaPago, String voucher, long usuarioRenovoId) {
        if (fechaPago == null) {
            throw new BusinessException("La fecha de pago es obligatoria para renovar.", HttpStatus.BAD_REQUEST);
        }
        if (voucher == null || voucher.isBlank()) {
            throw new BusinessException("El voucher de pago es obligatorio para renovar.", HttpStatus.BAD_REQUEST);
        }
        LicenciaInfo lic = obtenerUltimaLicencia(empresaId);
        if (lic == null) {
            throw new BusinessException("La empresa no tiene licencia.", HttpStatus.NOT_FOUND);
        }
        if ("D".equals(lic.tipo())) {
            throw new BusinessException("Las licencias demo no se renuevan; use la ampliación.", HttpStatus.UNPROCESSABLE_ENTITY);
        }
        OffsetDateTime base = lic.fechaVencimiento().isAfter(OffsetDateTime.now())
                ? lic.fechaVencimiento() : OffsetDateTime.now();
        OffsetDateTime nuevoVenc = base.plusMonths(1);
        jdbcTemplate.update("""
                UPDATE auth.licencia
                SET fecha_vencimiento = ?, estado = 'A', fecha_baja = NULL, fecha_aviso_renovacion = NULL
                WHERE id = ?
                """, nuevoVenc, lic.id());
        // Reactivar empresa y sus usuarios (pudieron quedar desactivados al vencer).
        jdbcTemplate.update("UPDATE master.empresa SET flag_estado = '1' WHERE id = ?", empresaId);
        jdbcTemplate.update("UPDATE auth.usuario_empresa SET flag_estado = '1' WHERE empresa_id = ?", empresaId);

        // Recontar activos y registrar exceso del nuevo periodo para los que superan el límite.
        int max = maxUsuariosEdicion(lic.edicionCodigo());
        List<Long> activos = jdbcTemplate.queryForList("""
                SELECT ue.usuario_id FROM auth.usuario_empresa ue
                JOIN auth.usuario u ON u.id = ue.usuario_id
                WHERE ue.empresa_id = ? AND ue.flag_estado = '1' AND u.flag_estado = '1'
                ORDER BY u.fec_creacion ASC
                """, Long.class, empresaId);
        for (int i = max; i < activos.size(); i++) {
            registrarExcesoUsuario(empresaId, activos.get(i));
        }

        CostoMensual costo = calcularCostoMensual(empresaId);
        // Histórico del pago de esta renovación (quién, cuándo, voucher, monto).
        jdbcTemplate.update("""
                INSERT INTO auth.licencia_pago (licencia_id, fecha_pago, voucher, monto, periodo, usuario_renovo_id)
                VALUES (?, ?, ?, ?, ?, ?)
                """, lic.id(), fechaPago, voucher.trim(), costo.costoTotal(), YearMonth.now().toString(), usuarioRenovoId);
        log.info("Licencia {} renovada hasta {} (empresa {}) por usuario {}; activos {}, límite {}, voucher {}",
                lic.id(), nuevoVenc, empresaId, usuarioRenovoId, activos.size(), max, voucher);
        return costo;
    }

    /** Listado de licencias por empresa para la consola de administración. */
    public List<Map<String, Object>> listarLicencias() {
        return jdbcTemplate.queryForList("""
                SELECT l.id, l.empresa_id, e.razon_social, e.flag_demo, l.codigo_licencia, l.edicion_codigo,
                       l.tipo, l.estado, l.fecha_inicio, l.fecha_vencimiento, l.correo_responsable,
                       GREATEST(0, CEIL(EXTRACT(EPOCH FROM (l.fecha_vencimiento - now())) / 86400))::int AS dias_restantes
                FROM auth.licencia l
                JOIN master.empresa e ON e.id = l.empresa_id
                WHERE l.estado <> 'E'
                ORDER BY l.fecha_vencimiento ASC
                """);
    }

    /** Resumen de la licencia activa de la empresa (para mostrar en el ERP/admin). */
    public LicenciaInfo obtenerLicenciaActiva(long empresaId) {
        return obtenerLicencia(empresaId, " AND estado = 'A'");
    }

    private LicenciaInfo obtenerUltimaLicencia(long empresaId) {
        return obtenerLicencia(empresaId, "");
    }

    private LicenciaInfo obtenerLicencia(long empresaId, String filtroEstado) {
        try {
            return jdbcTemplate.queryForObject("""
                    SELECT id, tipo, edicion_codigo, COALESCE(max_usuarios, 0) AS max_usuarios,
                           fecha_inicio, fecha_vencimiento, estado
                    FROM auth.licencia
                    WHERE empresa_id = ?""" + filtroEstado + """
                    ORDER BY fecha_inicio DESC LIMIT 1
                    """,
                    (rs, n) -> new LicenciaInfo(
                            rs.getLong("id"), rs.getString("tipo"), rs.getString("edicion_codigo"),
                            rs.getInt("max_usuarios"),
                            rs.getObject("fecha_inicio", OffsetDateTime.class),
                            rs.getObject("fecha_vencimiento", OffsetDateTime.class),
                            rs.getString("estado")),
                    empresaId);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    private int maxUsuariosEdicion(String edicionCodigo) {
        Map<String, Object> plan = obtenerPlanPorEdicion(edicionCodigo);
        if (plan != null && plan.get("max_usuarios") != null) {
            return ((Number) plan.get("max_usuarios")).intValue();
        }
        return DEMO_MAX_USUARIOS;
    }

    private BigDecimal precioEdicion(String edicionCodigo) {
        Map<String, Object> plan = obtenerPlanPorEdicion(edicionCodigo);
        return plan != null && plan.get("precio") != null
                ? new BigDecimal(plan.get("precio").toString())
                : BigDecimal.ZERO;
    }

    /** Usuarios activos (flag_estado='1') de la empresa, para el control de límite/exceso. */
    private int contarUsuariosActivos(long empresaId) {
        Integer n = jdbcTemplate.queryForObject("""
                SELECT COUNT(*) FROM auth.usuario_empresa ue
                JOIN auth.usuario u ON u.id = ue.usuario_id
                WHERE ue.empresa_id = ? AND ue.flag_estado = '1' AND u.flag_estado = '1'
                """, Integer.class, empresaId);
        return n != null ? n : 0;
    }

    /** Edición de la licencia activa de la empresa (o la demo por defecto si no hay). */
    private String obtenerEdicionLicenciaActiva(long empresaId) {
        try {
            return jdbcTemplate.queryForObject("""
                    SELECT edicion_codigo FROM auth.licencia
                    WHERE empresa_id = ? AND estado = 'A'
                    ORDER BY fecha_inicio DESC LIMIT 1
                    """, String.class, empresaId);
        } catch (EmptyResultDataAccessException e) {
            return EDICION_DEMO;
        }
    }

    /** Plan de suscripción de pago asociado a una edición (el de mayor precio, ignorando el demo). */
    private Map<String, Object> obtenerPlanPorEdicion(String edicionCodigo) {
        if (edicionCodigo == null) {
            return null;
        }
        List<Map<String, Object>> planes = jdbcTemplate.queryForList("""
                SELECT precio, max_usuarios FROM auth.plan_suscripcion
                WHERE edicion_codigo = ? AND flag_estado = '1'
                ORDER BY precio DESC LIMIT 1
                """, edicionCodigo);
        return planes.isEmpty() ? null : planes.get(0);
    }

    /** Usuarios activos de la empresa que han iniciado sesión correctamente al menos una vez. */
    private int contarUsuariosActivosConAcceso(long empresaId) {
        Integer n = jdbcTemplate.queryForObject("""
                SELECT COUNT(DISTINCT ue.usuario_id)
                FROM auth.usuario_empresa ue
                JOIN auth.usuario u ON u.id = ue.usuario_id
                WHERE ue.empresa_id = ?
                  AND ue.flag_estado = '1'
                  AND u.flag_estado = '1'
                  AND EXISTS (
                      SELECT 1 FROM auth.log_acceso la
                      WHERE la.usuario_id = ue.usuario_id
                        AND la.empresa_id = ue.empresa_id
                        AND la.exito = TRUE
                  )
                """, Integer.class, empresaId);
        return n != null ? n : 0;
    }

    private static String emptyToNull(String v) {
        return (v == null || v.isBlank()) ? null : v;
    }
}
