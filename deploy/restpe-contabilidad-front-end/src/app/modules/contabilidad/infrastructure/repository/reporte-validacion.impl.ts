import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, catchError, of } from 'rxjs';
import { IReporteValidacionRepository } from '../../domain/repositories/ireporte-validacion.repository';
import { ConsistenciaEntity, ConsistenciaPreEntity, AsientosDesEntity } from '../../domain/models/reporte-validacion.entity';

/**
 * ReporteValidacionRepositoryImpl — Capa de Infraestructura.
 * Responsabilidad única: acceso de lectura a los JSON de validación contable.
 * Cada tipo de reporte tiene su propio JSON.
 */
@Injectable()
export class ReporteValidacionRepositoryImpl implements IReporteValidacionRepository {

  private readonly http = inject(HttpClient);
  private readonly BASE_PATH = 'assets/data/contabilidad/reporte/validacion';

  obtenerConsistencia(): Observable<ConsistenciaEntity> {
    return this.http.get<ConsistenciaEntity>(`${this.BASE_PATH}/consistencia.json`).pipe(
      delay(300),
      catchError(() => of([]))
    );
  }

  obtenerConsistenciaPre(): Observable<ConsistenciaPreEntity> {
    return this.http.get<ConsistenciaPreEntity>(`${this.BASE_PATH}/consistencia-pre.json`).pipe(
      delay(300),
      catchError(() => of([]))
    );
  }

  obtenerAsientosDes(): Observable<AsientosDesEntity> {
    return this.http.get<AsientosDesEntity>(`${this.BASE_PATH}/asientos-descuadrados.json`).pipe(
      delay(300),
      catchError(() => of([]))
    );
  }
}
