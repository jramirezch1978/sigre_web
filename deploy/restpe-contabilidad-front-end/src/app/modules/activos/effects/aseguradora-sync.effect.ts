import { Injectable, inject, effect } from '@angular/core';
import { AseguradoraStore } from '../store/aseguradora.store';
import { AseguradoraFacade } from '../application/facades/aseguradora.facade';

/**
 * Effects de sincronización para Aseguradoras.
 * Recarga la lista automáticamente tras guardar, actualizar o eliminar.
 * Usa Angular Signals (effect) — sin suscripciones manuales.
 */
@Injectable()
export class AseguradoraSyncEffects {
  private readonly store  = inject(AseguradoraStore);
  private readonly facade = inject(AseguradoraFacade);

  constructor() {
    this.refrescarDespuesDeGuardar();
    this.refrescarDespuesDeEliminar();
    this.refrescarDespuesDeActualizar();
  }

  private refrescarDespuesDeGuardar(): void {
    effect(() => {
      if (this.store.resultGuardar()) {
        this.facade.cargarAseguradoras();
      }
    });
  }

  private refrescarDespuesDeEliminar(): void {
    effect(() => {
      if (this.store.resultEliminar()) {
        this.facade.cargarAseguradoras();
      }
    });
  }

  private refrescarDespuesDeActualizar(): void {
    effect(() => {
      if (this.store.resultActualizar()) {
        this.facade.cargarAseguradoras();
      }
    });
  }
}
