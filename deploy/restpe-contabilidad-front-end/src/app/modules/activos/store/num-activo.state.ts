import { NumActivoEntity } from '../domain/models/num-activo.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface NumActivoState {
  // Lista principal
  numActivos: NumActivoEntity[];
  numActivoSeleccionado: NumActivoEntity | null;

  // Obtener
  loadingObtener: boolean;
  errorObtener:   string | null;

  // Guardar
  loadingGuardar: boolean;
  errorGuardar:   string | null;
  resultGuardar:  ApiResponse | null;

  // Actualizar
  loadingActualizar: boolean;
  errorActualizar:   string | null;
  resultActualizar:  ApiResponse | null;

  // Eliminar
  loadingEliminar: boolean;
  errorEliminar:   string | null;
  resultEliminar:  ApiResponse | null;
}

export const initialNumActivoState: NumActivoState = {
  numActivos:            [],
  numActivoSeleccionado: null,

  loadingObtener: false,
  errorObtener:   null,

  loadingGuardar: false,
  errorGuardar:   null,
  resultGuardar:  null,

  loadingActualizar: false,
  errorActualizar:   null,
  resultActualizar:  null,

  loadingEliminar: false,
  errorEliminar:   null,
  resultEliminar:  null,
};
