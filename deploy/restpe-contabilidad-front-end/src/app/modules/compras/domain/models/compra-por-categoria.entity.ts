/**
 * Entidad de dominio: Compra por Categoría.
 * Convención: compra_categoria_campo
 */
export class CompraPorCategoriaEntity {
  constructor(
    public readonly compra_categoria_categoria:        string,
    public readonly compra_categoria_subcategoria:     string,
    public readonly compra_categoria_producto:         string,
    public readonly compra_categoria_codigo:           string,
    public readonly compra_categoria_doc_fiscal:       string,
    public readonly compra_categoria_razon_social:     string,
    public readonly compra_categoria_moneda:           string,
    public readonly compra_categoria_centro_costo:     string,
    public readonly compra_categoria_medida:           string,
    public readonly compra_categoria_cantidad_comprada: number,
    public readonly compra_categoria_monto_total:      number,
    public readonly compra_categoria_precio_promedio:  number,
    public readonly compra_categoria_participacion:    number,
    public readonly compra_categoria_ultima_compra:    string,
    public readonly compra_categoria_sucursal:         string,
    public readonly compra_categoria_estado:           string
  ) {}
}
