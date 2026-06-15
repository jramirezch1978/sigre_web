package com.sigre.rrhh.constants;

public final class VacacionConstants {
    private VacacionConstants() { throw new UnsupportedOperationException(); }

    // ── Estados (flag_estado) ────────────────────────────────────
    public static final String ESTADO_ANULADO     = "0";
    public static final String ESTADO_REGISTRADO  = "1";
    public static final String ESTADO_PENDIENTE   = "2";
    public static final String ESTADO_APROBADO    = "3";
    public static final String ESTADO_RECHAZADO   = "4";
    public static final String ESTADO_CERRADO     = "5";

    // ── Códigos de error ─────────────────────────────────────────
    public static final String ERROR_NO_ENCONTRADO = "RH-VC-001";
    public static final String ERROR_FECHAS_INVALIDAS = "RH-VC-002";
    public static final String ERROR_DIAS_EXCEDIDOS = "RH-VC-003";
    public static final String ERROR_ESTADO_INVALIDO = "RH-VC-004";
    public static final String ERROR_DUPLICADO = "RH-VC-005";

    // ── Mensajes ─────────────────────────────────────────────────
    public static final String MSG_NO_ENCONTRADO = "Vacación no encontrada.";
    public static final String MSG_CREADO = "Período vacacional creado.";
    public static final String MSG_ACTUALIZADO = "Vacación actualizada.";
    public static final String MSG_OBTENIDOS = "Vacaciones obtenidas.";
    public static final String MSG_GOCE_SOLICITADO = "Goce vacacional solicitado.";
    public static final String MSG_APROBADO = "Goce vacacional aprobado.";
    public static final String MSG_RECHAZADO = "Goce vacacional rechazado.";
    public static final String MSG_OBSERVADO = "Goce vacacional observado.";
    public static final String MSG_REPROGRAMADO = "Goce vacacional reprogramado.";
    public static final String MSG_CERRADO = "Goce vacacional cerrado.";
    public static final String MSG_ANULADO = "Vacación anulada.";
    public static final String MSG_DESACTIVADO = "Período vacacional desactivado correctamente.";
}
