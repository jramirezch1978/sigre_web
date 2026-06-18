import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, catchError, map, of } from 'rxjs';
import { IReporteComprasCategoriaRepository } from '../../domain/repositories/ireporte-compras-categoria.repository';
import { CompraPorCategoriaEntity } from '../../domain/models/compra-por-categoria.entity';
import { ApiClientService } from '../../../../core/infrastructure/http/api-client.service';

interface PageDto<T> {
  content?: T[];
}

/**
 * Repositorio del Reporte de Compras por Categoría.
 *
 * Contrato esperado del backend (a implementar por el equipo de backend):
 *   GET /api/compras/reportes/compras-categoria
 *
 * Mientras el endpoint no exista, hace fallback al JSON de assets para que la
 * pantalla siga operativa. Cuando el backend esté disponible, se consume solo.
 */
@Injectable({ providedIn: 'root' })
export class ReporteComprasCategoriaRepositoryImpl implements IReporteComprasCategoriaRepository {

  private readonly http = inject(HttpClient);
  private readonly api = inject(ApiClientService);
  private readonly ENDPOINT = '/compras/reportes/compras-categoria';
  private readonly JSON_PATH = 'assets/data/compras/reportes/reporte-compras-categoria.json';

  obtenerReporte(): Observable<CompraPorCategoriaEntity[]> {
    return this.api.get<CompraPorCategoriaEntity[] | PageDto<CompraPorCategoriaEntity>>(this.ENDPOINT, { page: 0, size: 2000 }).pipe(
      map((response) => this.extraerLista(response)),
      catchError(() =>
        this.http.get<CompraPorCategoriaEntity[]>(this.JSON_PATH).pipe(catchError(() => of([] as CompraPorCategoriaEntity[])))
      )
    );
  }

  private extraerLista(response: CompraPorCategoriaEntity[] | PageDto<CompraPorCategoriaEntity> | null | undefined): CompraPorCategoriaEntity[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response!.content as CompraPorCategoriaEntity[];
    }
    return [];
  }
}
