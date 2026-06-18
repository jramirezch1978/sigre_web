import { Injectable, effect, inject } from '@angular/core';
import { GestionCatalogoStore } from '../store/gestion-catalogo.store';

@Injectable()
export class GestionCatalogoSyncEffects {
  private readonly store = inject(GestionCatalogoStore);

  private readonly recargarTrasGuardarEffect = effect(() => {
    const result = this.store.resultGuardar();
    if (result?.success && result.data) {
      this.store.setResultGuardar(null);
      this.store.addDocumento(result.data);
    }
  });

  private readonly recargarTrasActualizarEffect = effect(() => {
    const result = this.store.resultActualizar();
    if (result?.success && result.data) {
      this.store.setResultActualizar(null);
      this.store.updateDocumento(result.data);
    }
  });
}
