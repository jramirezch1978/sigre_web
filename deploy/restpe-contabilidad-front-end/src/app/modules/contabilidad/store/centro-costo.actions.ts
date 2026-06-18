export const CentroCostoActions = {
  CargarCentrosCosto: '[CentroCosto] Cargar centros de costo',
  GuardarCentroCosto: '[CentroCosto] Guardar centro de costo',
  ActualizarCentroCosto: '[CentroCosto] Actualizar centro de costo',
  EliminarCentroCosto: '[CentroCosto] Eliminar centro de costo',
  LimpiarEstado: '[CentroCosto] Limpiar estado',
  SeleccionarCentroCosto: '[CentroCosto] Seleccionar centro de costo',
} as const;

export type CentroCostoActionKeys = keyof typeof CentroCostoActions;
