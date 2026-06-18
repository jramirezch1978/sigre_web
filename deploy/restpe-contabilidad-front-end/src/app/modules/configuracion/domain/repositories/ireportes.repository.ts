import { Observable } from 'rxjs';
import { HistorialActualizacionEntity } from '../models/historial-actualizacion.entity';
import { PlanEntity } from '../models/plan.entity';
import { PlantillaNotificacionEntity } from '../models/plantilla-notificacion.entity';
import { CompaniaEntity } from '../models/compania.entity';
import { CanalPagoCobroEntity } from '../models/canal-pago-cobro.entity';
import { CondicionPagoCobroEntity } from '../models/condicion-pago-cobro.entity';
import { CuentaBancariaEntity } from '../models/cuenta-bancaria.entity';
import { EjercicioFiscalEntity } from '../models/ejercicio-fiscal.entity';
import { MonedaEntity } from '../models/moneda.entity';
import { RetencionEntity } from '../models/retencion.entity';
import { UsuarioEntity } from '../models/usuario.entity';
import { SucursalEntity } from '../models/sucursal.entity';

export abstract class IReportesRepository {
    abstract obtenerHistorialDatosGenerales(): Observable<HistorialActualizacionEntity[]>;
    abstract obtenerPlanes(): Observable<PlanEntity[]>;
    abstract obtenerPlantillasNotificacion(): Observable<PlantillaNotificacionEntity[]>;
    abstract obtenerHistorialPlantillasNotificacion(): Observable<HistorialActualizacionEntity[]>;
    abstract obtenerCompanias(): Observable<CompaniaEntity[]>;
    abstract obtenerCanalesPagoCobro(): Observable<CanalPagoCobroEntity[]>;
    abstract obtenerCondicionesPagoCobro(): Observable<CondicionPagoCobroEntity[]>;
    abstract obtenerCuentasBancarias(): Observable<CuentaBancariaEntity[]>;
    abstract obtenerEjerciciosFiscales(): Observable<EjercicioFiscalEntity[]>;
    abstract obtenerMonedas(): Observable<MonedaEntity[]>;
    abstract obtenerRetenciones(): Observable<RetencionEntity[]>;
    abstract obtenerUsuarios(): Observable<UsuarioEntity[]>;
    abstract obtenerSucursales(): Observable<SucursalEntity[]>;
}
