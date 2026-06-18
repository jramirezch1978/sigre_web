export interface CatalogoItemEntity {
  catalogo_item_id: string;
  catalogo_item_nombre: string;
}

export interface CatalogosEntity {
  catalogos_tipos_documento: CatalogoItemEntity[];
  catalogos_estados_operacion: CatalogoItemEntity[];
  catalogos_tipos_despacho: CatalogoItemEntity[];
  catalogos_estados_producto: CatalogoItemEntity[];
  catalogos_unidades_medida: CatalogoItemEntity[];
  catalogos_tipos_movimiento: CatalogoItemEntity[];
}

export interface TransferenciaEntity {
  transferencia_nro: string;
  transferencia_fecha_envio: string;
  transferencia_fecha_recepcion: string;
  transferencia_cantidad_enviada: number;
  transferencia_cantidad_recibida: number;
  transferencia_diferencia: number;
  transferencia_origen: string;
  transferencia_destino: string;
  transferencia_estado: string;
}

export interface ComparacionInventarioEntity {
  comparacion_inventario_codigo: string;
  comparacion_inventario_fecha_creacion: string;
  comparacion_inventario_producto: string;
  comparacion_inventario_almacen: string;
  comparacion_inventario_responsable: string;
  comparacion_inventario_observaciones: string;
  comparacion_inventario_estado: string;
  comparacion_inventario_observacion: string;
}
