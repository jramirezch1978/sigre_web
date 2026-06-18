export interface PanelDocumentoInformacionFe {
  enlace: string;
  fecha_emision: string;
  fecha_aceptacion: string;
}

export interface PanelDocumentoDataProveedor {
  documento: string;
  estados: string[];
}

export interface PanelDocumentoEntity {
  panel_estado_doc_fecha: string;
  panel_estado_doc_cliente: string;
  panel_estado_doc_documento: string;
  panel_estado_doc_nro_documento: string;
  panel_estado_doc_total: number;
  panel_estado_doc_estado: string;
  panel_estado_doc_data_proveedor: PanelDocumentoDataProveedor;
  panel_estado_doc_informacion_fe: PanelDocumentoInformacionFe;
  panel_estado_doc_mensaje: string;
}
