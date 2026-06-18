export interface DetalleConceptoEntity {
  dc_concepto: string;
  dc_monto: string;
}

export interface ProyeccionIngresosEgresosEntity {
  pie_sucursal: string;
  pie_periodo: string;
  pie_saldoInicial: number;
  pie_ingresos: number;
  pie_egresos: number;
  pie_saldoFinal: number;
  pie_variacion: number;
  pie_estado: 'Superavit' | 'Deficit' | 'Equilibrado';
  pie_detalleIngresos: DetalleConceptoEntity[];
  pie_detalleEgresos: DetalleConceptoEntity[];
}