package pe.restaurant.activos.service;

/**
 * Códigos de Error del Módulo de Activos Fijos
 * 
 * <p>Esta clase centraliza todos los códigos de error utilizados en el módulo de activos fijos
 * para facilitar su mantenimiento y comprensión por parte del equipo de desarrollo.</p>
 * 
 * <p>Formato: ACT-XXX donde ACT = Activos Fijos, XXX = número secuencial</p>
 * 
 * @author Sistema Restaurant.pe
 * @version 1.0
 * @since 2026-04-16
 */
public final class ActivosErrorCodes {

    /**
     * ACT-001: Duplicado código de clase de activo
     * 
     * <p>Se lanza cuando se intenta crear o actualizar una clase de activo con un código 
     * que ya existe en el sistema.</p>
     * 
     * <p><strong>Solución:</strong> Verifique el código e ingrese uno único.</p>
     * 
     * <p><strong>Ejemplo:</strong></p>
     * <pre>{@code
     * // Intento crear clase con código "VEHICULOS" que ya existe
     * throw new BusinessException("Ya existe una clase de activo con el código: VEHICULOS", HttpStatus.CONFLICT, "ACT-001");
     * }</pre>
     */
    public static final String CLASE_CODIGO_DUPLICADO = "ACT-001";

    /**
     * ACT-002: Duplicado código de sub-clase de activo
     * 
     * <p>Se lanza cuando se intenta crear o actualizar una sub-clase con un código 
     * que ya existe para la misma clase de activo.</p>
     * 
     * <p><strong>Solución:</strong> Verifique el código e ingrese uno único para la clase seleccionada.</p>
     */
    public static final String SUB_CLASE_CODIGO_DUPLICADO = "ACT-002";

    /**
     * ACT-003: Duplicado código de ubicación de activo
     * 
     * <p>Se lanza cuando se intenta crear o actualizar una ubicación con un código 
     * que ya existe para la misma sucursal.</p>
     * 
     * <p><strong>Solución:</strong> Verifique el código e ingrese uno único para la sucursal seleccionada.</p>
     */
    public static final String UBICACION_CODIGO_DUPLICADO = "ACT-003";

    /**
     * ACT-004: Duplicado nombre de aseguradora
     * 
     * <p>Se lanza cuando se intenta crear o actualizar una aseguradora con un nombre 
     * que ya existe en el sistema.</p>
     * 
     * <p><strong>Solución:</strong> Verifique el nombre e ingrese uno único.</p>
     */
    public static final String ASEGURADORA_NOMBRE_DUPLICADO = "ACT-004";

    /**
     * ACT-005: Duplicado RUC de aseguradora
     * 
     * <p>Se lanza cuando se intenta crear o actualizar una aseguradora con un RUC 
     * que ya existe en el sistema.</p>
     * 
     * <p><strong>Solución:</strong> Verifique el RUC e ingrese uno único.</p>
     */
    public static final String ASEGURADORA_RUC_DUPLICADO = "ACT-005";

    /**
     * ACT-006: Clase de activo con dependencias
     * 
     * <p>Se lanza cuando se intenta eliminar una clase de activo que tiene 
     * sub-clases asociadas.</p>
     * 
     * <p><strong>Solución:</strong> Elimine primero todas las sub-clases asociadas 
     * o desactívelas antes de eliminar la clase.</p>
     * 
     * <p><strong>Ejemplo:</strong></p>
     * <pre>{@code
     * // Clase "VEHICULOS" tiene sub-clases "AUTOS", "MOTOS", "CAMIONES"
     * // No se puede eliminar "VEHICULOS" hasta eliminar las sub-clases
     * throw new BusinessException(
     *     "No se puede eliminar la clase de activo porque tiene sub-clases asociadas. Elimine primero las sub-clases.",
     *     HttpStatus.CONFLICT, 
     *     "ACT-006"
     * );
     * }</pre>
     */
    public static final String CLASE_CON_DEPENDENCIAS = "ACT-006";

    /**
     * ACT-007: Sucursal no encontrada
     * 
     * <p>Se lanza cuando se intenta crear o actualizar una ubicación de activo con una 
     * sucursal que no existe en el sistema.</p>
     * 
     * <p><strong>Solución:</strong> Verifique que la sucursal seleccionada exista en el sistema.</p>
     */
    public static final String SUCURSAL_NO_ENCONTRADA = "ACT-007";

    /**
     * ACT-008: Sucursal inactiva
     * 
     * <p>Se lanza cuando se intenta crear o actualizar una ubicación de activo con una 
     * sucursal que está inactiva.</p>
     * 
     * <p><strong>Solución:</strong> Active la sucursal o seleccione una sucursal activa.</p>
     */
    public static final String SUCURSAL_INACTIVA = "ACT-008";

    /**
     * ACT-009: Duplicado código de activo maestro
     * 
     * <p>Se lanza cuando se intenta crear o actualizar un activo fijo con un código 
     * que ya existe en el sistema.</p>
     * 
     * <p><strong>Solución:</strong> Verifique el código e ingrese uno único.</p>
     */
    public static final String MAESTRO_CODIGO_DUPLICADO = "ACT-009";

    /**
     * ACT-010: Sub-clase de activo no encontrada
     * 
     * <p>Se lanza cuando se intenta crear o actualizar un activo fijo con una 
     * sub-clase que no existe en el sistema.</p>
     * 
     * <p><strong>Solución:</strong> Verifique que la sub-clase seleccionada exista en el sistema.</p>
     */
    public static final String SUB_CLASE_NO_ENCONTRADA = "ACT-010";

    /**
     * ACT-011: Sub-clase de activo inactiva
     * 
     * <p>Se lanza cuando se intenta crear o actualizar un activo fijo con una 
     * sub-clase que está inactiva.</p>
     * 
     * <p><strong>Solución:</strong> Active la sub-clase o seleccione una sub-clase activa.</p>
     */
    public static final String SUB_CLASE_INACTIVA = "ACT-011";

    /**
     * ACT-012: Ubicación de activo no encontrada
     * 
     * <p>Se lanza cuando se intenta crear o actualizar un activo fijo con una 
     * ubicación que no existe en el sistema.</p>
     * 
     * <p><strong>Solución:</strong> Verifique que la ubicación seleccionada exista en el sistema.</p>
     */
    public static final String UBICACION_NO_ENCONTRADA = "ACT-012";

    /**
     * ACT-013: Ubicación de activo inactiva
     * 
     * <p>Se lanza cuando se intenta crear o actualizar un activo fijo con una 
     * ubicación que está inactiva.</p>
     * 
     * <p><strong>Solución:</strong> Active la ubicación o seleccione una ubicación activa.</p>
     */
    public static final String UBICACION_INACTIVA = "ACT-013";

    /**
     * ACT-014: Proveedor no encontrado
     * 
     * <p>Se lanza cuando se intenta crear o actualizar un activo fijo con un 
     * proveedor que no existe en el sistema.</p>
     * 
     * <p><strong>Solución:</strong> Verifique que el proveedor seleccionado exista en el sistema.</p>
     */
    public static final String PROVEEDOR_NO_ENCONTRADO = "ACT-014";

    /**
     * ACT-015: Proveedor inactivo
     * 
     * <p>Se lanza cuando se intenta crear o actualizar un activo fijo con un 
     * proveedor que está inactivo.</p>
     * 
     * <p><strong>Solución:</strong> Active el proveedor o seleccione un proveedor activo.</p>
     */
    public static final String PROVEEDOR_INACTIVO = "ACT-015";

    /**
     * ACT-016: Valor residual inválido
     * 
     * <p>Se lanza cuando el valor residual es mayor o igual al valor de adquisición.</p>
     * 
     * <p><strong>Solución:</strong> El valor residual debe ser menor al valor de adquisición.</p>
     */
    public static final String VALOR_RESIDUAL_INVALIDO = "ACT-016";

    /**
     * ACT-017: Depreciación duplicada
     * 
     * <p>Se lanza cuando ya existe un cálculo de depreciación para el activo en el periodo especificado.</p>
     * 
     * <p><strong>Solución:</strong> Verifique el periodo o actualice el registro existente.</p>
     */
    public static final String DEPRECIACION_DUPLICADA = "ACT-017";

    /**
     * ACT-018: Activo maestro no encontrado
     * 
     * <p>Se lanza cuando se intenta calcular depreciación para un activo que no existe.</p>
     * 
     * <p><strong>Solución:</strong> Verifique que el activo exista en el sistema.</p>
     */
    public static final String ACTIVO_MAESTRO_NO_ENCONTRADO = "ACT-018";

    /**
     * ACT-019: Activo sin método de depreciación
     * 
     * <p>Se lanza cuando el activo no tiene un método de depreciación definido en su clase.</p>
     * 
     * <p><strong>Solución:</strong> Configure el método de depreciación en la clase del activo.</p>
     */
    public static final String ACTIVO_SIN_METODO_DEPRECIACION = "ACT-019";

    /**
     * ACT-020: Periodo futuro no permitido
     * 
     * <p>Se lanza cuando se intenta calcular depreciación para un periodo futuro.</p>
     * 
     * <p><strong>Solución:</strong> Solo se puede calcular depreciación hasta el periodo actual.</p>
     */
    public static final String PERIODO_FUTURO_NO_PERMITIDO = "ACT-020";

    /**
     * ACT-021: Activo completamente depreciado
     * 
     * <p>Se lanza cuando se intenta calcular depreciación para un activo que ya está completamente depreciado.</p>
     * 
     * <p><strong>Solución:</strong> El activo ya alcanzó su valor residual.</p>
     */
    public static final String ACTIVO_COMPLETAMENTE_DEPRECIADO = "ACT-021";

    /**
     * ACT-022: Número de póliza duplicado
     * 
     * <p>Se lanza cuando se intenta crear/actualizar una póliza con número existente.</p>
     * 
     * <p><strong>Solución:</strong> Use un número de póliza único.</p>
     */
    public static final String POLIZA_NUMERO_DUPLICADO = "ACT-022";

    /**
     * ACT-023: Aseguradora no encontrada
     * 
     * <p>Se lanza cuando se referencia una aseguradora que no existe.</p>
     * 
     * <p><strong>Solución:</strong> Verifique que la aseguradora exista en el sistema.</p>
     */
    public static final String ASEGURADORA_NO_ENCONTRADA = "ACT-023";

    /**
     * ACT-024: Aseguradora inactiva
     * 
     * <p>Se lanza cuando se intenta usar una aseguradora inactiva.</p>
     * 
     * <p><strong>Solución:</strong> Active la aseguradora antes de usarla.</p>
     */
    public static final String ASEGURADORA_INACTIVA = "ACT-024";

    /**
     * ACT-025: Fecha fin anterior a inicio
     * 
     * <p>Se lanza cuando la fecha de fin de póliza es anterior a la fecha de inicio.</p>
     * 
     * <p><strong>Solución:</strong> La fecha de fin debe ser posterior a la fecha de inicio.</p>
     */
    public static final String FECHA_FIN_ANTERIOR_INICIO = "ACT-025";

    /**
     * ACT-026: Póliza vencida
     * 
     * <p>Se lanza cuando se intenta operar con una póliza vencida.</p>
     * 
     * <p><strong>Solución:</strong> Renueve la póliza o use una póliza vigente.</p>
     */
    public static final String POLIZA_VENCIDA = "ACT-026";

    /**
     * ACT-027: Activo ya asegurado en póliza
     * 
     * <p>Se lanza cuando se intenta asegurar un activo que ya está en la póliza.</p>
     * 
     * <p><strong>Solución:</strong> El activo ya está registrado en esta póliza.</p>
     */
    public static final String ACTIVO_YA_ASEGURADO = "ACT-027";

    /**
     * ACT-028: Valor asegurado mayor a valor neto
     * 
     * <p>Se lanza cuando el valor asegurado excede el valor neto del activo.</p>
     * 
     * <p><strong>Solución:</strong> El valor asegurado debe ser menor o igual al valor neto del activo.</p>
     */
    public static final String VALOR_ASEGURADO_EXCEDE_NETO = "ACT-028";

    /**
     * ACT-029: Activo maestro no encontrado para póliza
     * 
     * <p>Se lanza cuando se intenta asegurar un activo que no existe.</p>
     * 
     * <p><strong>Solución:</strong> Verifique que el activo exista en el sistema.</p>
     */
    public static final String ACTIVO_NO_ENCONTRADO_POLIZA = "ACT-029";

    /**
     * ACT-030: Activo inactivo para póliza
     * 
     * <p>Se lanza cuando se intenta asegurar un activo inactivo.</p>
     * 
     * <p><strong>Solución:</strong> Solo se pueden asegurar activos en estado ACTIVO.</p>
     */
    public static final String ACTIVO_INACTIVO_POLIZA = "ACT-030";

    /**
     * ACT-031: Adaptación capitalizada
     * 
     * <p>Se lanza cuando se intenta modificar/eliminar una adaptación capitalizada.</p>
     * 
     * <p><strong>Solución:</strong> No se pueden modificar adaptaciones capitalizadas.</p>
     */
    public static final String ADAPTACION_CAPITALIZADA = "ACT-031";

    /**
     * ACT-032: Adaptación ya capitalizada
     * 
     * <p>Se lanza cuando se intenta capitalizar una adaptación ya capitalizada.</p>
     * 
     * <p><strong>Solución:</strong> La adaptación ya fue capitalizada.</p>
     */
    public static final String ADAPTACION_YA_CAPITALIZADA = "ACT-032";

    /**
     * ACT-033: Monto inválido para capitalización
     * 
     * <p>Se lanza cuando el monto total es cero o negativo.</p>
     * 
     * <p><strong>Solución:</strong> El monto debe ser mayor a cero.</p>
     */
    public static final String MONTO_INVALIDO_CAPITALIZACION = "ACT-033";

    /**
     * ACT-034: Activo inactivo para adaptación
     * 
     * <p>Se lanza cuando se intenta registrar adaptación en activo inactivo.</p>
     * 
     * <p><strong>Solución:</strong> Solo se pueden adaptar activos en estado ACTIVO.</p>
     */
    public static final String ACTIVO_INACTIVO_ADAPTACION = "ACT-034";

    /**
     * ACT-035: Adaptación no encontrada
     * 
     * <p>Se lanza cuando no se encuentra la adaptación referenciada.</p>
     * 
     * <p><strong>Solución:</strong> Verifique que la adaptación exista.</p>
     */
    public static final String ADAPTACION_NO_ENCONTRADA = "ACT-035";

    /**
     * ACT-036: Depreciación adaptación duplicada
     * 
     * <p>Se lanza cuando ya existe depreciación de adaptación para el período.</p>
     * 
     * <p><strong>Solución:</strong> Ya existe depreciación para este año/mes.</p>
     */
    public static final String DEPRECIACION_ADAPTACION_DUPLICADA = "ACT-036";

    /**
     * ACT-037: Maestro no encontrado
     * 
     * <p>Se lanza cuando no se encuentra el activo maestro.</p>
     * 
     * <p><strong>Solución:</strong> Verifique que el activo exista.</p>
     */
    public static final String MAESTRO_NO_ENCONTRADO = "ACT-037";

    /**
     * ACT-040: Traslado en estado inválido
     * 
     * <p>Se lanza cuando se intenta modificar un traslado ejecutado.</p>
     * 
     * <p><strong>Solución:</strong> No se pueden modificar traslados ejecutados.</p>
     */
    public static final String TRASLADO_ESTADO_INVALIDO = "ACT-040";

    /**
     * ACT-041: Traslado no aprobado
     * 
     * <p>Se lanza cuando se intenta ejecutar un traslado no aprobado.</p>
     * 
     * <p><strong>Solución:</strong> El traslado debe estar aprobado para ejecutarse.</p>
     */
    public static final String TRASLADO_NO_APROBADO = "ACT-041";

    /**
     * ACT-042: Ubicaciones iguales
     * 
     * <p>Se lanza cuando origen y destino son la misma ubicación.</p>
     * 
     * <p><strong>Solución:</strong> Las ubicaciones deben ser diferentes.</p>
     */
    public static final String UBICACIONES_IGUALES = "ACT-042";

    /**
     * ACT-043: Venta en estado inválido
     * 
     * <p>Se lanza cuando se intenta modificar una venta aprobada.</p>
     * 
     * <p><strong>Solución:</strong> No se pueden modificar ventas aprobadas.</p>
     */
    public static final String VENTA_ESTADO_INVALIDO = "ACT-043";

    /**
     * ACT-044: Activo ya vendido
     * 
     * <p>Se lanza cuando se intenta vender un activo ya vendido.</p>
     * 
     * <p><strong>Solución:</strong> El activo ya fue dado de baja.</p>
     */
    public static final String ACTIVO_YA_VENDIDO = "ACT-044";

    /**
     * ACT-045: Operación en estado inválido
     * 
     * <p>Se lanza cuando se intenta modificar una operación ejecutada.</p>
     * 
     * <p><strong>Solución:</strong> No se pueden modificar operaciones ejecutadas.</p>
     */
    public static final String OPERACION_ESTADO_INVALIDO = "ACT-045";

    /**
     * ACT-046: Documento duplicado
     * 
     * <p>Se lanza cuando se intenta cargar un documento con ruta duplicada.</p>
     * 
     * <p><strong>Solución:</strong> Verifique que la ruta del archivo no exista.</p>
     */
    public static final String DOCUMENTO_DUPLICADO = "ACT-046";

    /**
     * ACT-047: Valuación en estado inválido
     * 
     * <p>Se lanza cuando se intenta modificar una valuación aprobada.</p>
     * 
     * <p><strong>Solución:</strong> No se pueden modificar valuaciones aprobadas.</p>
     */
    public static final String VALUACION_ESTADO_INVALIDO = "ACT-047";

    /** Matriz contable ya definida para la subclase. */
    public static final String MATRIZ_SUB_CLASE_DUPLICADA = "ACT-048";

    /** Cuenta del plan contable (detalle) inexistente o inactiva. */
    public static final String CUENTA_PLAN_NO_ACTIVA = "ACT-049";

    /** Devengo de prima ya registrado para la póliza y periodo. */
    public static final String PRIMA_DEVENGO_DUPLICADO = "ACT-050";

    /** Póliza sin prima definida para devengar. */
    public static final String PRIMA_SIN_MONTO = "ACT-051";

    /** Periodo fuera de la vigencia de la póliza. */
    public static final String PERIODO_FUERA_VIGENCIA_POLIZA = "ACT-052";

    /** No se puede eliminar la subclase: existen activos maestro que la referencian. */
    public static final String SUB_CLASE_CON_MAESTROS = "ACT-053";

    /** No se puede eliminar la ubicación: existen activos maestro asignados. */
    public static final String UBICACION_CON_MAESTROS = "ACT-054";

    /** La clase de activo está inactiva; no se puede usar en subclases o maestro. */
    public static final String CLASE_INACTIVA = "ACT-055";

    /** No se puede eliminar el maestro: existen registros de depreciación contable. */
    public static final String MAESTRO_CON_DEPRECIACION = "ACT-056";

    /** Faltan unidades de producción (totales o período) para el método UNIDADES_PRODUCIDAS. */
    public static final String UNIDADES_PRODUCCION_INCOMPLETAS = "ACT-057";

    /** Activo inactivo: no se calcula depreciación. */
    public static final String ACTIVO_INACTIVO_DEPRECIACION = "ACT-058";

    /** Seed: no hay sucursal en auth.sucursal (requerido para af_ubicacion). */
    public static final String SEED_SIN_SUCURSAL = "ACT-059";

    /** Seed: esquema o tablas requeridas no disponibles en la BD del tenant. */
    public static final String SEED_BD_INCOMPATIBLE = "ACT-060";

    /** Matriz contable incompleta para generar asiento. */
    public static final String MATRIZ_INCOMPLETA_INTEGRACION = "ACT-061";

    /** Integración con contabilidad deshabilitada por configuración. */
    public static final String INTEGRACION_CONTABILIDAD_DESHABILITADA = "ACT-062";

    /** Orden de compra no encontrada o no accesible vía ms-compras. */
    public static final String ORDEN_COMPRA_NO_ENCONTRADA = "ACT-063";

    /** Línea de orden de compra no pertenece a la OC indicada. */
    public static final String ORDEN_COMPRA_LINEA_INVALIDA = "ACT-064";

    /** Importe del activo no cuadra con el subtotal de la línea de compra. */
    public static final String IMPORTE_NO_CUADRA_COMPRA = "ACT-065";

    /** Ya existe un activo vinculado a la misma línea de orden de compra. */
    public static final String ACTIVO_YA_VINCULADO_OC = "ACT-066";

    /** Proveedor del activo no coincide con el de la orden de compra. */
    public static final String PROVEEDOR_NO_COINCIDE_OC = "ACT-067";

    /** Error al invocar ms-contabilidad (Feign / red). */
    public static final String CONTABILIDAD_NO_DISPONIBLE = "ACT-068";

    /** Monto cero: no se genera asiento contable. */
    public static final String MONTO_CERO_NO_CONTABILIZABLE = "ACT-069";

    /** Integración con compras deshabilitada por configuración. */
    public static final String INTEGRACION_COMPRAS_DESHABILITADA = "ACT-070";

    /** Valuación debe estar aprobada antes de contabilizar. */
    public static final String VALUACION_NO_APROBADA = "ACT-071";

    /** Código de tipo de operación duplicado. */
    public static final String TIPO_OPERACION_CODIGO_DUPLICADO = "ACT-072";

    /** Tipo de operación en uso; no se puede eliminar. */
    public static final String TIPO_OPERACION_EN_USO = "ACT-073";

    /** Numeración no configurada para el tipo solicitado. */
    public static final String NUMERACION_NO_CONFIGURADA = "ACT-074";

    /** Recepción de compra no encontrada en la orden indicada. */
    public static final String RECEPCION_COMPRA_NO_ENCONTRADA = "ACT-075";

    /** Tipo de operación referenciado no existe o está inactivo. */
    public static final String TIPO_OPERACION_NO_ENCONTRADO = "ACT-076";

    /** Adaptación no capitalizada; no se puede contabilizar. */
    public static final String ADAPTACION_NO_CAPITALIZADA = "ACT-077";

    /** Distribución % por centro de costo no suma 100. */
    public static final String DISTRIBUCION_CC_INVALIDA = "ACT-078";

    /** Línea OC sin cantidad facturada para alta desde factura. */
    public static final String LINEA_SIN_FACTURAR = "ACT-079";

    /** Factura proveedor ya vinculada a un activo. */
    public static final String FACTURA_PROVEEDOR_DUPLICADA = "ACT-080";

    /** Traslado sin centros de costo distintos para contabilizar. */
    public static final String TRASLADO_SIN_CAMBIO_CC = "ACT-081";

    /** Valor neto cero: no aplica asiento de traslado. */
    public static final String TRASLADO_VALOR_NETO_CERO = "ACT-082";

    public static final String REPORTE_FORMATO_INVALIDO = "ACT-083";

    public static final String REPORTE_EXPORT_ERROR = "ACT-084";

    // Constructor privado para evitar instanciación
    private ActivosErrorCodes() {
        throw new UnsupportedOperationException("Clase de utilidad - no se puede instanciar");
    }
}
