import { Injectable, inject, effect } from '@angular/core';
import { ProveedorStore } from '../store/proveedor.store';
import { ProveedorFacade } from '../application/facades/proveedor.facade';

/**
 * Effect para sincronizar el estado después de operaciones exitosas
 * - Recarga la lista de proveedores después de guardar
 * - Recarga la lista de proveedores después de actualizar
 * - Recarga la lista de proveedores después de eliminar
 */
@Injectable()
export class ProveedorSyncEffects {

  private readonly store = inject(ProveedorStore);
  private readonly facade = inject(ProveedorFacade);

  constructor() {
    this.sincronizarDespuesDeGuardar();
    this.sincronizarDespuesDeActualizar();
    this.sincronizarDespuesDeEliminar();
  }

  /**
   * Recarga proveedores después de guardar exitosamente
   */
  private sincronizarDespuesDeGuardar() {
    effect(() => {
      const result = this.store.resultGuardar();
      
      if (result?.success) {
        console.log('  Proveedor guardado, sincronizando...');
        
        // Esperar un momento antes de recargar
        setTimeout(() => {
          this.facade.cargarProveedores();
          
          // Limpiar resultado después de sincronizar
          this.store.resetResults();
        }, 500);
      }
    });
  }

  /**
   * Recarga proveedores después de actualizar exitosamente
   */
  private sincronizarDespuesDeActualizar() {
    effect(() => {
      const result = this.store.resultActualizar();
      
      if (result?.success) {
        console.log('  Proveedor actualizado, sincronizando...');
        
        setTimeout(() => {
          this.facade.cargarProveedores();
          this.store.resetResults();
        }, 500);
      }
    });
  }

  /**
   * Recarga proveedores después de eliminar exitosamente
   */
  private sincronizarDespuesDeEliminar() {
    effect(() => {
      const result = this.store.resultEliminar();
      
      if (result?.success) {
        console.log('  Proveedor eliminado, sincronizando...');
        
        setTimeout(() => {
          this.facade.cargarProveedores();
          this.store.resetResults();
        }, 500);
      }
    });
  }
}
