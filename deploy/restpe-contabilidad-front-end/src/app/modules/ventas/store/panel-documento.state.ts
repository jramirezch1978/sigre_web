import { PanelDocumentoEntity } from '../domain/models/panel-documento.entity';

export interface PanelDocumentoState {
  registrosCompletos: PanelDocumentoEntity[];
  registros: PanelDocumentoEntity[];
  loading: boolean;
  error: string | null;
}

export const initialPanelDocumentoState: PanelDocumentoState = {
  registrosCompletos: [],
  registros: [],
  loading: false,
  error: null,
};
