import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';

export interface MatrizContableOpcion {
  id: number;
  nombre: string;
}

interface ApiResp<T> { success: boolean; message?: string; errorCode?: string; data: T; }

/**
 * Catálogo de matrices contables (ms-contabilidad,
 * `/api/contabilidad/matrices-contables`) para el combo de Concepto Financiero.
 * El token/tenant los inyectan los interceptores.
 */
@Injectable({ providedIn: 'root' })
export class MatrizContableService {

  private readonly http = inject(HttpClient);
  private readonly base = `${environment.apiBaseUrl}/contabilidad/matrices-contables`;

  /** Lista matrices activas (id + "codigo - descripcion") para el selector. */
  listar(q = ''): Observable<MatrizContableOpcion[]> {
    const url = `${this.base}?size=2000` + (q ? `&q=${encodeURIComponent(q)}` : '');
    return this.http.get<ApiResp<any[]>>(url).pipe(
      map((r) => (this.unwrap(r) ?? []).map((m: any) => ({
        id: m.id,
        nombre: `${m.codigo} - ${m.descripcion ?? ''}`.trim(),
      })))
    );
  }

  private unwrap<T>(r: ApiResp<T>): T {
    if (r && r.success === false) {
      throw new Error(r.message || r.errorCode || 'Error del servidor');
    }
    return r?.data as T;
  }
}
