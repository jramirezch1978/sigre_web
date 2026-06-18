import { MatrizContableDetalleEntity } from '@modules/activos/domain/models/matriz-contable.entity';

export interface BackendMatrizContable {
  id: number;
  grupoMatrizCntblId: number;
  codigo: string;
  descripcion: string;
  flagEstado: string;
  createdBy: number;
  fecCreacion: string;
  updatedBy: number;
  fecModificacion?: string;
  detalles?: MatrizContableDetalleEntity[];
}
