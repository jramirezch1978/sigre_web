package pe.restaurant.activos.integracion;

public final class AfIntegracionContableModulo {

    /** Flag CHAR(1) para cntbl_asiento.modulo_origen: O = Activos Fijos */
    public static final String MODULO = "O";

    /** Valores para cntbl_asiento.tipo (naturaleza/operación) */
    public static final String DEPRECIACION = "AF-001";
    public static final String DEVENGO_PRIMA = "AF_DEVENGO_PRIMA";
    public static final String VENTA = "AF_VENTA";
    public static final String VALUACION = "AF_VALUACION";
    public static final String ALTA_ACTIVO = "AF_ALTA_ACTIVO";
    public static final String ADAPTACION = "AF_ADAPTACION";
    public static final String BAJA_ACTIVO = "AF_BAJA_ACTIVO";
    public static final String TRASLADO = "AF_TRASLADO";

    private AfIntegracionContableModulo() {
    }
}
