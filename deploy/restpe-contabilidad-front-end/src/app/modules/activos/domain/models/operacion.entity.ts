/**
 * Entidad de dominio: Operaciones de Activos Fijos.
 * Representa la configuración de tipos de operación con naturaleza y cuenta contable.
 * Convención de nombres: tabla_campo (snake_case).
 */
export interface OperacionEntity {
  id?: string;
  operacion_codigo:              string;    // Código único (RN-AF-001...)
  operacion_descripcion:         string;    // Descripción del tipo de operación
  operacion_naturaleza:          string;    // Aumento | Disminución | Neutro
  operacion_tipo_calculo:        string;    // Depreciación | Revaluación | Mejora | Baja | Transferencia | Otros
  operacion_metodo_calculo:      string;    // Método de cálculo (aplica según tipo)
  operacion_cta_contable:        string;    // Cuenta contable asociada
  operacion_estado:              string;    // Activo | Inactivo
  operacion_centro_costo?:       string;    // Centro de costo asociado
  operacion_afecta_contabilidad?: boolean;  // Indica si afecta la contabilidad
  operacion_observaciones?:      string;    // Observaciones adicionales
}
