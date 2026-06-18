/**
 * Entidad de dominio: Generación de Asientos de Depreciación.
 * Representa un registro del proceso de generación de asientos contables por depreciación.
 * Convención de nombres: gad_campo (snake_case).
 */
export interface GeneracionAsientosDepreciacionEntity {
  id?: string;
  gad_codigo:           string;   // Código del cálculo (DEP-2025-10...)
  gad_periodo:          string;   // Periodo del cálculo (202510...)
  gad_fecha_ejecucion:  string;   // Fecha de ejecución del cálculo
  gad_usuario_resp:     string;   // Usuario responsable
  gad_activos:          number;   // Total de activos procesados
  gad_moneda:           string;   // Moneda del ajuste (Soles, Dólares, etc.)
  gad_libro:            number;   // Cantidad de libros procesados
  gad_dpc_total:        number;   // Monto total de depreciación
  gad_valor_cont:       number;   // Valor contable total
  gad_nro_asiento_cont: string;   // Número de asiento contable generado
  gad_estado:           string;   // Pendiente | Contabilizado
  gad_tipo_calculo?:    string;   // Mensual | Anual
  gad_tipo_depreciacion?: string; // Contable | Tributaria
  gad_metodo_calculo?:  string;   // Lineal | Decreciente
  gad_fecha_contabilizacion?: string; // Fecha en que se contabilizó
  gad_prefijo_doc?:     string;   // Prefijo de documento
  gad_observaciones?:   string;   // Observaciones
}
