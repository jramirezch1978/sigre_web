/**
 * TablaContabilidadItem — Entidad de dominio.
 * Representa un ítem del árbol de tipos de documento contable.
 * Estructura jerárquica usada en la grilla de filtro (panel lateral izquierdo).
 */
export interface TablaContabilidadItemDetalle {
  cuentaC: string;
  tipo: string;
  formula: string;
  glosaCampo: string;
  glosaT: string;
  documentoR: string;
  replicacion: string;
}

export interface TablaContabilidadItem {
  t_contabilidad_codigo: string;
  t_contabilidad_descripcion: string;
  t_contabilidad_estado: string;
  t_contabilidad_org_hierarchy?: string[];
  t_contabilidad_items?: TablaContabilidadItemDetalle[];
}

/**
 * TablasContabilidadEntity — Entidad raíz del agregado.
 * Contiene el catálogo de tipos de documento contable para la tabla de contabilidad.
 */
export interface TablasContabilidadEntity {
  items: TablaContabilidadItem[];
}
