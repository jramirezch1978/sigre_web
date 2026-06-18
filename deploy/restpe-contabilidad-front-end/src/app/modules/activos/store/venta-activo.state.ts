import { VentaActivoEntity } from '../domain/models/venta-activo.entity';

export interface VentaActivoState {
  ventasActivos:  VentaActivoEntity[];
  loadingObtener: boolean;
  errorObtener:   string | null;
}

export const initialVentaActivoState: VentaActivoState = {
  ventasActivos:  [],
  loadingObtener: false,
  errorObtener:   null,
};
