export interface RelacionDocClienteEntity {
  rcli_org_hierarchy: string[];
  rcli_tipo_doc: string;
  rcli_nro_doc: string;
  rcli_cantidad_doc?: number;
  rcli_fecha_emision: string;
  rcli_fecha_vencimiento: string;
  rcli_moneda: string;
  rcli_monto_total: number;
  rcli_monto_pagado: number;
  rcli_monto_pendiente: number;
  rcli_nro_asiento: string;
  rcli_sucursal: string;
  rcli_centro_costo: string;
  rcli_usuario: string;
  rcli_estado: string;
  rcli_is_tipo?: boolean;
  rcli_is_cliente?: boolean;
}

/** Estructura del JSON: objeto indexado por ID de cliente (string) */
export type RelacionDocClienteMap = { [id: string]: RelacionDocClienteEntity[] };
