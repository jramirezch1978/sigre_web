/**
 * @summary Representa una retención fiscal
 * @description
 * Entidad de dominio que modela una retención con sus porcentajes,
 * cuentas contables y aplicabilidad en diferentes operaciones.
 */
export interface RetencionEntity {
  /** @summary Código único de la retención (ej: R001, R002) */
  retencion_codigo: string;

  /** @summary Descripción detallada de la retención */
  retencion_descripcion: string;

  /** @summary Porcentaje fijo de retención (null si es variable) */
  retencion_porcentaje: string | null;

  /** @summary Tipo de porcentaje: 'Fijo' o 'Variable' */
  retencion_tipo_porcentaje: 'Fijo' | 'Variable';

  /** @summary Porcentaje mínimo (solo para tipo Variable) */
  retencion_porcentaje_minimo: string | null;

  /** @summary Porcentaje máximo (solo para tipo Variable) */
  retencion_porcentaje_maximo: string | null;

  /** @summary Cuenta contable de cargo */
  retencion_cuenta_cargo: string;

  /** @summary Cuenta contable de abono */
  retencion_cuenta_abono: string;

  /** @summary Procesos donde aplica la retención (ej: 'Compras, Pagos') */
  retencion_aplicable: string;

  /** @summary Estado de la retención: 'Activo' o 'Inactivo' */
  retencion_estado: 'Activo' | 'Inactivo';
}
