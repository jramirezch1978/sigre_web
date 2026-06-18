import { Observable } from 'rxjs';
import { ProyeccionIngresosEgresosEntity } from '../models/proyeccion-ingresos-egresos.entity';

export abstract class IProyeccionIngresosEgresosRepository {
  abstract obtenerProyecciones(): Observable<ProyeccionIngresosEgresosEntity[]>;
}
