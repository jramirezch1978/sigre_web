import { Injectable, inject } from '@angular/core';
import { ITransaccionPeriodicaRepository } from '../../domain/repositories/itransaccion-periodica.repository';
import { TransaccionPeriodicaStore } from '../../store/transaccion-periodica.store';

@Injectable()
export class ObtenerTransaccionPeriodicaUseCase {
  private readonly repo = inject(ITransaccionPeriodicaRepository);
  private readonly store = inject(TransaccionPeriodicaStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setTransacciones(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener transacciones periódicas');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
