package pe.restaurant.activos.util;

/**
 * Constantes para flag_estado en el módulo de activos fijos.
 */
public final class ActivosFlagEstado {

    public static final String ACTIVO = "1";
    public static final String INACTIVO = "0";
    /** Adaptación ya capitalizada al valor del activo (`af_adaptacion.flag_estado`). */
    public static final String CAPITALIZADA = "2";

    private ActivosFlagEstado() {
        // Clase de utilidad, no instanciable
    }
}
