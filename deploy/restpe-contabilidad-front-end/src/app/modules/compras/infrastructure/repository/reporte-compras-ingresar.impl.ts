import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, catchError, map, of } from 'rxjs';
import { IReporteComprasIngresarRepository } from '../../domain/repositories/ireporte-compras-ingresar.repository';
import { CompraPorIngresarEntity } from '../../domain/models/compra-por-ingresar.entity';
import { ApiClientService } from '../../../../core/infrastructure/http/api-client.service';

interface PageDto<T> {
  content?: T[];
}

/**
 * Repositorio del Reporte de Compras por Ingresar.
 *
 * Contrato esperado del backend (a implementar por el equipo de backend):
 *   GET /api/compras/reportes/compras-por-ingresar
 *
 * Mientras el endpoint no exista, hace fallback al JSON de assets para que la
 * pantalla siga operativa. Cuando el backend esté disponible, se consume solo.
 */
@Injectable({ providedIn: 'root' })
export class ReporteComprasIngresarRepositoryImpl implements IReporteComprasIngresarRepository {

  private readonly http = inject(HttpClient);
  private readonly api = inject(ApiClientService);
  private readonly ENDPOINT = '/compras/reportes/compras-por-ingresar';
  private readonly JSON_PATH = 'assets/data/compras/reportes/reporte-compras-ingresar.json';

  obtenerReporte(): Observable<CompraPorIngresarEntity[]> {
    return this.api.get<CompraPorIngresarEntity[] | PageDto<CompraPorIngresarEntity>>(this.ENDPOINT, { page: 0, size: 2000 }).pipe(
      map((response) => this.extraerLista(response)),
      catchError(() =>
        this.http.get<CompraPorIngresarEntity[]>(this.JSON_PATH).pipe(catchError(() => of([] as CompraPorIngresarEntity[])))
      )
    );
  }

  private extraerLista(response: CompraPorIngresarEntity[] | PageDto<CompraPorIngresarEntity> | null | undefined): CompraPorIngresarEntity[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response!.content as CompraPorIngresarEntity[];
    }
    return [];
  }
}
