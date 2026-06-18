import { Injectable, inject, effect } from '@angular/core';
import { LetraCambioFacade } from '../application/facades/letra-cambio.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class LetraCambioSyncEffects {
  private readonly facade = inject(LetraCambioFacade);
  private readonly toast = inject(ToastService);

  private _prevLoadingGuardar = false;

  constructor() {
    // Éxito al guardar
    effect(() => {
      const loading = this.facade.loadingGuardar();
      const error = this.facade.errorGuardar();
      if (this._prevLoadingGuardar && !loading && !error) {
        this.toast.success('¡Letra registrada exitosamente!');
      }
      this._prevLoadingGuardar = loading;
    });


  }
}
