export interface GestionCatalogoEntity {
  /** Id real del backend (core.doc_tipo). Necesario para PUT/DELETE. */
  catalogo_id?:                 number;
  catalogo_codigo:              string;
  catalogo_nombre_doc:          string;
  catalogo_tipo_documento:      string;
  catalogo_naturaleza:          string;
  catalogo_uso:                 string;
  catalogo_cuenta_contable:     string;
  catalogo_estado:              string;
  catalogo_fecha_creacion:      string;
  /** FALTA: código SUNAT (DocTipoRequest.sunatCodigo). Agregado para alinear con backend. */
  catalogo_sunat_codigo?:       string;
  catalogo_tiene_referencia?:   string;
  catalogo_referencia_bancaria?: string;
  catalogo_tiene_comprobante?:  string;
  catalogo_nro_comprobante?:    string;
}
