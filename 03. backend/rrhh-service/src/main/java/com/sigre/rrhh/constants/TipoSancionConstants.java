package com.sigre.rrhh.constants;

public final class TipoSancionConstants {
    private TipoSancionConstants() { throw new UnsupportedOperationException("Clase de constantes — no instanciable"); }

    public static final String ERROR_CODIGO_OBLIGATORIO = "RH-TS-001";
    public static final String ERROR_CODIGO_DUPLICADO = "RH-TS-002";
    public static final String ERROR_NOMBRE_OBLIGATORIO = "RH-TS-003";
    public static final String ERROR_NO_ENCONTRADO = "RH-TS-004";
    public static final String ERROR_ELIMINACION_CON_SANCIONES = "RH-TS-005";

    public static final String MSG_CODIGO_OBLIGATORIO = "El código del tipo de sanción es obligatorio.";
    public static final String MSG_CODIGO_DUPLICADO = "Ya existe un tipo de sanción con ese código.";
    public static final String MSG_NOMBRE_OBLIGATORIO = "El nombre del tipo de sanción es obligatorio.";
    public static final String MSG_NO_ENCONTRADO = "Tipo de sanción no encontrado.";
    public static final String MSG_ELIMINACION_CON_SANCIONES = "No se puede eliminar un tipo de sanción con sanciones asociadas.";

    public static final String MSG_CREADO = "Tipo de sanción creado correctamente.";
    public static final String MSG_ACTUALIZADO = "Tipo de sanción actualizado correctamente.";
    public static final String MSG_DESACTIVADO = "Tipo de sanción desactivado correctamente.";
    public static final String MSG_ACTIVADO = "Tipo de sanción activado correctamente.";
    public static final String MSG_ELIMINADO = "Tipo de sanción desactivado correctamente.";
    public static final String MSG_OBTENIDOS = "Tipos de sanción obtenidos correctamente.";
}
