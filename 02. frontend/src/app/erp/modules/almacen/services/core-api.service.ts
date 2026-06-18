import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, map, switchMap } from 'rxjs';
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

  listarParametrosAlmacenConValor(): Observable<Record<string, unknown>[]> {
    const user = this.storage.getUser<{ empresaId?: number; sucursalId?: number }>();
    const empresaId = user?.empresaId ?? this.leerClaim<number>('empresaId');
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
