/**
 * Entidad de Clasificación de Activos Fijos.
 * Representa una clase o subclase del árbol jerárquico de activos.
 * El campo `orgHierarchy` es requerido por AG-Grid Tree Data.
 */
export interface ClasifActivoEntity {
  id?: string;
  clasif_activo_codigo: string;
  clasif_activo_nombre: string;
  clasif_activo_cnt_contable: string;
  clasif_activo_met_depreciacion: string;
  clasif_activo_tsa_anual: string;
  clasif_activo_vida_util: string;
  clasif_activo_descripcion?: string;
  clasif_activo_observaciones?: string;
  clasif_activo_estado: string;
  /** Requerido por AG-Grid Tree Data: define la jerarquía padre-hijo */
  orgHierarchy?: string[];
}
