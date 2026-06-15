package com.sigre.rrhh.constants;

public final class PermisoLicenciaConstants {

    private PermisoLicenciaConstants() {
        throw new UnsupportedOperationException("Clase de constantes — no instanciable");
    }

    // ── Estados (flag_estado) ────────────────────────────────────
    public static final String ESTADO_RECHAZADO   = "0";
    public static final String ESTADO_SOLICITADO  = "1";
    public static final String ESTADO_APROBADO    = "2";
    public static final String ESTADO_OBSERVADO   = "3";
    public static final String ESTADO_ANULADO     = "4";
    public static final String ESTADO_CERRADO     = "5";
    public static final String ESTADO_PROCESADO   = "6";
    public static final String ESTADO_EN_PLANILLA = "7";
    public static final String ESTADO_REF_BOLETA  = "8";

    // ── Códigos de error ───────────────────────────────────────
    public static final String ERROR_DATOS_INCOMPLETOS = "RH-PL-001";
    public static final String ERROR_TRABAJADOR_INEXISTENTE = "RH-PL-002";
    public static final String ERROR_FECHAS_INVALIDAS = "RH-PL-003";
    public static final String ERROR_SOLAPAMIENTO = "RH-PL-004";
    public static final String ERROR_YA_APROBADO_RECHAZADO = "RH-PL-005";
    public static final String ERROR_NO_ENCONTRADO = "RH-PL-006";
    public static final String ERROR_TIPO_SUSPENSION_INEXISTENTE = "RH-PL-007";
    public static final String ERROR_TRANSICION_INVALIDA = "RH-PL-008";

    public static final String MSG_DATOS_INCOMPLETOS = "Datos incompletos para el permiso o licencia.";
    public static final String MSG_TRABAJADOR_INEXISTENTE = "El trabajador especificado no existe.";
    public static final String MSG_FECHAS_INVALIDAS = "La fecha fin no puede ser anterior a la fecha inicio.";
    public static final String MSG_SOLAPAMIENTO = "El trabajador ya tiene un permiso activo en ese rango de fechas.";
    public static final String MSG_YA_APROBADO_RECHAZADO = "El permiso ya fue aprobado o rechazado.";
    public static final String MSG_NO_ENCONTRADO = "Permiso o licencia no encontrado.";
    public static final String MSG_TIPO_SUSPENSION_INEXISTENTE = "El tipo de suspensión laboral especificado no existe.";

    public static final String MSG_DATOS_INCOMPLETOS_TRANSICION = "Transición de estado no permitida.";
    public static final String MSG_CREADO = "Permiso o licencia registrado correctamente.";
    public static final String MSG_ACTUALIZADO = "Permiso o licencia actualizado correctamente.";
    public static final String MSG_APROBADO = "Permiso aprobado correctamente.";
    public static final String MSG_RECHAZADO = "Permiso rechazado correctamente.";
    public static final String MSG_OBSERVADO = "Permiso devuelto con observaciones.";
    public static final String MSG_ANULADO = "Permiso anulado correctamente.";
    public static final String MSG_CERRADO = "Permiso cerrado correctamente.";
    public static final String MSG_PROCESADO = "Permiso procesado para planilla.";
    public static final String MSG_EN_PLANILLA = "Permiso enviado a planilla.";
    public static final String MSG_REF_BOLETA = "Permiso reflejado en boleta.";
    public static final String MSG_ELIMINADO = "Permiso o licencia desactivado correctamente.";
    public static final String MSG_OBTENIDOS = "Permisos y licencias obtenidos correctamente.";
    public static final String MSG_DESACTIVADO = "Permiso desactivado correctamente.";
}
