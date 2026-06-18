package pe.restaurant.rrhh.constants;

/**
 * Constantes para el módulo de Conceptos de Planilla.
 * Define tipos de conceptos, estados y códigos de error estándar.
 * 
 * @author Equipo de Desarrollo RRHH
 */
public final class ConceptoPlanillaConstants {

    private ConceptoPlanillaConstants() {
        // Constructor privado para clase de constantes
    }

    // ========== Tipos de Concepto ==========
    
    /**
     * Tipo de concepto: INGRESO (sueldos, bonificaciones, etc.)
     */
    public static final String TIPO_INGRESO = "INGRESO";
    
    /**
     * Tipo de concepto: DESCUENTO (AFP, ONP, préstamos, etc.)
     */
    public static final String TIPO_DESCUENTO = "DESCUENTO";
    
    /**
     * Tipo de concepto: APORTE (EsSalud, SCTR, etc.)
     */
    public static final String TIPO_APORTE = "APORTE";

    // ========== Estados ==========
    
    /**
     * Estado activo del concepto
     */
    public static final String ESTADO_ACTIVO = "1";
    
    /**
     * Estado inactivo del concepto
     */
    public static final String ESTADO_INACTIVO = "0";

    // ========== Códigos de Error ==========
    
    /**
     * Error: El código del concepto es obligatorio
     */
    public static final String ERROR_CODIGO_OBLIGATORIO = "RH-CP-001";
    
    /**
     * Error: Ya existe un concepto con el código ingresado
     */
    public static final String ERROR_CODIGO_DUPLICADO = "RH-CP-002";
    
    /**
     * Error: El tipo debe ser INGRESO, DESCUENTO o APORTE
     */
    public static final String ERROR_TIPO_INVALIDO = "RH-CP-003";
    
    /**
     * Error: No se puede eliminar un concepto usado en planillas procesadas
     */
    public static final String ERROR_EN_USO = "RH-CP-004";
    
    /**
     * Error: Concepto no encontrado
     */
    public static final String ERROR_NO_ENCONTRADO = "RH-CP-005";

    // ========== Mensajes de Error ==========
    
    /**
     * Mensaje: El código del concepto es obligatorio
     */
    public static final String MSG_CODIGO_OBLIGATORIO = "El código del concepto es obligatorio.";
    
    /**
     * Mensaje: Ya existe un concepto con el código ingresado
     */
    public static final String MSG_CODIGO_DUPLICADO = "Ya existe un concepto con el código ingresado.";
    
    /**
     * Mensaje: El tipo debe ser INGRESO, DESCUENTO o APORTE
     */
    public static final String MSG_TIPO_INVALIDO = "El tipo debe ser INGRESO, DESCUENTO o APORTE.";
    
    /**
     * Mensaje: No se puede eliminar un concepto usado en planillas procesadas
     */
    public static final String MSG_EN_USO = "No se puede eliminar un concepto usado en planillas procesadas.";
    
    /**
     * Mensaje: Concepto no encontrado
     */
    public static final String MSG_NO_ENCONTRADO = "Concepto no encontrado.";

    // ========== Mensajes de Éxito ==========

    public static final String MSG_CONCEPTO_DESACTIVADO = "Concepto desactivado correctamente.";
    public static final String MSG_CONCEPTO_ACTIVADO = "Concepto activado correctamente.";
}
