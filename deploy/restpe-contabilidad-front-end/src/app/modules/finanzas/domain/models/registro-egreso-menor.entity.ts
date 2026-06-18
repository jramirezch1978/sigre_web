export interface RegistroEgresoMenorEntity {
  rem_codigo: string;
  rem_tipoFondo: string;
  rem_caja?: string;
  rem_responsableCaja?: string;
  rem_responsable: string;
  rem_fecha: string;
  rem_tipoMovimiento: string;
  rem_categoria: string;
  rem_descripcion?: string;
  rem_montoAsignado: number;
  rem_moneda: string;
  rem_nComprobante?: string;
  rem_archivoAdjunto?: string;
  rem_observaciones?: string;
  rem_motivoCierre?: string;
  rem_asientoContable: string;
  rem_estado: 'Aprobado' | 'Repuesto' | 'Pendiente' | 'Rechazado' | 'Cerrado';
}
