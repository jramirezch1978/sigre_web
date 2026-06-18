import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { PatrimonioEntity, ReporteFinancieroEntity } from '../models/reporte-financiero.entity';

/**
 * IReporteFinancieroRepository — Puerto del dominio (Abstracción).
 * Define el contrato de acceso a datos para los cuatro tipos de reporte financiero.
 * La implementación concreta reside en la capa de infraestructura.
 */
@Injectable()
export abstract class IReporteFinancieroRepository {
  abstract obtenerSituacionFinanciera(pais: string): Observable<ReporteFinancieroEntity>;
  abstract obtenerEstadoResultados(pais: string): Observable<ReporteFinancieroEntity>;
  abstract obtenerFlujoEfectivo(pais: string): Observable<ReporteFinancieroEntity>;
  abstract obtenerCambiosPatrimonio(pais: string): Observable<PatrimonioEntity>;
}
