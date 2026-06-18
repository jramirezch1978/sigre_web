import { Injectable, inject, effect } from '@angular/core';
import { CondicionPagoStore } from '../store/condicion-pago.store';
import { CondicionPagoFacade } from '../application/facades/condicion-pago.facade';

/**
 * Effect para sincronizar el estado después de operaciones exitosas
 * - Recarga la lista de condiciones de pago después de guardar
 * - Recarga la lista de condiciones de pago después de actualizar
 * - Recarga la lista de condiciones de pago después de eliminar
 */
@Injectable()
export class CondicionPagoSyncEffects {

  private readonly store = inject(CondicionPagoStore);
  private readonly facade = inject(CondicionPagoFacade);

  constructor() {
    this.sincronizarDespuesDeGuardar();
    this.sincronizarDespuesDeActualizar();
    this.sincronizarDespuesDeEliminar();
  }

  /**
   * Recarga condiciones de pago después de guardar exitosamente
   */
  private sincronizarDespuesDeGuardar() {
    effect(() => {
      const result = this.store.resultGuardar();
      
      if (result?.success) {
        console.log('  Condición de pago guardada, sincronizando...');
        
        // Esperar un momento antes de recargar
        setTimeout(() => {
          this.facade.cargarCondicionesPago();
          
          // Limpiar resultado después de sincronizar
          this.store.resetResults();
        }, 500);
      }
    });
  }

  /**
   * Recarga condiciones de pago después de actualizar exitosamente
   */
  private sincronizarDespuesDeActualizar() {
    effect(() => {
      const result = this.store.resultActualizar();
      
      if (result?.success) {
        console.log('  Condición de pago actualizada, sincronizando...');
        
        setTimeout(() => {
          this.facade.cargarCondicionesPago();
          this.store.resetResults();
        }, 500);
      }
    });
  }

  /**
   * Recarga condiciones de pago después de eliminar exitosamente
   */
  private sincronizarDespuesDeEliminar() {
    effect(() => {
      const result = this.store.resultEliminar();
      
      if (result?.success) {
        console.log('  Condición de pago eliminada, sincronizando...');
        
        setTimeout(() => {
          this.facade.cargarCondicionesPago();
          this.store.resetResults();
        }, 500);
      }
    });
  }
}
