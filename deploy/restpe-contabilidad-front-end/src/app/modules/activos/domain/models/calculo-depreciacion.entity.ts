/**
 * Entidad de dominio: Cálculo de Depreciación.
 * Representa un cálculo masivo de depreciación ejecutado en un periodo determinado.
 * Convención de nombres: cd_campo (snake_case).
 */
export interface CalculoDepreciacionEntity {
  id?: string;
  cd_codigo:             string;   // Código del cálculo (DEP-2025-08...)
  cd_periodo:            string;   // Periodo del cálculo (202508...)
  cd_fecha_ejecucion:    string;   // Fecha en que se ejecutó el cálculo
  cd_usuario:            string;   // Usuario que ejecutó el cálculo
  cd_total_activos?:      number;   // Total de activos procesados (calculado desde cd_activos)
  cd_depreciacion_total?: number;   // Monto total de depreciación calculada (calculado desde cd_activos)
  cd_costo_adquisicion?:  number;   // Costo de adquisición total (calculado desde cd_activos)
  cd_porcentaje_desgaste?: number;  // Porcentaje de desgaste acumulado (calculado desde cd_activos)
  cd_tipo_depreciacion:  string;   // Contable | Tributaria
  cd_tipo_calculo:       string;   // Mensual | Anual
  cd_metodo_calculo:     string;   // Lineal | Decreciente
  cd_incluir_ar:         boolean;  // Incluir activos en reparación
  cd_incluir_am:         boolean;  // Incluir activos en mantenimiento
  cd_estado?:            string;   // Pendiente | Contabilizado
  cd_nro_asiento_cont?:  string;   // Número de asiento contable generado
  cd_fecha_contabilizacion?: string; // Fecha en que se contabilizó
  cd_prefijo_doc?:       string;   // Prefijo de documento
  cd_observaciones?:     string;   // Observaciones
  cd_activos?:           any[];    // Lista de activos del cálculo (tabla secundaria)
}
