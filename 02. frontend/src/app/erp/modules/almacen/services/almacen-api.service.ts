import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, forkJoin, map, of, switchMap } from 'rxjs';
import { ApiBaseService } from '../../../../services/api-base.service';
import { ApiResponse, PageData } from '../../../shared/models/api-page.model';

export interface AlmacenDto {
  id: number;
  sucursalId: number;
  sucursalNombre?: string;
  almacenTipoId: number;
  almacenTipoNombre?: string;
  codigo: string;
  nombre: string;
  flagEstado: string;
}

export interface AlmacenTipoDto {
  id: number;
  codigo: string;
  nombre: string;
  flagEstado: string;
}

export interface ArticuloMovTipoDto {
  id: number;
  tipoMov: string;
  descTipoMov: string;
  flagEstado: string;
  flagContabiliza?: string;
  codSunat?: string;
}

export interface MotivoTrasladoDto {
  id: number;
  codigo: string;
  nombre: string;
  flagEstado: string;
}

export interface UbicacionAlmacenDto {
  id: number;
  almacenId: number;
  codigo: string;
  nombre: string;
  pasillo?: string;
  estante?: string;
  nivel?: string;
  almacenCodigo?: string;
  almacenNombre?: string;
}

export interface AlmacenTipoMovDto {
  id: number;
  almacenId: number;
  articuloMovTipoId: number;
  tipoMov: string;
  descTipoMov: string;
  flagEstado: string;
  almacenCodigo?: string;
  almacenNombre?: string;
}

export interface LotePalletDto {
  id: number;
  almacenId: number;
  articuloId: number;
  nroLote: string;
  fechaProduccion?: string;
  fechaVencimiento?: string;
  observacion?: string;
  flagEstado: string;
}

@Injectable({ providedIn: 'root' })
export class AlmacenApiService {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);

  private get base(): string {
    return `${this.apiBase.getApiBaseUrl()}/almacen`;
  }

  listarPagina<T>(path: string, page = 0, size = 200, extraParams?: Record<string, string | number>): Observable<PageData<T>> {
    let params = new HttpParams()
      .set('page', String(page))
      .set('size', String(size));
    if (extraParams) {
      for (const [k, v] of Object.entries(extraParams)) {
        params = params.set(k, String(v));
      }
    }
    return this.http
      .get<ApiResponse<PageData<T>>>(`${this.base}${path}`, { params })
      .pipe(map(res => res.data ?? { content: [], page: { number: 0, size, totalElements: 0, totalPages: 0 } }));
  }

  listarTodoPaginado<T>(path: string, size = 200, extraParams?: Record<string, string | number>): Observable<T[]> {
    return this.listarPagina<T>(path, 0, size, extraParams).pipe(
      switchMap(first => {
        const items = [...(first.content ?? [])];
        const totalPages = first.page?.totalPages ?? 1;
        if (totalPages <= 1) return of(items);
        const rest = Array.from({ length: totalPages - 1 }, (_, i) =>
          this.listarPagina<T>(path, i + 1, size, extraParams).pipe(map(p => p.content ?? []))
        );
        return forkJoin(rest).pipe(map(pages => items.concat(...pages)));
      })
    );
  }

  listarAlmacenes(): Observable<AlmacenDto[]> {
    return this.listarTodoPaginado<AlmacenDto>('/almacenes');
  }

  listarTiposAlmacen(): Observable<AlmacenTipoDto[]> {
    return this.listarTodoPaginado<AlmacenTipoDto>('/almacen-tipos');
  }

  listarTiposMovimiento(): Observable<ArticuloMovTipoDto[]> {
    return this.listarTodoPaginado<ArticuloMovTipoDto>('/maestros/tipos-movimiento-catalogo');
  }

  listarMotivosTraslado(): Observable<MotivoTrasladoDto[]> {
    return this.listarTodoPaginado<MotivoTrasladoDto>('/maestros/motivos-traslado');
  }

  listarLotes(): Observable<LotePalletDto[]> {
    return this.listarTodoPaginado<LotePalletDto>('/lotes-pallets');
  }

  listarUbicacionesTodas(): Observable<UbicacionAlmacenDto[]> {
    return this.listarAlmacenes().pipe(
      switchMap(almacenes => {
        if (!almacenes.length) return of([]);
        return forkJoin(
          almacenes.map(a =>
            this.http
              .get<ApiResponse<UbicacionAlmacenDto[]>>(`${this.base}/almacenes/${a.id}/ubicaciones`)
              .pipe(
                map(res =>
                  (res.data ?? []).map(u => ({
                    ...u,
                    almacenCodigo: a.codigo,
                    almacenNombre: a.nombre,
                  }))
                )
              )
          )
        ).pipe(map(grupos => grupos.flat()));
      })
    );
  }

  listarMovimientosPorAlmacen(): Observable<AlmacenTipoMovDto[]> {
    return this.listarAlmacenes().pipe(
      switchMap(almacenes => {
        if (!almacenes.length) return of([]);
        return forkJoin(
          almacenes.map(a =>
            this.listarTodoPaginado<AlmacenTipoMovDto>(`/almacenes/${a.id}/tipos-movimiento`).pipe(
              map(items =>
                items.map(item => ({
                  ...item,
                  almacenCodigo: a.codigo,
                  almacenNombre: a.nombre,
                }))
              )
            )
          )
        ).pipe(map(grupos => grupos.flat()));
      })
    );
  }
}
