import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { EmisionBoletasEntity } from '../../domain/models/emision-boletas.entity';

@Injectable()
export class ObtenerEmisionBoletasUseCase {
  private readonly reportesRepository = inject(IReportesRepository);

  execute(): Observable<EmisionBoletasEntity[]> {
    return this.reportesRepository.obtenerEmisionBoletas();
  }
}
