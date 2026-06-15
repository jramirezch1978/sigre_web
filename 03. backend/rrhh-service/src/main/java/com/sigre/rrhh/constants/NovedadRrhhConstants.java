package com.sigre.rrhh.constants;

public final class NovedadRrhhConstants {
    private NovedadRrhhConstants() { throw new UnsupportedOperationException(); }
    public static final String ERROR_TRABAJADOR_INEXISTENTE = "RH-NV-001";
    public static final String ERROR_TIPO_NOVEDAD_INEXISTENTE = "RH-NV-002";
    public static final String ERROR_FECHAS_INVALIDAS = "RH-NV-003";
    public static final String ERROR_DUPLICADO_PERIODO = "RH-NV-004";
    public static final String ERROR_NO_ENCONTRADO = "RH-NV-005";
    public static final String ERROR_DESACTIVACION_EN_USO = "RH-NV-006";

    public static final String MSG_TRABAJADOR_INEXISTENTE = "El trabajador no existe.";
    public static final String MSG_TIPO_NOVEDAD_INEXISTENTE = "El tipo de novedad no existe.";
    public static final String MSG_FECHAS_INVALIDAS = "La fecha fin no puede ser anterior a la fecha inicio.";
    public static final String MSG_DUPLICADO_PERIODO = "Ya existe una novedad del mismo tipo en ese período.";
    public static final String MSG_NO_ENCONTRADO = "Novedad no encontrada.";
    public static final String MSG_DESACTIVACION_EN_USO = "No se puede desactivar una novedad referenciada en planilla.";

    public static final String MSG_CREADO = "Novedad registrada correctamente.";
    public static final String MSG_ACTUALIZADO = "Novedad actualizada correctamente.";
    public static final String MSG_ELIMINADO = "Novedad desactivada correctamente.";
    public static final String MSG_OBTENIDOS = "Novedades obtenidas correctamente.";
    public static final String MSG_DESACTIVADO = "Novedad desactivada correctamente.";
    public static final String MSG_DETALLE_AGREGADO = "Detalle de novedad agregado correctamente.";
    public static final String MSG_DETALLE_ELIMINADO = "Detalle de novedad eliminado correctamente.";
}
