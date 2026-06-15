package com.sigre.comercializacion.service;

/**
 * Nombres calificados para el numerador corporativo.
 * <p><b>Implementación:</b> módulo {@code common} →
 * {@link com.sigre.common.service.NumeradorDocumentoService#siguienteNroDocumento(String, Long, int)}
 * → PostgreSQL {@code core.fn_get_document_number} (12 caracteres: sucursal + año + correlativo).</p>
 * <p>Uso en comercializacion-service: {@link com.sigre.comercializacion.service.impl.OrdenVentaServiceImpl#create} y
 * {@link com.sigre.comercializacion.service.impl.ProformaServiceImpl#create}.</p>
 */
public final class VentasNumeradorTablas {

    public static final String ORDEN_VENTA = "ventas.orden_venta";
    public static final String PROFORMA = "ventas.proforma";

    private VentasNumeradorTablas() {}
}
