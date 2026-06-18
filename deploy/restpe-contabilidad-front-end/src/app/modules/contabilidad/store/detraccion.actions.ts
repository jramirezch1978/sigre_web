export const DetraccionActions = {
  CargarDetracciones: '[Detraccion] Cargar detracciones',
  GuardarDetraccion: '[Detraccion] Guardar detraccion',
  ActualizarDetraccion: '[Detraccion] Actualizar detraccion',
  EliminarDetraccion: '[Detraccion] Eliminar detraccion',
  LimpiarEstado: '[Detraccion] Limpiar estado',
  SeleccionarDetraccion: '[Detraccion] Seleccionar detraccion',
} as const;

export type DetraccionActionKeys = keyof typeof DetraccionActions;
