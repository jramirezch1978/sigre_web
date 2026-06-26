package pe.restaurant.rrhh.constants;

public final class TipoNovedadRrhhConstants {

    private TipoNovedadRrhhConstants() {
        throw new UnsupportedOperationException("Clase de constantes — no instanciable");
    }

    // Códigos de error de dominio
    public static final String ERROR_CODIGO_OBLIGATORIO   = "RH-TN-001";
    public static final String ERROR_CODIGO_DUPLICADO     = "RH-TN-002";
    public static final String ERROR_NOMBRE_OBLIGATORIO   = "RH-TN-003";
    public static final String ERROR_DESACTIVACION_EN_USO = "RH-TN-004";
    public static final String ERROR_NO_ENCONTRADO        = "RH-TN-005";

    // Mensajes de error
    public static final String MSG_CODIGO_OBLIGATORIO      = "El c\u00f3digo del tipo de novedad es obligatorio.";
    public static final String MSG_CODIGO_DUPLICADO        = "Ya existe un tipo de novedad con el c\u00f3digo ingresado.";
    public static final String MSG_NOMBRE_OBLIGATORIO      = "El nombre del tipo de novedad es obligatorio.";
    public static final String MSG_DESACTIVACION_EN_USO    = "No se puede desactivar un tipo de novedad en uso.";
    public static final String MSG_NO_ENCONTRADO           = "Tipo de novedad no encontrado.";

    // Mensajes de éxito
    public static final String MSG_CREADO      = "Tipo de novedad creado correctamente.";
    public static final String MSG_ACTUALIZADO = "Tipo de novedad actualizado correctamente.";
    public static final String MSG_ELIMINADO   = "Tipo de novedad desactivado correctamente.";
    public static final String MSG_OBTENIDOS   = "Tipos de novedad obtenidos correctamente.";
    public static final String MSG_DESACTIVADO = "Tipo de novedad desactivado correctamente.";
}
