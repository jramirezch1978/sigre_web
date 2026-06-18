import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, catchError, map, of } from 'rxjs';
import { IReporteAnalisisProveedoresRepository } from '../../domain/repositories/ireporte-analisis-proveedores.repository';
import { AnalisisProveedorEntity } from '../../domain/models/analisis-proveedor.entity';
import { ApiClientService } from '../../../../core/infrastructure/http/api-client.service';

interface PageDto<T> {
  content?: T[];
}

/**
 * Repositorio del Reporte de Análisis de Proveedores.
 *
 * Contrato esperado del backend (a implementar por el equipo de backend):
 *   GET /api/compras/reportes/analisis-proveedores
 *
 * Mientras el endpoint no exista, hace fallback al JSON de assets para que la
 * pantalla siga operativa. Cuando el backend esté disponible, se consume solo.
 */
@Injectable({ providedIn: 'root' })
export class ReporteAnalisisProveedoresRepositoryImpl implements IReporteAnalisisProveedoresRepository {

  private readonly http = inject(HttpClient);
  private readonly api = inject(ApiClientService);
  private readonly ENDPOINT = '/compras/reportes/analisis-proveedores';
  private readonly JSON_PATH = 'assets/data/compras/reportes/reporte-compras-analisis-proveedores.json';

  obtenerReporte(): Observable<AnalisisProveedorEntity[]> {
    return this.api.get<AnalisisProveedorEntity[] | PageDto<AnalisisProveedorEntity>>(this.ENDPOINT, { page: 0, size: 2000 }).pipe(
      map((response) => this.extraerLista(response)),
      catchError(() =>
        this.http.get<AnalisisProveedorEntity[]>(this.JSON_PATH).pipe(catchError(() => of([] as AnalisisProveedorEntity[])))
      )
    );
  }

  private extraerLista(response: AnalisisProveedorEntity[] | PageDto<AnalisisProveedorEntity> | null | undefined): AnalisisProveedorEntity[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response!.content as AnalisisProveedorEntity[];
    }
    return [];
  }
}
