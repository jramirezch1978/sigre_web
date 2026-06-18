/**
 * Entidad de dominio: Parámetros de Operaciones de Activos Fijos.
 * Representa la configuración global del módulo (registro único).
 * Convención de nombres: tabla_campo (snake_case).
 */
export interface ParamOperacionEntity {
  id?: string;
  param_op_codigo:                 string;   // Identificador del registro (PARAM-001)
  param_op_metodo_depreciacion:    string;   // Lineal | Suma de dígitos | Otro
  param_op_libro_contable:         string;   // Financiero | Tributario | NIIF | Otro
  param_op_cuenta_activo_fijo:     string;   // Cuenta global de activo fijo
  param_op_cuenta_depreciacion:    string;   // Cuenta global de depreciación
  param_op_cuenta_gasto_depr:      string;   // Cuenta de gasto de depreciación
  param_op_centro_costo:           string;   // Centro de costo por defecto
  param_op_formato_numeracion:     string;   // Formato de numeración de activos
  param_op_correlativo_manual:     boolean;  // Habilitar correlativo manual
  param_op_modulo_contable:        boolean;  // Integración con módulo contable
  param_op_modulo_compras:         boolean;  // Integración con módulo de compras
  param_op_modulo_inventario:      boolean;  // Integración con módulo de inventario
  param_op_dias_previos_cierre:    string;   // Días previos al cierre
  param_op_modificacion_post_cierre: boolean; // Permitir modificación post cierre
  param_op_observaciones:          string;   // Observaciones generales
}
