import { Injectable } from '@angular/core';
import { ICanjeReprogramacionRepository } from '../../domain/repositories/icanje-reprogramacion.repository';
import { CanjeReprogramacionStore } from '../../store/canje-reprogramacion.store';

@Injectable()
export class ReprogramarVencimientoUseCase {
  constructor(
    private repository: ICanjeReprogramacionRepository,
    private store: CanjeReprogramacionStore,
  ) {}

  execute(nroDocumento: string, nuevaFechaVencimiento: string): void {
    this.store.setLoadingReprogramar(true);
    this.repository.reprogramarVencimiento(nroDocumento, nuevaFechaVencimiento).subscribe({
      next: (result) => this.store.setResultReprogramar(result),
      error: (err) => this.store.setErrorReprogramar(err?.message ?? 'Error al reprogramar vencimiento'),
    });
  }
}
