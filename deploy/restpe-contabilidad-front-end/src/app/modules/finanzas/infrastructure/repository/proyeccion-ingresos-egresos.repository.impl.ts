import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IProyeccionIngresosEgresosRepository } from '../../domain/repositories/iproyeccion-ingresos-egresos.repository';
import { ProyeccionIngresosEgresosEntity } from '../../domain/models/proyeccion-ingresos-egresos.entity';

@Injectable()
export class ProyeccionIngresosEgresosRepositoryImpl implements IProyeccionIngresosEgresosRepository {
  private readonly http = inject(HttpClient);
  private readonly url = 'assets/data/finanzas/tesoreria/proyeccion-ingresos-egresos.json';

  obtenerProyecciones(): Observable<ProyeccionIngresosEgresosEntity[]> {
    return this.http.get<ProyeccionIngresosEgresosEntity[]>(this.url).pipe(delay(800));
  }
}
