import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, catchError, map, of } from 'rxjs';
import { IReporteComprasSugeridasRepository } from '../../domain/repositories/ireporte-compras-sugeridas.repository';
import { SugerenciaCompraEntity } from '../../domain/models/sugerencia-compra.entity';
import { ApiClientService } from '../../../../core/infrastructure/http/api-client.service';

interface PageDto<T> {
  content?: T[];
}

/**
 * Repositorio del Reporte de Compras Sugeridas.
 *
 * Contrato esperado del backend (a implementar por el equipo de backend):
 *   GET /api/compras/reportes/compras-sugeridas
 *
 * Mientras el endpoint no exista, hace fallback al JSON de assets para que la
 * pantalla siga operativa. Cuando el backend esté disponible, se consume solo.
 */
@Injectable({ providedIn: 'root' })
export class ReporteComprasSugeridasRepositoryImpl implements IReporteComprasSugeridasRepository {

  private readonly http = inject(HttpClient);
  private readonly api = inject(ApiClientService);
  private readonly ENDPOINT = '/compras/reportes/compras-sugeridas';
  private readonly JSON_PATH = 'assets/data/compras/reportes/reporte-compras-sugeridas.json';

  obtenerReporte(): Observable<SugerenciaCompraEntity[]> {
    return this.api.get<SugerenciaCompraEntity[] | PageDto<SugerenciaCompraEntity>>(this.ENDPOINT, { page: 0, size: 2000 }).pipe(
      map((response) => this.extraerLista(response)),
      catchError(() =>
        this.http.get<SugerenciaCompraEntity[]>(this.JSON_PATH).pipe(catchError(() => of([] as SugerenciaCompraEntity[])))
      )
    );
  }

  private extraerLista(response: SugerenciaCompraEntity[] | PageDto<SugerenciaCompraEntity> | null | undefined): SugerenciaCompraEntity[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response!.content as SugerenciaCompraEntity[];
    }
    return [];
  }
}
