/**
 * ReporteFinancieroRow — Entidad de dominio para filas de reporte financiero jerárquico.
 * Corresponde a la interfaz IBalanceRow del componente.
 */
export interface ReporteFinancieroRow {
  orgHierarchy: string[];
  codigo: string;
  descripcion: string;
  saldoActual?: number;
  saldoComparativo?: number;
  variacion?: number;
  variacionPct?: number;
  moneda?: string;
  isTotal?: boolean;
  isMainCategory?: boolean;
  isSubCategory?: boolean;
}

/**
 * PatrimonioRow — Entidad de dominio para filas del estado de cambios en patrimonio.
 */
export interface PatrimonioRow {
  concepto: string;
  capital: number | null;
  reservas: number | null;
  resultados: number | null;
  ajustes: number | null;
  variacion: number | null;
}

/** Envoltura del JSON para reportes de balance / flujos */
export interface ReporteFinancieroEntity {
  items: ReporteFinancieroRow[];
}

/** Envoltura del JSON para el estado de cambios en patrimonio */
export interface PatrimonioEntity {
  items: PatrimonioRow[];
}

/** Agrupación de los 4 datasets del reporte financiero */
export interface ReporteFinancieroCompleto {
  situacionFinanciera: ReporteFinancieroEntity;
  estadoResultados: ReporteFinancieroEntity;
  flujoEfectivo: ReporteFinancieroEntity;
  cambiosPatrimonio: PatrimonioEntity;
}
