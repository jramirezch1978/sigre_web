import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, forkJoin, map, of, switchMap } from 'rxjs';
import { ApiBaseService } from '../../../../services/api-base.service';
import { ApiResponse, PageData } from '../../../shared/models/api-page.model';

/** Relación comercial (proveedor/cliente) = core.entidad_contribuyente. Maestro CM002. */
export interface RelacionComercialDto {
  id: number;
  razonSocial: string;
  nombreComercial?: string;
  nroDocumento?: string;
  direccion?: string;
  telefono?: string;
  email?: string;
  esProveedor?: boolean;
  esCliente?: boolean;
  tipoEntidadContribuyenteId?: number;
  flagEstado: string;
}

@Injectable({ providedIn: 'root' })
export class ComprasApiService {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);

  /** El maestro de relaciones comerciales vive en core-service (core.entidad_contribuyente). */
  private get coreBase(): string {
    return `${this.apiBase.getApiBaseUrl()}/core`;
  }

  /** Lista todas las relaciones comerciales (proveedores/clientes). */
  listarRelaciones(): Observable<RelacionComercialDto[]> {
    return this.listarTodoPaginado<RelacionComercialDto>('/relaciones-comerciales');
  }

  private listarPagina<T>(path: string, page: number, size: number): Observable<PageData<T>> {
    const params = new HttpParams().set('page', String(page)).set('size', String(size));
    return this.http
      .get<ApiResponse<PageData<T>>>(`${this.coreBase}${path}`, { params })
      .pipe(map(res => res.data ?? ({ content: [], page: { number: 0, size, totalElements: 0, totalPages: 0 } } as PageData<T>)));
  }

  private listarTodoPaginado<T>(path: string, size = 200): Observable<T[]> {
    return this.listarPagina<T>(path, 0, size).pipe(
      switchMap(first => {
        const items = [...(first.content ?? [])];
        const totalPages = first.page?.totalPages ?? 1;
        if (totalPages <= 1) return of(items);
        const rest = Array.from({ length: totalPages - 1 }, (_, i) =>
          this.listarPagina<T>(path, i + 1, size).pipe(map(p => p.content ?? []))
        );
        return forkJoin(rest).pipe(map(pages => items.concat(...pages)));
      })
    );
  }
}
