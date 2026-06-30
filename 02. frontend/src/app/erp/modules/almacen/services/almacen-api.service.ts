import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, forkJoin, map, of, switchMap } from 'rxjs';
import { ApiBaseService } from '../../../../services/api-base.service';
import { ApiResponse, PageData } from '../../../shared/models/api-page.model';

export interface AlmacenDto {
  id: number;
  sucursalId: number;
  sucursalCodigo?: string;
  sucursalNombre?: string;
  almacenTipoId?: number;
  almacenTipoCodigo?: string;
  almacenTipoNombre?: string;
  centrosCostoId?: number;
  centrosCostoCodigo?: string;
  centrosCostoNombre?: string;
  proveedorEntidadId?: number;
  proveedorDocumento?: string;
  proveedorNombre?: string;
  responsableUsuarioId?: number;
  codigo: string;
  nombre: string;
  direccion?: string;
  areaTotal?: number;
  volTotal?: number;
  flagCntrlLote?: string;
  distritoId?: number;
  codSunat?: string;
  flagVirtual?: string;
  ubigeo?: number;
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

export interface MovimientoListItemDto {
  id: number;
  sucursalId?: number;
  almacenId?: number;
  articuloMovTipoId?: number;
  nroVale?: string;
  tipoReferenciaOrigen?: string;
  fechaMov?: string;
  flagEstado?: string;
}

export interface DiagnosticoAlmacenDto {
  almacenId: number;
  almacenCodigo: string;
  almacenNombre: string;
  totalArticulos: number;
  totalUnidades: number;
  valorInventario: number;
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

  listarMovimientosPeriodo(
    fechaDesde: string,
    fechaHasta: string,
    estado = '1'
  ): Observable<MovimientoListItemDto[]> {
    return this.listarTodoPaginado<MovimientoListItemDto>('/movimientos', 500, {
      fechaDesde,
      fechaHasta,
      estado,
    });
  }

  obtenerDiagnostico(): Observable<DiagnosticoAlmacenDto[]> {
    return this.http
      .get<ApiResponse<DiagnosticoAlmacenDto[]>>(`${this.base}/reportes/diagnostico`)
      .pipe(map(res => res.data ?? []));
  }

  /** Catálogo TG_UBIGEO para el select de ubigeo. value = id (FK). */
  listarUbigeos(): Observable<{ value: number; label: string }[]> {
    return this.http
      .get<ApiResponse<{ value: number; label: string }[]>>(`${this.base}/ubigeos`)
      .pipe(map(res => res.data ?? []));
  }

  listarTiposAlmacen(): Observable<AlmacenTipoDto[]> {
    return this.listarTodoPaginado<AlmacenTipoDto>('/almacen-tipos');
  }

  listarTiposMovimiento(): Observable<ArticuloMovTipoDto[]> {
    return this.listarTodoPaginado<ArticuloMovTipoDto>('/maestros/tipos-movimiento-catalogo');
  }

  /** Tipos de movimiento ASIGNADOS a un almacén (almacen.almacen_tipo_mov). */
  listarTiposMovimientoPorAlmacen(almacenId: number): Observable<AlmacenTipoMovDto[]> {
    return this.listarTodoPaginado<AlmacenTipoMovDto>(`/almacenes/${almacenId}/tipos-movimiento`);
  }

  /** Almacenes asignados al usuario actual y activos (almacen.almacen_user). */
  listarMisAlmacenes(): Observable<AlmacenDto[]> {
    return this.http
      .get<ApiResponse<AlmacenDto[]>>(`${this.base}/almacenes/mis-almacenes`)
      .pipe(map(res => res.data ?? []));
  }

  /** Hora del servidor de BD (sin zona horaria) para fijar la fecha de registro. */
  obtenerHoraServidor(): Observable<{ fecha: string; fechaHora: string }> {
    const coreBase = `${this.apiBase.getApiBaseUrl()}/core`;
    return this.http
      .get<ApiResponse<{ fecha: string; fechaHora: string }>>(`${coreBase}/server-time`)
      .pipe(map(res => res.data ?? { fecha: '', fechaHora: '' }));
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

  /** Consulta genérica para vistas de operaciones, consultas y reportes. */
  consultarVista(apiPath: string): Observable<Record<string, unknown>[]> {
    if (apiPath === '/reportes/diagnostico') {
      return this.http
        .get<ApiResponse<Record<string, unknown>[]>>(`${this.base}${apiPath}`)
        .pipe(map(res => (res.data ?? []) as Record<string, unknown>[]));
    }
    return this.listarTodoPaginado<Record<string, unknown>>(apiPath);
  }

  ejecutarProceso(procesoPath: string): Observable<{ mensaje?: string; detalle?: string }> {
    return this.http
      .post<ApiResponse<{ mensaje?: string; detalle?: string }>>(`${this.base}${procesoPath}`, {})
      .pipe(map(res => res.data ?? {}));
  }

  crearRegistro(basePath: string, body: Record<string, unknown>): Observable<unknown> {
    return this.http
      .post<ApiResponse<unknown>>(`${this.base}${basePath}`, body)
      .pipe(map(res => res.data));
  }

  actualizarRegistro(basePath: string, id: number, body: Record<string, unknown>): Observable<unknown> {
    return this.http
      .put<ApiResponse<unknown>>(`${this.base}${basePath}/${id}`, body)
      .pipe(map(res => res.data));
  }

  desactivarRegistro(basePath: string, id: number): Observable<unknown> {
    return this.http
      .patch<ApiResponse<unknown>>(`${this.base}${basePath}/${id}/desactivar`, {})
      .pipe(map(res => res.data));
  }

  eliminarRegistro(basePath: string, id: number): Observable<unknown> {
    return this.http
      .delete<ApiResponse<unknown>>(`${this.base}${basePath}/${id}`)
      .pipe(map(res => res.data));
  }

  crearUbicacion(almacenId: number, body: Record<string, unknown>): Observable<unknown> {
    return this.http
      .post<ApiResponse<unknown>>(`${this.base}/almacenes/${almacenId}/ubicaciones`, body)
      .pipe(map(res => res.data));
  }

  actualizarUbicacion(id: number, body: Record<string, unknown>): Observable<unknown> {
    return this.http
      .put<ApiResponse<unknown>>(`${this.base}/ubicaciones/${id}`, body)
      .pipe(map(res => res.data));
  }

  eliminarUbicacion(id: number): Observable<unknown> {
    return this.http
      .delete<ApiResponse<unknown>>(`${this.base}/ubicaciones/${id}`)
      .pipe(map(res => res.data));
  }

  asignarTipoMovimiento(almacenId: number, articuloMovTipoId: number): Observable<unknown> {
    return this.http
      .post<ApiResponse<unknown>>(`${this.base}/almacenes/${almacenId}/tipos-movimiento`, { articuloMovTipoId })
      .pipe(map(res => res.data));
  }

  desasignarTipoMovimiento(almacenId: number, articuloMovTipoId: number): Observable<unknown> {
    return this.http
      .delete<ApiResponse<unknown>>(`${this.base}/almacenes/${almacenId}/tipos-movimiento/${articuloMovTipoId}`)
      .pipe(map(res => res.data));
  }

  crearMovimiento(body: Record<string, unknown>): Observable<unknown> {
    return this.http.post<ApiResponse<unknown>>(`${this.base}/movimientos`, body).pipe(map(res => res.data));
  }

  actualizarMovimiento(id: number, body: Record<string, unknown>): Observable<unknown> {
    return this.http.put<ApiResponse<unknown>>(`${this.base}/movimientos/${id}`, body).pipe(map(res => res.data));
  }

  anularMovimiento(id: number): Observable<unknown> {
    return this.http
      .post<ApiResponse<unknown>>(`${this.base}/movimientos/anular`, { id, motivo: 'Anulación desde SIGRE Web' })
      .pipe(map(res => res.data));
  }

  crearOrdenTraslado(body: Record<string, unknown>): Observable<unknown> {
    return this.http.post<ApiResponse<unknown>>(`${this.base}/ordenes-traslado`, body).pipe(map(res => res.data));
  }

  actualizarOrdenTraslado(id: number, body: Record<string, unknown>): Observable<unknown> {
    return this.http
      .put<ApiResponse<unknown>>(`${this.base}/ordenes-traslado/${id}`, body)
      .pipe(map(res => res.data));
  }

  anularOrdenTraslado(id: number): Observable<unknown> {
    return this.http
      .post<ApiResponse<unknown>>(`${this.base}/ordenes-traslado/${id}/anular`, {})
      .pipe(map(res => res.data));
  }

  crearTomaInventario(body: Record<string, unknown>): Observable<unknown> {
    return this.http.post<ApiResponse<unknown>>(`${this.base}/tomas-inventario`, body).pipe(map(res => res.data));
  }

  actualizarTomaInventario(id: number, body: Record<string, unknown>): Observable<unknown> {
    return this.http
      .put<ApiResponse<unknown>>(`${this.base}/tomas-inventario/${id}`, body)
      .pipe(map(res => res.data));
  }

  anularTomaInventario(id: number): Observable<unknown> {
    return this.http
      .post<ApiResponse<unknown>>(`${this.base}/tomas-inventario/${id}/anular`, {})
      .pipe(map(res => res.data));
  }
}
