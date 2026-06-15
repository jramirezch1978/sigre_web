package com.sigre.produccion.testdata;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class ProduccionTestDataFactory {

    private final DataSource dataSource;

    public static final String RECETA_NRO = "REC-TST-001";
    public static final String RECETA_NOMBRE = "Receta Test Lomo Saltado";
    public static final String DOC_NOMBRE = "Ficha Test Lomo Saltado";
    public static final String DOC_TIPO_CODIGO = "FICHA_TECNICA";
    public static final String LABOR_CODIGO_1 = "LAB-TEST-001";
    public static final String LABOR_CODIGO_2 = "LAB-TEST-002";
    public static final String LABOR_CODIGO_3 = "LAB-TEST-003";
    public static final String OT_TIPO_CODIGO = "PROD-TEST";
    public static final String OT_ADMIN_CODIGO = "COCINA-TEST";
    public static final String EJECUTOR_CODIGO = "EJEC-TEST-001";

    @Transactional
    public Map<String, Object> ensurePlanificacionData() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Map<String, Object> out = new LinkedHashMap<>();

        out.put("labores", ensureLabores(jdbc));
        out.put("articuloUsado", findOrWarnArticulo(jdbc));
        out.put("sucursalUsada", findOrWarnSucursal(jdbc));
        out.put("otTipo", ensureOtTipo(jdbc));
        out.put("otAdministracion", ensureOtAdministracion(jdbc));
        out.put("receta", ensureReceta(jdbc));
        out.put("docTecnica", ensureDocTecnica(jdbc));
        out.put("ordenTrabajo", ensureOrdenTrabajo(jdbc));
        out.put("programacion", ensureProgramacion(jdbc));
        out.put("operacion", ensureOperacion(jdbc));
        out.put("parteProduccion", ensureParteProduccion(jdbc));
        out.put("controlCalidad", ensureControlCalidad(jdbc));
        out.put("costeoProduccion", ensureCosteoProduccion(jdbc));
        out.put("ejecutor", ensureEjecutor(jdbc));

        return out;
    }

    @Transactional
    public Map<String, Object> statusData() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Map<String, Object> out = new LinkedHashMap<>();

        out.put("laboresExistentes", jdbc.queryForList(
                "SELECT id, codigo, nombre FROM produccion.labor WHERE flag_estado = '1' ORDER BY id"));
        out.put("recetaExiste", jdbc.queryForObject(
                "SELECT COUNT(*) FROM produccion.receta WHERE nro_receta = ?", Integer.class, RECETA_NRO) > 0);
        out.put("docTecnicaExiste", jdbc.queryForObject(
                "SELECT COUNT(*) FROM produccion.articulo_doc_tecnica WHERE nombre_documento = ?",
                Integer.class, DOC_NOMBRE) > 0);
        out.put("docTipos", jdbc.queryForList(
                "SELECT id, codigo, nombre FROM core.doc_tipo WHERE flag_estado = '1' ORDER BY id"));
        out.put("otTipoExiste", jdbc.queryForObject(
                "SELECT COUNT(*) FROM produccion.ot_tipo WHERE codigo = ?", Integer.class, OT_TIPO_CODIGO) > 0);
        out.put("otAdministracionExiste", jdbc.queryForObject(
                "SELECT COUNT(*) FROM produccion.ot_administracion WHERE codigo = ?", Integer.class, OT_ADMIN_CODIGO) > 0);
        out.put("ordenesTrabajo", jdbc.queryForList(
                "SELECT id, codigo, flag_estado FROM produccion.orden_trabajo ORDER BY id"));
        out.put("operaciones", jdbc.queryForList(
                "SELECT id, orden_trabajo_id, nro_operacion, fec_inicio_estimado, fec_inicio, fec_fin FROM produccion.operacion ORDER BY id"));
        out.put("programacionesExistentes", jdbc.queryForList(
                "SELECT id, receta_id, frecuencia, flag_estado FROM produccion.programacion_produccion ORDER BY id"));
        out.put("partesProduccion", jdbc.queryForList(
                "SELECT id, orden_trabajo_id, fecha FROM produccion.parte_produccion ORDER BY id"));
        out.put("controlesCalidad", jdbc.queryForList(
                "SELECT id, orden_trabajo_id, resultado FROM produccion.control_calidad ORDER BY id"));
        out.put("costeosProduccion", jdbc.queryForList(
                "SELECT id, orden_trabajo_id, costo_total FROM produccion.costeo_produccion ORDER BY id"));
        out.put("articulosCore", jdbc.queryForList(
                "SELECT id, codigo, nombre FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 10"));
        out.put("sucursalesAuth", jdbc.queryForList(
                "SELECT id, codigo, nombre FROM auth.sucursal WHERE flag_estado = '1' ORDER BY id LIMIT 10"));
        out.put("ejecutores", jdbc.queryForList(
                "SELECT id, codigo, nombre, flag_externo FROM produccion.ejecutor WHERE flag_estado = '1' ORDER BY id"));

        return out;
    }

    private List<Map<String, Object>> ensureLabores(JdbcTemplate jdbc) {
        Long id1 = findOrCreateLabor(jdbc, LABOR_CODIGO_1, "Corte de insumos");
        Long id2 = findOrCreateLabor(jdbc, LABOR_CODIGO_2, "Coccion");
        Long id3 = findOrCreateLabor(jdbc, LABOR_CODIGO_3, "Emplatado y presentacion");

        return List.of(
                Map.of("id", id1, "codigo", LABOR_CODIGO_1, "nombre", "Corte de insumos"),
                Map.of("id", id2, "codigo", LABOR_CODIGO_2, "nombre", "Coccion"),
                Map.of("id", id3, "codigo", LABOR_CODIGO_3, "nombre", "Emplatado y presentacion")
        );
    }

    private Long findOrCreateLabor(JdbcTemplate jdbc, String codigo, String nombre) {
        jdbc.update("INSERT INTO produccion.labor (codigo, nombre, flag_estado, created_by, fec_creacion)" +
                        " VALUES (?, ?, '1', 1, NOW())" +
                        " ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, flag_estado = '1'",
                codigo, nombre);
        return jdbc.queryForObject("SELECT id FROM produccion.labor WHERE codigo = ?",
                Long.class, codigo);
    }

    private Map<String, Object> findOrWarnArticulo(JdbcTemplate jdbc) {
        try {
            List<Map<String, Object>> rows = jdbc.queryForList(
                    "SELECT id, codigo, nombre FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 1");
            if (!rows.isEmpty()) {
                return rows.get(0);
            }
            return Map.of("warning", "No hay articulos en core.articulo. Crea uno via POST /api/core/articulos");
        } catch (Exception e) {
            return Map.of("warning", "Error al consultar core.articulo: " + e.getMessage());
        }
    }

    private Map<String, Object> findOrWarnSucursal(JdbcTemplate jdbc) {
        try {
            List<Map<String, Object>> rows = jdbc.queryForList(
                    "SELECT id, codigo, nombre FROM auth.sucursal WHERE flag_estado = '1' ORDER BY id LIMIT 1");
            if (!rows.isEmpty()) {
                return rows.get(0);
            }
            return Map.of("warning", "No hay sucursales en auth.sucursal. Crea una via POST /api/core/sucursales");
        } catch (Exception e) {
            return Map.of("warning", "Error al consultar auth.sucursal: " + e.getMessage());
        }
    }

    private Map<String, Object> ensureReceta(JdbcTemplate jdbc) {
        List<Long> existingIds = jdbc.queryForList(
                "SELECT id FROM produccion.receta WHERE nro_receta = ? AND version = 1",
                Long.class, RECETA_NRO);
        if (!existingIds.isEmpty()) {
            return Map.of("id", existingIds.get(0), "codigo", RECETA_NRO, "version", 1, "alreadyExisted", true);
        }

        List<Map<String, Object>> articulos = jdbc.queryForList(
                "SELECT id FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 1");
        if (articulos.isEmpty()) {
            return Map.of("warning", "No se puede crear receta sin articulo en core.articulo");
        }
        Long articuloId = (Long) articulos.get(0).get("id");

        Long recetaId = jdbc.queryForObject(
                "INSERT INTO produccion.receta (articulo_producido_id, nro_receta, nombre, version, flag_tipo_receta," +
                        " rendimiento_esperado, porcentaje_merma, costo_mano_obra, costo_indirecto," +
                        " flag_estado, created_by, fec_creacion)" +
                        " VALUES (?, ?, ?, 1, 'P', 10, 5.00, 15.00, 3.50, '1', 1, NOW()) RETURNING id",
                Long.class, articuloId, RECETA_NRO, RECETA_NOMBRE);

        List<Map<String, Object>> labores = jdbc.queryForList(
                "SELECT id FROM produccion.labor WHERE codigo IN (?, ?, ?) ORDER BY codigo",
                LABOR_CODIGO_1, LABOR_CODIGO_2, LABOR_CODIGO_3);

        for (int i = 0; i < labores.size(); i++) {
            Long laborId = (Long) labores.get(i).get("id");
            String descripcion = switch (i) {
                case 0 -> "Cortar insumos en juliana";
                case 1 -> "Cocinar a fuego alto por 15 min";
                default -> "Emplatar con guarnicion";
            };
            jdbc.update("INSERT INTO produccion.receta_labor (receta_id, labor_id, secuencia, descripcion_paso)" +
                    " VALUES (?, ?, ?, ?)", recetaId, laborId, i + 1, descripcion);
        }

        return Map.of("id", recetaId, "codigo", RECETA_NRO, "version", 1, "laboresAsignadas", labores.size());
    }

    private Long ensureDocTipo(JdbcTemplate jdbc) {
        List<Long> existing = jdbc.queryForList(
                "SELECT id FROM core.doc_tipo WHERE codigo = ?", Long.class, DOC_TIPO_CODIGO);
        if (!existing.isEmpty()) {
            return existing.get(0);
        }
        return jdbc.queryForObject(
                "INSERT INTO core.doc_tipo (codigo, nombre, flag_estado, created_by, fec_creacion)" +
                        " VALUES (?, 'Ficha Técnica Test', '1', 1, NOW()) RETURNING id",
                Long.class, DOC_TIPO_CODIGO);
    }

    private Map<String, Object> ensureDocTecnica(JdbcTemplate jdbc) {
        Long docTipoId = ensureDocTipo(jdbc);

        List<Long> existingIds = jdbc.queryForList(
                "SELECT id FROM produccion.articulo_doc_tecnica WHERE nombre_documento = ?",
                Long.class, DOC_NOMBRE);
        if (!existingIds.isEmpty()) {
            return Map.of("id", existingIds.get(0), "nombre", DOC_NOMBRE, "docTipoId", docTipoId, "alreadyExisted", true);
        }

        List<Map<String, Object>> articulos = jdbc.queryForList(
                "SELECT id FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 1");
        if (articulos.isEmpty()) {
            return Map.of("warning", "No se puede crear documento sin articulo en core.articulo");
        }
        Long articuloId = (Long) articulos.get(0).get("id");

        Long docId = jdbc.queryForObject(
                "INSERT INTO produccion.articulo_doc_tecnica (articulo_id, doc_tipo_id, nombre_documento," +
                        " archivo_url, observacion, flag_estado, created_by, fec_creacion)" +
                        " VALUES (?, ?, ?, 'https://docs.test.com/ficha.pdf', 'Documento generado por test seed'," +
                        " '1', 1, NOW()) RETURNING id",
                Long.class, articuloId, docTipoId, DOC_NOMBRE);

        jdbc.update("INSERT INTO produccion.articulo_doc_tecnica_caract_det" +
                        " (articulo_doc_tecnica_id, caracteristica, valor)" +
                        " VALUES (?, ?, ?)",
                docId, "Color", "Dorado");

        jdbc.update("INSERT INTO produccion.articulo_doc_tecnica_caract_det" +
                        " (articulo_doc_tecnica_id, caracteristica, valor)" +
                        " VALUES (?, ?, ?)",
                docId, "Textura", "Crujiente por fuera, suave por dentro");

        jdbc.update("INSERT INTO produccion.articulo_doc_tecnica_caract_det" +
                        " (articulo_doc_tecnica_id, caracteristica, valor)" +
                        " VALUES (?, ?, ?)",
                docId, "Temperatura servicio", "70°C");

        return Map.of("id", docId, "nombre", DOC_NOMBRE, "caracteristicasCreadas", 3, "docTipoId", docTipoId);
    }

    private Map<String, Object> ensureProgramacion(JdbcTemplate jdbc) {
        List<Long> recetaIds = jdbc.queryForList(
                "SELECT id FROM produccion.receta WHERE nro_receta = ? AND version = 1",
                Long.class, RECETA_NRO);
        if (recetaIds.isEmpty()) {
            return Map.of("warning", "No se puede crear programacion: no existe receta " + RECETA_NRO);
        }
        Long recetaId = recetaIds.get(0);

        List<Long> otIds = jdbc.queryForList(
                "SELECT id FROM produccion.orden_trabajo WHERE flag_estado = '1' ORDER BY id DESC LIMIT 1",
                Long.class);
        if (otIds.isEmpty()) {
            return Map.of("warning", "No se puede crear programacion: no existe orden de trabajo activa");
        }
        Long ordenTrabajoId = otIds.get(0);

        List<Long> existingIds = jdbc.queryForList(
                "SELECT id FROM produccion.programacion_produccion WHERE receta_id = ? AND orden_trabajo_id = ?" +
                        " AND flag_frecuencia = 'D' AND flag_estado = '1'",
                Long.class, recetaId, ordenTrabajoId);
        if (!existingIds.isEmpty()) {
            return Map.of("id", existingIds.get(0), "recetaId", recetaId, "ordenTrabajoId", ordenTrabajoId, "alreadyExisted", true);
        }

        Long sucursalId = null;
        try {
            sucursalId = jdbc.queryForObject(
                    "SELECT id FROM auth.sucursal WHERE flag_estado = '1' ORDER BY id LIMIT 1",
                    Long.class);
        } catch (Exception e) {
            // sucursal is optional in programacion
        }

        Long progId = jdbc.queryForObject(
                "INSERT INTO produccion.programacion_produccion" +
                        " (orden_trabajo_id, sucursal_id, receta_id, flag_frecuencia, fecha_inicio, fecha_fin," +
                        " cantidad_por_periodo, flag_turno, flag_estado, created_by, fec_creacion)" +
                        " VALUES (?, ?, ?, 'D', ?, ?, 50, 'M', '1', 1, NOW()) RETURNING id",
                Long.class, ordenTrabajoId, sucursalId, recetaId,
                LocalDate.now(), LocalDate.now().plusDays(30));

        return Map.of("id", progId, "recetaId", recetaId, "ordenTrabajoId", ordenTrabajoId, "frecuencia", "DIARIA");
    }

    private Map<String, Object> ensureOtTipo(JdbcTemplate jdbc) {
        List<Long> existing = jdbc.queryForList(
                "SELECT id FROM produccion.ot_tipo WHERE codigo = ?", Long.class, OT_TIPO_CODIGO);
        if (!existing.isEmpty()) {
            return Map.of("id", existing.get(0), "codigo", OT_TIPO_CODIGO, "alreadyExisted", true);
        }
        Long id = jdbc.queryForObject(
                "INSERT INTO produccion.ot_tipo (codigo, nombre, flag_estado, created_by, fec_creacion)" +
                        " VALUES (?, 'Tipo Produccion Test', '1', 1, NOW()) RETURNING id",
                Long.class, OT_TIPO_CODIGO);
        return Map.of("id", id, "codigo", OT_TIPO_CODIGO);
    }

    private Map<String, Object> ensureOtAdministracion(JdbcTemplate jdbc) {
        List<Long> existing = jdbc.queryForList(
                "SELECT id FROM produccion.ot_administracion WHERE codigo = ?", Long.class, OT_ADMIN_CODIGO);
        if (!existing.isEmpty()) {
            return Map.of("id", existing.get(0), "codigo", OT_ADMIN_CODIGO, "alreadyExisted", true);
        }
        Long id = jdbc.queryForObject(
                "INSERT INTO produccion.ot_administracion (codigo, nombre, flag_tipo_costo, flag_estado, created_by, fec_creacion)" +
                        " VALUES (?, 'Cocina Central Test', 'D', '1', 1, NOW()) RETURNING id",
                Long.class, OT_ADMIN_CODIGO);
        return Map.of("id", id, "codigo", OT_ADMIN_CODIGO);
    }

    private Map<String, Object> ensureEjecutor(JdbcTemplate jdbc) {
        List<Long> existing = jdbc.queryForList(
                "SELECT id FROM produccion.ejecutor WHERE codigo = ?", Long.class, EJECUTOR_CODIGO);
        if (!existing.isEmpty()) {
            return Map.of("id", existing.get(0), "codigo", EJECUTOR_CODIGO, "alreadyExisted", true);
        }
        Long id = jdbc.queryForObject(
                "INSERT INTO produccion.ejecutor (codigo, nombre, flag_externo, flag_estado, created_by, fec_creacion)" +
                        " VALUES (?, 'Ejecutor Test', '0', '1', 1, NOW()) RETURNING id",
                Long.class, EJECUTOR_CODIGO);
        return Map.of("id", id, "codigo", EJECUTOR_CODIGO);
    }

    private Map<String, Object> ensureOrdenTrabajo(JdbcTemplate jdbc) {
        List<Map<String, Object>> tipos = jdbc.queryForList(
                "SELECT id FROM produccion.ot_tipo WHERE codigo = ?", OT_TIPO_CODIGO);
        List<Map<String, Object>> admins = jdbc.queryForList(
                "SELECT id FROM produccion.ot_administracion WHERE codigo = ?", OT_ADMIN_CODIGO);
        if (tipos.isEmpty() || admins.isEmpty()) {
            return Map.of("warning", "No se puede crear OT: falta ot_tipo u ot_administracion");
        }
        Long otTipoId = (Long) tipos.get(0).get("id");
        Long otAdminId = (Long) admins.get(0).get("id");

        Long sucursalId;
        try {
            sucursalId = jdbc.queryForObject(
                    "SELECT id FROM auth.sucursal WHERE flag_estado = '1' ORDER BY id LIMIT 1", Long.class);
        } catch (Exception e) {
            return Map.of("warning", "No se puede crear OT: no hay sucursal en auth.sucursal");
        }

        String codigo = "OT-" + java.time.Year.now().getValue() + "-9001";
        List<Long> existing = jdbc.queryForList(
                "SELECT id FROM produccion.orden_trabajo WHERE codigo = ?", Long.class, codigo);
        if (!existing.isEmpty()) {
            return Map.of("id", existing.get(0), "codigo", codigo, "alreadyExisted", true);
        }

        Long id = jdbc.queryForObject(
                "INSERT INTO produccion.orden_trabajo (sucursal_id, ot_tipo_id, ot_administracion_id," +
                        " codigo, fecha_inicio, fecha_fin, flag_estado, created_by, fec_creacion)" +
                        " VALUES (?, ?, ?, ?, ?, ?, '1', 1, NOW()) RETURNING id",
                Long.class, sucursalId, otTipoId, otAdminId, codigo,
                LocalDate.now(), LocalDate.now().plusDays(30));
        return Map.of("id", id, "codigo", codigo);
    }

    private Map<String, Object> ensureOperacion(JdbcTemplate jdbc) {
        List<Long> otIds = jdbc.queryForList(
                "SELECT id FROM produccion.orden_trabajo WHERE codigo LIKE 'OT-%' ORDER BY id DESC LIMIT 1",
                Long.class);
        if (otIds.isEmpty()) {
            return Map.of("warning", "No se puede crear operacion: no hay OT");
        }
        Long otId = otIds.get(0);

        List<Long> existing = jdbc.queryForList(
                "SELECT id FROM produccion.operacion WHERE orden_trabajo_id = ?", Long.class, otId);
        if (!existing.isEmpty()) {
            return Map.of("id", existing.get(0), "ordenTrabajoId", otId, "alreadyExisted", true);
        }

        Long opId = jdbc.queryForObject(
                "INSERT INTO produccion.operacion (orden_trabajo_id, nro_operacion, fec_inicio_estimado, flag_estado, created_by, fec_creacion)" +
                        " VALUES (?, ?, ?, '1', 1, NOW()) RETURNING id",
                Long.class, otId, 1, LocalDate.now());

        List<Map<String, Object>> labores = jdbc.queryForList(
                "SELECT id FROM produccion.labor WHERE codigo IN (?, ?, ?) ORDER BY codigo LIMIT 1",
                LABOR_CODIGO_1, LABOR_CODIGO_2, LABOR_CODIGO_3);
        List<Map<String, Object>> articulos = jdbc.queryForList(
                "SELECT id FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 1");

        if (!labores.isEmpty() && !articulos.isEmpty()) {
            Long laborId = (Long) labores.get(0).get("id");
            Long artId = (Long) articulos.get(0).get("id");
            jdbc.update("INSERT INTO produccion.operaciones_det (operacion_id, articulo_id," +
                            " cantidad_requerida, flag_estado, created_by, fec_creacion)" +
                            " VALUES (?, ?, 10.0000, '1', 1, NOW())",
                    opId, artId);
        }

        return Map.of("id", opId, "ordenTrabajoId", otId);
    }

    private Map<String, Object> ensureParteProduccion(JdbcTemplate jdbc) {
        List<Long> otIds = jdbc.queryForList(
                "SELECT id FROM produccion.orden_trabajo WHERE codigo LIKE 'OT-%' ORDER BY id DESC LIMIT 1",
                Long.class);
        if (otIds.isEmpty()) {
            return Map.of("warning", "No se puede crear parte: no hay OT");
        }
        Long otId = otIds.get(0);

        List<Long> existing = jdbc.queryForList(
                "SELECT id FROM produccion.parte_produccion WHERE orden_trabajo_id = ?", Long.class, otId);
        if (!existing.isEmpty()) {
            return Map.of("id", existing.get(0), "ordenTrabajoId", otId, "alreadyExisted", true);
        }

        Long ppId = jdbc.queryForObject(
                "INSERT INTO produccion.parte_produccion (orden_trabajo_id, fecha, flag_estado, created_by, fec_creacion)" +
                        " VALUES (?, ?, '1', 1, NOW()) RETURNING id",
                Long.class, otId, LocalDate.now());

        List<Map<String, Object>> articulos = jdbc.queryForList(
                "SELECT id FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 1");
        if (!articulos.isEmpty()) {
            Long artId = (Long) articulos.get(0).get("id");
            jdbc.update("INSERT INTO produccion.parte_produccion_insumo (parte_produccion_id, articulo_id," +
                            " cantidad_consumida, flag_estado, created_by, fec_creacion)" +
                            " VALUES (?, ?, 25.0000, '1', 1, NOW())",
                    ppId, artId);
            jdbc.update("INSERT INTO produccion.parte_produccion_producido (parte_produccion_id, articulo_id," +
                            " cantidad_producida, flag_estado, created_by, fec_creacion)" +
                            " VALUES (?, ?, 100.0000, '1', 1, NOW())",
                    ppId, artId);
        }

        return Map.of("id", ppId, "ordenTrabajoId", otId);
    }

    private Map<String, Object> ensureControlCalidad(JdbcTemplate jdbc) {
        List<Long> otIds = jdbc.queryForList(
                "SELECT id FROM produccion.orden_trabajo WHERE codigo LIKE 'OT-%' ORDER BY id DESC LIMIT 1",
                Long.class);
        if (otIds.isEmpty()) {
            return Map.of("warning", "No se puede crear control calidad: no hay OT");
        }
        Long otId = otIds.get(0);

        List<Long> existing = jdbc.queryForList(
                "SELECT id FROM produccion.control_calidad WHERE orden_trabajo_id = ?", Long.class, otId);
        if (!existing.isEmpty()) {
            return Map.of("id", existing.get(0), "ordenTrabajoId", otId, "alreadyExisted", true);
        }

        Long id = jdbc.queryForObject(
                "INSERT INTO produccion.control_calidad (orden_trabajo_id, inspector_id, fecha, resultado," +
                        " observaciones, created_by, fec_creacion)" +
                        " VALUES (?, 1, ?, 'APROBADO', 'Control de calidad de prueba - producto conforme'," +
                        " 1, NOW()) RETURNING id",
                Long.class, otId, LocalDate.now());
        return Map.of("id", id, "ordenTrabajoId", otId, "resultado", "APROBADO");
    }

    private Map<String, Object> ensureCosteoProduccion(JdbcTemplate jdbc) {
        List<Long> otIds = jdbc.queryForList(
                "SELECT id FROM produccion.orden_trabajo WHERE codigo LIKE 'OT-%' ORDER BY id DESC LIMIT 1",
                Long.class);
        if (otIds.isEmpty()) {
            return Map.of("warning", "No se puede crear costeo: no hay OT");
        }
        Long otId = otIds.get(0);

        List<Long> existing = jdbc.queryForList(
                "SELECT id FROM produccion.costeo_produccion WHERE orden_trabajo_id = ?", Long.class, otId);
        if (!existing.isEmpty()) {
            return Map.of("id", existing.get(0), "ordenTrabajoId", otId, "alreadyExisted", true);
        }

        Long id = jdbc.queryForObject(
                "INSERT INTO produccion.costeo_produccion (orden_trabajo_id, anio, mes, costo_materia_prima, costo_mano_obra," +
                        " costo_indirecto, costo_total, costo_unitario, rendimiento_real, porcentaje_merma_real," +
                        " created_by, fec_creacion)" +
                        " VALUES (?, ?, ?, 1500.0000, 500.0000, 200.0000, 2200.0000, 22.0000, 100, 5.0000, 1, NOW()) RETURNING id",
                Long.class, otId, java.time.Year.now().getValue(), java.time.LocalDate.now().getMonthValue());
        return Map.of("id", id, "ordenTrabajoId", otId);
    }
}
