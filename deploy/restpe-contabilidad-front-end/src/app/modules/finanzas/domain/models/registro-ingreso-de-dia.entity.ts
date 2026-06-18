export interface RegistroIngresoDeDiaEntity {
  rid_caja: string;
  rid_fecha: string;
  rid_medioPago: string;
  rid_montoTotal: string;
  rid_nComprobantes: string;
  rid_cuentaIngreso: string;
  rid_asientoContable: string;
  rid_observaciones: string;
  rid_estado: 'Procesado' | 'Conciliado';
  rid_showEye: boolean;
  rid_acciones: string;
}