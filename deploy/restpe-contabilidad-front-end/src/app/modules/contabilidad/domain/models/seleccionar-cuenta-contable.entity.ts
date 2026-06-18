/**
 * CuentaContableItem — Entidad de dominio.
 * Representa una cuenta del plan contable disponible para selección en asientos manuales.
 */
export interface CuentaContableItem {
  cuenta_contable_codigo: string;
  cuenta_contable_descripcion: string;
  cuenta_contable_nivel: number;
  cuenta_contable_tipo: string;
  cuenta_contable_r_tercero: string;
}

/**
 * SeleccionarCuentaContableEntity — Entidad raíz del agregado.
 * Contiene el catálogo de cuentas contables disponibles para el buscador.
 */
export interface SeleccionarCuentaContableEntity {
  items: CuentaContableItem[];
}
