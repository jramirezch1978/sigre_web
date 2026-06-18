/**
 * CuentaCorrienteItem — Entidad de dominio.
 * Representa una línea de movimiento en el análisis de cuentas corriente.
 */
export interface CuentaCorrienteItem {
  cta_cte_razon_social: string;
  cta_cte_cuenta_contable: string;
  cta_cte_nro_asiento: string;
  cta_cte_doc_referencial: string;
  cta_cte_fecha_asiento: string;
  cta_cte_glosa: string;
  cta_cte_debito: number;
  cta_cte_credito: number;
  cta_cte_saldo: number;
  cta_cte_antiguedad: string;
  cta_cte_moneda: string;
}

/**
 * CuentasCorrienteEntity — Agregado raíz.
 * Encapsula la colección de movimientos de cuentas corriente.
 */
export interface CuentasCorrienteEntity {
  items: CuentaCorrienteItem[];
}
