import { Injectable, inject } from '@angular/core';
import { ICarterasCobrosRepository } from '../../domain/repositories/icarteras-cobros.repository';
import { CarterasCobrosStore } from '../../store/carteras-cobros.store';
import { CarterasCobrosEntity } from '../../domain/models/carteras-cobros.entity';

@Injectable()
export class ActualizarCarterasCobrosUseCase {
  private readonly repo = inject(ICarterasCobrosRepository);
  private readonly store = inject(CarterasCobrosStore);

  execute(entity: CarterasCobrosEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setErrorActualizar(null);
    this.store.setActualizadoOk(false);
    this.repo.actualizar(entity).subscribe({
      next: updated => {
        this.store.updateCobro(updated);
        this.store.setLoadingActualizar(false);
        this.store.setActualizadoOk(true);
      },
      error: err => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar cartera de cobros');
        this.store.setLoadingActualizar(false);
      },
    });
  }
}
