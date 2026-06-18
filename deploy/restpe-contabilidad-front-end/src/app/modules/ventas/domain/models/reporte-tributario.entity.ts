export interface ReporteTributarioDetalleEntity {
  trib_org_hierarchy: string[];
  trib_sucursal?: string;
  trib_es_sucursal?: boolean;
  trib_comprobantes_count?: number;
  trib_tipo?: string;
  trib_serie?: string;
  trib_fecha?: string;
  trib_ruc?: string;
  trib_cliente?: string;
  trib_impuesto?: string;
  trib_base_imponible?: number;
  trib_debito_fiscal?: number;
  trib_total?: number;
}

export interface ReporteTributarioConsolidadoEntity {
  trib_sucursal: string;
  trib_tipo_impuesto: string;
  trib_base_imponible: number;
  trib_tasa_porcentaje: number;
  trib_debito_fiscal: number;
  trib_creditos_fiscales: number;
  trib_impuesto_neto_pagar: number;
}
