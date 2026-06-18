/**
 * ConsultaCentroCostosItem — Entidad de dominio.
 * Representa un movimiento de centro de costos por trabajador.
 */
export interface ConsultaCentroCostosItem {
  cc_trab_cod_ceco: string;
  cc_trab_descripcion: string;
  cc_trab_cod_trabajador: string;
  cc_trab_nombre: string;
  cc_trab_usuario_registro: string;
  cc_trab_area_departamento: string;
  cc_trab_cuenta_contable: string;
  cc_trab_glosa_contable: string;
  cc_trab_fecha_contable: string;
  cc_trab_doc_origen: string;
  cc_trab_moneda_s: number;
  cc_trab_moneda_d: number;
}

/**
 * ConsultaCentroCostosEntity — Agregado raíz.
 * Encapsula la colección de movimientos por centro de costos y trabajador.
 */
export interface ConsultaCentroCostosEntity {
  items: ConsultaCentroCostosItem[];
}
