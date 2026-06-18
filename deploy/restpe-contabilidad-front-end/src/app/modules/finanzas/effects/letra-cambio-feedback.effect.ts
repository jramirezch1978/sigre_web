import { Injectable, inject, effect } from '@angular/core';
import { LetraCambioFacade } from '../application/facades/letra-cambio.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class LetraCambioFeedbackEffects {
  private readonly facade = inject(LetraCambioFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    // Error al obtener
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar letras de cambio: ${err}`);
      }
    });

    // Error al guardar
    effect(() => {
      const err = this.facade.errorGuardar();
      if (err) {
        this.toast.danger(`Error al guardar la letra de cambio: ${err}`);
      }
    });

    // Error al actualizar
    effect(() => {
      const err = this.facade.errorActualizar();
      if (err) {
        this.toast.danger(`Error al actualizar la letra de cambio: ${err}`);
      }
    });
  }
}
