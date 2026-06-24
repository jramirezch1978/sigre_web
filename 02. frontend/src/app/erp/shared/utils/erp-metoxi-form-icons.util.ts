export type ErpMetoxiFormFieldType = 'text' | 'number' | 'select' | 'date' | 'switch';

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
  if (type === 'switch' || type === 'date') {
    return 'col-12';
  }
  if (['pasillo', 'estante', 'nivel'].includes(fieldKey)) {
    return 'col-md-4';
  }
  if (type === 'select') {
    return 'col-12';
  }
  if (type === 'text' || type === 'number') {
    return 'col-md-6';
  }
  return 'col-12';
}
