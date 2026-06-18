import { Injectable, computed, inject } from '@angular/core';
import { ProcesosAjustesStore } from '../../store/procesos-ajustes.store';
import { ObtenerProcesosAjustesUseCase } from '../usecases/obtener-procesos-ajustes.usecase';

/**
 * ProcesosAjustesFacade — Fachada de aplicación.
 * Punto único de entrada para el componente: orquesta el caso de uso y expone los signals del store.
 */
@Injectable()
export class ProcesosAjustesFacade {

  private readonly store     = inject(ProcesosAjustesStore);
  private readonly obtenerUC = inject(ObtenerProcesosAjustesUseCase);

  // Signals expuestos al componente
  readonly items        = computed(() => this.store.items());
  readonly isLoading    = computed(() => this.store.isLoading());
  readonly errorObtener = computed(() => this.store.errorObtener());

  /**
   * Carga o recarga el listado de asientos de procesos de ajuste desde el repositorio.
   */
  cargarDatos(): void {
    this.store.setLoading(true);
    this.obtenerUC.execute().subscribe({
      next:  (entity) => this.store.setData(entity),
      error: (err)    => this.store.setError(err?.message ?? 'Error al obtener los procesos de ajuste'),
    });
  }
}
