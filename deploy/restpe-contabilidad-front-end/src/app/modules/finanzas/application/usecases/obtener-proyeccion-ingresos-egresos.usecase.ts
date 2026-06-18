import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IProyeccionIngresosEgresosRepository } from '../../domain/repositories/iproyeccion-ingresos-egresos.repository';
import { ProyeccionIngresosEgresosEntity } from '../../domain/models/proyeccion-ingresos-egresos.entity';

@Injectable()
export class ObtenerProyeccionIngresosEgresosUseCase {
  private readonly repository = inject(IProyeccionIngresosEgresosRepository);

  execute(): Observable<ProyeccionIngresosEgresosEntity[]> {
    return this.repository.obtenerProyecciones();
  }
}
