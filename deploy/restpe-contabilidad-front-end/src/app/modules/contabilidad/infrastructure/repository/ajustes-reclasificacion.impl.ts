import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, catchError, of } from 'rxjs';
import { IAjustesReclasificacionRepository } from '../../domain/repositories/iajustes-reclasificacion.repository';
import { AjustesReclasificacionEntity } from '../../domain/models/ajustes-reclasificacion.entity';

const ENTIDAD_VACIA: AjustesReclasificacionEntity = {
  items: [],
};

/**
 * AjustesReclasificacionRepositoryImpl — Capa de Infraestructura.
 * Responsabilidad única: acceso de lectura al JSON de ajustes y reclasificaciones.
 * El JSON local simula una API REST del módulo de operaciones contables.
 * Cumple con el principio de responsabilidad única (SRP).
 */
@Injectable()
export class AjustesReclasificacionRepositoryImpl implements IAjustesReclasificacionRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/operaciones/ajustes-reclasificacion.json';

  /**
   * Obtiene los ajustes y reclasificaciones desde el JSON
   * (simulación de GET /api/contabilidad/operaciones/ajustes-reclasificacion).
   */
  obtenerTodos(): Observable<AjustesReclasificacionEntity> {
    return this.http.get<AjustesReclasificacionEntity>(this.JSON_PATH).pipe(
      delay(300),
      catchError(() => of(ENTIDAD_VACIA))
    );
  }
}
