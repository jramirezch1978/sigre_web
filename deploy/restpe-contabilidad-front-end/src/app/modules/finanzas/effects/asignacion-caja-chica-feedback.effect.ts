import { Injectable, inject, effect } from '@angular/core';
import { AsignacionCajaChicaFacade } from '../application/facades/asignacion-caja-chica.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class AsignacionCajaChicaFeedbackEffects {
  private readonly facade = inject(AsignacionCajaChicaFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar las asignaciones de caja chica: ${err}`);
      }
    });
  }
}
