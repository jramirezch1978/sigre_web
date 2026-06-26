package pe.restaurant.rrhh.constants;

public final class SancionAmonestacionConstants {
    private SancionAmonestacionConstants() { throw new UnsupportedOperationException("Clase de constantes — no instanciable"); }

    public static final String ERROR_DATOS_INCOMPLETOS = "RH-SA-001";
    public static final String ERROR_TRABAJADOR_INEXISTENTE = "RH-SA-002";
    public static final String ERROR_TIPO_SANCION_INEXISTENTE = "RH-SA-003";
    public static final String ERROR_FECHA_FUTURA = "RH-SA-004";
    public static final String ERROR_NO_ENCONTRADO = "RH-SA-005";

    public static final String MSG_DATOS_INCOMPLETOS = "Datos incompletos para la sanción.";
    public static final String MSG_TRABAJADOR_INEXISTENTE = "El trabajador especificado no existe.";
    public static final String MSG_TIPO_SANCION_INEXISTENTE = "El tipo de sanción especificado no existe.";
    public static final String MSG_FECHA_FUTURA = "La fecha de la sanción no puede ser futura.";
    public static final String MSG_NO_ENCONTRADO = "Sanción o amonestación no encontrada.";

    public static final String MSG_CREADO = "Sanción registrada correctamente.";
    public static final String MSG_ACTUALIZADO = "Sanción actualizada correctamente.";
    public static final String MSG_ELIMINADO = "Sanción desactivada correctamente.";
    public static final String MSG_OBTENIDOS = "Sanciones obtenidas correctamente.";
    public static final String MSG_DESACTIVADO = "Sanción desactivada correctamente.";
}
