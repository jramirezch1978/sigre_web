import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { IFacturaNoCompraRepository } from '../../../domain/repositories/ifactura-no-compra.repository';
import { FacturaNoCompraStore } from '../../../stores/factura-no-compra.store';

/**
 * Caso de uso: Eliminar Factura No Compra (Anular)
 */
@Injectable()
export class EliminarFacturaNoCompraUseCase {
  private readonly repository = inject(IFacturaNoCompraRepository);
  private readonly store = inject(FacturaNoCompraStore);

  execute(codigo: string) {
    this.store.setLoadingEliminar(true);
    this.store.setErrorEliminar(null);

    return this.repository.eliminar(codigo).pipe(
      tap((response) => {
        if (response.success) {
          console.log('  Factura no compra anulada:', codigo);
        }
      }),
      catchError((error) => {
        const errorMsg = 'Error al anular la factura no compra';
        this.store.setErrorEliminar(errorMsg);
        console.error(errorMsg, error);
        return of({ success: false, message: errorMsg, data: false });
      }),
      finalize(() => {
        this.store.setLoadingEliminar(false);
      })
    );
  }
}
