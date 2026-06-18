import { Injectable, inject } from '@angular/core';
import { ILiqRendicionRepository } from '../../domain/repositories/iliq-rendicion.repository';
import { LiqRendicionStore } from '../../store/liq-rendicion.store';
import { LiqRendicionEntity } from '../../domain/models/liq-rendicion.entity';

@Injectable()
export class ActualizarLiqRendicionUseCase {
  private readonly repo = inject(ILiqRendicionRepository);
  private readonly store = inject(LiqRendicionStore);

  execute(entity: LiqRendicionEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setErrorActualizar(null);
    this.store.setActualizadoOk(false);
    this.repo.actualizar(entity).subscribe({
      next: updated => {
        this.store.updateLiquidacion(updated);
        this.store.setLoadingActualizar(false);
        this.store.setActualizadoOk(true);
      },
      error: err => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar liquidación');
        this.store.setLoadingActualizar(false);
      },
    });
  }
}
