import { Injectable, computed, inject } from '@angular/core';
import { TablasContabilidadStore } from '../../store/tablas-contabilidad.store';
import { ObtenerTablasContabilidadUseCase } from '../usecases/obtener-tablas-contabilidad.usecase';

/**
 * TablasContabilidadFacade — Fachada de aplicación.
 * Punto único de entrada para el componente: orquesta el caso de uso y expone los signals del store.
 */
@Injectable()
export class TablasContabilidadFacade {

  private readonly store     = inject(TablasContabilidadStore);
  private readonly obtenerUC = inject(ObtenerTablasContabilidadUseCase);

  // Signals expuestos al componente
  readonly items        = computed(() => this.store.items());
  readonly isLoading    = computed(() => this.store.isLoading());
  readonly errorObtener = computed(() => this.store.errorObtener());

  /**
   * Carga o recarga el catálogo de tipos de documento contable desde el repositorio.
   */
  cargarDatos(): void {
    this.store.setLoading(true);
    this.obtenerUC.execute().subscribe({
      next:  (entity) => this.store.setData(entity),
      error: (err)    => this.store.setError(err?.message ?? 'Error al obtener los tipos de documento contable'),
    });
  }
}
