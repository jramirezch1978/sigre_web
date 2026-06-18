package pe.restaurant.almacen.messaging;

/**
 * Etiquetas de tipo de evento ({@code eventType}) usadas en los pre-asientos que
 * {@code ms-almacen} envía a {@code ms-contabilidad} vía HTTP (Feign).
 */
public final class AlmacenMessagingConstants {

    /** Pre-asiento de costo de producción hacia {@code ms-contabilidad}. */
    public static final String ROUTING_PRE_ASIENTO_COSTEO = "almacen.pre_asiento.costo_produccion";

    /** Pre-asiento de ingreso de inventario (clases I y P) hacia {@code ms-contabilidad}. */
    public static final String ROUTING_PRE_ASIENTO_INGRESO = "almacen.pre_asiento.ingreso";

    /** Pre-asiento de consumo de inventario (clase C) hacia {@code ms-contabilidad}. */
    public static final String ROUTING_PRE_ASIENTO_CONSUMO = "almacen.pre_asiento.consumo";

    private AlmacenMessagingConstants() {
    }
}
