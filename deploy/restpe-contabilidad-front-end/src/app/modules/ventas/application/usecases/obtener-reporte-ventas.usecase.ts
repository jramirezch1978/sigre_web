import { Injectable, inject } from '@angular/core';
import { IReporteVentasRepository } from '../../domain/repositories/ireporte-ventas.repository';
import { ReporteVentasEntity } from '../../domain/models/reporte-ventas.entity';
import { Observable } from 'rxjs';

@Injectable()
export class ObtenerReporteVentasUseCase {

  private readonly repository = inject(IReporteVentasRepository);

  execute(): Observable<ReporteVentasEntity[]> {
    return this.repository.obtenerTodos();
  }
}
