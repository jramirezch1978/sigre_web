import { Injectable, inject } from '@angular/core';
import { IPagosMasivosRepository } from '../../domain/repositories/ipagos-masivos.repository';
import { PagosMasivosStore } from '../../store/pagos-masivos.store';

@Injectable()
export class ObtenerPagosMasivosUseCase {
  private readonly repo = inject(IPagosMasivosRepository);
  private readonly store = inject(PagosMasivosStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setRegistros(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al cargar pagos masivos');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
