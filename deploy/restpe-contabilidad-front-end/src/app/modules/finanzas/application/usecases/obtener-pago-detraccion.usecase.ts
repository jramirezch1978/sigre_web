import { Injectable, inject } from '@angular/core';
import { IPagoDetraccionRepository } from '../../domain/repositories/ipago-detraccion.repository';
import { PagoDetraccionStore } from '../../store/pago-detraccion.store';

@Injectable()
export class ObtenerPagoDetraccionUseCase {
  private readonly repo = inject(IPagoDetraccionRepository);
  private readonly store = inject(PagoDetraccionStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setDetracciones(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener las detracciones');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
