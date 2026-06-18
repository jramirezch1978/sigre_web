/**
 * Entidad de dominio: Sugerencia de Compra.
 * Convención: sugerencia_compra_campo
 */
export class SugerenciaCompraEntity {
  constructor(
    public readonly sugerencia_compra_codigo:         string,
    public readonly sugerencia_compra_producto:       string,
    public readonly sugerencia_compra_categoria:      string,
    public readonly sugerencia_compra_almacen:        string,
    public readonly sugerencia_compra_medida:         string,
    public readonly sugerencia_compra_stock_actual:   number,
    public readonly sugerencia_compra_prom_consumo:   number,
    public readonly sugerencia_compra_pt_reposicion:  number,
    public readonly sugerencia_compra_fecha_registro: string,
    public readonly sugerencia_compra_estado:         string
  ) {}
}
