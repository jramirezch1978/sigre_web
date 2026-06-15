package com.sigre.comercializacion.service;

public final class VentasErrorCodes {
    
    // Punto de venta
    public static final String PUNTO_VENTA_NOT_FOUND = "VEN-001";
    public static final String PUNTO_VENTA_CODIGO_DUPLICADO = "VEN-002";
    public static final String PUNTO_VENTA_SUCURSAL_INVALIDA = "VEN-003";
    public static final String PUNTO_VENTA_ALMACEN_INVALIDO = "VEN-004";
    public static final String PUNTO_VENTA_SERIE_BOLETA_DUPLICADA = "VEN-005";
    public static final String PUNTO_VENTA_SERIE_FACTURA_DUPLICADA = "VEN-006";
    public static final String PUNTO_VENTA_ALMACEN_SUCURSAL_INVALIDA = "VEN-007";

    // Mesa
    public static final String MESA_NOT_FOUND = "VEN-010";
    public static final String MESA_NUMERO_DUPLICADO = "VEN-011";
    public static final String MESA_ZONA_INVALIDA = "VEN-012";
    public static final String MESA_ZONA_SUCURSAL_INVALIDA = "VEN-013";
    public static final String MESA_OCUPADA_NO_DESACTIVABLE = "VEN-014";
    public static final String MESA_OCUPADA_NO_ELIMINABLE = "VEN-015";

    // Vendedor
    public static final String VENDEDOR_NOT_FOUND = "VEN-020";
    public static final String VENDEDOR_USUARIO_INVALIDO = "VEN-021"; // Usuario duplicado
    public static final String VENDEDOR_USUARIO_FK_INVALIDO = "VEN-022"; // Usuario no existe o inactivo
    
    // Canal de distribución
    public static final String CANAL_DISTRIBUCION_NOT_FOUND = "VEN-030";
    public static final String CANAL_DISTRIBUCION_CODIGO_DUPLICADO = "VEN-031";
    
    // Carta
    public static final String CARTA_NOT_FOUND = "VEN-040";
    public static final String CARTA_SUCURSAL_INVALIDA = "VEN-041";
    public static final String ARTICULO_NO_ENCONTRADO = "VEN-042";
    public static final String ARTICULO_DUPLICADO_CARTA = "VEN-043";
    public static final String PRECIO_INVALIDO = "VEN-044";
    public static final String ITEM_CARTA_INVALIDO = "VEN-045";
    public static final String ITEM_NO_ENCONTRADO = "VEN-046";
    
    // Servicios CxC
    public static final String SERVICIOS_CXC_NOT_FOUND = "VEN-050";
    public static final String SERVICIOS_CXC_CODIGO_DUPLICADO = "VEN-051";
    
    // Zonas
    public static final String ZONA_NOT_FOUND = "VEN-060";
    public static final String ZONA_SUCURSAL_INVALIDA = "VEN-061";
    public static final String ZONA_NOMBRE_DUPLICADO = "VEN-062";

    // Comanda / pedido mesa / factura simplificada (operaciones ventas sigree)
    public static final String COMANDA_NOT_FOUND = "VEN-070";
    public static final String COMANDA_STATE = "VEN-071";
    public static final String COMANDA_FK = "VEN-072";
    public static final String PEDIDO_MESA_NOT_FOUND = "VEN-073";
    public static final String PEDIDO_MESA_STATE = "VEN-074";
    public static final String PEDIDO_MESA_DUPLICATE_NUMERO = "VEN-075";
    public static final String PEDIDO_MESA_MESA_ABIERTA = "VEN-076";
    public static final String PEDIDO_MESA_FK = "VEN-077";
    public static final String FS_NOT_FOUND = "VEN-080";
    public static final String FS_STATE = "VEN-081";
    public static final String FS_FK = "VEN-082";
    public static final String FS_DUPLICATE_NUMERACION = "VEN-083";
    public static final String FS_PAGOS = "VEN-084";
    public static final String FS_CXC_CONCEPTO_NO_CONFIGURADO = "VEN-085";
    public static final String FS_CXC_GENERACION_FALLIDA = "VEN-086";
    public static final String FS_CXC_CONTABILIDAD_FALLIDA = "VEN-087";
    /** Anulación de factura bloqueada: reservación confirmada aún enlazada a este comprobante. */
    public static final String FS_ANULAR_RESERVACION_PENDIENTE = "VEN-088";

    // Orden de venta comercial (OV + detalle)
    public static final String OV_NOT_FOUND = "VEN-090";
    public static final String OV_STATE = "VEN-091";
    public static final String OV_NUMERO_DUPLICADO = "VEN-092";

    // OV — integración almacén (despacho)
    public static final String OV_DESPACHO_ESTADO_INVALIDO = "VEN-093";
    public static final String OV_DESPACHO_SIN_LINEAS = "VEN-094";
    public static final String OV_DESPACHO_ALMACEN_NOT_FOUND = "VEN-095";
    public static final String OV_DESPACHO_VALIDACION = "VEN-096";
    public static final String OV_DESPACHO_REQUEST_INVALIDO = "VEN-097";
    public static final String OV_DESPACHO_COMUNICACION = "VEN-098";

    // Proforma
    public static final String PROFORMA_NOT_FOUND = "VEN-100";
    public static final String PROFORMA_STATE = "VEN-101";
    public static final String PROFORMA_NUMERO_DUPLICADO = "VEN-102";
    /** Generación automática de número vía numerador: sucursal obligatoria. */
    public static final String PROFORMA_SUCURSAL_NUMERADOR = "VEN-103";

    // Cierre de caja
    public static final String CIERRE_CAJA_NOT_FOUND = "VEN-110";
    public static final String CIERRE_CAJA_STATE = "VEN-111";

    // Descuento / promoción
    public static final String DESCUENTO_PROMOCION_NOT_FOUND = "VEN-120";
    public static final String DESCUENTO_PROMOCION_INVALIDO = "VEN-121";

    // Propina
    public static final String PROPINA_NOT_FOUND = "VEN-130";
    public static final String PROPINA_FK = "VEN-131";
    public static final String PROPINA_VALIDATION = "VEN-132";

    // Reservación
    public static final String RESERVACION_NOT_FOUND = "VEN-140";
    public static final String RESERVACION_STATE = "VEN-141";
    public static final String RESERVACION_FK = "VEN-142";
    public static final String RESERVACION_VALIDATION = "VEN-143";
    public static final String RESERVACION_MESA_OCUPADA = "VEN-144";

    // Créditos CxC por entidad
    public static final String CREDITOS_CXC_NOT_FOUND = "VEN-150";
    public static final String CREDITOS_CXC_DUPLICATE = "VEN-151";
    public static final String CREDITOS_CXC_FK = "VEN-152";
    public static final String CREDITOS_CXC_VALIDATION = "VEN-153";

    // Cuentas por cobrar — flujos directo / detracción / NC
    public static final String CXC_FK = "VEN-160";
    public static final String CXC_VALIDATION = "VEN-161";
    public static final String CXC_CREDITO_EXCEDIDO = "VEN-162";
    public static final String CXC_DETRACCION_YA_EXISTE = "VEN-163";
    public static final String CXC_DETRACCION_MONTO_MINIMO = "VEN-164";
    public static final String CXC_NC_SALDO_INSUFICIENTE = "VEN-165";
    public static final String CXC_SERVICIO_INVALIDO = "VEN-166";
    public static final String CXC_DOC_TIPO_NO_CONFIGURADO = "VEN-167";
    public static final String CXC_LIBRO_NO_ENCONTRADO = "VEN-168";
    public static final String CXC_PERIODO_INVALIDO = "VEN-169";

    private VentasErrorCodes() {
        // Constructor privado para prevenir instanciación
    }
}
