export interface RecepcionTransferenciaEntity {
  nroTransferencia: string;
  fechaEnvio: string;
  fechaRecepcion: string;
  cantidadEnviada: number;
  cantidadRecibida: number;
  diferencia: number;
  origen: string;
  destino: string;
  recepcion_transferencia_estado: string;
}
