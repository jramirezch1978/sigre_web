import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, catchError, of } from 'rxjs';
import { IConsistenciaAsientosRepository } from '../../domain/repositories/iconsistencia-asientos.repository';
import { ConsistenciaAsientosEntity } from '../../domain/models/consistencia-asientos.entity';

@Injectable()
export class ConsistenciaAsientosRepositoryImpl implements IConsistenciaAsientosRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/procesos/consistencia-asientos.json';

  obtenerTodos(): Observable<ConsistenciaAsientosEntity[]> {
    return this.http.get<ConsistenciaAsientosEntity[]>(this.JSON_PATH).pipe(
      delay(300),
      catchError(() => of([]))
    );
  }
}

