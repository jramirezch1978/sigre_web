import { Injectable, inject } from '@angular/core';
import { ILetraCambioRepository } from '../../domain/repositories/iletra-cambio.repository';
import { LetraCambioStore } from '../../store/letra-cambio.store';
import { LetraCambioEntity } from '../../domain/models/letra-cambio.entity';

@Injectable()
export class ActualizarLetraCambioUseCase {
  private readonly repo = inject(ILetraCambioRepository);
  private readonly store = inject(LetraCambioStore);

  execute(letra: LetraCambioEntity): void {
    this.store.setLoadingActualizar(true);
    this.repo.actualizar(letra).subscribe({
      next: updated => this.store.updateLetra(updated),
      error: err => this.store.setErrorActualizar(err?.message ?? 'Error al actualizar la letra de cambio'),
    });
  }
}
