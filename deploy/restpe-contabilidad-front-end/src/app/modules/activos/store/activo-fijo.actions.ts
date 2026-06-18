export const ActivoFijoActions = {
  CargarActivosFijos: '[ActivoFijo] Cargar activos fijos',
  GuardarActivoFijo:  '[ActivoFijo] Guardar activo fijo',
  EliminarActivoFijo: '[ActivoFijo] Eliminar activo fijo',
  ActualizarActivoFijo: '[ActivoFijo] Actualizar activo fijo',
  SeleccionarActivoFijo: '[ActivoFijo] Seleccionar activo fijo',
  LimpiarEstado: '[ActivoFijo] Limpiar estado',
} as const;

export type ActivoFijoActionKeys = keyof typeof ActivoFijoActions;
