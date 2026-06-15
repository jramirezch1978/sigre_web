package com.sigre.contabilidad.service;

public class ContabilidadErrorCodes {
    
    public static final String ASIENTO_NO_BALANCEADO = "CONT-001";
    
    public static final String CUENTA_NO_DETALLE = "CONT-002";
    
    public static final String ASIENTO_NO_ENCONTRADO = "CONT-003";
    
    public static final String ESTADO_INVALIDO_PARA_ACTUALIZACION = "CONT-004";
    
    public static final String ESTADO_INVALIDO_PARA_ANULACION = "CONT-005";

    public static final String PERIODO_CONTABLE_CERRADO = "CONT-006";

    public static final String PERIODO_CONTABLE_INVALIDO = "CONT-007";
    
    public static final String PLAN_CONTABLE_NO_ENCONTRADO = "CONT-101";

    public static final String PLAN_CONTABLE_DET_DUPLICADO = "CONT-111";

    public static final String TIPO_DETRACCION_DUPLICADO = "CONT-501";

    public static final String UIT_DUPLICADA = "CONT-601";
    
    public static final String LIBRO_CONTABLE_NO_ENCONTRADO = "CONT-102";

    public static final String LIBRO_CONTABLE_DUPLICADO = "CONT-112";
    
    public static final String MONEDA_NO_ENCONTRADA = "CONT-103";

    public static final String SUCURSAL_NO_ENCONTRADA = "CONT-104";

    public static final String SUCURSAL_SIN_CODIGO = "CONT-105";
    
    public static final String ERROR_COMUNICACION_CORE_MAESTROS = "CONT-900";
    
    public static final String MATRIZ_CONTABLE_NO_ENCONTRADA = "CONT-201";

    public static final String CENTRO_COSTO_NO_ENCONTRADO = "CONT-401";

    public static final String CENTRO_COSTO_DUPLICADO = "CONT-402";

    public static final String MATRIZ_CONTABLE_DUPLICADA = "CONT-205";

    public static final String MATRIZ_CONTABLE_DET_DUPLICADO = "CONT-206";

    public static final String ASIENTO_DUPLICADO = "CONT-202";

    public static final String CONCEPTO_FINANCIERO_NO_ENCONTRADO = "CONT-203";

    public static final String CONCEPTO_FINANCIERO_INACTIVO = "CONT-204";

    public static final String PREASIENTO_NO_ENCONTRADO = "CONT-301";

    public static final String PREASIENTO_DUPLICADO = "CONT-302";

    public static final String PREASIENTO_SIN_PENDIENTES = "CONT-303";

    public static final String PREASIENTO_YA_IMPORTADO = "CONT-304";

    public static final String ERROR_INTERNO_CONTABILIDAD = "CONT-999";
    
    private ContabilidadErrorCodes() {
    }
}
