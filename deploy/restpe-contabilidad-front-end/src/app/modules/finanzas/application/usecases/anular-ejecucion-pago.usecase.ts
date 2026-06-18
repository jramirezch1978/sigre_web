import { Injectable, inject } from '@angular/core';
import { IEjecucionPagoRepository } from '../../domain/repositories/iejecucion-pago.repository';
import { EjecucionPagoStore } from '../../store/ejecucion-pago.store';

@Injectable()
export class AnularEjecucionPagoUseCase {
  private readonly repo = inject(IEjecucionPagoRepository);
  private readonly store = inject(EjecucionPagoStore);

  execute(ep_codigo: string): void {
    this.store.setLoadingAnular(true);
    this.store.setErrorAnular(null);
    this.store.setAnuladoOk(false);
    this.repo.anular(ep_codigo).subscribe({
      next: () => {
        this.store.anularPago(ep_codigo);
        this.store.setLoadingAnular(false);
        this.store.setAnuladoOk(true);
      },
      error: err => {
        this.store.setErrorAnular(err?.message ?? 'Error al anular el pago');
        this.store.setLoadingAnular(false);
      },
    });
  }
}
