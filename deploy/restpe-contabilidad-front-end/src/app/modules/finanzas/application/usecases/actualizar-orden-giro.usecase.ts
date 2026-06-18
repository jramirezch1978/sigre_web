import { Injectable, inject } from '@angular/core';
import { IOrdenGiroRepository } from '../../domain/repositories/iorden-giro.repository';
import { OrdenGiroStore } from '../../store/orden-giro.store';
import { OrdenGiroEntity } from '../../domain/models/orden-giro.entity';

@Injectable()
export class ActualizarOrdenGiroUseCase {
  private readonly repo = inject(IOrdenGiroRepository);
  private readonly store = inject(OrdenGiroStore);

  execute(entity: OrdenGiroEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setErrorActualizar(null);
    this.store.setActualizadoOk(false);
    this.repo.actualizar(entity).subscribe({
      next: updated => {
        this.store.updateOrden(updated);
        this.store.setLoadingActualizar(false);
        this.store.setActualizadoOk(true);
      },
      error: err => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar orden de giro');
        this.store.setLoadingActualizar(false);
      },
    });
  }
}
