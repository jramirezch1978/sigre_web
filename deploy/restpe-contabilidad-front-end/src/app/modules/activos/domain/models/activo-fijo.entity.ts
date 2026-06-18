/**
 * Entidad principal de Activo Fijo.
 * Nomenclatura: tabla_campo (convencion del diagrama de base de datos).
 * Refleja la estructura del JSON en assets/data/activo-fijo/tabla/registro-activos.json
 * y los campos guardados en localStorage.
 */
export interface ActivoFijoEntity {
  id?: string;
  // Campos de ACTIVO_FIJO
  activo_fijo_codigo: string;
  activo_fijo_descripcion: string;
  activo_fijo_nombre_activo?: string;
  activo_fijo_clasificacion?: string;
  activo_fijo_subclase?: string;
  activo_fijo_subclasificacion?: string;
  activo_fijo_marca_modelo?: string;
  activo_fijo_proveedor?: string;
  activo_fijo_documento_vinculado?: string;
  activo_fijo_fecha_adquisicion: string;
  activo_fijo_periodo_contable: string;
  activo_fijo_moneda: string;
  activo_fijo_valor_adquisicion: number;
  activo_fijo_tasa_cambio?: number;
  activo_fijo_valor_soles?: number;
  activo_fijo_valor_dolares?: number;
  activo_fijo_valor_neto: number;
  activo_fijo_vida_util?: number;
  activo_fijo_estado: string;
  activo_fijo_garantia?: string;
  activo_fijo_usuario_asignado?: string;
  activo_fijo_estado_complementario?: string;
  activo_fijo_ubicacion_fisica?: string;
  activo_fijo_observaciones?: string;
  activo_fijo_valor_actualizado?: number;
  // Campos de DEPRECIACION
  activo_fijo_metodo_depreciacion?: string;
  activo_fijo_tasa_anual?: number;
  activo_fijo_fecha_inicio_depreciacion?: string;
  activo_fijo_valor_residual?: number;
  activo_fijo_depreciacion_acumulada?: number;
  activo_fijo_valor_neto_libros?: number;
  // Campos de ASIGNACION_ACTIVO
  activo_fijo_responsable?: string;
  activo_fijo_centro_costos?: string;
  activo_fijo_fecha_asignacion?: string;
  // Metadatos
  activo_fijo_fecha_creacion?: string;
  activo_fijo_fecha_modificacion?: string;
}
