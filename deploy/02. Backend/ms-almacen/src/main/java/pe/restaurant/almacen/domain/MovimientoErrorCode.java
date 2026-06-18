package pe.restaurant.almacen.domain;

/**
 * Códigos de error de negocio para el módulo de movimientos de almacén.
 * Prefijo {@code ALM-} según catálogo definido en
 * {@code CONTRATO_API_MOVIMIENTOS_ALMACEN.md §1.2} y
 * {@code HU_MOVIMIENTOS_ALMACEN.md §19}.
 */
public final class MovimientoErrorCode {

    private MovimientoErrorCode() {
    }

    // --- Cabecera ---
    public static final String ALMACEN_NO_ENCONTRADO = "ALM-001";
    public static final String TIPO_MOV_NO_ENCONTRADO = "ALM-002";
    public static final String TIPO_MOV_NO_HABILITADO = "ALM-003";
    public static final String PROVEEDOR_OBLIGATORIO = "ALM-010";
    public static final String DOC_EXTERNO_OBLIGATORIO = "ALM-011";
    public static final String DOC_INTERNO_OBLIGATORIO = "ALM-012";
    public static final String REFERENCIA_OBLIGATORIA = "ALM-013";
    public static final String PERIODO_CERRADO = "ALM-014";
    public static final String COHERENCIA_CLASE_MOV = "ALM-015";
    public static final String REFERENCIA_NO_ENCONTRADA = "ALM-016";
    public static final String REFERENCIA_ESTADO_INVALIDO = "ALM-017";

    // --- Detalle ---
    public static final String ARTICULO_NO_ENCONTRADO = "ALM-020";
    public static final String CANTIDAD_INVALIDA = "ALM-021";
    public static final String UBICACION_NO_PERTENECE = "ALM-022";
    public static final String CENTRO_COSTO_OBLIGATORIO = "ALM-023";
    public static final String LOTE_OBLIGATORIO = "ALM-024";
    public static final String STOCK_INSUFICIENTE = "ALM-025";
    public static final String ARTICULO_DUPLICADO = "ALM-026";
    public static final String ARTICULO_SIN_SUBCATEGORIA = "ALM-027";
    public static final String FK_LINEA_NO_CORRESPONDE = "ALM-028";

    // --- Matriz contable ---
    public static final String MATRIZ_NO_ENCONTRADA = "ALM-030";
    public static final String MATRIZ_INVALIDA = "ALM-031";

    // --- Estado / operaciones ---
    public static final String MOVIMIENTO_NO_ENCONTRADO = "ALM-040";
    public static final String SOLO_EDITABLE_ACTIVO = "ALM-041";
    public static final String SOLO_CONFIRMABLE_ACTIVO = "ALM-042";
    public static final String NO_ANULAR_CERRADO = "ALM-043";
    public static final String NO_ANULAR_GUIA_ACTIVA = "ALM-044";
    public static final String NO_ANULAR_FACTURADO = "ALM-045";
    public static final String NO_ANULAR_CONSIGNACION = "ALM-046";
    public static final String NO_ANULAR_GUIA_RECEPCION_MP = "ALM-047";
    /** Otro vale referencia a este como original (devolución) y sigue activo. */
    public static final String NO_ANULAR_REFERENCIA_HIJO = "ALM-048";
    /** El vale está referenciado por un consumo de producción (parte) activo. */
    public static final String NO_ANULAR_PARTE_PRODUCCION = "ALM-049";
    public static final String MOVIMIENTO_YA_ANULADO = "ALM-050";

    /** PUT movimiento: solo cantidad y costo unitario por línea; cabecera y FK de línea inmutables (salvo observaciones). */
    public static final String ACTUALIZACION_MOV_SOLO_CANT_PRECIO = "ALM-096";

    // --- Traslados ---
    public static final String ORDEN_TRASLADO_REQUERIDA = "ALM-032";
    public static final String ORDEN_TRASLADO_NO_ENCONTRADA = "ALM-033";
    public static final String TIPO_INGRESO_TRASLADO_NO_ENCONTRADO = "ALM-034";
    public static final String ALMACEN_DESTINO_NO_ENCONTRADO = "ALM-035";

    // --- Devoluciones ---
    public static final String SALDO_INSUFICIENTE_DEVOLUCION = "ALM-060";
    public static final String CANTIDAD_DEVOLUCION_EXCEDIDA = "ALM-061";
    public static final String TIPO_SIN_DEVOLUCION = "ALM-062";
    public static final String MOVIMIENTO_ORIGEN_NO_DEVOLVIBLE = "ALM-063";

    // --- Kardex ---
    public static final String KARDEX_NO_ENCONTRADO = "ALM-070";

    // --- Excel / PDF ---
    public static final String EXCEL_ERROR = "ALM-080";
    public static final String PDF_ERROR = "ALM-081";

    // --- Integraciones (bloque F: OC/OV/OT) ---
    /** No quedan líneas pendientes para el almacén indicado o documento sin saldo. */
    public static final String INTEGRACION_SIN_LINEAS_PENDIENTES = "ALM-091";
    /** El tipo de movimiento no coincide con la clase esperada (I/V/T) o no está habilitado para traslado. */
    public static final String INTEGRACION_TIPO_MOV_INVALIDO = "ALM-092";
    /** Traslado entre almacenes sin vale espejo posterior al vale de salida. */
    public static final String INTEGRACION_ESPEJO_NO_GENERADO = "ALM-093";
    /** Documento origen tiene más de una línea pendiente para el mismo artículo (vale no admite duplicados). */
    public static final String INTEGRACION_ARTICULO_DUPLICADO_EN_ORIGEN = "ALM-094";

    /** UPDATE en compras/ventas/traslado no afectó exactamente la línea esperada (datos desalineados). */
    public static final String SYNC_ACUMULADO_ORIGEN_FALLIDO = "ALM-095";

    /** Diferencia OC vs factura vs conteo físico en recepción de compra (validación 3 vías). */
    public static final String VALIDACION_TRES_VIAS = "ALM-097";
}
