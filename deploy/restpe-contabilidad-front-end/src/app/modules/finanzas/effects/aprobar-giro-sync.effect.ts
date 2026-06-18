import { Injectable, inject, effect } from '@angular/core';
import { AprobarGiroFacade } from '../application/facades/aprobar-giro.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class AprobarGiroSyncEffects {
  private readonly facade = inject(AprobarGiroFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      if (this.facade.actualizadoOk()) {
        const mensaje = this.facade.mensajeExito();
        this.toast.success(mensaje ?? '¡Orden de giro actualizada exitosamente!');
        this.facade.limpiarExito();
        // Recargar la bandeja desde el backend: la orden aprobada/rechazada ya no es
        // Pendiente (sale de la lista) y se reflejan las nuevas solicitudes Pendientes.
        this.facade.cargarDatos();
      }
    });
  }
}
