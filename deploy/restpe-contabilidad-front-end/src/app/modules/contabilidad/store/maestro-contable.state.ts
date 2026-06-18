import { MaestroContableEntity } from '../domain/models/maestro-contable.entity';

const MAESTRO_VACIO: MaestroContableEntity = {
  planCuentas: [],
  centroCosto: [],
  impuestos: [],
  tiposDetraccion: [],
  configuraciones: [],
};

/**
 * MaestroContableState — Estado del signal store para Maestro Contable.
 * Solo lectura: no tiene estado de guardar/actualizar.
 */
export interface MaestroContableState {
  data: MaestroContableEntity;
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const initialMaestroContableState: MaestroContableState = {
  data: MAESTRO_VACIO,
  loadingObtener: false,
  errorObtener: null,
};
