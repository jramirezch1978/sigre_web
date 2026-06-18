import { ProyeccionIngresosEgresosEntity } from "../domain/models/proyeccion-ingresos-egresos.entity";

export interface ProyeccionIngresosEgresosState {
  proyecciones: ProyeccionIngresosEgresosEntity[];
  isLoading: boolean;
  error: string | null;
}

export const initialProyeccionIngresosEgresosState: ProyeccionIngresosEgresosState = {
  proyecciones: [],
  isLoading: false,
  error: null,
};
