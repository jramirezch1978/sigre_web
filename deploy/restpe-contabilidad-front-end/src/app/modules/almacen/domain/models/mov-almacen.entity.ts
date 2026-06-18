export interface MovAlmacenEntity {
  /** Id numérico real del vale (backend); requerido para el PDF `/movimientos/pdf/{id}`. */
  mov_almacen_id: number | null;
  mov_almacen_codigo: string;
  mov_almacen_fecha_registro: string;
  mov_almacen_tipo: string;
  mov_almacen_almacen_asociado: string;
  mov_almacen_afecta_inventario: string;
  mov_almacen_motivo: string;
  mov_almacen_afecta_valor: string;
  mov_almacen_estado: string;
}
