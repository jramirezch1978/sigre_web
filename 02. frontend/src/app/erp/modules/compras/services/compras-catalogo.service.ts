import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, forkJoin, map, of, switchMap } from 'rxjs';
import { ApiBaseService } from '../../../../services/api-base.service';
import { ApiResponse, PageData } from '../../../shared/models/api-page.model';

/** CRUD genérico para maestros de catálogo de core (marcas, colores, categorías, etc.). */
@Injectable({ providedIn: 'root' })
export class ComprasCatalogoService {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);

  /** endpoint relativo al servicio base (core por defecto), p.ej. '/marcas', '/articulos'. */
  private url(endpoint: string, base: 'core' | 'compras' = 'core'): string {
    return `${this.apiBase.getApiBaseUrl()}/${base}${endpoint}`;
  }

  /** Lista todas las filas (recorre páginas). */
  listar<T>(endpoint: string, size = 200, base: 'core' | 'compras' = 'core'): Observable<T[]> {
    return this.pagina<T>(endpoint, 0, size, base).pipe(
      switchMap(first => {
        const items = [...(first.content ?? [])];
        const totalPages = first.page?.totalPages ?? 1;
        if (totalPages <= 1) return of(items);
        const rest = Array.from({ length: totalPages - 1 }, (_, i) =>
          this.pagina<T>(endpoint, i + 1, size, base).pipe(map(p => p.content ?? [])),
        );
        return forkJoin(rest).pipe(map(pages => items.concat(...pages)));
      }),
    );
  }

  crear(endpoint: string, body: Record<string, unknown>, base: 'core' | 'compras' = 'core'): Observable<unknown> {
    return this.http.post<ApiResponse<unknown>>(this.url(endpoint, base), body).pipe(map(r => r.data));
  }

  actualizar(endpoint: string, id: number, body: Record<string, unknown>, base: 'core' | 'compras' = 'core'): Observable<unknown> {
    return this.http.put<ApiResponse<unknown>>(`${this.url(endpoint, base)}/${id}`, body).pipe(map(r => r.data));
  }

  eliminar(endpoint: string, id: number, base: 'core' | 'compras' = 'core'): Observable<unknown> {
    return this.http.delete<ApiResponse<unknown>>(`${this.url(endpoint, base)}/${id}`).pipe(map(r => r.data));
  }

  desactivar(endpoint: string, id: number, base: 'core' | 'compras' = 'core'): Observable<unknown> {
    return this.http.patch<ApiResponse<unknown>>(`${this.url(endpoint, base)}/${id}/desactivar`, {}).pipe(map(r => r.data));
  }

  private pagina<T>(endpoint: string, page: number, size: number, base: 'core' | 'compras' = 'core'): Observable<PageData<T>> {
    const params = new HttpParams().set('page', String(page)).set('size', String(size));
    return this.http
      .get<ApiResponse<PageData<T>>>(this.url(endpoint, base), { params })
      .pipe(map(res => res.data ?? ({ content: [], page: { number: 0, size, totalElements: 0, totalPages: 0 } } as PageData<T>)));
  }
}
