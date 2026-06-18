import { FacturacionRegaliasEntity } from '../domain/models/facturacion-regalias.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface FacturacionRegaliasState {
  facturas: FacturacionRegaliasEntity[];
  facturaSeleccionada: FacturacionRegaliasEntity | null;

  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingAnular: boolean;

  errorObtener: string | null;
  errorGuardar: string | null;
  errorAnular: string | null;

  resultGuardar: ApiResponse<FacturacionRegaliasEntity> | null;
  resultAnular: ApiResponse<FacturacionRegaliasEntity> | null;
}

export const initialFacturacionRegaliasState: FacturacionRegaliasState = {
  facturas: [],
  facturaSeleccionada: null,

  loadingObtener: false,
  loadingGuardar: false,
  loadingAnular: false,

  errorObtener: null,
  errorGuardar: null,
  errorAnular: null,

  resultGuardar: null,
  resultAnular: null,
};
