export interface AsignacionFondoFijoCajaEntity {
  affc_codigo: string;
  affc_sucursal: string;
  affc_caja: string;
  affc_fechaAsignacion: string;
  affc_montoAsignado: number;
  affc_moneda: string;
  affc_responsable: string;
  affc_observaciones: string;
  affc_estado: 'Activo' | 'Reintegrado';
}
