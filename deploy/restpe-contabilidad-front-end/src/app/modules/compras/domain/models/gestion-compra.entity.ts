/**
 * Entidad de dominio: Gestión de Compra.
 * Convención: gestion_compra_campo
 */
export interface GestionCompraDetalleItem {
  codigo:         string;
  cantidad:       number;
  producto:       string;
  montoAcumulado: number;
}

export class GestionCompraEntity {
  constructor(
    public readonly gestion_compra_fecha_compra:  string,
    public readonly gestion_compra_nro_orden:     string,
    public readonly gestion_compra_doc_fiscal:    string,
    public readonly gestion_compra_razon_social:  string,
    public readonly gestion_compra_producto:      string,
    public readonly gestion_compra_categoria:     string,
    public readonly gestion_compra_medida:        string,
    public readonly gestion_compra_cantidad:      number,
    public readonly gestion_compra_precio_venta:  number,
    public readonly gestion_compra_condicion:     string,
    public readonly gestion_compra_estado:        string,
    public readonly gestion_compra_detalle?:      GestionCompraDetalleItem[]
  ) {}
}
