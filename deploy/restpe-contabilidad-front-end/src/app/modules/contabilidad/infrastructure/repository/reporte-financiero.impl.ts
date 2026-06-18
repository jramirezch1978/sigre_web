import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, catchError, of } from 'rxjs';
import { IReporteFinancieroRepository } from '../../domain/repositories/ireporte-financiero.repository';
import { PatrimonioEntity, ReporteFinancieroEntity } from '../../domain/models/reporte-financiero.entity';

const ENTIDAD_BALANCE_VACIA: ReporteFinancieroEntity = { items: [] };
const ENTIDAD_PATRIMONIO_VACIA: PatrimonioEntity = { items: [] };

const BASE_PATH = 'assets/data/contabilidad/reporte';

/**
 * ReporteFinancieroRepositoryImpl — Capa de Infraestructura.
 * Resuelve los JSON según el país y el tipo de reporte.
 * Cumple con el principio de responsabilidad única (SRP).
 */
@Injectable()
export class ReporteFinancieroRepositoryImpl implements IReporteFinancieroRepository {

  private readonly http = inject(HttpClient);

  obtenerSituacionFinanciera(pais: string): Observable<ReporteFinancieroEntity> {
    const path = `${BASE_PATH}/${pais.toLowerCase()}/situacion-financiera.json`;
    return this.http.get<ReporteFinancieroEntity>(path).pipe(
      delay(300),
      catchError(() => of(ENTIDAD_BALANCE_VACIA))
    );
  }

  obtenerEstadoResultados(pais: string): Observable<ReporteFinancieroEntity> {
    const path = `${BASE_PATH}/${pais.toLowerCase()}/estado-resultados.json`;
    return this.http.get<ReporteFinancieroEntity>(path).pipe(
      delay(300),
      catchError(() => of(ENTIDAD_BALANCE_VACIA))
    );
  }

  obtenerFlujoEfectivo(pais: string): Observable<ReporteFinancieroEntity> {
    const path = `${BASE_PATH}/${pais.toLowerCase()}/flujo-efectivo.json`;
    return this.http.get<ReporteFinancieroEntity>(path).pipe(
      delay(300),
      catchError(() => of(ENTIDAD_BALANCE_VACIA))
    );
  }

  obtenerCambiosPatrimonio(pais: string): Observable<PatrimonioEntity> {
    const path = `${BASE_PATH}/${pais.toLowerCase()}/cambios-patrimonio.json`;
    return this.http.get<PatrimonioEntity>(path).pipe(
      delay(300),
      catchError(() => of(ENTIDAD_PATRIMONIO_VACIA))
    );
  }
}
