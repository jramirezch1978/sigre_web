/**
 * Entidad TipoDeCambio — Domain Layer
 * Representa un registro de tipo de cambio diario publicado por la entidad tributaria.
 */
export interface TipoDeCambioEntity {
  /** Id del backend (core.tipo_cambio). Ausente al crear; requerido para actualizar. */
  id?: number;
  /** Fecha en que se registró el tipo de cambio (DD/MM/YYYY) */
  tipo_cambio_fecha_registro: string;
  /** Fecha desde la que entra en vigencia (DD/MM/YYYY) */
  tipo_cambio_fecha_vigencia: string;
  /** Moneda de referencia: "Dólar" | "Euro" */
  tipo_cambio_moneda: string;
  /** Tipo de cambio de compra (hasta 5 decimales) */
  tipo_cambio_tc_compra: number;
  /** Tipo de cambio de venta (hasta 5 decimales) */
  tipo_cambio_tc_venta: number;
  /** Estado del registro: "Activo" | "Inactivo" */
  tipo_cambio_estado: string;
}
