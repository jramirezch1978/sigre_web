import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { ApiClientService, PageResponse } from '@core';
import { CotizacionEntity } from '@modules/compras/domain/models/cotizacion.entity';
import { ICotizacionRepository } from '@modules/compras/domain/repositories/icotizacion.repository';
import { ApiResponse } from '@shared';
import { delay, map, Observable } from 'rxjs';

/**
 * Implementación del repositorio de Cotizaciones - Infrastructure Layer
 * SRP: responsable exclusivamente del flujo de cotizaciones.
 * Consume el JSON de cotizaciones y simula transiciones de estado con delay.
 */
@Injectable({ providedIn: 'root' })
export class CotizacionRepositoryImpl implements ICotizacionRepository {
  //   private readonly JSON_PATH = 'assets/data/compras/cotizaciones-mock.json';
  private readonly apiService = inject(ApiClientService);
  private readonly http = inject(HttpClient);

  obtenerCotizaciones(): Observable<CotizacionEntity[]> {
    return this.apiService
      .get(`/compras/cotizaciones`, { page: 1, size: 100 })
      .pipe(
        map((apiResponse : any) => {
          console.log(apiResponse);
          return apiResponse.content;
        }),
      );

    // return this.http.get<CotizacionEntity[]>(`/api/compras/cotizaciones`);
    // return this.http.get<CotizacionEntity[]>(this.JSON_PATH).pipe(delay(800));
  }

  obtenerCotizacionPorId(id: string): Observable<CotizacionEntity | null> {
    // return this.http.get<CotizacionEntity[]>(`/api/compras/cotizaciones/${id}`);
    // return this.apiService.get<CotizacionEntity>(`/api/compras/cotizaciones/${id}`);
    return this.apiService.get<CotizacionEntity>(`/compras/cotizaciones/${id}`);
  }

  guardarCotizacion(
    cotizacion: CotizacionEntity,
  ): Observable<CotizacionEntity> {
    // return this.apiService.post<CotizacionEntity>(
    //   `/api/compras/cotizaciones`,
    //   cotizacion,
    return this.http.post<CotizacionEntity>(
      `/api/compras/cotizaciones`,
      cotizacion,
    );
  }
  actualizarCotizacion(
    cotizacion: CotizacionEntity,
  ): Observable<CotizacionEntity> {
    throw new Error('Method not implemented.');
  }
  eliminarCotizacion(id: string): Observable<boolean> {
    throw new Error('Method not implemented.');
  }
}
