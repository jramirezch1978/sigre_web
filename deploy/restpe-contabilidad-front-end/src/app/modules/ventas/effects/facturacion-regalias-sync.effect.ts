import { effect, inject, Injectable } from '@angular/core';
import { FacturacionRegaliasStore } from '../store/facturacion-regalias.store';
import { FacturacionRegaliasFacade } from '../application/facades/facturacion-regalias.facade';

/**
 * @summary Efectos de sincronización para facturación de regalías.
 * @description
 * Reacciona automáticamente a resultados exitosos (guardar/anular) y
 * dispara la recarga de la lista para mantener el estado sincronizado.
 * No usa suscripciones manuales: todo es reactivo mediante Angular Signals.
 */
@Injectable()
export class FacturacionRegaliasSyncEffects {
  private readonly store = inject(FacturacionRegaliasStore);
  private readonly facade = inject(FacturacionRegaliasFacade);

  constructor() {
    this.refrescarDespuesDeGuardar();
    this.refrescarDespuesDeAnular();
  }

  private refrescarDespuesDeGuardar() {
    effect(() => {
      if (this.store.resultGuardar()) {
        this.facade.cargarFacturas();
      }
    });
  }

  private refrescarDespuesDeAnular() {
    effect(() => {
      if (this.store.resultAnular()) {
        this.facade.cargarFacturas();
      }
    });
  }
}
