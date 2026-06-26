package pe.restaurant.activos.support;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import pe.restaurant.activos.client.ContabilidadAsientosClient;
import pe.restaurant.activos.client.dto.contabilidad.AsientoDetalleRequest;
import pe.restaurant.activos.client.dto.contabilidad.AsientoRequest;
import pe.restaurant.activos.client.dto.contabilidad.AsientoResponse;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.security.TenantContext;

import javax.sql.DataSource;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Types;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Implementación de {@link ContabilidadAsientosClient} que persiste en
 * {@code contabilidad.cntbl_asiento} / {@code cntbl_asiento_det} del tenant (tests IT).
 */
public class JdbcContabilidadAsientosClient implements ContabilidadAsientosClient {

    private static final AtomicLong VOUCHER_SEQ = new AtomicLong(System.currentTimeMillis() % 1_000_000_000L);

    private final JdbcTemplate jdbc;

    public JdbcContabilidadAsientosClient(DataSource dataSource) {
        this.jdbc = new JdbcTemplate(dataSource);
    }

    @Override
    public ApiResponse<AsientoResponse> obtenerAsientoPorId(Long id) {
        if (!tableExists("contabilidad", "cntbl_asiento")) {
            return ApiResponse.ok(null);
        }
        List<AsientoResponse> rows = jdbc.query(selectAsientoSql("WHERE id = ?"), (rs, rowNum) -> mapRow(rs), id);
        return ApiResponse.ok(rows.isEmpty() ? null : rows.get(0));
    }

    @Override
    public ApiResponse<AsientoResponse> buscarPorOrigen(String moduloOrigen, Long documentoOrigenId) {
        if (!tableExists("contabilidad", "cntbl_asiento")) {
            return ApiResponse.ok(null);
        }
        String whereClause;
        Object[] args;
        if (columnExists("contabilidad", "cntbl_asiento", "documento_origen_id")) {
            whereClause = """
                    WHERE modulo_origen = ? AND documento_origen_id = ? AND flag_estado = '1'
                    ORDER BY id DESC
                    LIMIT 1
                    """;
            args = new Object[]{moduloOrigen, documentoOrigenId};
        } else {
            whereClause = """
                    WHERE modulo_origen = ? AND glosa LIKE ? AND flag_estado = '1'
                    ORDER BY id DESC
                    LIMIT 1
                    """;
            args = new Object[]{moduloOrigen, "%" + documentMarker(documentoOrigenId) + "%"};
        }
        List<AsientoResponse> rows = jdbc.query(selectAsientoSql(whereClause), (rs, rowNum) -> mapRow(rs), args);
        return ApiResponse.ok(rows.isEmpty() ? null : rows.get(0));
    }

    @Override
    public ApiResponse<AsientoResponse> crear(AsientoRequest request) {
        if (!tableExists("contabilidad", "cntbl_asiento")) {
            throw new IllegalStateException("Tabla contabilidad.cntbl_asiento no existe en el tenant de test");
        }
        Long userId = TenantContext.getUsuarioId() != null ? TenantContext.getUsuarioId() : 1L;
        String voucher = nextVoucher();

        KeyHolder keyHolder = new GeneratedKeyHolder();
        final boolean hasDocumentoOrigenId = columnExists("contabilidad", "cntbl_asiento", "documento_origen_id");
        final String glosaPersistida = decorateGlosa(request.getGlosa(), request.getDocumentoOrigenId(), hasDocumentoOrigenId);
        final String naturalezaAsiento = resolveNaturalezaAsiento(request.getTipo());
        jdbc.update(con -> {
            String sql = hasDocumentoOrigenId
                    ? """
                    INSERT INTO contabilidad.cntbl_asiento (
                        voucher, libro_id, fecha, glosa, naturaleza_asiento, modulo_origen, documento_origen_id,
                        flag_estado, moneda_id, tasa_cambio, created_by
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, '1', ?, ?, ?)
                    """
                    : """
                    INSERT INTO contabilidad.cntbl_asiento (
                        voucher, libro_id, fecha, glosa, naturaleza_asiento, modulo_origen,
                        flag_estado, moneda_id, tasa_cambio, created_by
                    ) VALUES (?, ?, ?, ?, ?, ?, '1', ?, ?, ?)
                    """;
            PreparedStatement ps = con.prepareStatement(sql, new String[]{"id"});
            ps.setString(1, voucher);
            ps.setLong(2, request.getLibroId() != null ? request.getLibroId() : 1L);
            ps.setObject(3, request.getFecha() != null ? request.getFecha() : LocalDate.now());
            ps.setString(4, glosaPersistida);
            ps.setString(5, naturalezaAsiento);
            ps.setString(6, request.getModuloOrigen());
            int idx = 7;
            if (hasDocumentoOrigenId) {
                if (request.getDocumentoOrigenId() != null) {
                    ps.setLong(idx, request.getDocumentoOrigenId());
                } else {
                    ps.setNull(idx, Types.BIGINT);
                }
                idx++;
            }
            if (request.getMonedaId() != null) {
                ps.setLong(idx, request.getMonedaId());
            } else {
                ps.setNull(idx, Types.BIGINT);
            }
            idx++;
            ps.setBigDecimal(idx, request.getTc() != null ? request.getTc() : java.math.BigDecimal.ONE);
            idx++;
            ps.setLong(idx, userId);
            return ps;
        }, keyHolder);

        Number generatedKey = keyHolder.getKey();
        if (generatedKey == null && keyHolder.getKeys() != null && keyHolder.getKeys().get("id") != null) {
            generatedKey = (Number) keyHolder.getKeys().get("id");
        }
        if (generatedKey == null) {
            throw new IllegalStateException("INSERT cntbl_asiento no devolvió id generado");
        }
        Long asientoId = generatedKey.longValue();
        insertDetalles(asientoId, request.getDetalles(), userId, request.getGlosa());

        AsientoResponse response = new AsientoResponse();
        response.setId(asientoId);
        response.setVoucher(voucher);
        response.setLibroId(request.getLibroId());
        response.setFecha(request.getFecha());
        response.setGlosa(glosaPersistida);
        response.setTipo(request.getTipo());
        response.setModuloOrigen(request.getModuloOrigen());
        response.setDocumentoOrigenId(request.getDocumentoOrigenId());
        response.setFlagEstado("1");
        return ApiResponse.ok(response);
    }

    @Override
    public ApiResponse<pe.restaurant.activos.client.dto.contabilidad.GenerarPreasientoResponse> generarDepreciacion(
            pe.restaurant.activos.client.dto.contabilidad.GenerarAsientoRequest request) {
        throw new UnsupportedOperationException("generarDepreciacion solo en ms-contabilidad");
    }

    @Override
    public ApiResponse<pe.restaurant.activos.client.dto.contabilidad.GenerarPreasientoResponse> generarRevaluacion(
            pe.restaurant.activos.client.dto.contabilidad.GenerarAsientoRequest request) {
        throw new UnsupportedOperationException("generarRevaluacion solo en ms-contabilidad");
    }

    @Override
    public ApiResponse<pe.restaurant.activos.client.dto.contabilidad.GenerarPreasientoResponse> generarIndexacion(
            pe.restaurant.activos.client.dto.contabilidad.GenerarAsientoRequest request) {
        throw new UnsupportedOperationException("generarIndexacion solo en ms-contabilidad");
    }

    @Override
    public ApiResponse<pe.restaurant.activos.client.dto.contabilidad.GenerarPreasientoResponse> generarDevengoSeguros(
            pe.restaurant.activos.client.dto.contabilidad.GenerarAsientoRequest request) {
        throw new UnsupportedOperationException("generarDevengoSeguros solo en ms-contabilidad");
    }

    public int countAsientoDetalle(Long asientoId) {
        if (!tableExists("contabilidad", "cntbl_asiento_det")) {
            return 0;
        }
        Integer n = jdbc.queryForObject(
                "SELECT COUNT(*)::int FROM contabilidad.cntbl_asiento_det WHERE cntbl_asiento_id = ?",
                Integer.class, asientoId);
        return n != null ? n : 0;
    }

    private void insertDetalles(Long asientoId, List<AsientoDetalleRequest> detalles, Long userId, String glosaCabecera) {
        if (detalles == null || detalles.isEmpty() || !tableExists("contabilidad", "cntbl_asiento_det")) {
            return;
        }
        Long proveedorId = resolveProveedorFactoryId();
        Long ccDefaultId = resolveCentroCostoFactoryId();
        for (AsientoDetalleRequest d : detalles) {
            if (d.getPlanContableDetId() == null) {
                continue;
            }
            String glosaDetalle = d.getGlosaDetalle() != null && !d.getGlosaDetalle().isBlank()
                    ? d.getGlosaDetalle()
                    : (glosaCabecera != null && !glosaCabecera.isBlank() ? glosaCabecera : "Detalle factory IT activos");
            String referencia = sanitizeReferencia(d.getReferencia() != null && !d.getReferencia().isBlank()
                    ? d.getReferencia()
                    : "FACTORY-AF-ASIENTO");
            Long ccId = d.getCentrosCostoId() != null ? d.getCentrosCostoId() : ccDefaultId;
            Long entidadId = d.getEntidadContribuyenteId() != null ? d.getEntidadContribuyenteId() : proveedorId;
            boolean esDebe = d.getDebe() != null && d.getDebe().compareTo(java.math.BigDecimal.ZERO) > 0;
            java.math.BigDecimal importeSol = esDebe
                    ? (d.getDebe() != null ? d.getDebe() : java.math.BigDecimal.ZERO)
                    : (d.getHaber() != null ? d.getHaber() : java.math.BigDecimal.ZERO);
            jdbc.update("""
                    INSERT INTO contabilidad.cntbl_asiento_det (
                        cntbl_asiento_id, plan_contable_det_id, centros_costo_id, entidad_contribuyente_id,
                        glosa_detalle, nro_referencia, flag_debe_haber, importe_sol, importe_dol, created_by
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """,
                    asientoId,
                    d.getPlanContableDetId(),
                    ccId,
                    entidadId,
                    glosaDetalle,
                    referencia,
                    esDebe ? "D" : "H",
                    importeSol,
                    java.math.BigDecimal.ZERO,
                    userId);
        }
    }

    private String sanitizeReferencia(String referencia) {
        if (referencia == null || referencia.isBlank()) {
            return "FACTORY-AF";
        }
        return referencia.length() <= 12 ? referencia : referencia.substring(0, 12);
    }

    private Long resolveProveedorFactoryId() {
        if (!tableExists("core", "entidad_contribuyente")) {
            return null;
        }
        return jdbc.query(
                "SELECT id FROM core.entidad_contribuyente WHERE nro_documento = '20123456789' LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null);
    }

    private Long resolveCentroCostoFactoryId() {
        if (!tableExists("contabilidad", "centros_costo")) {
            return null;
        }
        return jdbc.query(
                "SELECT id FROM contabilidad.centros_costo WHERE cencos = 'FACTORY-AF-CC1' LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null);
    }

    private static String nextVoucher() {
        long n = VOUCHER_SEQ.incrementAndGet();
        return String.format("FA%014d", n % 100_000_000_000_000L);
    }

    private static AsientoResponse mapRow(java.sql.ResultSet rs) throws java.sql.SQLException {
        AsientoResponse r = new AsientoResponse();
        r.setId(rs.getLong("id"));
        r.setVoucher(rs.getString("voucher"));
        r.setLibroId(rs.getObject("libro_id") != null ? rs.getLong("libro_id") : null);
        r.setFecha(rs.getDate("fecha") != null ? rs.getDate("fecha").toLocalDate() : null);
        r.setGlosa(rs.getString("glosa"));
        r.setTipo(rs.getString("tipo"));
        r.setModuloOrigen(rs.getString("modulo_origen"));
        Object docOrigenValue = rs.getObject("documento_origen_id");
        if (docOrigenValue instanceof Number number) {
            r.setDocumentoOrigenId(number.longValue());
        } else {
            r.setDocumentoOrigenId(extractDocumentoOrigenId(r.getGlosa()));
        }
        r.setFlagEstado(rs.getString("flag_estado"));
        return r;
    }

    private String selectAsientoSql(String whereClause) {
        boolean hasDocumentoOrigenId = columnExists("contabilidad", "cntbl_asiento", "documento_origen_id");
        return """
                SELECT id, voucher, libro_id, fecha, glosa,
                       naturaleza_asiento AS tipo,
                       modulo_origen,
                       %s AS documento_origen_id,
                       flag_estado
                FROM contabilidad.cntbl_asiento
                %s
                """.formatted(hasDocumentoOrigenId ? "documento_origen_id" : "NULL", whereClause);
    }

    private static String decorateGlosa(String glosa, Long documentoOrigenId, boolean hasDocumentoOrigenIdColumn) {
        String safeGlosa = glosa != null && !glosa.isBlank() ? glosa : "Asiento factory IT activos";
        if (hasDocumentoOrigenIdColumn || documentoOrigenId == null) {
            return safeGlosa;
        }
        return safeGlosa + " " + documentMarker(documentoOrigenId);
    }

    private static String documentMarker(Long documentoOrigenId) {
        return "[DOC_ORIGEN_ID=" + documentoOrigenId + "]";
    }

    private static Long extractDocumentoOrigenId(String glosa) {
        if (glosa == null) {
            return null;
        }
        int start = glosa.indexOf("[DOC_ORIGEN_ID=");
        if (start < 0) {
            return null;
        }
        int valueStart = start + "[DOC_ORIGEN_ID=".length();
        int end = glosa.indexOf(']', valueStart);
        if (end < 0) {
            return null;
        }
        try {
            return Long.parseLong(glosa.substring(valueStart, end));
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private static String resolveNaturalezaAsiento(String tipoOperacion) {
        if (tipoOperacion == null || tipoOperacion.isBlank()) {
            return "M";
        }
        return switch (tipoOperacion) {
            case "AF-001" -> "A";
            case "AF_REVALUACION" -> "B";
            case "AF_INDEXACION" -> "C";
            case "AF_DEVENGO_PRIMA" -> "D";
            case "AF_VENTA" -> "E";
            case "AF_ALTA_ACTIVO" -> "F";
            case "AF_ADAPTACION" -> "G";
            case "AF_BAJA_ACTIVO" -> "H";
            case "AF_TRASLADO" -> "I";
            default -> "M";
        };
    }

    private boolean columnExists(String schema, String table, String column) {
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM information_schema.columns
                WHERE table_schema = ? AND table_name = ? AND column_name = ?
                """, Integer.class, schema, table, column);
        return n != null && n > 0;
    }

    private boolean tableExists(String schema, String table) {
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM information_schema.tables
                WHERE table_schema = ? AND table_name = ?
                """, Integer.class, schema, table);
        return n != null && n > 0;
    }
}
