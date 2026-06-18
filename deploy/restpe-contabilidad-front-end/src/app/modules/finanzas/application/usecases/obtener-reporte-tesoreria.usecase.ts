import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReporteTesoreriaRepository } from '../../domain/repositories/ireporte-tesoreria.repository';
import { ReporteTesoreriaEntity } from '../../domain/models/reporte-tesoreria.entity';

@Injectable()
export class ObtenerReporteTesoreriaUseCase {
  private readonly repository = inject(IReporteTesoreriaRepository);

  execute(): Observable<ReporteTesoreriaEntity[]> {
    return this.repository.obtenerMovimientos();
  }
}
