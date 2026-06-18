import { Injectable, inject } from '@angular/core';
import { IAprobarGiroRepository } from '../../domain/repositories/iaprobar-giro.repository';
import { AprobarGiroStore } from '../../store/aprobar-giro.store';
import { AprobarGiroEntity } from '../../domain/models/aprobar-giro.entity';

@Injectable()
export class ActualizarAprobarGiroUseCase {
  private readonly repo = inject(IAprobarGiroRepository);
  private readonly store = inject(AprobarGiroStore);

  execute(entity: AprobarGiroEntity, mensaje?: string): void {
    this.store.setLoadingActualizar(true);
    this.store.setErrorActualizar(null);
    this.store.setActualizadoOk(false);
    this.store.setMensajeExito(null);
    this.repo.actualizar(entity).subscribe({
      next: updated => {
        this.store.updateOrden(updated);
        this.store.setLoadingActualizar(false);
        this.store.setMensajeExito(mensaje ?? null);
        this.store.setActualizadoOk(true);
      },
      error: err => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar orden de giro');
        this.store.setLoadingActualizar(false);
      },
    });
  }
}
