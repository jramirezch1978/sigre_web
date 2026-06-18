export interface PanelReenvioDetalle {
  det_cantidad: number;
  det_solicitado: string;
  det_categoria: string;
  det_producto: string;
  det_descuento: number;
  det_pu: number;
  det_total: number;
}

export interface PanelReenvioEntity {
  panel_reenvio_fecha: string;
  panel_reenvio_documento: string;
  panel_reenvio_nro_documento: string;
  panel_reenvio_total: number;
  panel_reenvio_estado: string;
  panel_reenvio_cliente: string;
  panel_reenvio_direccion: string;
  panel_reenvio_tipo: string;
  detalles: PanelReenvioDetalle[];
}
