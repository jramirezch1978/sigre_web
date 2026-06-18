export interface ReporteFinanzasEntity {
  rf_fechaRegistro: string;
  rf_sucursal: string;
  rf_cliProveedor: string;
  rf_nombre: string;
  rf_documentofiscal: string;
  rf_origenDoc: string;
  rf_tipoComp: string;
  rf_nucDoc: string;
  rf_desConcepto: string;
  rf_moneda: string;
  rf_tipoCambio: number;
  rf_montoT: number;
  rf_cuentaC: string;
  rf_numeroA: string;
  rf_estado: 'Activo' | 'Pendiente' | 'Anulado';
}
