/**
 * AnalisisCuentaContableEntity — Entidades del dominio para el Análisis de Cuenta Contable.
 * Cumple con el principio de responsabilidad única (SRP).
 */

/** Línea de detalle de un asiento (sub-tabla del modal) */
export interface DetalleAsientoItem {
  ana_cta_det_cta_contable: string;
  ana_cta_det_descripcion: string;
  ana_cta_det_debe: string;
  ana_cta_det_haber: string;
}

/** Fila de análisis de cuenta contable */
export interface AnalisisCuentaContableItem {
  ana_cta_fregistro: string;
  ana_cta_periodo: string;
  ana_cta_cta_contable: string;
  ana_cta_doc_relacionado: string;
  ana_cta_nro_asiento: string;
  ana_cta_glosa: string;
  ana_cta_moneda: string;
  ana_cta_debe: number | string;
  ana_cta_haber: number | string;
  ana_cta_saldo: number;
  ana_cta_sucursal: string;
  ana_cta_centro_costo: string;
  ana_cta_estado: string;
  // Campos adicionales para el modal de detalle
  ana_cta_fecha_registro: string;
  ana_cta_fecha_contable: string;
  ana_cta_total: string;
  ana_cta_duplicado: string;
  ana_cta_detalles: DetalleAsientoItem[];
}

/** Entidad raíz del reporte */
export interface AnalisisCuentaContableEntity {
  items: AnalisisCuentaContableItem[];
}
