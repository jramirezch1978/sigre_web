import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, catchError, of } from 'rxjs';
import { IClonacionAsientosRepository } from '../../domain/repositories/iclonacion-asientos.repository';
import { ClonacionAsientosEntity } from '../../domain/models/clonacion-asientos.entity';

const REPORTE_VACIO: ClonacionAsientosEntity = {
  items: [],
};

/**
 * ClonacionAsientosRepositoryImpl — Capa de Infraestructura.
 * Responsabilidad única: acceso de lectura al JSON de clonación de asientos.
 * El JSON local simula una API REST del proceso de clonación contable.
 * Cumple con el principio de responsabilidad única (SRP).
 */
@Injectable()
export class ClonacionAsientosRepositoryImpl implements IClonacionAsientosRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/procesos/clonacion-asientos.json';

  /**
   * Obtiene los registros de asientos disponibles para clonar desde el JSON
   * (simulación de GET /api/contabilidad/procesos/clonacion-asientos).
   */
  obtenerTodos(): Observable<ClonacionAsientosEntity> {
    return this.http.get<ClonacionAsientosEntity>(this.JSON_PATH).pipe(
      delay(300),
      catchError(() => of(REPORTE_VACIO))
    );
  }
}
