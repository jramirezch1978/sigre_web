package com.sigre.rrhh.constants;

public final class RemuneracionMinimaVitalConstants {
    private RemuneracionMinimaVitalConstants() { throw new UnsupportedOperationException(); }

    public static final String ERROR_DUPLICADO = "RH-RMV-001";
    public static final String ERROR_NO_ENCONTRADO = "RH-RMV-002";
    public static final String ERROR_TIPO_TRABAJADOR_NO_ENCONTRADO = "RH-RMV-003";

    public static final String MSG_DUPLICADO = "Ya existe un registro con ese tipo de trabajador, RMV y fecha desde.";
    public static final String MSG_NO_ENCONTRADO = "RemuneracionMinimaVital no encontrado.";
    public static final String MSG_TIPO_TRABAJADOR_NO_ENCONTRADO = "TipoTrabajador no encontrado.";
    public static final String MSG_CREADO = "RemuneracionMinimaVital creado correctamente.";
    public static final String MSG_OBTENIDOS = "RemuneracionMinimaVital obtenidos correctamente.";
    public static final String MSG_DESACTIVADO = "RemuneracionMinimaVital desactivado correctamente.";
    public static final String MSG_ACTIVADO = "RemuneracionMinimaVital activado correctamente.";
}
