export type TipoComprobante =
  | 'FACTURA'
  | 'BOLETA'
  | 'NOTA_CREDITO'
  | 'NOTA_DEBITO'
  | 'GUIA_REMISION';

export type EstadoSunat = 'PENDIENTE' | 'ACEPTADA' | 'RECHAZADA' | 'ANULADA';

export interface Comprobante {
  id: number;
  tipo: TipoComprobante;
  serie: string;
  correlativo: string;
  clienteRuc: string;
  clienteNombre: string;
  fechaEmision: string;
  fechaVencimiento: string;
  moneda: string;
  subtotal: number;
  igv: number;
  total: number;
  estadoSunat: EstadoSunat;
  hashCpe?: string;
  xmlUrl?: string;
  pdfUrl?: string;
}

export interface ComprobanteFilter {
  tipo?: TipoComprobante;
  estadoSunat?: EstadoSunat;
  fechaDesde?: string;
  fechaHasta?: string;
  page: number;
  size: number;
}
