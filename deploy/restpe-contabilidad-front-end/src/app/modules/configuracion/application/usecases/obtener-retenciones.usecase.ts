import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { RetencionEntity } from '../../domain/models/retencion.entity';

@Injectable()
export class ObtenerRetencionesUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<RetencionEntity[]> {
    return this.repository.obtenerRetenciones();
  }
}
