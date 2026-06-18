export interface ReporteVentasFechaHT {
  rventas_fecha: string;
  rventas_hora: string;
  rventas_turno: string;
}

export interface ReporteVentasEntity {
  rventas_fecha_ht: ReporteVentasFechaHT;
  rventas_mesa: string;
  rventas_caja: string;
  rventas_cliente: string;
  rventas_documento: string;
  rventas_numero_documento: string;
  rventas_pagos: string;
  rventas_propina: string;
  rventas_tipo: string;
  rventas_canal: string;
  rventas_estado: string;
}
