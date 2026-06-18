export interface CarterasCobrosEntity {
  cc_serieNum: string;
  cc_cliente: string;
  cc_tipoDoc: string;
  cc_fechaEmision: string;
  cc_fechaVenc: string;
  cc_dias: string;
  cc_sucursal: string;
  cc_montoTotal: number;
  cc_montoCobrado: number;
  cc_montoPendiente: number;
  cc_estado: string;
  cc_moneda?: string;
  cc_mediodeCobro?: string;
  cc_fechadeCobro?: string;
  cc_fechadeCobroParcial?: string;
  cc_saldoPendiente?: number;
  cc_observacion?: string;
  cc_asientoContable?: string;
}
