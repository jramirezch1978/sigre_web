import { PanelReenvioEntity } from '../domain/models/panel-reenvio.entity';

export interface PanelReenvioState {
  registrosCompletos: PanelReenvioEntity[];
  registros: PanelReenvioEntity[];
  loading: boolean;
  error: string | null;
}

export const initialPanelReenvioState: PanelReenvioState = {
  registrosCompletos: [],
  registros: [],
  loading: false,
  error: null,
};
