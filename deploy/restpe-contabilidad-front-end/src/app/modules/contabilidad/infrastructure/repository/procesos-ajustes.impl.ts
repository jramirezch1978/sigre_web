import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, catchError, of } from 'rxjs';
import { IProcesosAjustesRepository } from '../../domain/repositories/iprocesos-ajustes.repository';
import { ProcesosAjustesEntity } from '../../domain/models/procesos-ajustes.entity';

const ENTIDAD_VACIA: ProcesosAjustesEntity = {
  items: [],
};

/**
 * ProcesosAjustesRepositoryImpl — Capa de Infraestructura.
 * Responsabilidad única: acceso de lectura al JSON de procesos de ajuste contable.
 * El JSON local simula una API REST del módulo de procesos contables.
 * Cumple con el principio de responsabilidad única (SRP).
 */
@Injectable()
export class ProcesosAjustesRepositoryImpl implements IProcesosAjustesRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/procesos/procesos-ajustes.json';

  /**
   * Obtiene los asientos de proceso de ajuste desde el JSON
   * (simulación de GET /api/contabilidad/procesos/ajustes).
   */
  obtenerTodos(): Observable<ProcesosAjustesEntity> {
    return this.http.get<ProcesosAjustesEntity>(this.JSON_PATH).pipe(
      delay(300),
      catchError(() => of(ENTIDAD_VACIA))
    );
  }
}
