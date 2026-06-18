/**
 * Entidad de dominio: Registro de Operaciones de Activos Fijos.
 * Representa un registro de operación especial sobre un activo fijo.
 * Convención de nombres: tabla_campo (snake_case).
 */
export interface RegistroOperacionActivoEntity {
  registro_op_codigo:                      string;
  registro_op_cod_activo:                  string;
  registro_op_activo_nombre:               string;
  registro_op_tipo_operacion:              string;
  registro_op_fecha:                       string;
  registro_op_monto:                       string;
  registro_op_moneda:                      string;
  registro_op_descripcion:                 string;
  registro_op_responsable:                 string;
  registro_op_matriz_contable:             string;
  registro_op_estado:                      string;
  registro_op_observaciones?:              string;
  registro_op_documentos?:                 string[];
  // Campos específicos de Revaluación
  registro_op_tipo_revaluacion?:           string;
  registro_op_fuente_revaluacion?:         string;
  registro_op_factor_revaluacion?:         string;
  registro_op_nuevo_valor?:                string;
  registro_op_responsable_evaluador?:      string;
  registro_op_responsable_evaluador_tipo?: string;
}
