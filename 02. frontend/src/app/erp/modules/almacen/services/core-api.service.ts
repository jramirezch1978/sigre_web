import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, map, of, switchMap } from 'rxjs';
import { ApiBaseService } from '../../../../services/api-base.service';
import { ApiResponse, PageData } from '../../../shared/models/api-page.model';
import { StorageService } from '../../../../core/services/storage.service';

export interface ConversionUnidadDto {
  id: number;
  articuloId: number;
  umOrigenId: number;
  umDestinoId: number;
  factorConversion: number;
  flagEstado: string;
}

export interface NumeradorDocumentoDto {
  nombreTabla: string;
  sucursalId: number;
  sucursalCodigo?: string;
  sucursalNombre?: string;
  ano: number;
  ultNro: number;
  flagEstado: string;
}

export interface ConfigClaveDto {
  clave: string;
  modulo: string;
  nivel: string;
  descripcion: string;
  tipoDato: string;
  flagEstado: string;
}

export interface SelectOptionDto {
  value: number | string;
  label: string;
}

export interface SucursalDto {
  id: number;
  codigo?: string;
  nombre: string;
}

@Injectable({ providedIn: 'root' })
export class CoreApiService {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);
  private readonly storage = inject(StorageService);

  private get base(): string {
    return `${this.apiBase.getApiBaseUrl()}/core`;
  }

  listarConversionesUnidad(): Observable<ConversionUnidadDto[]> {
    const params = new HttpParams().set('page', '0').set('size', '500');
    return this.http
      .get<ApiResponse<PageData<ConversionUnidadDto>>>(`${this.base}/conversiones-unidad`, { params })
      .pipe(map(res => res.data?.content ?? []));
  }

  listarNumeradoresDocumento(nombreTabla: string): Observable<NumeradorDocumentoDto[]> {
    const params = new HttpParams()
      .set('nombreTabla', nombreTabla)
      .set('page', '0')
      .set('size', '500');
    return this.http
      .get<ApiResponse<PageData<NumeradorDocumentoDto>>>(`${this.base}/numeradores-documento`, { params })
      .pipe(map(res => res.data?.content ?? []));
  }

  listarParametrosAlmacen(): Observable<ConfigClaveDto[]> {
    const params = new HttpParams().set('modulo', 'ALMACEN');
    return this.http
      .get<ApiResponse<ConfigClaveDto[]>>(`${this.base}/config/claves`, { params })
      .pipe(map(res => res.data ?? []));
  }

  listarMisSucursales(): Observable<SucursalDto[]> {
    const empresaId = this.leerEmpresaId();
    if (!empresaId) return of([]);
    return this.http
      .get<ApiResponse<SucursalDto[]>>(`${this.base}/empresas/${empresaId}/sucursales/mias`)
      .pipe(map(res => res.data ?? []));
  }

  listarCentrosCosto(): Observable<SelectOptionDto[]> {
    // El catálogo de centros de costo vive en el módulo de CONTABILIDAD (no finanzas), y es paginado.
    const contabilidadBase = `${this.apiBase.getApiBaseUrl()}/contabilidad`;
    const params = new HttpParams().set('page', '0').set('size', '500').set('flagEstado', '1');
    return this.http
      .get<ApiResponse<PageData<{ id: number; cencos?: string; descCencos?: string }>>>(
        `${contabilidadBase}/centros-costo`, { params })
      .pipe(
        map(res =>
          (res.data?.content ?? []).map(item => ({
            value: Number(item.id),
            label: `${item.cencos ?? item.id}${item.descCencos ? ' — ' + item.descCencos : ''}`,
          }))
        )
      );
  }

  listarProveedores(): Observable<SelectOptionDto[]> {
    const params = new HttpParams()
      .set('esProveedor', 'true')
      .set('activo', 'true')
      .set('page', '0')
      .set('size', '500');
    return this.http
      .get<ApiResponse<PageData<{ id: number; razonSocial?: string; nombreComercial?: string; nroDocumento?: string }>>>(
        `${this.base}/relaciones-comerciales`,
        { params }
      )
      .pipe(
        map(res =>
          (res.data?.content ?? []).map(p => ({
            value: p.id,
            label: `${p.nroDocumento ?? p.id} — ${p.razonSocial ?? p.nombreComercial ?? 'Proveedor'}`,
          }))
        )
      );
  }

  listarParametrosAlmacenConValor(): Observable<Record<string, unknown>[]> {
    const empresaId = this.leerEmpresaId();
    if (!empresaId) {
      return this.listarParametrosAlmacen().pipe(
        map(claves =>
          claves.map(c => ({
            clave: c.clave,
            modulo: c.modulo,
            nivel: c.nivel,
            descripcion: c.descripcion,
            tipoDato: c.tipoDato,
            valor: '—',
            flagEstado: c.flagEstado,
          }))
        )
      );
    }
    return this.listarParametrosAlmacen().pipe(
      switchMap(claves => {
        const params = new HttpParams().set('empresaId', String(empresaId));
        return this.http
          .get<ApiResponse<Record<string, unknown>>>(`${this.base}/config/empresa`, { params })
          .pipe(
            map(res => {
              const valores = res.data ?? {};
              return claves.map(c => ({
                clave: c.clave,
                modulo: c.modulo,
                nivel: c.nivel,
                descripcion: c.descripcion,
                tipoDato: c.tipoDato,
                valor: valores[c.clave] ?? '—',
                flagEstado: c.flagEstado,
              }));
            })
          );
      })
    );
  }

  private leerEmpresaId(): number | undefined {
    const user = this.storage.getUser<{ empresaId?: number }>();
    return user?.empresaId ?? this.leerClaim<number>('empresaId');
  }

  crearConversionUnidad(body: Record<string, unknown>): Observable<unknown> {
    return this.http
      .post<ApiResponse<unknown>>(`${this.base}/conversiones-unidad`, body)
      .pipe(map(res => res.data));
  }

  actualizarConversionUnidad(id: number, body: Record<string, unknown>): Observable<unknown> {
    return this.http
      .put<ApiResponse<unknown>>(`${this.base}/conversiones-unidad/${id}`, body)
      .pipe(map(res => res.data));
  }

  eliminarConversionUnidad(id: number): Observable<unknown> {
    return this.http
      .delete<ApiResponse<unknown>>(`${this.base}/conversiones-unidad/${id}`)
      .pipe(map(res => res.data));
  }

  desactivarConversionUnidad(id: number): Observable<unknown> {
    return this.http
      .patch<ApiResponse<unknown>>(`${this.base}/conversiones-unidad/${id}/desactivar`, {})
      .pipe(map(res => res.data));
  }

  guardarNumeradorDocumento(body: {
    nombreTabla: string;
    sucursalId: number;
    ano: number;
    ultNro: number;
  }): Observable<unknown> {
    return this.http
      .post<ApiResponse<unknown>>(`${this.base}/numeradores-documento`, body)
      .pipe(map(res => res.data));
  }

  desactivarNumeradorDocumento(nombreTabla: string, sucursalId: number, ano: number): Observable<unknown> {
    const params = new HttpParams()
      .set('nombreTabla', nombreTabla)
      .set('sucursalId', String(sucursalId))
      .set('ano', String(ano));
    return this.http
      .patch<ApiResponse<unknown>>(`${this.base}/numeradores-documento/desactivar`, {}, { params })
      .pipe(map(res => res.data));
  }

  guardarParametroEmpresa(clave: string, valor: unknown): Observable<unknown> {
    const empresaId = this.leerEmpresaId();
    if (!empresaId) {
      throw new Error('Empresa no identificada en sesión');
    }
    return this.http
      .put<ApiResponse<unknown>>(`${this.base}/config/empresa`, {
        empresaId,
        valores: { [clave]: valor },
      })
      .pipe(map(res => res.data));
  }

  crearRegistroCore(basePath: string, body: Record<string, unknown>): Observable<unknown> {
    return this.http
      .post<ApiResponse<unknown>>(`${this.base}${basePath}`, body)
      .pipe(map(res => res.data));
  }

  actualizarRegistroCore(basePath: string, id: number, body: Record<string, unknown>): Observable<unknown> {
    return this.http
      .put<ApiResponse<unknown>>(`${this.base}${basePath}/${id}`, body)
      .pipe(map(res => res.data));
  }

  desactivarRegistroCore(basePath: string, id: number): Observable<unknown> {
    return this.http
      .patch<ApiResponse<unknown>>(`${this.base}${basePath}/${id}/desactivar`, {})
      .pipe(map(res => res.data));
  }

  eliminarRegistroCore(basePath: string, id: number): Observable<unknown> {
    return this.http
      .delete<ApiResponse<unknown>>(`${this.base}${basePath}/${id}`)
      .pipe(map(res => res.data));
  }

  private leerClaim<T>(key: string): T | undefined {
    const token = this.storage.getToken();
    if (!token) return undefined;
    try {
      const parts = token.split('.');
      if (parts.length !== 3) return undefined;
      let base64 = parts[1].replace(/-/g, '+').replace(/_/g, '/');
      while (base64.length % 4 !== 0) base64 += '=';
      const payload = JSON.parse(atob(base64));
      return payload[key] as T;
    } catch {
      return undefined;
    }
  }
}
