import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, catchError, of } from 'rxjs';
import { IConsultaCentroCostosRepository } from '../../domain/repositories/iconsulta-centro-costos.repository';
import { ConsultaCentroCostosEntity } from '../../domain/models/consulta-centro-costos.entity';

const REPORTE_VACIO: ConsultaCentroCostosEntity = {
  items: [],
};

/**
 * ConsultaCentroCostosRepositoryImpl — Capa de Infraestructura.
 * Responsabilidad única: acceso de lectura al JSON de consulta de centros de costo.
 * El JSON local simula una API REST de consulta.
 * Cumple con el principio de responsabilidad única (SRP).
 */
@Injectable()
export class ConsultaCentroCostosRepositoryImpl implements IConsultaCentroCostosRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/consultas/consulta-centro-costos.json';

  /**
   * Obtiene los movimientos de centros de costo por trabajador desde el JSON
   * (simulación de GET /api/contabilidad/consultas/consulta-centro-costos).
   */
  obtenerTodos(): Observable<ConsultaCentroCostosEntity> {
    return this.http.get<ConsultaCentroCostosEntity>(this.JSON_PATH).pipe(
      delay(300),
      catchError(() => of(REPORTE_VACIO))
    );
  }
}
