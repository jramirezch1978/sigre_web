package pe.restaurant.rrhh.constants;

public final class PrestamoConstants {
    private PrestamoConstants() { throw new UnsupportedOperationException(); }
    public static final String ERROR_DATOS_INCOMPLETOS = "RH-PR-001";
    public static final String ERROR_TRABAJADOR_INEXISTENTE = "RH-PR-002";
    public static final String ERROR_MONTO_CUOTAS_INVALIDO = "RH-PR-003";
    public static final String ERROR_MODIFICACION_CON_CUOTAS = "RH-PR-004";
    public static final String ERROR_NO_ENCONTRADO = "RH-PR-005";

    public static final String MSG_TRABAJADOR_INEXISTENTE = "El trabajador no existe.";
    public static final String MSG_MONTO_CUOTAS_INVALIDO = "El monto y las cuotas deben ser mayores a cero.";
    public static final String MSG_MODIFICACION_CON_CUOTAS = "No se puede modificar un préstamo con cuotas ya descontadas en planilla.";
    public static final String MSG_NO_ENCONTRADO = "Préstamo no encontrado.";

    public static final String MSG_CREADO = "Préstamo registrado correctamente.";
    public static final String MSG_ACTUALIZADO = "Préstamo actualizado correctamente.";
    public static final String MSG_ESTADO_CAMBIADO = "Estado del préstamo cambiado correctamente.";
    public static final String MSG_OBTENIDOS = "Préstamos obtenidos correctamente.";
}
