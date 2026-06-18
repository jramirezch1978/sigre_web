import { Injectable, inject, effect } from '@angular/core';
import { RelacionDocProveedorFacade } from '../application/facades/relaciondoc-proveedor.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class RelacionDocProveedorFeedbackEffects {
  private readonly facade = inject(RelacionDocProveedorFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    // Error al obtener documentos
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar documentos por proveedor: ${err}`);
      }
    });
  }
}
