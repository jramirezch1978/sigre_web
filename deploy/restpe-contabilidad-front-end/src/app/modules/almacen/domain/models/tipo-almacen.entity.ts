/**
 * Tipo de almacén (catálogo `almacen.almacen_tipo`): clasificación del almacén
 * por contenido (MP=Materia Prima, PT=Producto Terminado, etc.).
 * `id` es el FK que persiste `almacen.almacen_tipo_id`.
 */
export interface TipoAlmacenEntity {
  id: number;
  codigo: string;
  nombre: string;
}
