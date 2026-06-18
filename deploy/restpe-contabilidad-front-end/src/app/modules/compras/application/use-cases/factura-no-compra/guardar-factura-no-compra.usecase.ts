import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { IFacturaNoCompraRepository } from '../../../domain/repositories/ifactura-no-compra.repository';
import { FacturaNoCompraEntity } from '../../../domain/models/factura-no-compra.entity';
import { FacturaNoCompraStore } from '../../../stores/factura-no-compra.store';

/**
 * Caso de uso: Guardar Factura No Compra
 */
@Injectable()
export class GuardarFacturaNoCompraUseCase {
  private readonly repository = inject(IFacturaNoCompraRepository);
  private readonly store = inject(FacturaNoCompraStore);

  execute(factura: FacturaNoCompraEntity) {
    this.store.setLoadingGuardar(true);
    this.store.setErrorGuardar(null);

    return this.repository.guardar(factura).pipe(
      tap((response) => {
        if (response.success) {
          console.log('  Factura no compra guardada:', response.data?.factura_no_compra_codigo);
        }
      }),
      catchError((error) => {
        const errorMsg = 'Error al guardar la factura no compra';
        this.store.setErrorGuardar(errorMsg);
        console.error(errorMsg, error);
        return of({ success: false, message: errorMsg, data: null as any });
      }),
      finalize(() => {
        this.store.setLoadingGuardar(false);
      })
    );
  }
}
