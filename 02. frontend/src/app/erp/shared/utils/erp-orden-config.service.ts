import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, map, of, catchError } from 'rxjs';
import { ApiBaseService } from '../../../services/api-base.service';
import { StorageService } from '../../../core/services/storage.service';
import { ApiResponse } from '../models/api-page.model';

/**
 * Persiste el ordenamiento de tablas por usuario + ventana en core.configuracion
 * (clave ORDER_[USERID]_[CODIGO_VENTANA]). Es por empresa (BD tenant). El valor guarda
 * "columna:direccion" (ej. "nombre:asc"); vacío => sin orden.
 */
@Injectable({ providedIn: 'root' })
export class ErpOrdenConfigService {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);
  private readonly storage = inject(StorageService);

  private clave(codigoVentana: string): string {
    const uid = this.userId();
    return `ORDER_${uid}_${(codigoVentana || 'GENERAL').toUpperCase()}`;
  }

  leerOrden(codigoVentana: string): Observable<string | null> {
    const params = new HttpParams().set('clave', this.clave(codigoVentana));
    return this.http
      .get<ApiResponse<string>>(`${this.apiBase.getApiBaseUrl()}/core/config/param`, { params })
      .pipe(map(r => r.data ?? null), catchError(() => of(null)));
  }

  guardarOrden(codigoVentana: string, valor: string): void {
    this.http
      .put(`${this.apiBase.getApiBaseUrl()}/core/config/param`, { clave: this.clave(codigoVentana), valor })
      .subscribe({ error: () => { /* preferencia de UI: no bloquear si falla */ } });
  }

  private userId(): number | string {
    const u = this.storage.getUser<{ userId?: number; id?: number }>();
    if (u?.userId != null) return u.userId;
    if (u?.id != null) return u.id;
    const claim = this.leerClaim<number | string>('userId') ?? this.leerClaim<number | string>('sub');
    return claim ?? 0;
  }

  private leerClaim<T>(name: string): T | undefined {
    const token = this.storage.getToken();
    if (!token) return undefined;
    try {
      const parts = token.split('.');
      if (parts.length !== 3) return undefined;
      let b64 = parts[1].replace(/-/g, '+').replace(/_/g, '/');
      while (b64.length % 4 !== 0) b64 += '=';
      return JSON.parse(atob(b64))[name] as T;
    } catch {
      return undefined;
    }
  }
}
