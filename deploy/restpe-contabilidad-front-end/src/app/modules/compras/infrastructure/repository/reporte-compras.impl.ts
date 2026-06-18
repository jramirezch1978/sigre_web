import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, catchError, map, of } from 'rxjs';
import { IReporteComprasRepository } from '../../domain/repositories/ireporte-compras.repository';
import { CompraProcesadaEntity } from '../../domain/models/compra-procesada.entity';
import { ApiClientService } from '../../../../core/infrastructure/http/api-client.service';

interface PageDto<T> {
  content?: T[];
}

/**
 * Repositorio del Reporte de Compras.
 *
 * Contrato esperado del backend (a implementar por el equipo de backend):
 *   GET /api/compras/reportes/compras
 *
 * Mientras el endpoint no exista, hace fallback al JSON de assets para que la
 * pantalla siga operativa. Cuando el backend esté disponible, se consume solo.
 */
@Injectable({ providedIn: 'root' })
export class ReporteComprasRepositoryImpl implements IReporteComprasRepository {

  private readonly http = inject(HttpClient);
  private readonly api = inject(ApiClientService);
  private readonly ENDPOINT = '/compras/reportes/compras';
  private readonly JSON_PATH = 'assets/data/compras/reportes/reporte-compras.json';

  obtenerReporte(): Observable<CompraProcesadaEntity[]> {
    return this.api.get<CompraProcesadaEntity[] | PageDto<CompraProcesadaEntity>>(this.ENDPOINT, { page: 0, size: 2000 }).pipe(
      map((response) => this.extraerLista(response)),
      catchError(() =>
        this.http.get<CompraProcesadaEntity[]>(this.JSON_PATH).pipe(catchError(() => of([] as CompraProcesadaEntity[])))
      )
    );
  }

  private extraerLista(response: CompraProcesadaEntity[] | PageDto<CompraProcesadaEntity> | null | undefined): CompraProcesadaEntity[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response!.content as CompraProcesadaEntity[];
    }
    return [];
  }
}
