import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { CotizacionStore } from '@modules/compras/stores/cotizacion.store';
import { ICotizacionRepository } from '@modules/compras/domain/repositories/icotizacion.repository';

/**
 * Caso de uso: Obtener Cotizaciones
 * Obtiene todas las cotizaciones desde el repositorio y actualiza el store
 */
@Injectable()
export class ObtenerCotizacionesUseCase {
  private readonly repository = inject(ICotizacionRepository);
  private readonly store = inject(CotizacionStore);

  execute() {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    return this.repository.obtenerCotizaciones().pipe(
      tap((cotizaciones) => {
        this.store.setCotizaciones(cotizaciones);
        console.log('  Cotizaciones cargadas:', cotizaciones.length);
      }),
      catchError((error) => {
        const errorMsg = 'Error al obtener cotizaciones';
        this.store.setErrorObtener(errorMsg);
        console.error(errorMsg, error);
        return of([]);
      }),
      finalize(() => {
        this.store.setLoadingObtener(false);
      }),
    );
  }
}
