/**
 * Entidad CuentaVsSubcategoria — Domain Layer
 * Representa la relación entre una subcategoría de artículos y su cuenta contable.
 */
export interface CuentaVsSubcategoriaEntity {
  /** Código único de la relación (ej. SUB-001) */
  cuenta_sub_codigo: string;
  /** Nombre de la subcategoría */
  cuenta_sub_subcategoria: string;
  /** Categoría padre a la que pertenece la subcategoría */
  cuenta_sub_categoria: string;
  /** Tipo de cuenta: "Gasto / Compra" | "Ingreso / Venta" */
  cuenta_sub_tipo_c?: string;
  /** Cuenta contable principal asociada */
  cuenta_sub_cuenta_c?: string;
  /** Cuenta de egreso / gasto */
  cuenta_sub_cuenta_e?: string;
  /** Cuenta de ingreso / venta */
  cuenta_sub_cuenta_i?: string;
  /** Regla de asignación contable */
  cuenta_sub_regla?: string;
  /** Rubro del negocio */
  cuenta_sub_rubro?: string;
  /** Fecha de creación (ISO string YYYY-MM-DD) */
  cuenta_sub_fecha_c?: string;
  /** Fecha de última modificación (ISO string YYYY-MM-DD) */
  cuenta_sub_fecha_m?: string;
  /** Estado de la vinculación: "Vinculado" | "Por vincular" */
  cuenta_sub_estado: string;
}
