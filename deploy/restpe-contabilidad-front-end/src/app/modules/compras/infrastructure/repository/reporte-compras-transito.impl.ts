import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, catchError, map, of } from 'rxjs';
import { IReporteComprasTransitoRepository } from '../../domain/repositories/ireporte-compras-transito.repository';
import { CompraTransitoEntity } from '../../domain/models/compra-transito.entity';
import { ApiClientService } from '../../../../core/infrastructure/http/api-client.service';

interface PageDto<T> {
  content?: T[];
}

/**
 * Repositorio del Reporte de Compras en Tránsito.
 *
 * Contrato esperado del backend (a implementar por el equipo de backend):
 *   GET /api/compras/reportes/compras-transito
 *
 * Mientras el endpoint no exista, hace fallback al JSON de assets para que la
 * pantalla siga operativa. Cuando el backend esté disponible, se consume solo.
 */
@Injectable({ providedIn: 'root' })
export class ReporteComprasTransitoRepositoryImpl implements IReporteComprasTransitoRepository {

  private readonly http = inject(HttpClient);
  private readonly api = inject(ApiClientService);
  private readonly ENDPOINT = '/compras/reportes/compras-transito';
  private readonly JSON_PATH = 'assets/data/compras/reportes/reporte-compras-transito.json';

  obtenerReporte(): Observable<CompraTransitoEntity[]> {
    return this.api.get<CompraTransitoEntity[] | PageDto<CompraTransitoEntity>>(this.ENDPOINT, { page: 0, size: 2000 }).pipe(
      map((response) => this.extraerLista(response)),
      catchError(() =>
        this.http.get<CompraTransitoEntity[]>(this.JSON_PATH).pipe(catchError(() => of([] as CompraTransitoEntity[])))
      )
    );
  }

  private extraerLista(response: CompraTransitoEntity[] | PageDto<CompraTransitoEntity> | null | undefined): CompraTransitoEntity[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response!.content as CompraTransitoEntity[];
    }
    return [];
  }
}
