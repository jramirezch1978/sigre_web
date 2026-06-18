export const TipoDeCambioActions = {
  CargarItems: '[TipoDeCambio] Cargar tipos de cambio',
  GuardarItem: '[TipoDeCambio] Guardar tipo de cambio',
  ActualizarItem: '[TipoDeCambio] Actualizar tipo de cambio',
  LimpiarEstado: '[TipoDeCambio] Limpiar estado',
} as const;

export type TipoDeCambioActionKeys = keyof typeof TipoDeCambioActions;
