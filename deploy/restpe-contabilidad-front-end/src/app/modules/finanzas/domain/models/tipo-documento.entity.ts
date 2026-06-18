export interface TipoDocumentoEntity {
  id?: number;
  codigo: string;
  nombre: string;
  sunatCodigo?: string | null;
  flagEstado: string;
  sunatCatalogoTipoDocumento?: SunatTipoDocumentoEntity;
}

export interface SunatTipoDocumentoEntity {
  id?: number;
  catalogoSunatId: number;
  codigoItem: string;
  nombreItem: string;
  descripcionItem?: string | null;
  flagEstado: string;
}
