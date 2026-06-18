import { Injectable } from '@angular/core';
import { ICanjeReprogramacionRepository } from '../../domain/repositories/icanje-reprogramacion.repository';
import { CanjeReprogramacionStore } from '../../store/canje-reprogramacion.store';

@Injectable()
export class AplicarCanjeUseCase {
  constructor(
    private repository: ICanjeReprogramacionRepository,
    private store: CanjeReprogramacionStore,
  ) {}

  execute(nroDocumento: string): void {
    this.store.setLoadingCanje(true);
    this.repository.aplicarCanje(nroDocumento).subscribe({
      next: (result) => this.store.setResultCanje(result),
      error: (err) => this.store.setErrorCanje(err?.message ?? 'Error al aplicar canje'),
    });
  }
}
