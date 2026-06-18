import { Injectable, inject, effect } from '@angular/core';
import { FacturaNoCompraStore } from '../stores/factura-no-compra.store';
import { ObtenerFacturasNoCompraUseCase } from '../application/use-cases/factura-no-compra/obtener-facturas-no-compra.usecase';

/**
 * Effect: Sincronización de Factura No Compra
 * Auto-recarga las facturas después de guardar, actualizar o anular
 */
@Injectable()
export class FacturaNoCompraSyncEffects {
  private readonly store = inject(FacturaNoCompraStore);
  private readonly obtenerFacturasUseCase = inject(ObtenerFacturasNoCompraUseCase);

  private previousLoadingGuardar = false;
  private previousLoadingActualizar = false;
  private previousLoadingEliminar = false;

  constructor() {
    // Effect: recargar después de guardar
    effect(() => {
      const loading = this.store.loadingGuardar();
      const error = this.store.errorGuardar();

      if (this.previousLoadingGuardar && !loading && !error) {
        console.log('  Auto-recarga después de guardar factura no compra');
        this.obtenerFacturasUseCase.execute().subscribe();
      }
      this.previousLoadingGuardar = loading;
    });

    // Effect: recargar después de actualizar
    effect(() => {
      const loading = this.store.loadingActualizar();
      const error = this.store.errorActualizar();

      if (this.previousLoadingActualizar && !loading && !error) {
        console.log('  Auto-recarga después de actualizar factura no compra');
        this.obtenerFacturasUseCase.execute().subscribe();
      }
      this.previousLoadingActualizar = loading;
    });

    // Effect: recargar después de anular
    effect(() => {
      const loading = this.store.loadingEliminar();
      const error = this.store.errorEliminar();

      if (this.previousLoadingEliminar && !loading && !error) {
        console.log('  Auto-recarga después de anular factura no compra');
        this.obtenerFacturasUseCase.execute().subscribe();
      }
      this.previousLoadingEliminar = loading;
    });
  }
}
