/**
 * LibrosAsientosEntity — Entidades del dominio para el reporte de Libros y Asientos.
 * Cada tipo de reporte tiene su propia entidad independiente.
 * Cumple con el principio de responsabilidad única (SRP).
 */

/** Fila de Libro Mayor */
export interface LibroMayorItem {
  codigoC:     string;
  descripcionC: string;
  fechaC:      string;
  nasiento:    string;
  glosa:       string;
  saldoInicial: number | null;
  centroC:     string;
  debito:      number;
  credito:     number;
  saldo:       number;
  moneda:      string;
  usuario:     string;
}

/** Entidad de Libro Mayor */
export type LibroMayorEntity = LibroMayorItem[];

/** Fila de Libro Diario */
export interface LibroDiarioItem {
  fechaC:      string;
  nlibro:      string;
  nasiento:    string;
  glosa:       string;
  codigoC:     string;
  descripcionC: string;
  centroC:     string;
  debito:      number;
  credito:     number;
  usuario:     string;
  estado:      string;
}

/** Entidad de Libro Diario */
export type LibroDiarioEntity = LibroDiarioItem[];

/** Fila de Balance de Comprobación */
export interface BalanceComprobItem {
  codigo:              string;
  denominacion:        string;
  movDebe:             number | null;
  movHaber:            number | null;
  saldoDeudor:         number | null;
  saldoAcreedor:       number | null;
  inventarioActivo:    number | null;
  inventarioPasivo:    number | null;
  eePerdidas:          number | null;
  eeGanancias:         number | null;
  transfCargo:         number | null;
  transfAbono:         number | null;
  saldo2Deudor:        number | null;
  saldo2Acreedor:      number | null;
  eeNaturalPerdidas:   number | null;
  eeNaturalGanancias:  number | null;
}

/** Entidad de Balance de Comprobación */
export type BalanceComprobEntity = BalanceComprobItem[];

/** Entidad raíz que agrupa los tres datasets (se mantiene para compatibilidad) */
export interface LibrosAsientosEntity {
  libroMayor:         LibroMayorItem[];
  libroDiario:        LibroDiarioItem[];
  balanceComprobacion: BalanceComprobItem[];
}
