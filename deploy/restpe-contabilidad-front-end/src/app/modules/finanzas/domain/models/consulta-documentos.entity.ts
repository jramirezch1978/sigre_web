export interface ConsultaDocumentosEntity {
  cdoc_razon_social: string;
  cdoc_tipo_documento: string;
  cdoc_numero_documento: string;
  cdoc_fecha_emision: string;
  cdoc_modulo_origen: string;
  cdoc_referencia: string;
  cdoc_moneda: string;
  cdoc_monto_total: string;
  cdoc_cuenta_bancaria: string;
  cdoc_responsable: string;
  cdoc_numero_asiento: string;
  cdoc_observaciones: string;
  cdoc_estado: string;
  cdoc_show_eye?: boolean;
}
