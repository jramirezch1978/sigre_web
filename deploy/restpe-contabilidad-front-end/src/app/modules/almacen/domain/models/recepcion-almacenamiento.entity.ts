export interface RecepcionAlmacenamientoEntity {
  codigoRecepcion: string;
  fechaRecepcion: string;
  ordenCompra: string;
  recepcion_almacenamiento_proveedor: string;
  cantidadSolicitada: number;
  cantidadEntregada: number;
  diferencia: number;
  almacenDestino: string;
  nroFactura: string;
  nroGuia: string;
  usuario: string;
  recepcion_almacenamiento_estado: string;
  moneda: string;
}
