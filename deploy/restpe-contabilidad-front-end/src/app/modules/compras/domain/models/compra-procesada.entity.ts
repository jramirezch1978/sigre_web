/**
 * Entidad de dominio: Compra Procesada.
 * Convención: compra_procesada_campo
 */
export class CompraProcesadaEntity {
  constructor(
    public readonly compra_procesada_nro_documento:          string,
    public readonly compra_procesada_fecha_emision:          string,
    public readonly compra_procesada_proveedor:              string,
    public readonly compra_procesada_ruc_nit:                string,
    public readonly compra_procesada_sucursal:               string,
    public readonly compra_procesada_centro_costo:           string,
    public readonly compra_procesada_tipo_documento:         string,
    public readonly compra_procesada_comprobante:            string,
    public readonly compra_procesada_fecha_registro:         string,
    public readonly compra_procesada_moneda:                 string,
    public readonly compra_procesada_base_imponible:         number,
    public readonly compra_procesada_valor_inafecto:         number,
    public readonly compra_procesada_valor_adq_no_gravadas:  number,
    public readonly compra_procesada_igv:                    number,
    public readonly compra_procesada_icbper:                 number,
    public readonly compra_procesada_monto_total:            number,
    public readonly compra_procesada_tipo_cambio:            number,
    public readonly compra_procesada_estado:                 string
  ) {}
}
