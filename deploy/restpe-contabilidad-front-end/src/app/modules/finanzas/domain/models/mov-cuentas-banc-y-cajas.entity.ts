export interface MovCuentasBancYCajasEntity {
  mcb_codigo: string;
  mcb_fechaRegistro: string;
  mcb_fechaTransferencia: string;
  mcb_tipoMovimiento: string;
  mcb_cuentaOrigen: string;
  mcb_cuentaDestino: string;
  mcb_tipoCambio: number;
  mcb_montoTransferido: number;
  mcb_medioTransferencia: string;
  mcb_archivoAdjunto?: string;
  mcb_estado: 'Pendiente' | 'Confirmado' | 'Anulado';
  mcb_numeroAsiento?: string;
  mcb_observaciones: string;
}

