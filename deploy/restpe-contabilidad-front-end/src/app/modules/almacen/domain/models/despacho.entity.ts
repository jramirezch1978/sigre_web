export interface DespachoEntity {
  despacho_codigo?: string;
  despacho_fecha: string;
  despacho_tipo: string;
  despacho_destino: string;
  despacho_cantidad_solicitada: number;
  despacho_cantidad_despachada: number;
  despacho_diferencia: number;
  despacho_almacen_origen: string;
  despacho_usuario: string;
  despacho_estado: string;
}
