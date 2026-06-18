package pe.restaurant.ventas.service;

/**
 * Nombres calificados para el numerador corporativo.
 * <p><b>Implementación:</b> módulo {@code common} →
 * {@link pe.restaurant.common.service.NumeradorDocumentoService#siguienteNroDocumento(String, Long, int)}
 * → PostgreSQL {@code core.fn_get_document_number} (12 caracteres: sucursal + año + correlativo).</p>
 * <p>Uso en ms-ventas: {@link pe.restaurant.ventas.service.impl.OrdenVentaServiceImpl#create} y
 * {@link pe.restaurant.ventas.service.impl.ProformaServiceImpl#create}.</p>
 */
public final class VentasNumeradorTablas {

    public static final String ORDEN_VENTA = "ventas.orden_venta";
    public static final String PROFORMA = "ventas.proforma";

    private VentasNumeradorTablas() {}
}
