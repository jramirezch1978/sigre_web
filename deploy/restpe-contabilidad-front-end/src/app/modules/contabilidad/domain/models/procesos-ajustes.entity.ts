/**
 * ProcesosAjusteDetalleItem — Entidad de dominio.
 * Representa una línea contable (cuenta de movimiento) dentro de un asiento de proceso de ajuste.
 * Los campos cuenta/descripción corresponden al catálogo de cuentas contables.
 */
export interface ProcesosAjusteDetalleItem {
  proc_ajuste_det_cuenta: string;
  proc_ajuste_det_descripcion: string;
  proc_ajuste_det_debe: string;
  proc_ajuste_det_haber: string;
  proc_ajuste_det_centrocostos: string;
}

/**
 * ProcesosAjusteItem — Entidad de dominio.
 * Representa un asiento de proceso de ajuste contable con sus líneas de detalle embebidas.
 */
export interface ProcesosAjusteItem {
  proc_ajuste_nasiento: string;
  proc_ajuste_fecha_registro: string;
  proc_ajuste_fecha_contable: string;
  proc_ajuste_glosa: string;
  proc_ajuste_situacion_c: string;
  proc_ajuste_total: string;
  proc_ajuste_estado: string;
  proc_ajuste_usuario: string;
  proc_ajuste_origen: string;
  proc_ajuste_tipo_flujo: string;
  proc_ajuste_moneda: string;
  proc_ajuste_tasa_c: string;
  proc_ajuste_detalle?: ProcesosAjusteDetalleItem[];
}

/**
 * ProcesosAjustesEntity — Entidad raíz del agregado.
 * Contiene la lista de asientos de procesos de ajuste generados en el período.
 */
export interface ProcesosAjustesEntity {
  items: ProcesosAjusteItem[];
}
