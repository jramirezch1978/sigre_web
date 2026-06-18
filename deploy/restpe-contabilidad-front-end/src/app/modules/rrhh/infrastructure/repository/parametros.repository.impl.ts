import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IParametrosRepository } from '../../domain/repositories/iparametros.repository';
import { AgrupacionSedeEntity } from '../../domain/models/agrupacion-sede.entity';
import { ConfiguracionProvisionesEntity } from '../../domain/models/configuracion-provisiones.entity';
import { FrecuenciaCalendariosEntity } from '../../domain/models/frecuencia-calendarios.entity';
import { GeneracionNumeracionEntity } from '../../domain/models/generacion-numeracion.entity';

@Injectable()
export class ParametrosRepositoryImpl extends IParametrosRepository {
  private readonly agrupacionSedeUrl = 'assets/data/rr-hh/parametros/agrupacion-sede.json';
  private readonly configuracionProvisionesUrl = 'assets/data/rr-hh/parametros/configuracion-provisiones.json';
  private readonly frecuenciaCalendariosUrl = 'assets/data/rr-hh/parametros/frecuencia-calendarios.json';
  private readonly generacionNumeracionUrl = 'assets/data/rr-hh/parametros/generacion-numeracion.json';

  constructor(private readonly http: HttpClient) {
    super();
  }

  obtenerAgrupacionSede(): Observable<AgrupacionSedeEntity[]> {
    return this.http.get<AgrupacionSedeEntity[]>(this.agrupacionSedeUrl).pipe(delay(1000));
  }

  obtenerConfiguracionProvisiones(): Observable<ConfiguracionProvisionesEntity[]> {
    return this.http.get<ConfiguracionProvisionesEntity[]>(this.configuracionProvisionesUrl).pipe(delay(1000));
  }

  obtenerFrecuenciaCalendarios(): Observable<FrecuenciaCalendariosEntity[]> {
    return this.http.get<FrecuenciaCalendariosEntity[]>(this.frecuenciaCalendariosUrl).pipe(delay(1000));
  }

  obtenerGeneracionNumeracion(): Observable<GeneracionNumeracionEntity[]> {
    return this.http.get<GeneracionNumeracionEntity[]>(this.generacionNumeracionUrl).pipe(delay(1000));
  }
}
