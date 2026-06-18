export const CuentaVsSubcategoriaActions = {
  CargarItems: '[CuentaVsSubcategoria] Cargar relaciones',
  ActualizarItem: '[CuentaVsSubcategoria] Actualizar relación',
  LimpiarEstado: '[CuentaVsSubcategoria] Limpiar estado',
  SeleccionarItem: '[CuentaVsSubcategoria] Seleccionar relación',
} as const;

export type CuentaVsSubcategoriaActionKeys = keyof typeof CuentaVsSubcategoriaActions;
