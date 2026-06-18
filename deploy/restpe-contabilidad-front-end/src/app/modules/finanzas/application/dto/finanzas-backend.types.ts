export interface BackendTipoDocumento {
  id?: number;
  codigo: string;
  nombre: string;
  sunatCodigo?: string | null;
  flagEstado: string;
}

export interface BackendCatalogoSunatTipoDocumento {
  id?: number;
  catalogoSunatId: number;
  codigoItem: string;
  nombreItem: string;
  descripcionItem?: string | null;
  flagEstado: string;
}

export interface BackendConceptoFinanciero {
  id?: number;
  codigo: string;
  nombre: string;
  matrizContableId: number;
  flagEstado: string;
  activo: boolean;
  createdBy: string;
  fecCreacion: string;
  updatedBy: string;
  fecModificacion?: any | null;
  createdAt?: any | null;
  updatedAt?: any | null;
}
