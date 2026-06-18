import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { DocumentoClienteFacade } from '../application/facades/documento-cliente.facade';

@Injectable()
export class DocumentoClienteFeedbackEffects {
  private readonly facade = inject(DocumentoClienteFacade);
  private readonly toastService = inject(ToastService);

  constructor() {
    effect(() => {
      const error = this.facade.error();
      if (error) {
        this.toastService.danger(error);
      }
    });
  }
}
