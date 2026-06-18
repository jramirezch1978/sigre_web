import { HistorialActualizacionEntity } from '../domain/models/historial-actualizacion.entity';
import { PlanEntity } from '../domain/models/plan.entity';
import { PlantillaNotificacionEntity } from '../domain/models/plantilla-notificacion.entity';
import { CompaniaEntity } from '../domain/models/compania.entity';
import { CanalPagoCobroEntity } from '../domain/models/canal-pago-cobro.entity';
import { CondicionPagoCobroEntity } from '../domain/models/condicion-pago-cobro.entity';
import { CuentaBancariaEntity } from '../domain/models/cuenta-bancaria.entity';
import { EjercicioFiscalEntity } from '../domain/models/ejercicio-fiscal.entity';
import { MonedaEntity } from '../domain/models/moneda.entity';
import { RetencionEntity } from '../domain/models/retencion.entity';
import { UsuarioEntity } from '../domain/models/usuario.entity';
import { SucursalEntity } from '../domain/models/sucursal.entity';

export interface ConfiguracionState {
  // Datos
  historialDatosGenerales: HistorialActualizacionEntity[];
  planes: PlanEntity[];
  plantillasNotificacion: PlantillaNotificacionEntity[];
  historialPlantillasNotificacion: HistorialActualizacionEntity[];
  companias: CompaniaEntity[];
  canalesPagoCobro: CanalPagoCobroEntity[];
  condicionesPagoCobro: CondicionPagoCobroEntity[];
  cuentasBancarias: CuentaBancariaEntity[];
  ejerciciosFiscales: EjercicioFiscalEntity[];
  monedas: MonedaEntity[];
  retenciones: RetencionEntity[];
  usuarios: UsuarioEntity[];
  sucursales: SucursalEntity[];

  // Loading states
  loadingHistorialDatosGenerales: boolean;
  loadingPlanes: boolean;
  loadingPlantillasNotificacion: boolean;
  loadingHistorialPlantillasNotificacion: boolean;
  loadingCompanias: boolean;
  loadingCanalesPagoCobro: boolean;
  loadingCondicionesPagoCobro: boolean;
  loadingCuentasBancarias: boolean;
  loadingEjerciciosFiscales: boolean;
  loadingMonedas: boolean;
  loadingRetenciones: boolean;
  loadingUsuarios: boolean;
  loadingSucursales: boolean;

  // Error states
  errorHistorialDatosGenerales: string | null;
  errorPlanes: string | null;
  errorPlantillasNotificacion: string | null;
  errorHistorialPlantillasNotificacion: string | null;
  errorCompanias: string | null;
  errorCanalesPagoCobro: string | null;
  errorCondicionesPagoCobro: string | null;
  errorCuentasBancarias: string | null;
  errorEjerciciosFiscales: string | null;
  errorMonedas: string | null;
  errorRetenciones: string | null;
  errorUsuarios: string | null;
  errorSucursales: string | null;
}

export const initialConfiguracionState: ConfiguracionState = {
  historialDatosGenerales: [],
  planes: [],
  plantillasNotificacion: [],
  historialPlantillasNotificacion: [],
  companias: [],
  canalesPagoCobro: [],
  condicionesPagoCobro: [],
  cuentasBancarias: [],
  ejerciciosFiscales: [],
  monedas: [],
  retenciones: [],
  usuarios: [],
  sucursales: [],
  loadingHistorialDatosGenerales: false,
  loadingPlanes: false,
  loadingPlantillasNotificacion: false,
  loadingHistorialPlantillasNotificacion: false,
  loadingCompanias: false,
  loadingCanalesPagoCobro: false,
  loadingCondicionesPagoCobro: false,
  loadingCuentasBancarias: false,
  loadingEjerciciosFiscales: false,
  loadingMonedas: false,
  loadingRetenciones: false,
  loadingUsuarios: false,
  loadingSucursales: false,
  errorHistorialDatosGenerales: null,
  errorPlanes: null,
  errorPlantillasNotificacion: null,
  errorHistorialPlantillasNotificacion: null,
  errorCompanias: null,
  errorCanalesPagoCobro: null,
  errorCondicionesPagoCobro: null,
  errorCuentasBancarias: null,
  errorEjerciciosFiscales: null,
  errorMonedas: null,
  errorRetenciones: null,
  errorUsuarios: null,
  errorSucursales: null,
};
