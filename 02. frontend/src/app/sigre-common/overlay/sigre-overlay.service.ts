import { Injectable, inject } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';

/**
 * Cierra todas las ventanas/overlays abiertos. Cubre tanto los diálogos de Angular Material
 * (MatDialog, usados por el ERP) como los overlays de Ionic (ion-modal/popover/alert/etc.,
 * usados por administración). Se invoca al cerrar sesión y al expirar la sesión, para que no
 * quede ningún popup encima del login.
 */
@Injectable({ providedIn: 'root' })
export class SigreOverlayService {

  private readonly dialog = inject(MatDialog, { optional: true });

  private static readonly SELECTORES_IONIC = [
    'ion-modal', 'ion-popover', 'ion-action-sheet', 'ion-alert', 'ion-loading', 'ion-picker',
  ];

  /** Cierra todos los diálogos Material y descarta los overlays Ionic abiertos. */
  async cerrarTodos(): Promise<void> {
    try {
      this.dialog?.closeAll();
    } catch { /* noop */ }

    for (const selector of SigreOverlayService.SELECTORES_IONIC) {
      document.querySelectorAll(selector).forEach((el: unknown) => {
        const overlay = el as { dismiss?: () => Promise<unknown> };
        try { void overlay.dismiss?.(); } catch { /* noop */ }
      });
    }
    // Pequeña espera para que terminen las animaciones de cierre antes de navegar al login.
    await new Promise(resolve => setTimeout(resolve, 60));
  }
}
