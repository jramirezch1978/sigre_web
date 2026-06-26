package pe.restaurant.rrhh.constants;

public final class TipoSuspensionLaboralConstants {

    private TipoSuspensionLaboralConstants() {
        throw new UnsupportedOperationException("Clase de constantes — no instanciable");
    }

    public static final String ERROR_CODIGO_OBLIGATORIO = "RH-TS-001";
    public static final String ERROR_CODIGO_DUPLICADO = "RH-TS-002";
    public static final String ERROR_NOMBRE_OBLIGATORIO = "RH-TS-003";
    public static final String ERROR_NO_ENCONTRADO = "RH-TS-004";
    public static final String ERROR_ELIMINACION_CON_PERMISOS = "RH-TS-005";

    public static final String MSG_CODIGO_OBLIGATORIO = "El código del tipo de suspensión es obligatorio.";
    public static final String MSG_CODIGO_DUPLICADO = "Ya existe un tipo de suspensión con ese código.";
    public static final String MSG_NOMBRE_OBLIGATORIO = "El nombre del tipo de suspensión es obligatorio.";
    public static final String MSG_NO_ENCONTRADO = "Tipo de suspensión laboral no encontrado.";
    public static final String MSG_ELIMINACION_CON_PERMISOS = "No se puede eliminar un tipo de suspensión con permisos asociados.";

    public static final String MSG_CREADO = "Tipo de suspensión laboral creado correctamente.";
    public static final String MSG_ACTUALIZADO = "Tipo de suspensión laboral actualizado correctamente.";
    public static final String MSG_ELIMINADO = "Tipo de suspensión laboral desactivado correctamente.";
    public static final String MSG_OBTENIDOS = "Tipos de suspensión laboral obtenidos correctamente.";
    public static final String MSG_DESACTIVADO = "Tipo de suspensión laboral desactivado correctamente.";
    public static final String MSG_ACTIVADO = "Tipo de suspensión laboral activado correctamente.";
}
