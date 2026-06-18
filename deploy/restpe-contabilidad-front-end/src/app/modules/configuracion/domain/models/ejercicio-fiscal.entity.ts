export interface PeriodoFiscalEntity {
  periodo_fiscal_codigo: string;
  periodo_fiscal_nombre: string;
  periodo_fiscal_fecha_inicio_detalle: string;
  periodo_fiscal_fecha_fin_detalle: string;
  periodo_fiscal_cierre: string;
  periodo_fiscal_estado: string;
}

export interface EjercicioFiscalEntity {
  ejercicio_fiscal_nombre: string;
  ejercicio_fiscal_fecha_inicio: string;
  ejercicio_fiscal_fecha_fin: string;
  ejercicio_fiscal_periocidad: string;
  ejercicio_fiscal_estado: string;
  ejercicio_fiscal_cierre?: string;
  ejercicio_fiscal_periodos: PeriodoFiscalEntity[];
}
