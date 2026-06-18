import { Injectable, inject, effect } from '@angular/core';
import { TransaccionPeriodicaFacade } from '../application/facades/transaccion-periodica.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class TransaccionPeriodicaFeedbackEffects {
  private readonly facade = inject(TransaccionPeriodicaFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    // Éxito al guardar
    effect(() => {
      const result = this.facade.resultGuardar();
      if (result?.success) {
        this.toast.success('¡Transacción registrada exitosamente!');
      }
    });

    // Éxito al actualizar
    effect(() => {
      const result = this.facade.resultActualizar();
      if (result?.success) {
        this.toast.success('¡Transacción actualizada exitosamente!');
      }
    });

    // Error al obtener
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar transacciones periódicas: ${err}`);
      }
    });

    // Error al guardar
    effect(() => {
      const err = this.facade.errorGuardar();
      if (err) {
        this.toast.danger(`Error al registrar la transacción: ${err}`);
      }
    });

    // Error al actualizar
    effect(() => {
      const err = this.facade.errorActualizar();
      if (err) {
        this.toast.danger(`Error al actualizar la transacción: ${err}`);
      }
    });
  }
}
