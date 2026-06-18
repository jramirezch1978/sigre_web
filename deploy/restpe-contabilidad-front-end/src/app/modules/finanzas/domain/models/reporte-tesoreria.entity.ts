export interface ReporteTesoreriaEntity {
  rt_fechaMov: string;
  rt_tipoM: string;
  rt_comprobante: string;
  rt_entidadF: string;
  rt_ncuenta: string;
  rt_descripcionM: string;
  rt_moneda: string;
  rt_montoT: number;
  rt_observaciones: string;
  rt_cuentaC: string;
  rt_numeroA: string;
  rt_estado: 'Conciliado' | 'No conciliado' | 'Anulado';
  rt_sucursal: string;
  rt_tipoCambio: string;
}
