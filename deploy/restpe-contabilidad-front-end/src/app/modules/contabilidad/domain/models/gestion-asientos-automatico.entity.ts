/**
 * CuentaMovimientoAutomaticoItem — Entidad de dominio.
 * Representa una línea contable (cuenta) dentro de un asiento automático.
 */
export interface CuentaMovimientoAutomaticoItem {
  cuenta_mov_auto_cuenta: string;
  cuenta_mov_auto_descripcion: string;
  cuenta_mov_auto_debe_soles: number;
  cuenta_mov_auto_haber_soles: number;
  cuenta_mov_auto_debe_dolares: number;
  cuenta_mov_auto_haber_dolares: number;
  cuenta_mov_auto_centro_costo: string;
  cuenta_mov_auto_doc_referencial: string;
}

/**
 * AsientoAutomaticoItem — Entidad de dominio.
 * Representa un asiento contable automático con sus cuentas de movimiento.
 */
export interface AsientoAutomaticoItem {
  asiento_auto_numero_asiento: string;
  asiento_auto_fecha_registro: string;
  asiento_auto_fecha_contable: string;
  asiento_auto_glosa: string;
  asiento_auto_situacion_contable: string;
  asiento_auto_total: number;
  asiento_auto_estado: string;
  asiento_auto_libro: string;
  asiento_auto_moneda: string;
  asiento_auto_origen: string;
  asiento_auto_usuario: string;
  asiento_auto_tasa_cambio: string;
  asiento_auto_cuentas?: CuentaMovimientoAutomaticoItem[];
}

/**
 * GestionAsientosAutomaticoEntity — Entidad raíz del agregado.
 * Contiene la lista de asientos automáticos registrados.
 */
export interface GestionAsientosAutomaticoEntity {
  items: AsientoAutomaticoItem[];
}
