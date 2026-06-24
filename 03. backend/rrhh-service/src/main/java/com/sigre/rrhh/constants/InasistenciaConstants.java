package com.sigre.rrhh.constants;

public final class InasistenciaConstants {

    private InasistenciaConstants() {
        throw new UnsupportedOperationException();
    }

    public static final String ESTADO_ANULADA = "0";
    public static final String ESTADO_REGISTRADO = "1";
    public static final String ESTADO_JUSTIFICADA = "2";
    public static final String ESTADO_INJUSTIFICADA = "3";
    public static final String ESTADO_DESCANSO_MEDICO = "4";

    public static final String MSG_CREADA = "Inasistencia registrada exitosamente.";
    public static final String MSG_ACTUALIZADA = "Inasistencia actualizada exitosamente.";
    public static final String MSG_APROBADA = "Inasistencia justificada exitosamente.";
    public static final String MSG_RECHAZADA = "Inasistencia marcada como injustificada.";
    public static final String MSG_ANULADA = "Inasistencia anulada exitosamente.";
    public static final String MSG_REGULARIZADA = "Inasistencia regularizada exitosamente.";
    public static final String MSG_DESACTIVADA = "Inasistencia desactivada exitosamente.";
    public static final String MSG_NO_ENCONTRADA = "Inasistencia no encontrada.";
    public static final String MSG_DUPLICADA = "Ya existe una inasistencia activa para este trabajador en la fecha indicada.";
}
