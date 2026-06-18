import { Injectable, inject, effect } from '@angular/core';
import { AprovisionamientoStore } from '../stores/aprovisionamiento.store';
import { ObtenerPlanesAbastecimientoUseCase } from '../application/use-cases/aprovisionamiento/obtener-planes-abastecimiento.usecase';

/**
 * Effect: Sincronización de Aprovisionamiento
 * Auto-recarga los planes después de guardar, actualizar o eliminar
 */
@Injectable()
export class AprovisionamientoSyncEffects {
  private readonly store = inject(AprovisionamientoStore);
  private readonly obtenerPlanesUseCase = inject(ObtenerPlanesAbastecimientoUseCase);

  private previousLoadingGuardar = false;
  private previousLoadingActualizar = false;
  private previousLoadingEliminar = false;

  constructor() {
    // Effect: recargar después de guardar
    effect(() => {
      const loading = this.store.loadingGuardar();
      const error = this.store.errorGuardar();

      if (this.previousLoadingGuardar && !loading && !error) {
        console.log('  Auto-recarga después de guardar plan de abastecimiento');
        this.obtenerPlanesUseCase.execute().subscribe();
      }
      this.previousLoadingGuardar = loading;
    });

    // Effect: recargar después de actualizar
    effect(() => {
      const loading = this.store.loadingActualizar();
      const error = this.store.errorActualizar();

      if (this.previousLoadingActualizar && !loading && !error) {
        console.log('  Auto-recarga después de actualizar plan de abastecimiento');
        this.obtenerPlanesUseCase.execute().subscribe();
      }
      this.previousLoadingActualizar = loading;
    });

    // Effect: recargar después de eliminar
    effect(() => {
      const loading = this.store.loadingEliminar();
      const error = this.store.errorEliminar();

      if (this.previousLoadingEliminar && !loading && !error) {
        console.log('  Auto-recarga después de eliminar plan de abastecimiento');
        this.obtenerPlanesUseCase.execute().subscribe();
      }
      this.previousLoadingEliminar = loading;
    });
  }
}
