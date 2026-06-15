package com.sigre.almacen.event.publisher;

import com.sigre.almacen.entity.ArticuloMovTipo;
import com.sigre.almacen.entity.ValeMov;
import com.sigre.almacen.messaging.AlmacenMessagingConstants;

/**
 * Clasifica un {@link ValeMov} confirmado en su tipo de pre-asiento de inventario.
 * Solo ingreso (clases {@code I}, {@code P}) y consumo (clase {@code C}) generan asiento.
 */
final class PreAsientoMovimientoClasificador {

    enum TipoAsiento {
        INGRESO("INGRESO_ALMACEN", AlmacenMessagingConstants.ROUTING_PRE_ASIENTO_INGRESO),
        CONSUMO("CONSUMO_ALMACEN", AlmacenMessagingConstants.ROUTING_PRE_ASIENTO_CONSUMO);

        final String tipoDocumento;
        final String routingKey;

        TipoAsiento(String tipoDocumento, String routingKey) {
            this.tipoDocumento = tipoDocumento;
            this.routingKey = routingKey;
        }
    }

    private PreAsientoMovimientoClasificador() {
    }

    /** Indica si el movimiento contabiliza ({@code flag_contabiliza = '1'}). */
    static boolean contabiliza(ArticuloMovTipo tipo) {
        return tipo != null && "1".equals(tipo.getFlagContabiliza());
    }

    /**
     * Resuelve el tipo de asiento por la clase del movimiento ({@code tipo_referencia_origen}).
     * Devuelve {@code null} para clases que no generan asiento de ingreso/consumo (V, T, G, etc.).
     */
    static TipoAsiento clasificar(ValeMov mov) {
        if (mov == null || mov.getTipoReferenciaOrigen() == null) {
            return null;
        }
        return switch (mov.getTipoReferenciaOrigen().trim().toUpperCase()) {
            case "I", "P" -> TipoAsiento.INGRESO;
            case "C" -> TipoAsiento.CONSUMO;
            default -> null;
        };
    }
}
