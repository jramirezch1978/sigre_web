import { Injectable, inject, effect } from '@angular/core';
import { ClasifActivoStore } from '../store/clasif-activo.store';
import { ClasifActivoFacade } from '../application/facades/clasif-activo.facade';

/**
 * Effects de sincronización para Clasificación de Activos.
 * Recarga la lista automáticamente tras guardar, actualizar o eliminar.
 * Usa Angular Signals (effect) — sin suscripciones manuales.
 */
@Injectable()
export class ClasifActivoSyncEffects {
  private readonly store  = inject(ClasifActivoStore);
  private readonly facade = inject(ClasifActivoFacade);

  constructor() {
    this.refrescarDespuesDeGuardar();
    this.refrescarDespuesDeEliminar();
    this.refrescarDespuesDeActualizar();
  }

  private refrescarDespuesDeGuardar(): void {
    effect(() => {
      if (this.store.resultGuardar()) {
        this.facade.cargarClasifActivos();
      }
    });
  }

  private refrescarDespuesDeEliminar(): void {
    effect(() => {
      if (this.store.resultEliminar()) {
        this.facade.cargarClasifActivos();
      }
    });
  }

  private refrescarDespuesDeActualizar(): void {
    effect(() => {
      if (this.store.resultActualizar()) {
        this.facade.cargarClasifActivos();
      }
    });
  }
}
