/**
 * ReporteValidacionEntity — Entidades del dominio para el Reporte de Validación.
 * Cumple con el principio de responsabilidad única (SRP).
 */

/** Ítem de Consistencia de Asientos Contables y Asientos Descuadrados */
export interface ConsistenciaAsientoItem {
  origen: string;
  fechaRegistro: string;
  fechaContable: string;
  nlibro: string;
  nasiento: string;
  glosa: string;
  codcuenta: string;
  desccuenta: string;
  totalD: string;
  totalC: string;
  diferencia: string;
  moneda: string;
  centrodecostos: string;
  estado: string;
}

/** Ítem de Consistencia de Pre-Asientos Contables */
export interface ConsistenciaPreAsientoItem {
  origen: string;
  periodoC: string;
  npasiento: string;
  glosa: string;
  totalD: string;
  totalC: string;
  diferencia: string;
  fecha: string;
  estado: string;
  observacion: string;
}

/** Type aliases para cada conjunto del reporte */
export type ConsistenciaEntity = ConsistenciaAsientoItem[];
export type ConsistenciaPreEntity = ConsistenciaPreAsientoItem[];
export type AsientosDesEntity = ConsistenciaAsientoItem[];

/** Entidad compuesta que agrupa los tres conjuntos del reporte */
export interface ReporteValidacionEntity {
  consistencia: ConsistenciaAsientoItem[];
  consistenciaPre: ConsistenciaPreAsientoItem[];
  asientosDes: ConsistenciaAsientoItem[];
}
