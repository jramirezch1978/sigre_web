import { Injectable, effect, inject } from '@angular/core';
import { CanjeReprogramacionStore } from '../store/canje-reprogramacion.store';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class CanjeReprogramacionFeedbackEffects {
  private readonly store = inject(CanjeReprogramacionStore);
  private readonly toast = inject(ToastService);

  private readonly canjeExitoEffect = effect(() => {
    const result = this.store.resultCanje();
    if (result?.success) {
      this.toast.success('¡Canje aplicado exitosamente!');
    }
  });

  private readonly reprogramarExitoEffect = effect(() => {
    const result = this.store.resultReprogramar();
    if (result?.success) {
      this.toast.success('¡Vencimiento reprogramado exitosamente!');
    }
  });

  private readonly errorObtenerEffect = effect(() => {
    const error = this.store.errorObtener();
    if (error) {
      this.toast.danger(error);
      this.store.setErrorObtener(null);
    }
  });

  private readonly errorCanjeEffect = effect(() => {
    const error = this.store.errorCanje();
    if (error) {
      this.toast.danger(error);
      this.store.setErrorCanje(null);
    }
  });

  private readonly errorReprogramarEffect = effect(() => {
    const error = this.store.errorReprogramar();
    if (error) {
      this.toast.danger(error);
      this.store.setErrorReprogramar(null);
    }
  });
}
