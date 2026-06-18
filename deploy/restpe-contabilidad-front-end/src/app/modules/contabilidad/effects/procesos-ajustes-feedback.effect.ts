import { Injectable, effect, inject, untracked } from '@angular/core';
import { ProcesosAjustesStore } from '../store/procesos-ajustes.store';
import { ToastService } from '../../../ui/services/toast.service';
import { PROCESOS_AJUSTES_MENSAJES_FALLBACK } from '../constants/procesos-ajustes.constants';

/**
 * ProcesosAjustesFeedbackEffects — Efectos de retroalimentación de UI.
 * Escucha errores del store y muestra notificaciones toast.
 */
@Injectable()
export class ProcesosAjustesFeedbackEffects {

  private readonly store = inject(ProcesosAjustesStore);
  private readonly toast = inject(ToastService);

  constructor() {
    this.obtenerEffect();
  }

  private obtenerEffect(): void {
    effect(() => {
      const error = this.store.errorObtener();

      if (error) {
        untracked(() => {
          this.toast.danger(
            error || PROCESOS_AJUSTES_MENSAJES_FALLBACK.ERROR_CARGA
          );
          this.store.setErrorObtener(null);
        });
      }
    });
  }
}
