import { effect, inject, Injectable } from '@angular/core';
import { ActivoFijoStore } from '../store/activo-fijo.store';
import { ActivoFijoFacade } from '../application/facades/activo-fijo.facade';

/**
 * Effects de sincronización para Activos Fijos.
 * Recarga la lista automáticamente tras guardar, actualizar o eliminar.
 * Usa Angular Signals (effect) — sin suscripciones manuales.
 */
@Injectable()
export class ActivoFijoSyncEffects {
  private readonly store  = inject(ActivoFijoStore);
  private readonly facade = inject(ActivoFijoFacade);

  constructor() {
    this.refrescarDespuesDeGuardar();
    this.refrescarDespuesDeEliminar();
    this.refrescarDespuesDeActualizar();
  }

  private refrescarDespuesDeGuardar(): void {
    effect(() => {
      if (this.store.resultGuardar()) {
        this.facade.cargarActivosFijos();
      }
    });
  }

  private refrescarDespuesDeEliminar(): void {
    effect(() => {
      if (this.store.resultEliminar()) {
        this.facade.cargarActivosFijos();
      }
    });
  }

  private refrescarDespuesDeActualizar(): void {
    effect(() => {
      if (this.store.resultActualizar()) {
        this.facade.cargarActivosFijos();
      }
    });
  }
}
