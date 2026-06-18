import { Injectable, inject } from '@angular/core';
import { ILetraCambioRepository } from '../../domain/repositories/iletra-cambio.repository';
import { LetraCambioStore } from '../../store/letra-cambio.store';
import { LetraCambioEntity } from '../../domain/models/letra-cambio.entity';
;

@Injectable()
export class GuardarLetraCambioUseCase {
  private readonly repo = inject(ILetraCambioRepository);
  private readonly store = inject(LetraCambioStore);

  execute(letra: LetraCambioEntity): void {
    this.store.setLoadingGuardar(true);
    this.repo.guardar(letra).subscribe({
      next: saved => this.store.addLetra(saved),
      error: err => this.store.setErrorGuardar(err?.message ?? 'Error al guardar la letra de cambio'),
    });
  }
}
