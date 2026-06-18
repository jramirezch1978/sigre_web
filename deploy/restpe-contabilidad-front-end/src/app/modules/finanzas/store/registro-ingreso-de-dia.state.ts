import { RegistroIngresoDeDiaEntity } from "../domain/models/registro-ingreso-de-dia.entity";

export interface RegistroIngresoDeDiaState {
  ingresos: RegistroIngresoDeDiaEntity[];
  isLoading: boolean;
  error: string | null;
}

export const initialRegistroIngresoDeDiaState: RegistroIngresoDeDiaState = {
  ingresos: [],
  isLoading: false,
  error: null,
};
