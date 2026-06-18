import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, catchError, of } from 'rxjs';
import { IGestionAsientosAutomaticosRepository } from '../../domain/repositories/igestion-asientos-automaticos.repository';
import { GestionAsientosAutomaticoEntity } from '../../domain/models/gestion-asientos-automatico.entity';

const ENTIDAD_VACIA: GestionAsientosAutomaticoEntity = {
  items: [],
};

/**
 * AsientosAutomaticosRepositoryImpl — Capa de Infraestructura.
 * Responsabilidad única: acceso de lectura al JSON de gestión de asientos automáticos.
 * El JSON local simula una API REST del módulo de operaciones contables.
 * Cumple con el principio de responsabilidad única (SRP).
 */
@Injectable()
export class AsientosAutomaticosRepositoryImpl implements IGestionAsientosAutomaticosRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/operaciones/asientos-automatico.json';

  /**
   * Obtiene los asientos automáticos desde el JSON
   * (simulación de GET /api/contabilidad/operaciones/asientos-automaticos).
   */
  obtenerTodos(): Observable<GestionAsientosAutomaticoEntity> {
    return this.http.get<GestionAsientosAutomaticoEntity>(this.JSON_PATH).pipe(
      delay(300),
      catchError(() => of(ENTIDAD_VACIA))
    );
  }
}
