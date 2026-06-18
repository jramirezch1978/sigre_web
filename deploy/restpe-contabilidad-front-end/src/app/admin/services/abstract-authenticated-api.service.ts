import { HttpClient, HttpHeaders } from '@angular/common/http';
import { inject } from '@angular/core';
import { environment } from '../../../environments/environment';
import { StorageService } from '../../core/services/storage.service';

/**
 * Base para clientes HTTP autenticados (encapsulación + reutilización).
 * Las subclases concretas aportan rutas y verbos (plantilla: un solo sitio para headers y URL).
 */
export abstract class AbstractAuthenticatedApiService {

  protected readonly http = inject(HttpClient);
  protected readonly storage = inject(StorageService);

  protected buildUrl(suffix: string): string {
    const base = environment.apiBaseUrl.replace(/\/$/, '');
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
