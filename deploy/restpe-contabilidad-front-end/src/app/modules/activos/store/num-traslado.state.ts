import { NumTrasladoEntity } from '../domain/models/num-traslado.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface NumTrasladoState {
  // Lista principal
  numTraslados: NumTrasladoEntity[];
  numTrasladoSeleccionado: NumTrasladoEntity | null;

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

export const initialNumTrasladoState: NumTrasladoState = {
  numTraslados:            [],
  numTrasladoSeleccionado: null,

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
