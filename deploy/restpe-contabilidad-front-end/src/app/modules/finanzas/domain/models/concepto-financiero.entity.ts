export interface ConceptoFinancieroEntity {
  /** Id real del backend (finanzas.concepto_financiero). Necesario para PUT/DELETE/PATCH. */
  concepto_id?: number;
  concepto_codigo: string;
  concepto_nombre: string;
  /** Matriz contable asociada (obligatoria en el backend: NOT NULL + FK). */
  concepto_matriz_contable_id?: number;
  concepto_tipo_movimiento: string;
  concepto_categoria: string;
  concepto_naturaleza_contable: string;
  concepto_cuenta_contable: string;
  concepto_origen: string;
  concepto_destino: string;
  concepto_estado: string;
  concepto_numero_documento: string;
  concepto_fecha_creacion: string;
  concepto_activo: boolean;
  concepto_created_by?: string;
  concepto_updated_by?: string;
  concepto_fec_modificacion?: string;
  concepto_created_at?: string;
  concepto_updated_at?: string;
  concepto_matriz_contable_codigo?: string;
  concepto_matriz_contable_descripcion?: string;
  concepto_estado_flag?: string;
}
