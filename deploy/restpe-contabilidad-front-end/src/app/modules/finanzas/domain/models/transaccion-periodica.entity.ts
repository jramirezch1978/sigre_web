export interface TransaccionPeriodicaEntity {
  transaccion_tipo_doc_proveedor: string;
  transaccion_codigo_programacion: string;
  transaccion_doc_fiscal: string;
  transaccion_proveedor: string;
  transaccion_tipo_gasto: string;
  transaccion_periodicidad: string;
  transaccion_dia_mes: number;
  transaccion_tipo_monto: string;
  transaccion_monto: number;
  transaccion_monto_min: number;
  transaccion_monto_max: number;
  transaccion_moneda: string;
  transaccion_cuenta_contable: string;
  transaccion_centro_costo: string;
  transaccion_sucursal: string;
  transaccion_estado: string;
  transaccion_fecha_emision: string;
  transaccion_fecha_vencimiento: string;
  transaccion_aprobacion: string;
}
