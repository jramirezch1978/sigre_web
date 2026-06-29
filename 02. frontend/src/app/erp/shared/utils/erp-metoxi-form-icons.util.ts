export type ErpMetoxiFormFieldType = 'text' | 'number' | 'select' | 'date' | 'switch' | 'centros-costo';

const ICONOS_POR_CAMPO: Record<string, string> = {
  codigo: 'tag',
  nombre: 'label',
  descTipoMov: 'description',
  almacenId: 'warehouse',
  sucursalId: 'store',
  almacenTipoId: 'category',
  articuloMovTipoId: 'sync_alt',
  tipoMov: 'swap_horiz',
  pasillo: 'view_week',
  estante: 'shelves',
  nivel: 'layers',
  fechaMov: 'event',
  fecha: 'event',
  fechaConteo: 'event',
  ano: 'calendar_today',
  valor: 'tune',
  nombreTabla: 'table_chart',
  prefijo: 'text_fields',
  correlativo: 'numbers',
  centrosCostoId: 'account_balance',
  proveedorEntidadId: 'local_shipping',
  responsableUsuarioId: 'person',
  direccion: 'location_on',
  ubigeo: 'map',
  distrito: 'place',
  provincia: 'map',
  departamento: 'public',
  areaTotal: 'square_foot',
  volTotal: 'inventory_2',
  corrGuia: 'receipt_long',
  codOrigen: 'flag',
  codSunat: 'gavel',
  anoApertura: 'calendar_today',
  flagCntrlLote: 'inventory',
  flagReplicacion: 'sync',
  flagVirtual: 'cloud',
  flagEstado: 'toggle_on',
};

export function iconoMetoxiCampo(fieldKey: string, type: ErpMetoxiFormFieldType): string {
  if (ICONOS_POR_CAMPO[fieldKey]) {
    return ICONOS_POR_CAMPO[fieldKey];
  }
  switch (type) {
    case 'number':
      return 'pin';
    case 'date':
      return 'event';
    case 'select':
      return 'list';
    case 'switch':
      return 'toggle_on';
    default:
      return 'edit';
  }
}

export function colClassMetoxiCampo(fieldKey: string, type: ErpMetoxiFormFieldType): string {
  // Flags (switch) compactos y en la misma fila (hasta 3 por fila).
  if (type === 'switch') {
    return 'col-6 col-md-4';
  }
  if (type === 'date') {
    return 'col-12';
  }
  if (['pasillo', 'estante', 'nivel'].includes(fieldKey)) {
    return 'col-md-4';
  }
  if (fieldKey === 'direccion') {
    return 'col-12';
  }
  if (type === 'select') {
    return 'col-12';
  }
  if (type === 'text' || type === 'number') {
    return 'col-md-6';
  }
  return 'col-12';
}
