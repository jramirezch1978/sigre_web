import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { ProvisionGastoEntity } from '../../domain/models/provision-gasto.entity';

@Injectable()
export class ObtenerProvisionGastoUseCase {
  private readonly reportesRepository = inject(IReportesRepository);

  execute(): Observable<ProvisionGastoEntity[]> {
    return this.reportesRepository.obtenerProvisionGasto();
  }
}
