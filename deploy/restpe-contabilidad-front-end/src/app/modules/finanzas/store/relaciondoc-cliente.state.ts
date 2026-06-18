import { RelacionDocClienteMap } from '../domain/models/relaciondoc-cliente.entity';

export interface RelacionDocClienteState {
  facturasPorCliente: RelacionDocClienteMap;
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const initialRelacionDocClienteState: RelacionDocClienteState = {
  facturasPorCliente: {},
  loadingObtener: false,
  errorObtener: null,
};
