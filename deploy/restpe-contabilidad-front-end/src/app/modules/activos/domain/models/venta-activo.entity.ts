export interface VentaActivoEntity {
  venta_activo_codigo_baja:         string;
  venta_activo_tipo_debaja:         string;
  venta_activo_fecha_baja:          string;
  venta_activo_nro_activos:         number;
  venta_activo_valor_neto_contable: number;
  venta_activo_estado:              string;
  venta_activo_moneda?:             string;
  venta_activo_cuenta_contable?:    string;
  // Venta
  venta_activo_valor_venta?:          number;
  venta_activo_tipo_doc_comprador?:   string;
  venta_activo_nro_doc_comprador?:    string;
  venta_activo_nombre_comprador?:     string;
  venta_activo_tipo_doc_venta?:       string;
  venta_activo_nro_doc_venta?:        string;
  // Siniestro
  venta_activo_tipo_siniestro?:       string;
  venta_activo_parte_policial?:       string;
  venta_activo_monto_indemnizacion?:  number;
  venta_activo_descripcion_siniestro?: string;
  // Obsolescencia
  venta_activo_motivo_obsolescencia?:      string;
  venta_activo_descripcion_obsolescencia?: string;
  // Activos asociados a la baja
  venta_activo_activos?: {
    activo_fijo_codigo: string;
    activo_fijo_descripcion: string;
    activo_fijo_valor_adquisicion: number;
    activo_fijo_depreciacion_acumulada: number;
    activo_fijo_valor_neto_libros: number;
  }[];
}
