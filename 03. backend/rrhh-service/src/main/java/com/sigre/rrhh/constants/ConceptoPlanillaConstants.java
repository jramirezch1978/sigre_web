package com.sigre.rrhh.constants;

/**
 * Constantes para el módulo de Conceptos de Planilla (SIGRE CONCEPTO).
 */
public final class ConceptoPlanillaConstants {

    private ConceptoPlanillaConstants() {
    }

    public static final String ESTADO_ACTIVO = "1";
    public static final String ESTADO_INACTIVO = "0";

    public static final String ERROR_CODIGO_OBLIGATORIO = "RH-CP-001";
    public static final String ERROR_CODIGO_DUPLICADO = "RH-CP-002";
    public static final String ERROR_GRUPO_CALCULO_INVALIDO = "RH-CP-003";
    public static final String ERROR_EN_USO = "RH-CP-004";
    public static final String ERROR_NO_ENCONTRADO = "RH-CP-005";

    public static final String MSG_CODIGO_OBLIGATORIO = "El código del concepto es obligatorio.";
    public static final String MSG_CODIGO_DUPLICADO = "Ya existe un concepto con el código ingresado.";
    public static final String MSG_GRUPO_CALCULO_INVALIDO = "El grupo de cálculo es obligatorio.";
    public static final String MSG_EN_USO = "No se puede eliminar un concepto usado en planillas procesadas.";
    public static final String MSG_NO_ENCONTRADO = "Concepto no encontrado.";

    public static final String MSG_CONCEPTO_DESACTIVADO = "Concepto desactivado correctamente.";
    public static final String MSG_CONCEPTO_ACTIVADO = "Concepto activado correctamente.";
}
