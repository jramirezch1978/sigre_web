import { Injectable, inject } from '@angular/core';
import { ITransaccionPeriodicaRepository } from '../../domain/repositories/itransaccion-periodica.repository';
import { TransaccionPeriodicaStore } from '../../store/transaccion-periodica.store';
import { TransaccionPeriodicaEntity } from '../../domain/models/transaccion-periodica.entity';

@Injectable()
export class ActualizarTransaccionPeriodicaUseCase {
  private readonly repo = inject(ITransaccionPeriodicaRepository);
  private readonly store = inject(TransaccionPeriodicaStore);

  execute(codigoProgramacion: string, cambios: Partial<TransaccionPeriodicaEntity>): void {
    this.store.setLoadingActualizar(true);
    this.store.setErrorActualizar(null);
    this.store.setResultActualizar(null);
    this.repo.actualizar(codigoProgramacion, cambios).subscribe({
      next: result => {
        this.store.updateTransaccion(codigoProgramacion, cambios);
        this.store.setResultActualizar(result);
        this.store.setLoadingActualizar(false);
      },
      error: err => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar la transacción periódica');
        this.store.setLoadingActualizar(false);
      },
    });
  }
}
