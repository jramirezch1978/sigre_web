import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, catchError, of } from 'rxjs';
import { IAnalisisCuentaContableRepository } from '../../domain/repositories/ianalisis-cuenta-contable.repository';
import { AnalisisCuentaContableEntity } from '../../domain/models/analisis-cuenta-contable.entity';

const REPORTE_VACIO: AnalisisCuentaContableEntity = {
  items: [],
};

/**
 * AnalisisCuentaContableRepositoryImpl — Capa de Infraestructura.
 * Responsabilidad única: acceso de lectura al JSON de análisis de cuenta contable.
 * El JSON local simula una API REST de consulta.
 * Cumple con el principio de responsabilidad única (SRP).
 */
@Injectable()
export class AnalisisCuentaContableRepositoryImpl implements IAnalisisCuentaContableRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/reporte/analisis-cuenta-contable.json';

  /**
   * Obtiene el análisis de cuenta contable desde el JSON
   * (simulación de GET /api/contabilidad/reporte/analisis-cuenta-contable).
   */
  obtenerTodos(): Observable<AnalisisCuentaContableEntity> {
    return this.http.get<AnalisisCuentaContableEntity>(this.JSON_PATH).pipe(
      delay(300),
      catchError(() => of(REPORTE_VACIO))
    );
  }
}
