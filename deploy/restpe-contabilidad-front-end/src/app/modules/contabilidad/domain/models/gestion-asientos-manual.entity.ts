/**
 * CuentaMovimientoItem — Entidad de dominio.
 * Representa una línea contable (cuenta) dentro de un asiento manual.
 */
export interface CuentaMovimientoItem {
  cuenta_mov_cuenta: string;
  cuenta_mov_descripcion: string;
  cuenta_mov_debe_soles: number;
  cuenta_mov_haber_soles: number;
  cuenta_mov_debe_dolares: number;
  cuenta_mov_haber_dolares: number;
  cuenta_mov_centro_costo: string;
  cuenta_mov_doc_referencial: string;
}

/**
 * AsientoManualItem — Entidad de dominio.
 * Representa un asiento contable manual con sus cuentas de movimiento.
 */
export interface AsientoManualItem {
  asiento_manual_numero_asiento: string;
  asiento_manual_fecha_registro: string;
  asiento_manual_fecha_contable: string;
  asiento_manual_glosa: string;
  asiento_manual_situacion_contable: string;
  asiento_manual_total: number;
  asiento_manual_estado: string;
  asiento_manual_libro: string;
  asiento_manual_moneda: string;
  asiento_manual_origen: string;
  asiento_manual_usuario: string;
  asiento_manual_tasa_cambio: string;
  asiento_manual_cuentas?: CuentaMovimientoItem[];
}

/**
 * GestionAsientosManualesEntity — Entidad raíz del agregado.
 * Contiene la lista de asientos manuales registrados.
 */
export interface GestionAsientosManualesEntity {
  items: AsientoManualItem[];
}
