import { Injectable, inject, effect } from '@angular/core';
import { NotaCreditoStore } from '../stores/nota-credito.store';
import { ObtenerNotasCreditoUseCase } from '../application/use-cases/nota-credito/obtener-notas-credito.usecase';

/**
 * Effects de sincronización para Notas de Crédito/Débito
 * Recarga automáticamente la lista tras operaciones CRUD exitosas
 */
@Injectable()
export class NotaCreditoSyncEffects {
  private readonly store = inject(NotaCreditoStore);
  private readonly obtenerUseCase = inject(ObtenerNotasCreditoUseCase);

  constructor() {
    let previousLoadingGuardar = false;
    let previousLoadingActualizar = false;
    let previousLoadingEliminar = false;

    // Effect: Recargar tras guardar
    effect(() => {
      const isLoading = this.store.loadingGuardar();
      const error = this.store.errorGuardar();

      if (previousLoadingGuardar && !isLoading && !error) {
        this.recargarNotas();
      }
      previousLoadingGuardar = isLoading;
    });

    // Effect: Recargar tras actualizar
    effect(() => {
      const isLoading = this.store.loadingActualizar();
      const error = this.store.errorActualizar();

      if (previousLoadingActualizar && !isLoading && !error) {
        this.recargarNotas();
      }
      previousLoadingActualizar = isLoading;
    });

    // Effect: Recargar tras eliminar
    effect(() => {
      const isLoading = this.store.loadingEliminar();
      const error = this.store.errorEliminar();

      if (previousLoadingEliminar && !isLoading && !error) {
        this.recargarNotas();
      }
      previousLoadingEliminar = isLoading;
    });
  }

  private recargarNotas(): void {
    this.store.setLoadingObtener(true);
    this.obtenerUseCase.execute().subscribe({
      next: notas => this.store.setNotas(notas),
      error: err => this.store.setErrorObtener(err.message),
      complete: () => this.store.setLoadingObtener(false),
    });
  }
}
