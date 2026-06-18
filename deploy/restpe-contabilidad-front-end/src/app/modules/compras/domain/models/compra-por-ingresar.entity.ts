/**
 * Entidad de dominio: Compra por Ingresar.
 * Convención: compra_ingresar_campo
 */
export class CompraPorIngresarEntity {
  constructor(
    public compra_ingresar_nro_orden:          string,
    public compra_ingresar_fecha_emision:      string,
    public compra_ingresar_fecha_recepcion:    string,
    public compra_ingresar_doc_fiscal:         string,
    public compra_ingresar_proveedor:          string,
    public compra_ingresar_moneda:             string,
    public compra_ingresar_sucursal:           string,
    public compra_ingresar_monto_total:        number,
    public compra_ingresar_recepcionado:       number,
    public compra_ingresar_cantidad:           number,
    public compra_ingresar_ingresado:          number,
    public compra_ingresar_diferencia:         number,
    public compra_ingresar_usuario_receptor:   string,
    public compra_ingresar_estado:             string
  ) {}
}
