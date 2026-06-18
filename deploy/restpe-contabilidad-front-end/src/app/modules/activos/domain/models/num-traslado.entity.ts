/**
 * Entidad de dominio: Numerador de Traslados de Activos Fijos.
 * Representa la configuración de secuencias numéricas para traslados por sucursal.
 * Convención de nombres: tabla_campo (snake_case).
 */
export interface NumTrasladoEntity {
  id?: string;
  num_traslado_codigo:        string;   // Código de configuración (TRA-001...)
  num_traslado_sucursal:      string;   // Sucursal asignada
  num_traslado_periodo_cont:  string;   // Período contable (mes/año)
  num_traslado_prefijo:       string;   // Prefijo de la secuencia
  num_traslado_tipo_doc:      string;   // Tipo de documento
  num_traslado_ninicial:      string;   // Número inicial de la secuencia
  num_traslado_nactual:       string;   // Número actual
  num_traslado_estado:        string;   // Activo | Inactivo
  num_traslado_longitud?:     string;   // Longitud total del número
  num_traslado_incremento?:   string;   // Incremento por registro
  num_traslado_rango?:        string;   // Rango permitido (ej. "1-9999")
  num_traslado_relleno?:      string;   // Carácter de relleno
  num_traslado_reinicio?:     string;   // Anual | Mensual | Manual | No reiniciar
  num_traslado_formato?:      string;   // Formato de presentación
  num_traslado_observaciones?: string;
}
