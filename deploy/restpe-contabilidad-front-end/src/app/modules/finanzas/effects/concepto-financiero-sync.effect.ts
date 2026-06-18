import { Injectable, inject, effect } from '@angular/core';
import { ConceptoFinancieroStore } from '../store/concepto-financiero.store';
import { ConceptoFinancieroFacade } from '../application/facades/concepto-financiero.facade';

/**
 * @summary Sync effects para concepto financiero.
 * @description
 * Recarga la lista después de guardar o actualizar un concepto con éxito.
 */
@Injectable()
export class ConceptoFinancieroSyncEffects {

  private readonly store  = inject(ConceptoFinancieroStore);
  private readonly facade = inject(ConceptoFinancieroFacade);

  constructor() {
    this.recargarDespuesDeGuardar();
    this.recargarDespuesDeActualizar();
  }

  private recargarDespuesDeGuardar() {
    effect(() => {
      if (this.store.resultGuardar()) {
        // El item ya fue agregado en el facade; no recargar del JSON
      }
    });
  }

  private recargarDespuesDeActualizar() {
    effect(() => {
      if (this.store.resultActualizar()) {
        this.facade.cargarConceptos();
      }
    });
  }
}
