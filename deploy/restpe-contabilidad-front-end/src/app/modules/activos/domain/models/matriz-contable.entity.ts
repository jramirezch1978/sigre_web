/**
 * Entidad de dominio: Matriz Contable de Activos Fijos.
 * Representa el mapeo entre una subclase de activo y sus cuentas contables.
 * Convención de nombres: tabla_campo (snake_case).
 */
export interface MatrizContableEntity {
  id?: number;
  matriz_contable_codigo: string; // Código subclase (SCL001...)
  matriz_contable_nombre: string; // Nombre de la subclase
  matriz_contable_cta_activo: string; // Cuenta activo fijo
  matriz_contable_cta_depreciacion: string; // Cuenta depreciación acumulada
  matriz_contable_cta_gasto: string; // Cuenta gasto depreciación
  matriz_contable_centro_costo: string; // Centro de costo
  matriz_contable_venta?: string; // Cta. ganancia por venta
  matriz_contable_acumulado?: string; // Cta. pérdida por venta
  matriz_contable_fecha_vigencia?: string; // Fecha de vigencia
  matriz_contable_estado: string; // Activo | Inactivo
  matriz_contable_observaciones?: string;
  matriz_contable_grupo_id?: number; // ID del grupo matriz contable
  matriz_contable_created_by?: number;
  matriz_contable_fecha_creacion?: string;
  matriz_contable_updated_by?: number;
  matriz_contable_fec_modificacion?: string;
  matriz_contable_descripcion?: string;
  matriz_contable_detalles?: MatrizContableDetalleEntity[];
}

export interface MatrizContableDetalleEntity {
  id: number;
  matrizContableId: number;
  secuencia: number;
  planContableDetId: number;
  flagDebHab: string;
  referenciaCampo: string;
  campo: string;
  formula: string;
  glosaTexto: string;
  glosaCampo: string;
  flagCencos: string;
  flagCtabco: string;
  flagDocref: string;
  createdBy: number;
  fecCreacion: string;
  updatedBy: number;
  fecModificacion: string;
}
