package pe.restaurant.finanzas.service;

public class FinanzasErrorCodes {
    
    // Errores de Validación de FK Externas
    public static final String MONEDA_NO_ENCONTRADA = "FIN-005";
    
    public static final String MONEDA_INACTIVA = "FIN-006";
    
    // Errores de Negocio de Maestros
    public static final String CONCEPTO_FINANCIERO_CODIGO_DUPLICADO = "FIN-001";
    
    public static final String CODIGO_FLUJO_CAJA_CODIGO_DUPLICADO = "FIN-002";
    
    public static final String BANCO_CODIGO_DUPLICADO = "FIN-003";
    
    public static final String CUENTA_BANCARIA_CODIGO_DUPLICADO = "FIN-004";
    
    public static final String ACTIVIDAD_FLUJO_CAJA_CODIGO_DUPLICADO = "FIN-007";
    
    // Errores de Reglas de Negocio
    public static final String CUENTA_BANCARIA_NO_ACTIVA = "FIN-031";
    
    // Errores de Cuentas por Pagar
    public static final String DOCUMENTO_DUPLICADO = "FIN-101";
    
    public static final String DOCUMENTO_UNIQUE_KEY_DUPLICADO = "FIN-107";
    
    public static final String ESTADO_INVALIDO = "FIN-102";
    
    public static final String SALDO_INVALIDO = "FIN-103";
    
    public static final String CONTABILIDAD_INVALIDA = "FIN-104";
    
    public static final String ASIENTO_NO_BALANCEADO = "FIN-105";
    
    public static final String CUENTA_NO_DETALLE = "FIN-106";
    
    public static final String PROVEEDOR_NO_ENCONTRADO = "FIN-201";

    public static final String CREDITO_FISCAL_NO_ENCONTRADO = "FIN-207";
    
    public static final String DOC_TIPO_NO_ENCONTRADO = "FIN-202";
    
    public static final String ARTICULO_NO_ENCONTRADO = "FIN-203";
    
    public static final String PLAN_CONTABLE_NO_ENCONTRADO = "FIN-204";

    public static final String PLAN_CONTABLE_DET_NO_ENCONTRADO = "FIN-205";

    public static final String PLAN_CONTABLE_DET_INACTIVO = "FIN-206";

    public static final String LIBRO_CONTABLE_NO_ENCONTRADO = "FIN-208";
    
    public static final String FECHA_VENCIMIENTO_INVALIDA = "FIN-301";
    
    public static final String TIPO_CAMBIO_NO_ENCONTRADO = "FIN-302";

    public static final String PERIODO_CONTABLE_INVALIDO = "FIN-303";
    
    // Errores de Canje de Documentos
    public static final String CANJE_PROVEEDOR_INCOHERENTE = "FIN-401";
    
    public static final String CANJE_MONEDA_INCOHERENTE = "FIN-402";
    
    public static final String CANJE_MONTO_NO_COINCIDE = "FIN-403";
    
    public static final String CANJE_SALDO_INSUFICIENTE = "FIN-404";
    
    public static final String CANJE_ESTADO_INVALIDO = "FIN-405";
    
    public static final String CANJE_FECHA_INVALIDA = "FIN-406";
    
    public static final String CANJE_NO_REVERSIBLE = "FIN-407";
    
    public static final String CANJE_REFERENCIA_DUPLICADA = "FIN-408";

    /** Catálogo CF004 requerido para líneas de movimiento generadas por canje de documentos. */
    public static final String CONCEPTO_FINANCIERO_CANJE_REQUERIDO = "FIN-410";
    
    public static final String CANJE_DOCUMENTO_SIN_DETALLES = "FIN-411";
    
    // Errores de Solicitudes de Giro
    public static final String SOLICITUD_NUMERO_DUPLICADO = "FIN-501";
    
    public static final String SOLICITUD_ESTADO_INVALIDO = "FIN-502";
    
    public static final String SOLICITUD_MONTO_INVALIDO = "FIN-503";
    
    public static final String SOLICITUD_NO_EDITABLE = "FIN-504";
    
    public static final String SOLICITUD_NO_ANULABLE = "FIN-505";
    
    public static final String SOLICITUD_GIRO_INACTIVA = "FIN-506";
    
    public static final String SOLICITUD_GIRO_NO_APROBADA = "FIN-507";
    
    public static final String SOLICITUD_NO_ES_DEVOLUCION = "FIN-508";
    
    public static final String DEVOLUCION_NO_PENDIENTE = "FIN-509";
    
    // Errores de Liquidaciones
    public static final String LIQUIDACION_ESTADO_INVALIDO = "FIN-601";
    
    public static final String LIQUIDACION_TOTALES_NO_CUADRAN = "FIN-602";
    
    @Deprecated
    public static final String ORDEN_GIRO_INACTIVA = "FIN-603";
    
    @Deprecated
    public static final String ORDEN_GIRO_DUPLICADA = "FIN-604";
    
    public static final String SALDO_DEVOLUCION_INSUFICIENTE = "FIN-605";
    
    // Errores de Conciliación Bancaria (FI347)
    public static final String CONCILIACION_DUPLICADA = "FIN-701";
    public static final String CONCILIACION_ESTADO_INVALIDO = "FIN-702";
    public static final String CONCILIACION_PARTIDAS_PENDIENTES = "FIN-703";
    public static final String CONCILIACION_PERIODO_INVALIDO = "FIN-704";
    public static final String CONCILIACION_PARTIDAS_INVALIDAS = "FIN-705";
    
    // Errores de Detracción (FI334)
    public static final String DETRACCION_DUPLICADA = "FIN-801";
    public static final String DETRACCION_ESTADO_INVALIDO = "FIN-802";
    public static final String DETRACCION_NO_EDITABLE = "FIN-803";
    public static final String DETRACCION_IMPORTE_INVALIDO = "FIN-804";
    
    // Errores de Retención IGV (FI331)
    public static final String RETENCION_DUPLICADA = "FIN-910";
    public static final String RETENCION_ESTADO_INVALIDO = "FIN-911";
    public static final String RETENCION_NO_EDITABLE = "FIN-912";
    public static final String RETENCION_TIPO_CAMBIO_INVALIDO = "FIN-913";
    public static final String RETENCION_IMPORTE_INVALIDO = "FIN-914";
    public static final String PROVEEDOR_INACTIVO = "FIN-915";
    public static final String PROVEEDOR_FORMATO_INVALIDO = "FIN-916";
    
    // Errores de Cálculo de Impuestos
    public static final String SUCURSAL_NO_ENCONTRADA = "SUCURSAL_NO_ENCONTRADA";
    
    public static final String IMPUESTO_NO_ENCONTRADO = "IMPUESTO_NO_ENCONTRADO";
    
    public static final String SUCURSAL_SIN_PAIS = "SUCURSAL_SIN_PAIS";
    
    public static final String PAIS_NO_ENCONTRADO = "PAIS_NO_ENCONTRADO";
    
    public static final String ERROR_COMUNICACION_CORE = "ERROR_COMUNICACION_CORE";

    public static final String MULTIPLES_FISCALIZADOS = "MULTIPLES_FISCALIZADOS";

    public static final String ESTRUCTURA_IMPUESTOS_DIVERGENTE = "ESTRUCTURA_IMPUESTOS_DIVERGENTE";
    
    // Errores de Comunicación con Microservicios
    public static final String ERROR_COMUNICACION_CORE_MAESTROS = "FIN-900";
    
    public static final String ERROR_COMUNICACION_AUTH_SECURITY = "FIN-901";
    
    public static final String ERROR_COMUNICACION_CONTABILIDAD = "FIN-902";
    
    // Autorización
    public static final String ACCESO_DENEGADO = "FIN-403";

    // Error Genérico
    public static final String ERROR_INTERNO = "FIN-998";
    
    public static final String ERROR_INTERNO_FINANZAS = "FIN-999";
    
    private FinanzasErrorCodes() {
    }
}
