export interface RelacionDocProveedorEntity {
  rdoc_org_hierarchy: string[];
  rdoc_tipo_doc: string;
  rdoc_nro_doc: string;
  rdoc_cantidad_doc?: number;
  rdoc_fecha_emision: string;
  rdoc_fecha_vencimiento: string;
  rdoc_moneda: string;
  rdoc_monto_total: number;
  rdoc_monto_pagado: number;
  rdoc_monto_pendiente: number;
  rdoc_nro_asiento: string;
  rdoc_sucursal: string;
  rdoc_centro_costo: string;
  rdoc_usuario: string;
  rdoc_estado: string;
  rdoc_is_tipo?: boolean;
  rdoc_is_proveedor?: boolean;
}

/** Estructura del JSON: objeto indexado por ID de proveedor (string) */
export type RelacionDocProveedorMap = { [id: string]: RelacionDocProveedorEntity[] };
