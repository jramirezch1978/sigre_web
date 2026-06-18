import { Injectable, inject } from '@angular/core';
import { IEjecucionPagoRepository } from '../../domain/repositories/iejecucion-pago.repository';
import { EjecucionPagoStore } from '../../store/ejecucion-pago.store';

@Injectable()
export class ObtenerEjecucionPagoUseCase {
  private readonly repo = inject(IEjecucionPagoRepository);
  private readonly store = inject(EjecucionPagoStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setPagos(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los pagos de ejecución');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
