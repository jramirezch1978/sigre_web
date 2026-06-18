import { Injectable, inject } from '@angular/core';
import { IOrdenGiroRepository } from '../../domain/repositories/iorden-giro.repository';
import { OrdenGiroStore } from '../../store/orden-giro.store';
import { OrdenGiroEntity } from '../../domain/models/orden-giro.entity';

@Injectable()
export class GuardarOrdenGiroUseCase {
  private readonly repo = inject(IOrdenGiroRepository);
  private readonly store = inject(OrdenGiroStore);

  execute(entity: OrdenGiroEntity, esEdicion: boolean): void {
    this.store.setLoadingGuardar(true);
    this.store.setErrorGuardar(null);
    this.store.setGuardadoOk(false);
    this.repo.guardar(entity).subscribe({
      next: saved => {
        if (esEdicion) {
          this.store.updateOrden(saved);
        } else {
          this.store.addOrden(saved);
        }
        this.store.setLoadingGuardar(false);
        this.store.setGuardadoOk(true);
      },
      error: err => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar orden de giro');
        this.store.setLoadingGuardar(false);
      },
    });
  }
}
