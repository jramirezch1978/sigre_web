export interface AnulacionPagosEntity {
  arp_proveedor: string;
  arp_tipoDoc: string;
  arp_serieNumDoc: string;
  arp_fechaPago: string;
  arp_moneda: string;
  arp_sucursal: string;
  arp_montoPagado: number;
  arp_medioPago: string;
  arp_accionRealizada: string;
  arp_estado: string;
  arp_numeroAsiento?: string;
  arp_justificacion: string;
}

