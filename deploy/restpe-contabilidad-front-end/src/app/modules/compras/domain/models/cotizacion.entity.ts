/**
 * Entidad de dominio: Cotización.
 * Convención: cotizacion_campo / det_cotizacion_campo
 * 
 * Una cotización es un registro de ofertas de múltiples proveedores
 * para los mismos artículos, con el objetivo de comparar precios.
 * Estados: "1"=registrada, "SELECCIONADA", "DESCARTADA", "0"=anulada, "2"=convertida
 */

/**
 * Línea de detalle de una cotización (artículos cotizados)
 */
export interface LineaCotizacionEntity {
  id?: number;
  cotizacion_id?: number;
  articulo_id: number;
  articulo_codigo: string;
  articulo_descripcion: string;
  cantidad: number;
  precio_unitario: number;
  descuento?: number;
  plazo_entrega_dias?: number;
  subtotal?: number;
  [key: string]: any;
}

/**
 * Cotización principal con líneas de artículos
 */
export interface CotizacionEntity {
  id?: number;
  sucursal_id?: number;
  proveedor_id: number;
  proveedor_razon_social: string;
  proveedor_ruc?: string;
  proveedor_direccion?: string;
  fecha: string; // LocalDate (YYYY-MM-DD)
  moneda_id?: number;
  moneda_codigo?: string; // "PEN", "USD", etc.
  total: number;
  flag_estado: string; // "1"=registrada, "SELECCIONADA", "DESCARTADA", "0"=anulada, "2"=convertida
  usuario_creacion?: string;
  fecha_creacion?: string; // ISO 8601
  lineas: LineaCotizacionEntity[];
  [key: string]: any;
}

/**
 * Respuesta de comparativo de cotizaciones
 * Agrupa ofertas por artículo y proveedor
 */
export interface OfertaProveedorComparativo {
  cotizacion_id: number;
  proveedor_id: number;
  proveedor_razon_social: string;
  precio_unitario: number;
  descuento?: number;
  plazo_entrega_dias?: number;
  cantidad: number;
}

export interface ArticuloComparativoEntity {
  articulo_id: number;
  articulo_codigo: string;
  articulo_nombre: string;
  ofertas: OfertaProveedorComparativo[];
}

export interface ComparativoCotizacionesEntity {
  articulos: ArticuloComparativoEntity[];
}
