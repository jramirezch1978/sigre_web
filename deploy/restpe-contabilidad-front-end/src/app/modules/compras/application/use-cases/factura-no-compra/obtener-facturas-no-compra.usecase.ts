import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { IFacturaNoCompraRepository } from '../../../domain/repositories/ifactura-no-compra.repository';
import { FacturaNoCompraStore } from '../../../stores/factura-no-compra.store';

/**
 * Caso de uso: Obtener Facturas No Compras
 */
@Injectable()
export class ObtenerFacturasNoCompraUseCase {
  private readonly repository = inject(IFacturaNoCompraRepository);
  private readonly store = inject(FacturaNoCompraStore);

  execute() {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    return this.repository.obtenerFacturas().pipe(
      tap((facturas) => {
        this.store.setFacturas(facturas);
        console.log('📄 Facturas no compras cargadas:', facturas.length);
      }),
      catchError((error) => {
        const errorMsg = 'Error al obtener facturas no compras';
        this.store.setErrorObtener(errorMsg);
        console.error(errorMsg, error);
        return of([]);
      }),
      finalize(() => {
        this.store.setLoadingObtener(false);
      })
    );
  }
}
