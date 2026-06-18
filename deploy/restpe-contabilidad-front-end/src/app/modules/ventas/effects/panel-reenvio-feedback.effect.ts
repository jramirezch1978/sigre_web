import { Injectable, inject, effect } from '@angular/core';
import { PanelReenvioStore } from '../store/panel-reenvio.store';
import { ToastService } from '../../../ui/services/toast.service';

@Injectable()
export class PanelReenvioFeedbackEffects {

  private readonly store = inject(PanelReenvioStore);
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
