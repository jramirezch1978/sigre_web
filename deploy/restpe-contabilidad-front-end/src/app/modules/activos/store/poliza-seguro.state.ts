import { PolizaSeguroEntity } from '../domain/models/poliza-seguro.entity';

export interface PolizaSeguroState {
  polizas:        PolizaSeguroEntity[];
  loadingObtener: boolean;
  errorObtener:   string | null;
}

export const initialPolizaSeguroState: PolizaSeguroState = {
  polizas:        [],
  loadingObtener: false,
  errorObtener:   null,
};
