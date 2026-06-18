import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { TipoContratoEntity } from '../../domain/models/tipo-contrato.entity';

@Injectable()
export class ObtenerTipoContratoUseCase {
  private readonly reportesRepository = inject(IReportesRepository);

  execute(): Observable<TipoContratoEntity[]> {
    return this.reportesRepository.obtenerTipoContrato();
  }
}
