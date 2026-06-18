import { Injectable, inject } from '@angular/core';
import { IPagoRecibidoRepository } from '../../domain/repositories/ipago-recibido.repository';
import { PagoRecibidoStore } from '../../store/pago-recibido.store';

@Injectable()
export class ObtenerPagoRecibidoUseCase {
  private readonly repo = inject(IPagoRecibidoRepository);
  private readonly store = inject(PagoRecibidoStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setPagos(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener pagos recibidos');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
