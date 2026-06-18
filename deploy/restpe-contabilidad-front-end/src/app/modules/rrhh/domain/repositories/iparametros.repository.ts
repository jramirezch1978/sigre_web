import { Observable } from 'rxjs';
import { AgrupacionSedeEntity } from '../models/agrupacion-sede.entity';
import { ConfiguracionProvisionesEntity } from '../models/configuracion-provisiones.entity';
import { FrecuenciaCalendariosEntity } from '../models/frecuencia-calendarios.entity';
import { GeneracionNumeracionEntity } from '../models/generacion-numeracion.entity';

export abstract class IParametrosRepository {
  abstract obtenerAgrupacionSede(): Observable<AgrupacionSedeEntity[]>;
  abstract obtenerConfiguracionProvisiones(): Observable<ConfiguracionProvisionesEntity[]>;
  abstract obtenerFrecuenciaCalendarios(): Observable<FrecuenciaCalendariosEntity[]>;
  abstract obtenerGeneracionNumeracion(): Observable<GeneracionNumeracionEntity[]>;
}
