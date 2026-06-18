/**
 * ClonacionAsientoDetalleItem — Entidad de dominio.
 * Representa una línea de cuenta del asiento a clonar.
 */
export interface ClonacionAsientoDetalleItem {
  cuenta: string;
  descripcion: string;
  debe: string;
  haber: string;
}

/**
 * ClonacionAsientoItem — Entidad de dominio.
 * Representa un asiento contable disponible para el proceso de clonación.
 */
export interface ClonacionAsientoItem {
  nasiento: string;
  fechaR: string;
  fechaC: string;
  glosa: string;
  situacionC: string;
  total: string;
  estado: string;
  usuario: string;
  origen: string;
  tipoFlujo: string;
  moneda: string;
  tasaC: string;
  cuentas?: ClonacionAsientoDetalleItem[];
}

/**
 * ClonacionAsientosEntity — Entidad raíz del agregado.
 * Contiene la lista de asientos disponibles para el proceso de clonación.
 */
export interface ClonacionAsientosEntity {
  items: ClonacionAsientoItem[];
}
