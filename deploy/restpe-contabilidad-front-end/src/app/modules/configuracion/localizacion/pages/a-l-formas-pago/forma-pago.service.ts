import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';

/** Forma de pago (catálogo `core.forma_pago`). */
export interface FormaPago {
  id?: number;
  codigo: string;
  nombre: string;
  tipo: string;
  flagEstado?: string;
}

interface ApiResponse<T> {
  success: boolean;
  message?: string;
  errorCode?: string;
  data: T;
}
interface PageData<T> { content: T[]; }

/**
 * Cliente HTTP del catálogo de Formas de Pago contra `ms-core-maestros`
 * (`/api/core/formas-pago`). El token (Bearer) y las cabeceras de tenant las
 * agregan los interceptores globales (jwt/tenant); aquí solo se desempaqueta
 * la envoltura `ApiResponse<T>`.
 */
@Injectable({ providedIn: 'root' })
export class FormaPagoService {

  private readonly http = inject(HttpClient);
  private readonly base = `${environment.apiBaseUrl}/core/formas-pago`;

  listar(): Observable<FormaPago[]> {
    return this.http
      .get<ApiResponse<PageData<FormaPago>>>(`${this.base}?size=1000&sort=id,asc`)
      .pipe(map((r) => this.unwrap(r)?.content ?? []));
  }

  crear(body: FormaPago): Observable<FormaPago> {
    return this.http.post<ApiResponse<FormaPago>>(this.base, body).pipe(map((r) => this.unwrap(r)));
  }

  actualizar(id: number, body: FormaPago): Observable<FormaPago> {
    return this.http.put<ApiResponse<FormaPago>>(`${this.base}/${id}`, body).pipe(map((r) => this.unwrap(r)));
  }

  eliminar(id: number): Observable<boolean> {
    return this.http.delete<ApiResponse<boolean>>(`${this.base}/${id}`).pipe(map((r) => this.unwrap(r)));
  }

  private unwrap<T>(r: ApiResponse<T>): T {
    if (r && r.success === false) {
      throw new Error(r.message || r.errorCode || 'Error del servidor');
    }
    return r?.data as T;
  }
}
