/**
 * Entidad de dominio: Compra en Tránsito.
 * Convención: compra_transito_campo
 */
export class CompraTransitoEntity {
  constructor(
    public compra_transito_nro_orden:          string,
    public compra_transito_fecha_emision:      string,
    public compra_transito_proveedor:          string,
    public compra_transito_ruc_nit:            string,
    public compra_transito_moneda:             string,
    public compra_transito_monto_total:        number,
    public compra_transito_sucursal:           string,
    public compra_transito_tipo_doc:           string,
    public compra_transito_solicitado:         number,
    public compra_transito_cantidad:           number,
    public compra_transito_recepcionado:       number,
    public compra_transito_pendiente:          number,
    public compra_transito_fecha_entrega:      string,
    public compra_transito_porcentaje_total:   number,
    public compra_transito_dias:               number,
    public compra_transito_estado:             string
  ) {}
}
