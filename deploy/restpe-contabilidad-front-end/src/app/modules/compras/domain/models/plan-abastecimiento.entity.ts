/**
 * Entidad de dominio: Plan de Abastecimiento.
 * Convención: plan_abastecimiento_campo / det_plan_abast_campo
 */
export interface ArticuloPlanEntity {
  det_plan_abast_codigo:                    string;
  det_plan_abast_descripcion:               string;
  det_plan_abast_unidad_medida:             string;
  det_plan_abast_stock_actual:              number;
  det_plan_abast_chp:                       number;
  det_plan_abast_demanda_proyectada:        number;
  det_plan_abast_cantidad_sugerida:         number;
  det_plan_abast_cantidad_final_planificada: number;
}

export interface PlanAbastecimientoEntity {
  plan_abastecimiento_numero:       string;
  plan_abastecimiento_responsable:  string;
  plan_abastecimiento_fecha:        string;
  plan_abastecimiento_periodo:      string;
  plan_abastecimiento_tipo:         string;
  plan_abastecimiento_almacen:      string;
  plan_abastecimiento_sucursal:     string;
  plan_abastecimiento_numero_items: number;
  plan_abastecimiento_estado:       string;
  plan_abastecimiento_articulos?:   ArticuloPlanEntity[];
  [key: string]: any;
}
