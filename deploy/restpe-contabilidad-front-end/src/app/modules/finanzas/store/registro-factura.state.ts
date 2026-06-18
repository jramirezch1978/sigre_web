import { RegistroFacturaEntity } from '../domain/models/registro-factura.entity';

export interface RegistroFacturaState {
  facturas: RegistroFacturaEntity[];
  loadingObtener: boolean;
  errorObtener: string | null;
  loadingGuardar: boolean;
  errorGuardar: string | null;
  loadingActualizar: boolean;
  errorActualizar: string | null;
}

export const REGISTRO_FACTURA_INITIAL_STATE: RegistroFacturaState = {
  facturas: [],
  loadingObtener: false,
  errorObtener: null,
  loadingGuardar: false,
  errorGuardar: null,
  loadingActualizar: false,
  errorActualizar: null,
};
