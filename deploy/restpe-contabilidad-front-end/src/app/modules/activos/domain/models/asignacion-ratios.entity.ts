/**
 * Entidad de dominio: Asignación de Ratios de Depreciación.
 * Convención de nombres: ars_campo (snake_case).
 */
export interface AsignacionRatiosEntity {
  id?: string;
  ars_cod_configuracion: string;   // Código de configuración (CFG-001...)
  ars_cod_activo:        string;   // Código del activo fijo
  ars_tipo_depreciacion?: string;  // Tipo de depreciación (tipo1, tipo2)
  ars_metodo:            string;   // Método de depreciación
  ars_tasa_anual:        string;   // Tasa anual (ej: '25')
  ars_valor_residual?:   string;   // Valor residual
  ars_fecha_inicio:      string;   // Fecha de inicio (DD/MM/YYYY)
  ars_estado:            'Activo' | 'Inactivo';
  ars_centros_costo?:    { centroCosto: string; porcentaje: string }[];  // Centros de costo
  ars_norma_contable?:   string;   // Norma contable aplicable
  ars_notas_adicionales?: string;  // Observaciones / notas adicionales
}
