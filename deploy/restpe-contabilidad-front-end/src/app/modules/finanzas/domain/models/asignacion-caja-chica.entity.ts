export interface AsignacionCajaChicaEntity {
  acc_codigo: string;
  acc_sucursal: string;
  acc_caja: string;
  acc_fechaAsignacion: string;
  acc_montoMaximo: number;
  acc_montoAsignado: number;
  acc_moneda: string;
  acc_responsable: string;
  acc_observaciones: string;
  acc_estado: 'Activo' | 'Reintegrado';
}
