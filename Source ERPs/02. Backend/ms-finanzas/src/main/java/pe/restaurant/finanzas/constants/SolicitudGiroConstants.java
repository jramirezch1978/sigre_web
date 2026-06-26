package pe.restaurant.finanzas.constants;

public final class SolicitudGiroConstants {

    private SolicitudGiroConstants() {
        throw new UnsupportedOperationException("Esta es una clase de constantes y no debe ser instanciada");
    }

    /** Tipos de solicitud (tipo_solicitud) */
    public static final String TIPO_ORDEN_GIRO = "O";  // Orden de Giro - Cuenta 14
    public static final String TIPO_FONDO_FIJO = "F";   // Fondo Fijo - Caja Chica, Cuenta 32

    /** Estados de solicitud (flag_estado) */
    public static final String FLAG_PENDIENTE = "3";    // Pendiente aprobación
    public static final String FLAG_APROBADA = "1";     // Aprobada
    public static final String FLAG_ANULADA = "0";      // Anulada
    /**
     * Rechazada (HU-FIN-ADL-002): estado de rechazo DIFERENCIADO de Anulada.
     * La columna {@code flag_estado} no tiene CHECK ni FK (05-finanzas.sql), por lo que admite
     * este valor nuevo sin migración. El endpoint legacy /solicitudes-giro/{id}/rechazar sigue
     * usando FLAG_ANULADA; solo la aprobación de órdenes de giro (ADL-002) usa este valor.
     */
    public static final String FLAG_RECHAZADA = "5";    // Rechazada (ADL-002, sin tocar BD)

    /** Estados de devolución (flag_estado_devolucion) */
    public static final String DEVOLUCION_APROBADA = "A";   // Aprobada
    public static final String DEVOLUCION_RECHAZADA = "R";  // Rechazada
    // NULL = sin devolución o pendiente de aprobación

}
