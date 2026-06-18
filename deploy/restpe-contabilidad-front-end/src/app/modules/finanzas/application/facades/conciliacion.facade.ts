import { Injectable, inject } from '@angular/core';
import { ConciliacionStore } from '../../store/conciliacion.store';
import { ObtenerConciliacionUseCase } from '../usecases/obtener-conciliacion.usecase';

@Injectable()
export class ConciliacionFacade {
  private readonly store = inject(ConciliacionStore);
  private readonly obtenerUseCase = inject(ObtenerConciliacionUseCase);

  readonly conciliaciones = this.store.conciliaciones;
  readonly isLoading = this.store.isLoading;
  readonly error = this.store.error;

  cargarConciliaciones(): void {
    this.store.setLoading(true);
    this.obtenerUseCase.execute().subscribe({
      next: (conciliaciones) => this.store.setConciliaciones(conciliaciones),
      error: (err) => this.store.setError(err?.message ?? 'Error al cargar conciliaciones'),
    });
  }

  resetState(): void {
    this.store.resetState();
  }
}
