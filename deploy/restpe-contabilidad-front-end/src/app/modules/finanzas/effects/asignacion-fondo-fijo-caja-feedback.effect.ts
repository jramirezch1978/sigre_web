import { Injectable, inject, effect } from '@angular/core';
import { AsignacionFondoFijoCajaFacade } from '../application/facades/asignacion-fondo-fijo-caja.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class AsignacionFondoFijoCajaFeedbackEffects {
  private readonly facade = inject(AsignacionFondoFijoCajaFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar las asignaciones de fondo fijo: ${err}`);
      }
    });
  }
}
