import { Injectable, inject } from '@angular/core';
import { ITransaccionPeriodicaRepository } from '../../domain/repositories/itransaccion-periodica.repository';
import { TransaccionPeriodicaStore } from '../../store/transaccion-periodica.store';
import { TransaccionPeriodicaEntity } from '../../domain/models/transaccion-periodica.entity';

@Injectable()
export class GuardarTransaccionPeriodicaUseCase {
  private readonly repo = inject(ITransaccionPeriodicaRepository);
  private readonly store = inject(TransaccionPeriodicaStore);

  execute(transaccion: Partial<TransaccionPeriodicaEntity>): void {
    this.store.setLoadingGuardar(true);
    this.store.setErrorGuardar(null);
    this.store.setResultGuardar(null);
    this.repo.guardar(transaccion).subscribe({
      next: result => {
        this.store.addTransaccion(transaccion as any);
        this.store.setResultGuardar(result);
        this.store.setLoadingGuardar(false);
      },
      error: err => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar la transacción periódica');
        this.store.setLoadingGuardar(false);
      },
    });
  }
}
