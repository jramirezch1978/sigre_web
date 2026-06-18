import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { AprobarServicioStore } from '../stores/aprobar-servicio.store';

/**
 * Effects de feedback (toasts) para el flujo de Aprobación de Servicios
 * Detecta transiciones loading → done y muestra toasts de éxito o error
 */
@Injectable()
export class AprobarServicioFeedbackEffects {
  private readonly store = inject(AprobarServicioStore);
  private readonly toastService = inject(ToastService);

  constructor() {
    let previousLoadingAprobar  = false;
    let previousLoadingRechazar = false;
    let previousLoadingRetornar = false;

    // Effect: Toast al aprobar
    effect(() => {
      const isLoading = this.store.loadingAprobar();
      const error     = this.store.errorAprobar();

      if (previousLoadingAprobar && !isLoading) {
        if (error) {
          this.toastService.danger('Error al aprobar la orden de servicio: ' + error);
        } else {
          this.toastService.success('¡Orden de servicio aprobada exitosamente!');
        }
      }
      previousLoadingAprobar = isLoading;
    });

    // Effect: Toast al rechazar
    effect(() => {
      const isLoading = this.store.loadingRechazar();
      const error     = this.store.errorRechazar();

      if (previousLoadingRechazar && !isLoading) {
        if (error) {
          this.toastService.danger('Error al rechazar la orden de servicio: ' + error);
        } else {
          this.toastService.success('Orden de servicio rechazada correctamente');
        }
      }
      previousLoadingRechazar = isLoading;
    });

    // Effect: Toast al retornar
    effect(() => {
      const isLoading = this.store.loadingRetornar();
      const error     = this.store.errorRetornar();

      if (previousLoadingRetornar && !isLoading) {
        if (error) {
          this.toastService.danger('Error al retornar la orden de servicio: ' + error);
        } else {
          this.toastService.success('Orden de servicio retornada al emisor');
        }
      }
      previousLoadingRetornar = isLoading;
    });
  }
}
