import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, map } from 'rxjs/operators';
import { environment } from '../../../../environments/environment';
import { ApiResponse, PageResponse } from '../../models/api-response.model';

/**
 * Cliente HTTP base para comunicación con el API Gateway.
 *
 * Centraliza:
 * - URL base del API
 * - Manejo uniforme de errores
 * - Transformación de respuestas ApiResponse<T>
 * - Construcción de parámetros de paginación/filtro
 *
 * Los servicios de cada módulo inyectan este servicio en lugar de usar
 * HttpClient directamente, garantizando consistencia.
 *
 * Ejemplo:
 *   private readonly api = inject(ApiClientService);
 *   getProductos(filtro) { return this.api.get<PageResponse<Producto>>('/almacen/productos', filtro); }
 */
@Injectable({ providedIn: 'root' })
export class ApiClientService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = environment.apiBaseUrl;

  get<T>(path: string, params?: Record<string, string | number | boolean | undefined>): Observable<T> {
    const httpParams = this.buildParams(params);
    return this.http.get<ApiResponse<T>>(`${this.baseUrl}${path}`, { params: httpParams }).pipe(
      map(response => response.data),
      catchError(this.handleError),
    );
  }

  getRaw<T>(path: string, params?: Record<string, string | number | boolean | undefined>): Observable<ApiResponse<T>> {
    const httpParams = this.buildParams(params);
    return this.http.get<ApiResponse<T>>(`${this.baseUrl}${path}`, { params: httpParams }).pipe(
      catchError(this.handleError),
    );
  }

  post<T>(path: string, body: unknown): Observable<T> {
    return this.http.post<ApiResponse<T>>(`${this.baseUrl}${path}`, body).pipe(
      map(response => response.data),
      catchError(this.handleError),
    );
  }

  postRaw<T>(path: string, body: unknown): Observable<ApiResponse<T>> {
    return this.http.post<ApiResponse<T>>(`${this.baseUrl}${path}`, body).pipe(
      catchError(this.handleError),
    );
  }

  put<T>(path: string, body: unknown): Observable<T> {
    return this.http.put<ApiResponse<T>>(`${this.baseUrl}${path}`, body).pipe(
      map(response => response.data),
      catchError(this.handleError),
    );
  }

  delete<T>(path: string): Observable<T> {
    return this.http.delete<ApiResponse<T>>(`${this.baseUrl}${path}`).pipe(
      map(response => response.data),
      catchError(this.handleError),
    );
  }

  patch<T>(path: string, body: unknown): Observable<T> {
    return this.http.patch<ApiResponse<T>>(`${this.baseUrl}${path}`, body).pipe(
      map(response => response.data),
      catchError(this.handleError),
    );
  }

  private buildParams(params?: Record<string, string | number | boolean | undefined>): HttpParams {
    let httpParams = new HttpParams();
    if (params) {
      Object.entries(params).forEach(([key, value]) => {
        if (value !== undefined && value !== null && value !== '') {
          httpParams = httpParams.set(key, String(value));
        }
      });
    }
    return httpParams;
  }

  private handleError(error: HttpErrorResponse): Observable<never> {
    let message = 'Error desconocido';

    if (error.error instanceof ErrorEvent) {
      message = `Error de red: ${error.error.message}`;
    } else {
      message = error.error?.message || `Error ${error.status}: ${error.statusText}`;
    }

    console.error('[ApiClient]', message, error);
    return throwError(() => error);
  }
}
