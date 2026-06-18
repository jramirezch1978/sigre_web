import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICondicionPagoRepository } from '../../domain/repositories/icondicion-pago.repository';
import { CondicionPagoEntity } from '../../domain/models/condicion-pago.entity';

@Injectable()
export class ObtenerCondicionesPagoUseCase {
  private readonly repository = inject(ICondicionPagoRepository);

  execute(): Observable<CondicionPagoEntity[]> {
    return this.repository.obtenerTodos();
  }
}
