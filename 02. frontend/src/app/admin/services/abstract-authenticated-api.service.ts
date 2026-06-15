import { HttpClient, HttpHeaders } from '@angular/common/http';
import { inject } from '@angular/core';
import { ApiBaseService } from '../../services/api-base.service';
import { StorageService } from '../../core/services/storage.service';

/**
 * Base para clientes HTTP autenticados (encapsulación + reutilización).
 */
export abstract class AbstractAuthenticatedApiService {

  protected readonly http = inject(HttpClient);
  protected readonly storage = inject(StorageService);
  protected readonly apiBase = inject(ApiBaseService);

  protected buildUrl(suffix: string): string {
    const base = this.apiBase.getApiBaseUrl().replace(/\/$/, '');
    const path = suffix.startsWith('/') ? suffix : `/${suffix}`;
    return `${base}${path}`;
  }

  protected bearerHeaders(extra?: Record<string, string | undefined>): HttpHeaders {
    const token = this.storage.getToken();
    if (!token) {
      throw new Error('Sesión no disponible');
    }
    let headers = new HttpHeaders({ Authorization: `Bearer ${token}` });
    if (extra) {
      for (const [key, val] of Object.entries(extra)) {
        if (val != null && val !== '') {
          headers = headers.set(key, val);
        }
      }
    }
    return headers;
  }
}
