import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, map } from 'rxjs';
import { ApiBaseService } from '../../../../services/api-base.service';
import { ApiResponse, PageData } from '../../../shared/models/api-page.model';

export interface SolicitudCompraDetLinea {
  id?: number;
  articuloId: number;
  almacenId?: number | null;
  articuloCodigo?: string;
  articuloDescripcion?: string;
  cantidad: number;
  especificaciones?: string | null;
}

export interface SolicitudCompraRequestDto {
  sucursalId?: number | null;
  fecha: string;
  solicitanteId?: number | null;
  prioridad?: string | null;
  justificacion?: string | null;
  lineas: SolicitudCompraDetLinea[];
}

export interface SolicitudCompraFila {
  id: number;
  numero: string;
  fecha: string;
  prioridad?: string;
  flagEstado: string;
  totalItems: number;
  solicitanteId?: number;
  sucursalId?: number;
}

export interface SolicitudCompraDetalle extends SolicitudCompraRequestDto {
  id: number;
  numero: string;
  flagEstado: string;
  createdBy?: number;
  fecCreacion?: string;
  updatedBy?: number;
  fecModificacion?: string;
}

export interface TrazabilidadDocumento {
  tipoDocumento: string;
  documentoId: number;
  numero: string;
  fecha: string;
  flagEstado: string;
}

export interface ConvertirSolicitudRequestDto {
  destino: 'COTIZACION' | 'ORDEN_COMPRA';
  proveedorIds: number[];
  monedaId?: number | null;
}

export interface ConvertirSolicitudResultado {
  solicitudId: number;
  destino: string;
  documentosGenerados: number[];
}

export interface SolicitudCompraFiltro {
  sucursalId?: number | null;
  flagEstado?: string | null;
  prioridad?: string | null;
  fechaDesde?: string | null;
  fechaHasta?: string | null;
}

@Injectable({ providedIn: 'root' })
export class SolicitudCompraApiService {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);

  private get base(): string {
    return `${this.apiBase.getApiBaseUrl()}/compras/solicitudes-compra`;
  }

  listar(filtro: SolicitudCompraFiltro, page = 0, size = 200): Observable<PageData<SolicitudCompraFila>> {
    let params = new HttpParams().set('page', String(page)).set('size', String(size));
    if (filtro.sucursalId != null) params = params.set('sucursalId', String(filtro.sucursalId));
    if (filtro.flagEstado) params = params.set('flagEstado', filtro.flagEstado);
    if (filtro.prioridad) params = params.set('prioridad', filtro.prioridad);
    if (filtro.fechaDesde) params = params.set('fechaDesde', filtro.fechaDesde);
    if (filtro.fechaHasta) params = params.set('fechaHasta', filtro.fechaHasta);
    return this.http
      .get<ApiResponse<PageData<SolicitudCompraFila>>>(this.base, { params })
      .pipe(map(res => res.data ?? ({ content: [], page: { number: 0, size, totalElements: 0, totalPages: 0 } } as PageData<SolicitudCompraFila>)));
  }

  obtener(id: number): Observable<SolicitudCompraDetalle> {
    return this.http
      .get<ApiResponse<SolicitudCompraDetalle>>(`${this.base}/${id}`)
      .pipe(map(res => res.data as SolicitudCompraDetalle));
  }

  crear(body: SolicitudCompraRequestDto): Observable<SolicitudCompraDetalle> {
    return this.http
      .post<ApiResponse<SolicitudCompraDetalle>>(this.base, body)
      .pipe(map(res => res.data as SolicitudCompraDetalle));
  }

  actualizar(id: number, body: SolicitudCompraRequestDto): Observable<SolicitudCompraDetalle> {
    return this.http
      .put<ApiResponse<SolicitudCompraDetalle>>(`${this.base}/${id}`, body)
      .pipe(map(res => res.data as SolicitudCompraDetalle));
  }

  enviar(id: number): Observable<SolicitudCompraDetalle> {
    return this.http
      .post<ApiResponse<SolicitudCompraDetalle>>(`${this.base}/${id}/enviar`, {})
      .pipe(map(res => res.data as SolicitudCompraDetalle));
  }

  aprobar(id: number, observacion?: string): Observable<SolicitudCompraDetalle> {
    return this.http
      .post<ApiResponse<SolicitudCompraDetalle>>(`${this.base}/${id}/aprobar`, observacion ? { observacion } : {})
      .pipe(map(res => res.data as SolicitudCompraDetalle));
  }

  rechazar(id: number, motivo: string): Observable<SolicitudCompraDetalle> {
    return this.http
      .post<ApiResponse<SolicitudCompraDetalle>>(`${this.base}/${id}/rechazar`, { motivo })
      .pipe(map(res => res.data as SolicitudCompraDetalle));
  }

  anular(id: number, motivo: string): Observable<SolicitudCompraDetalle> {
    return this.http
      .post<ApiResponse<SolicitudCompraDetalle>>(`${this.base}/${id}/anular`, { motivo })
      .pipe(map(res => res.data as SolicitudCompraDetalle));
  }

  convertir(id: number, body: ConvertirSolicitudRequestDto): Observable<ConvertirSolicitudResultado> {
    return this.http
      .post<ApiResponse<ConvertirSolicitudResultado>>(`${this.base}/${id}/convertir`, body)
      .pipe(map(res => res.data as ConvertirSolicitudResultado));
  }

  trazabilidad(id: number): Observable<TrazabilidadDocumento[]> {
    return this.http
      .get<ApiResponse<TrazabilidadDocumento[]>>(`${this.base}/${id}/trazabilidad`)
      .pipe(map(res => res.data ?? []));
  }
}
