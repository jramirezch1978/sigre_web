export const AlmacenActions = {
  CargarAlmacenes: '[Almacen] Cargar almacenes',
  GuardarAlmacen: '[Almacen] Guardar almacen',
  EliminarAlmacen: '[Almacen] Eliminar almacen',
  ActualizarAlmacen: '[Almacen] Actualizar almacen',
  LimpiarEstado: '[Almacen] Limpiar estado',
  SeleccionarAlmacen: '[Almacen] Seleccionar almacen',
} as const;

export type AlmacenActionKeys = keyof typeof AlmacenActions;
