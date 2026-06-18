import { ConsultaFlujoCajaEntity } from '../domain/models/consulta-flujo-caja.entity';

export interface ConsultaFlujoCajaState {
  registros: ConsultaFlujoCajaEntity[];
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const initialConsultaFlujoCajaState: ConsultaFlujoCajaState = {
  registros: [],
  loadingObtener: false,
  errorObtener: null,
};
