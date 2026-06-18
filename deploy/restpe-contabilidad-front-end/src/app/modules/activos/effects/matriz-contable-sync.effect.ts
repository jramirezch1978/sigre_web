import { Injectable, inject, effect } from '@angular/core';
import { MatrizContableStore } from '../store/matriz-contable.store';
import { MatrizContableFacade } from '../application/facades/matriz-contable.facade';

/**
 * Effect que recarga la lista de Matriz Contable
 * automáticamente tras guardar, actualizar o eliminar.
 */
@Injectable()
export class MatrizContableSyncEffects {
  private readonly store  = inject(MatrizContableStore);
  private readonly facade = inject(MatrizContableFacade);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarMatrizContable();
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarMatrizContable();
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarMatrizContable();
      }
    });
  }
}
