/**
 * RegistroUitEntity — Capa de Dominio.
 * Representa el Valor de la Unidad Impositiva Tributaria (UIT) por año fiscal.
 * Campos derivados de los colDefs del componente c-t-registro-uit.
 */
export interface RegistroUitEntity {
  /** Año fiscal (ej. '2025') */
  registro_uit_anio_fiscal: string;
  /** Valor monetario de la UIT para el año fiscal */
  registro_uit_valor_uit: number;
  /** Fecha de inicio de vigencia (ISO 8601: 'YYYY-MM-DD') */
  registro_uit_fecha_inicio: string;
  /** Fecha de fin de vigencia (ISO 8601: 'YYYY-MM-DD') */
  registro_uit_fecha_fin: string;
  /** Estado del registro: 'Vigente' | 'Histórico' */
  registro_uit_estado: string;
}
