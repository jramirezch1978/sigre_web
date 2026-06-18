import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { RecepcionTransferenciaEntity } from '../../domain/models/recepcion-transferencia.entity';

@Injectable()
export class ObtenerRecepcionesTransferenciaUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<RecepcionTransferenciaEntity[]> {
    return this.repository.obtenerRecepcionesTransferencia();
  }
}
