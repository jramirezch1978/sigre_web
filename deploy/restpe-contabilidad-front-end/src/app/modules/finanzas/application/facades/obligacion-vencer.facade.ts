import { Injectable, inject } from '@angular/core';
import { ObligacionVencerStore } from '../../store/obligacion-vencer.store';
import { ObtenerObligacionVencerUseCase } from '../usecases/obtener-obligacion-vencer.usecase';

@Injectable()
export class ObligacionVencerFacade {
  private readonly store = inject(ObligacionVencerStore);
  private readonly obtenerUseCase = inject(ObtenerObligacionVencerUseCase);

  readonly obligaciones = this.store.obligaciones;
  readonly isLoading = this.store.isLoading;
  readonly error = this.store.error;

  cargarObligaciones(): void {
    this.store.setLoading(true);
    this.obtenerUseCase.execute().subscribe({
      next: (obligaciones) => this.store.setObligaciones(obligaciones),
      error: (err) => this.store.setError(err?.message ?? 'Error al cargar obligaciones por vencer'),
    });
  }

  resetState(): void {
    this.store.resetState();
  }
}
