import { Injectable, inject, effect } from '@angular/core';
import { GeneracionDevengoAseguradoresStore } from '../store/generacion-devengo-aseguradores.store';
import { GeneracionDevengoAseguradoresFacade } from '../application/facades/generacion-devengo-aseguradores.facade';

@Injectable()
export class GeneracionDevengoAseguradoresSyncEffects {
  private readonly store  = inject(GeneracionDevengoAseguradoresStore);
  private readonly facade = inject(GeneracionDevengoAseguradoresFacade);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarDevengo();
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarDevengo();
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarDevengo();
      }
    });
  }
}
