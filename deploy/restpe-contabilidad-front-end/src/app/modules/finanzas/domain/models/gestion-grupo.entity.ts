export interface GestionGrupoConceptoDetalle {
  codigo: string;
  descripcion: string;
  tipo: string;
  categoria: string;
  naturalezaC: string;
  cuentaC: string;
  origen: string;
  destino: string;
  estado: string;
}

export interface GestionGrupoEntity {
  /** Id real del backend (finanzas.grupo_codigo_flujo_caja). Necesario para PUT/PATCH. */
  grupo_id?: number;
  grupo_codigo: string;
  grupo_descripcion: string;
  // Campos reales del backend (grupo_codigo_flujo_caja).
  grupo_orden?: number;
  grupo_factor?: string;
  grupo_flag_reporte?: string;
  grupo_cod_actividad?: string;
  grupo_tipo_flujo: string;
  grupo_naturaleza_contable: string;
  grupo_conceptos: string;
  grupo_estado: string;
  grupo_nivel?: string;
  grupo_org_hierarchy?: string[];
  grupo_fecha_creacion?: Date | string;
  grupo_detalle?: GestionGrupoConceptoDetalle[];
}
