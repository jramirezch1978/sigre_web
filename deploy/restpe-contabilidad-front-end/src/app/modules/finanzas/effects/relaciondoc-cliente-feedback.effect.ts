import { Injectable, inject, effect } from '@angular/core';
import { RelacionDocClienteFacade } from '../application/facades/relaciondoc-cliente.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class RelacionDocClienteFeedbackEffects {
  private readonly facade = inject(RelacionDocClienteFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    // Error al obtener documentos
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar documentos por cliente: ${err}`);
      }
    });
  }
}
