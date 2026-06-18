import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { CotizacionStore } from '@modules/compras/stores/cotizacion.store';
import { ICotizacionRepository } from '@modules/compras/domain/repositories/icotizacion.repository';
import { CotizacionEntity } from '@modules/compras/domain/models/cotizacion.entity';

/**
 * Caso de uso: Obtener Cotizaciones
 * Obtiene todas las cotizaciones desde el repositorio y actualiza el store
 */
@Injectable()
export class GuardarCotizacionUseCase {
  private readonly repository = inject(ICotizacionRepository);
  private readonly store = inject(CotizacionStore);

  execute(cotizacion: Partial<CotizacionEntity>) {
    this.store.setLoadingGuardar(true);
    this.store.setErrorGuardar(null);

    return this.repository.guardarCotizacion(cotizacion).pipe(
      tap((response) => {
        if (response["success"]) {
          console.log('  Cotizacion guardada:', cotizacion);
        }
      }),
      catchError((error) => {
        const errorMsg = 'Error al guardar cotizacion';
        this.store.setErrorGuardar(errorMsg);
        console.error(errorMsg, error);
        return of({ success: false, message: errorMsg, data: null as any });
      }),
      finalize(() => {
        this.store.setLoadingGuardar(false);
      }),
    );
  }
}
