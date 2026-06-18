export interface LetraCambioEntity {
  letra_codigo: string;
  letra_tipo_doc_cliente: string;
  letra_nro_doc_cliente: string;
  letra_doc_cliente: string;
  letra_cliente: string;
  letra_sucursal: string;
  letra_fecha_emision: string;
  letra_fecha_vencimiento: string;
  letra_cuotas: number;
  letra_monto_total: number;
  letra_moneda: string;
  letra_tasa_interes: string;
  letra_tipo_cambio: string;
  letra_banco_emisor: string;
  letra_cuenta_banco: string;
  letra_asiento: string;
  letra_estado: string;
}
