import { Injectable, inject } from '@angular/core';
import { Observable, forkJoin, map } from 'rxjs';
import { IReporteFinancieroRepository } from '../../domain/repositories/ireporte-financiero.repository';
import { ReporteFinancieroCompleto } from '../../domain/models/reporte-financiero.entity';

/**
 * ObtenerReporteFinancieroUseCase — Caso de uso de aplicación.
 * Carga en paralelo los cuatro datasets del reporte financiero para un país dado.
 */
@Injectable()
export class ObtenerReporteFinancieroUseCase {

  private readonly repo = inject(IReporteFinancieroRepository);

  execute(pais: string): Observable<ReporteFinancieroCompleto> {
    return forkJoin({
      situacionFinanciera: this.repo.obtenerSituacionFinanciera(pais),
      estadoResultados:    this.repo.obtenerEstadoResultados(pais),
      flujoEfectivo:       this.repo.obtenerFlujoEfectivo(pais),
      cambiosPatrimonio:   this.repo.obtenerCambiosPatrimonio(pais),
    });
  }
}
