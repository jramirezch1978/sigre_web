import { Injectable, computed, inject } from '@angular/core';
import { AjustesReclasificacionStore } from '../../store/ajustes-reclasificacion.store';
import { ObtenerAjustesReclasificacionUseCase } from '../usecases/obtener-ajustes-reclasificacion.usecase';

/**
 * AjustesReclasificacionFacade — Fachada de aplicación.
 * Punto único de entrada para el componente: orquesta el caso de uso y expone los signals del store.
 */
@Injectable()
export class AjustesReclasificacionFacade {

  private readonly store     = inject(AjustesReclasificacionStore);
  private readonly obtenerUC = inject(ObtenerAjustesReclasificacionUseCase);

  // Signals expuestos al componente
  readonly items      = computed(() => this.store.items());
  readonly isLoading  = computed(() => this.store.isLoading());
  readonly errorObtener = computed(() => this.store.errorObtener());

  /**
   * Carga o recarga el listado de ajustes y reclasificaciones desde el repositorio.
   */
  cargarDatos(): void {
    this.store.setLoading(true);
    this.obtenerUC.execute().subscribe({
      next:  (entity) => this.store.setData(entity),
      error: (err)    => this.store.setError(err?.message ?? 'Error al obtener ajustes y reclasificaciones'),
    });
  }
}
