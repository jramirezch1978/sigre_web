export interface ReqTrasladoArticuloEntity {
  req_traslado_art_codigo: string;
  req_traslado_art_descripcion: string;
  req_traslado_art_unidad_medida: string;
  req_traslado_art_stock_disponible: number;
  req_traslado_art_cantidad_solicitada: number;
}

export interface ReqTrasladoEntity {
  req_traslado_id: string;
  req_traslado_nro: string;
  req_traslado_fecha_registro: string;
  req_traslado_origen: string;
  req_traslado_destino: string;
  req_traslado_prioridad: string;
  req_traslado_centro_costo: string;
  req_traslado_motivo: string;
  req_traslado_estado: string;
  req_traslado_observaciones?: string;
  req_traslado_articulos?: ReqTrasladoArticuloEntity[];
}
