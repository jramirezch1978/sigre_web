import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, catchError, of } from 'rxjs';
import { IMaestroContableRepository } from '../../domain/repositories/imaestro-contable.repository';
import { MaestroContableEntity } from '../../domain/models/maestro-contable.entity';

const MAESTRO_VACIO: MaestroContableEntity = {
  planCuentas: [],
  centroCosto: [],
  impuestos: [],
  tiposDetraccion: [],
  configuraciones: [],
};

/**
 * MaestroContableRepositoryImpl — Capa de Infraestructura.
 * Responsabilidad única: acceso de lectura al Maestro Contable.
 * El JSON local simula una API REST de consulta.
 * Cumple con el principio de responsabilidad única (SRP).
 */
@Injectable()
export class MaestroContableRepositoryImpl implements IMaestroContableRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/tablas/maestro-contable.json';

  /**
   * Obtiene el maestro contable completo desde el JSON
   * (simulación de GET /api/contabilidad/maestro-contable).
   */
  obtenerTodos(): Observable<MaestroContableEntity> {
    return this.http.get<MaestroContableEntity>(this.JSON_PATH).pipe(
      delay(300),
      catchError(() => of(MAESTRO_VACIO))
    );
  }
}
