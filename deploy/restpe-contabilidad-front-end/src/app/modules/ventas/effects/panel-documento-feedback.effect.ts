import { Injectable, inject, effect } from '@angular/core';
import { PanelDocumentoStore } from '../store/panel-documento.store';
import { ToastService } from '../../../ui/services/toast.service';

@Injectable()
export class PanelDocumentoFeedbackEffects {

  private readonly store = inject(PanelDocumentoStore);
  private readonly toast = inject(ToastService);

  constructor() {
    this.errorEffect();
  }

  private errorEffect() {
    effect(() => {
      const error = this.store.error();
      if (error) {
        this.toast.danger(error);
        this.store.setError(null);
      }
    });
  }
}
