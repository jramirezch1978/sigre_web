import { Injectable, inject } from '@angular/core';
import { ObtenerReglasAsignacionUseCase } from '../usecases/obtener-reglas-asignacion.usecase';
import { ProduccionStore } from '../../store/produccion.store';

@Injectable()
export class ProduccionFacade {

  private readonly store = inject(ProduccionStore);
  private readonly obtenerReglasAsignacionUC = inject(ObtenerReglasAsignacionUseCase);

  // Selectores
  readonly reglasAsignacion = this.store.reglasAsignacion;
  readonly loadingReglasAsignacion = this.store.loadingReglasAsignacion;
  readonly errorReglasAsignacion = this.store.errorReglasAsignacion;
  readonly isLoading = this.store.isLoading;

  cargarReglasAsignacion(): void {
    this.store.setLoadingReglasAsignacion(true);

    this.obtenerReglasAsignacionUC.execute().subscribe({
      next: (reglas) => {
        this.store.setReglasAsignacion(reglas);
      },
      error: (err) => {
        console.error('Error al cargar reglas de asignación:', err);
        this.store.setErrorReglasAsignacion(err.message || 'Error al cargar reglas de asignación');
      },
    });
  }

  clearReglasAsignacion(): void {
    this.store.clearReglasAsignacion();
  }

  resetState(): void {
    this.store.resetState();
  }
}
