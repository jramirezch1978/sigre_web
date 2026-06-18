import { ConsultaCajaBancoEntity } from '../domain/models/consulta-caja-banco.entity';

export interface ConsultaCajaBancoState {
  cuentas: ConsultaCajaBancoEntity[];
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const initialConsultaCajaBancoState: ConsultaCajaBancoState = {
  cuentas: [],
  loadingObtener: false,
  errorObtener: null,
};
