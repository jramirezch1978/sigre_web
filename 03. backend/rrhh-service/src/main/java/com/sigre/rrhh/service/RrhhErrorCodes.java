package com.sigre.rrhh.service;

public final class RrhhErrorCodes {

    private RrhhErrorCodes() {
        throw new UnsupportedOperationException("Utility class");
    }

    // Ganancia/Descuento Fijo
    public static final String GF_TRABAJADOR_OBLIGATORIO = "RH-GF-001";
    public static final String GF_CONCEPTO_OBLIGATORIO = "RH-GF-002";
    public static final String GF_IMPORTE_O_PORCENTAJE_REQUERIDO = "RH-GF-003";
    public static final String GF_DUPLICADO_ACTIVO = "RH-GF-004";
}
