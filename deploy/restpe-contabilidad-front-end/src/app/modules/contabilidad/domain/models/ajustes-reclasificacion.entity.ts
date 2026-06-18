/**
 * CuentaMovimientoAjusteItem — Entidad de dominio.
 * Representa una línea contable (cuenta) dentro de un asiento de ajuste/reclasificación.
 */
export interface CuentaMovimientoAjusteItem {
  cuenta_mov_ajuste_cuenta: string;
  cuenta_mov_ajuste_descripcion: string;
  cuenta_mov_ajuste_debe_soles: number;
  cuenta_mov_ajuste_haber_soles: number;
  cuenta_mov_ajuste_debe_dolares: number;
  cuenta_mov_ajuste_haber_dolares: number;
  cuenta_mov_ajuste_centro_costo: string;
  cuenta_mov_ajuste_doc_referencial: string;
}

/**
 * AjusteReclasificacionItem — Entidad de dominio.
 * Representa un asiento de ajuste/reclasificación con sus cuentas de movimiento.
 */
export interface AjusteReclasificacionItem {
  ajuste_rec_numero_asiento: string;
  ajuste_rec_fecha_registro: string;
  ajuste_rec_fecha_contable: string;
  ajuste_rec_origen: string;
  ajuste_rec_glosa: string;
  ajuste_rec_situacion_contable: string;
  ajuste_rec_usuario_ejecutor?: string;
  ajuste_rec_total: number;
  ajuste_rec_moneda: string;
  ajuste_rec_estado: string;
  ajuste_rec_cuentas?: CuentaMovimientoAjusteItem[];
}

/**
 * AjustesReclasificacionEntity — Entidad raíz del agregado.
 * Contiene la lista de asientos de ajuste/reclasificación registrados.
 */
export interface AjustesReclasificacionEntity {
  items: AjusteReclasificacionItem[];
}
