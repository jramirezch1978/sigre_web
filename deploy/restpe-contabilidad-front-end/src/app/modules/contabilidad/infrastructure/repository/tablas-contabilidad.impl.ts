import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, catchError, of } from 'rxjs';
import { ITablasContabilidadRepository } from '../../domain/repositories/itablas-contabilidad.repository';
import { TablasContabilidadEntity } from '../../domain/models/tablas-contabilidad.entity';

const ENTIDAD_VACIA: TablasContabilidadEntity = {
  items: [],
};

/**
 * TablasContabilidadRepositoryImpl — Capa de Infraestructura.
 * Responsabilidad única: acceso de lectura al JSON de tipos de documento contable.
 * El JSON local simula una API REST del módulo de tablas contables.
 * Cumple con el principio de responsabilidad única (SRP).
 */
@Injectable()
export class TablasContabilidadRepositoryImpl implements ITablasContabilidadRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/tablas/tablas-contabilidad.json';

  /**
   * Obtiene los tipos de documento contable desde el JSON
   * (simulación de GET /api/contabilidad/tablas/contabilidad).
   */
  obtenerTodos(): Observable<TablasContabilidadEntity> {
    return this.http.get<TablasContabilidadEntity>(this.JSON_PATH).pipe(
      delay(300),
      catchError(() => of(ENTIDAD_VACIA))
    );
  }
}
