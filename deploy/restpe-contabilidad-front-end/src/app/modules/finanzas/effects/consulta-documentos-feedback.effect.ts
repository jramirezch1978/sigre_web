import { Injectable, inject, effect } from '@angular/core';
import { ConsultaDocumentosFacade } from '../application/facades/consulta-documentos.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class ConsultaDocumentosFeedbackEffects {
  private readonly facade = inject(ConsultaDocumentosFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar documentos: ${err}`);
      }
    });
  }
}
