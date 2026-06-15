package com.sigre.produccion.service;

public class ProduccionErrorCodes {

    private ProduccionErrorCodes() {
    }

    // ─── Labor (PRD-LB) ──────────────────────────────────────────

    public static final String LABOR_DATOS_INCOMPLETOS = "PRD-LB-001";
    public static final String LABOR_FK_INEXISTENTE = "PRD-LB-002";
    public static final String LABOR_CODIGO_DUPLICADO = "PRD-LB-003";
    public static final String LABOR_ACCION_NO_PERMITIDA = "PRD-LB-004";
    public static final String LABOR_REFERENCIAS_ASOCIADAS = "PRD-LB-005";

    // ─── Tipo OT (PRD-OT — compartido con Orden Trabajo) ────────

    public static final String OT_TIPO_DATOS_INCOMPLETOS = "PRD-OT-001";
    public static final String OT_TIPO_FK_INEXISTENTE = "PRD-OT-002";
    public static final String OT_TIPO_CODIGO_DUPLICADO = "PRD-OT-003";
    public static final String OT_TIPO_ACCION_NO_PERMITIDA = "PRD-OT-004";

    // ─── Administración OT (PRD-OA) ──────────────────────────────

    public static final String OT_ADMIN_DATOS_INCOMPLETOS = "PRD-OA-001";
    public static final String OT_ADMIN_FK_INEXISTENTE = "PRD-OA-002";
    public static final String OT_ADMIN_CODIGO_DUPLICADO = "PRD-OA-003";
    public static final String OT_ADMIN_ACCION_NO_PERMITIDA = "PRD-OA-004";
    public static final String OT_ADMIN_REFERENCIAS_ASOCIADAS = "PRD-OA-005";
    public static final String OT_ADMIN_FLAG_TIPO_COSTO_INVALIDO = "PRD-OA-006";

    // ─── Receta (PRD-RC) ─────────────────────────────────────────

    public static final String RECETA_DATOS_INCOMPLETOS = "PRD-RC-001";
    public static final String RECETA_ARTICULO_INEXISTENTE = "PRD-RC-002";
    public static final String RECETA_CODIGO_DUPLICADO = "PRD-RC-003";
    public static final String RECETA_LABOR_INEXISTENTE = "PRD-RC-004";
    public static final String RECETA_HIJA_INEXISTENTE = "PRD-RC-005";
    public static final String RECETA_REFERENCIA_CIRCULAR = "PRD-RC-006";
    public static final String RECETA_SECUENCIA_DUPLICADA = "PRD-RC-007";
    public static final String RECETA_INACTIVA = "PRD-RC-008";
    public static final String RECETA_PROGRAMACIONES_ACTIVAS = "PRD-RC-009";
    public static final String RECETA_VERSION_EXISTENTE = "PRD-RC-010";

    // ─── Documentación Técnica (PRD-DT) ──────────────────────────

    public static final String DOC_TECNICA_DATOS_INCOMPLETOS = "PRD-DT-001";
    public static final String DOC_TECNICA_ARTICULO_INEXISTENTE = "PRD-DT-002";
    public static final String DOC_TECNICA_TIPO_INVALIDO = "PRD-DT-003";
    public static final String DOC_TECNICA_UM_INEXISTENTE = "PRD-DT-004";
    public static final String DOC_TECNICA_INACTIVO = "PRD-DT-005";

    // ─── Orden Trabajo (PRD-OT) ──────────────────────────────────

    public static final String OT_SUCURSAL_INEXISTENTE = "PRD-OT-001";
    public static final String OT_TIPO_INEXISTENTE = "PRD-OT-002";
    public static final String OT_ADMIN_INEXISTENTE = "PRD-OT-003";
    public static final String OT_CODIGO_DUPLICADO = "PRD-OT-004";
    public static final String OT_FECHA_INICIO_REQUERIDA = "PRD-OT-005";
    public static final String OT_FECHA_FIN_INVALIDA = "PRD-OT-006";
    public static final String OT_FECHA_FIN_REQUERIDA = "PRD-OT-FECHA-FIN-REQ";
    public static final String OT_NRO_OPERACION_DUPLICADO = "PRD-OT-007";
    public static final String OT_LABOR_INEXISTENTE = "PRD-OT-008";
    public static final String OT_EJECUTOR_INEXISTENTE = "PRD-OT-009";
    public static final String OT_ENTIDAD_INEXISTENTE = "PRD-OT-010";
    public static final String OT_CENTROS_COSTO_INEXISTENTE = "PRD-OT-011";
    public static final String OT_UNIDAD_MEDIDA_INEXISTENTE = "PRD-OT-012";
    public static final String OT_ARTICULO_INEXISTENTE = "PRD-OT-013";
    public static final String OT_CANTIDAD_INVALIDA = "PRD-OT-014";
    public static final String OT_SIN_OPERACIONES = "PRD-OT-015";
    public static final String OT_CANTIDAD_NEGATIVA = "PRD-OT-016";
    public static final String OT_COSTO_NEGATIVO = "PRD-OT-016";
    public static final String OT_CONFLICTO_ESTADO = "PRD-OT-CONFLICT";
    public static final String OT_ANULAR_VALE = "PRD-OT-ANULAR-VALE";
    public static final String OT_ANULAR_OC = "PRD-OT-ANULAR-OC";

    // ─── Operación (PRD-OP) ──────────────────────────────────────

    public static final String OPERACION_LABOR_INEXISTENTE = "PRD-OP-001";

    // ─── Parte Producción (PRD-PT) ───────────────────────────────

    public static final String PARTE_DATOS_INCOMPLETOS = "PRD-PT-001";
    public static final String PARTE_OT_INEXISTENTE = "PRD-PT-002";
    public static final String PARTE_ARTICULO_INEXISTENTE = "PRD-PT-003";
    public static final String PARTE_CANTIDAD_INVALIDA = "PRD-PT-004";
    public static final String PARTE_SIN_INSUMOS_NI_PRODUCIDOS = "PRD-PT-005";
    public static final String PARTE_VALE_INEXISTENTE = "PRD-PT-006";
    public static final String PARTE_INACTIVO = "PRD-PT-007";
    public static final String PARTE_UM_INEXISTENTE = "PRD-PT-008";

    // ─── Programación Producción (PRD-PP) ────────────────────────

    public static final String PROG_DATOS_INCOMPLETOS = "PRD-PP-001";
    public static final String PROG_RECETA_INEXISTENTE = "PRD-PP-002";
    public static final String PROG_OT_INEXISTENTE = "PRD-PP-003";
    public static final String PROG_SUCURSAL_INEXISTENTE = "PRD-PP-004";
    public static final String PROG_FRECUENCIA_INVALIDA = "PRD-PP-005";

    // ─── Ejecutor (PRD-EJ) ────────────────────────────────────────

    public static final String EJECUTOR_DATOS_INCOMPLETOS = "PRD-EJ-001";
    public static final String EJECUTOR_FK_INEXISTENTE = "PRD-EJ-002";
    public static final String EJECUTOR_CODIGO_DUPLICADO = "PRD-EJ-003";
    public static final String EJECUTOR_REFERENCIAS_ASOCIADAS = "PRD-EJ-004";

    // ─── Control Calidad (PRD-CC) ────────────────────────────────

    public static final String CONTROL_CALIDAD_DATOS_INCOMPLETOS = "PRD-CC-001";
    public static final String CONTROL_CALIDAD_FK_INEXISTENTE = "PRD-CC-002";
    public static final String CONTROL_CALIDAD_RESULTADO_INVALIDO = "PRD-CC-003";
    public static final String CONTROL_CALIDAD_NO_ENCONTRADO = "PRD-CC-004";
    public static final String CONTROL_CALIDAD_ACCION_NO_PERMITIDA = "PRD-CC-005";

    // ─── Costeo Producción (PRD-CP) ──────────────────────────────

    public static final String COSTEO_PERIODO_OBLIGATORIO = "PRD-CP-001";
    public static final String COSTEO_PERIODO_INVALIDO = "PRD-CP-002";
    public static final String COSTEO_SIN_OTS_EN_PERIODO = "PRD-CP-003";
    public static final String COSTEO_SUCURSAL_INEXISTENTE = "PRD-CP-004";
    public static final String COSTEO_ERROR_CALCULO = "PRD-CP-005";
}
