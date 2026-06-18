import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { UtilityService } from '../../../../services/utility.service';
import { StorageService } from '../../../../core/services/storage.service';
import { ALMACEN_API_BASE } from './almacen-api.config';
import { BackendApiResponse, BackendPageData } from '../../application/dto/almacen-backend.types';

/** Pares clave/valor admitidos como query params. */
export type QueryParams = Record<string, string | number | boolean | null | undefined>;

/**
 * Cliente HTTP del módulo de almacén contra el api-gateway de microservicios.
 *
 * Responsabilidades:
 *  - Prefijar las rutas con {@link ALMACEN_API_BASE}.
 *  - Adjuntar el `Authorization: Bearer <token>` de la sesión y las cabeceras
 *    de tenant `X-Empresa-Id` / `X-Sucursal-Id`.
 *  - Desempaquetar la envoltura `ApiResponse<T>` del backend y propagar el
 *    `message`/`errorCode` como error cuando `success === false`.
 *
 * NOTA: el backend resuelve el tenant desde el JWT (`empresaId`) o, en su
 * defecto, desde la cabecera `X-Empresa-Id`. Mientras el login del front no
 * emita el JWT de `ms-auth-security`, se envían cabeceras de tenant de
 * desarrollo (empresaId=2, sucursalId=1). Las escrituras (POST/PUT/DELETE)
 * pueden requerir el contexto autenticado real.
 */
@Injectable({ providedIn: 'root' })
export class AlmacenHttpService {

  private readonly http = inject(HttpClient);
  private readonly storage = inject(StorageService);

  /** Headers: tenant (X-Empresa-Id/X-Sucursal-Id) y Bearer token si existe. */
  private buildHeaders(): HttpHeaders {
    let headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'X-Empresa-Id': String(AlmacenHttpService.getEmpresaId()),
      'X-Sucursal-Id': String(AlmacenHttpService.getSucursalId()),
    });
    // Prefiere el JWT de ms-auth-security (StorageService → 'rpe_access_token');
    // cae al token legacy del monolito solo si no hay sesión nueva.
    const token = this.storage.getToken() ?? UtilityService.getToken();
    if (token) {
      headers = headers.set('Authorization', `Bearer ${token}`);
    }
    return headers;
  }

  /** Convierte un objeto plano en HttpParams, omitiendo null/undefined/''. */
  private buildParams(params?: QueryParams): HttpParams {
    let httpParams = new HttpParams();
    if (!params) {
      return httpParams;
    }
    for (const [key, value] of Object.entries(params)) {
      if (value !== null && value !== undefined && value !== '') {
        httpParams = httpParams.set(key, String(value));
      }
    }
    return httpParams;
  }

  /** Desempaqueta `ApiResponse<T>`; lanza error con el mensaje del backend si falla. */
  private unwrap<T>() {
    return map((res: BackendApiResponse<T>): T => {
      if (res && res.success === false) {
        throw new Error(res.message || res.errorCode || 'Error del servidor');
      }
      return res?.data as T;
    });
  }

  /** GET que devuelve un objeto único (`ApiResponse<T>`). */
  get<T>(path: string, params?: QueryParams): Observable<T> {
    return this.http
      .get<BackendApiResponse<T>>(`${ALMACEN_API_BASE}${path}`, {
        headers: this.buildHeaders(),
        params: this.buildParams(params),
      })
      .pipe(this.unwrap<T>());
  }

  /** GET paginado (`ApiResponse<PageData<T>>`): devuelve sólo el `content`. */
  getList<T>(path: string, params?: QueryParams): Observable<T[]> {
    return this.http
      .get<BackendApiResponse<BackendPageData<T>>>(`${ALMACEN_API_BASE}${path}`, {
        headers: this.buildHeaders(),
        params: this.buildParams(params),
      })
      .pipe(
        this.unwrap<BackendPageData<T>>(),
        map((page) => page?.content ?? []),
      );
  }

  /** GET paginado devolviendo la página completa (content + metadatos). */
  getPage<T>(path: string, params?: QueryParams): Observable<BackendPageData<T>> {
    return this.http
      .get<BackendApiResponse<BackendPageData<T>>>(`${ALMACEN_API_BASE}${path}`, {
        headers: this.buildHeaders(),
        params: this.buildParams(params),
      })
      .pipe(this.unwrap<BackendPageData<T>>());
  }

  post<T>(path: string, body: unknown, params?: QueryParams): Observable<T> {
    return this.http
      .post<BackendApiResponse<T>>(`${ALMACEN_API_BASE}${path}`, body, {
        headers: this.buildHeaders(),
        params: this.buildParams(params),
      })
      .pipe(this.unwrap<T>());
  }

  put<T>(path: string, body: unknown): Observable<T> {
    return this.http
      .put<BackendApiResponse<T>>(`${ALMACEN_API_BASE}${path}`, body, {
        headers: this.buildHeaders(),
      })
      .pipe(this.unwrap<T>());
  }

  patch<T>(path: string, body: unknown = {}): Observable<T> {
    return this.http
      .patch<BackendApiResponse<T>>(`${ALMACEN_API_BASE}${path}`, body, {
        headers: this.buildHeaders(),
      })
      .pipe(this.unwrap<T>());
  }

  delete<T>(path: string): Observable<T> {
    return this.http
      .delete<BackendApiResponse<T>>(`${ALMACEN_API_BASE}${path}`, {
        headers: this.buildHeaders(),
      })
      .pipe(this.unwrap<T>());
  }

  /**
   * GET de un recurso binario (PDF/Excel): devuelve el `Blob` crudo, sin
   * desempaquetar `ApiResponse` (estos endpoints responden `application/pdf`,
   * no JSON). Conserva las cabeceras de tenant + token.
   */
  getBlob(path: string, params?: QueryParams): Observable<Blob> {
    return this.http.get(`${ALMACEN_API_BASE}${path}`, {
      headers: this.buildHeaders(),
      params: this.buildParams(params),
      responseType: 'blob',
    });
  }

  /** Sesión real del login (auth.service → StorageService 'rpe_user'). */
  private static sesionLogin(): any {
    try {
      return JSON.parse(localStorage.getItem('rpe_user') ?? '{}') ?? {};
    } catch {
      return {};
    }
  }

  /**
   * `sucursalId` del tenant: sale de la SESIÓN del login (empresa/sucursal que el
   * usuario eligió en `seleccionar-empresa` → guardado en 'rpe_user'). Solo si no
   * hay sesión cae al fallback de DEV (3).
   */
  static getSucursalId(): number {
    const u = AlmacenHttpService.sesionLogin();
    const raw = u?.sucursalId ?? u?.sucursal_id;
    const parsed = Number(raw);
    return Number.isFinite(parsed) && parsed > 0 ? parsed : 3;
  }

  /**
   * `empresaId` del tenant: sale de la SESIÓN del login ('rpe_user'). El backend
   * resuelve el tenant por el `empresaId` del JWT (Bearer) o esta cabecera.
   * Solo si no hay sesión cae al fallback de DEV (2).
   */
  static getEmpresaId(): number {
    const u = AlmacenHttpService.sesionLogin();
    const raw = u?.empresaId ?? u?.empresa_id;
    const parsed = Number(raw);
    return Number.isFinite(parsed) && parsed > 0 ? parsed : 2;
  }

  /** Nombre de la sucursal de la sesión (la elegida en el login). */
  static getSucursalNombre(): string {
    const u = AlmacenHttpService.sesionLogin();
    return u?.sucursalNombre ?? u?.sucursal_nombre ?? '';
  }
}
