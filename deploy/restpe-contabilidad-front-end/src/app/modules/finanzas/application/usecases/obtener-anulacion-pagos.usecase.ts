import { Injectable, inject } from '@angular/core';
import { IAnulacionPagosRepository } from '../../domain/repositories/ianulacion-pagos.repository';
import { AnulacionPagosStore } from '../../store/anulacion-pagos.store';

@Injectable()
export class ObtenerAnulacionPagosUseCase {
  private readonly repo = inject(IAnulacionPagosRepository);
  private readonly store = inject(AnulacionPagosStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setRegistros(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los registros de anulación/reversión de pagos');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
