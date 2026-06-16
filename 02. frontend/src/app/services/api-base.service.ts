import { Injectable, inject } from '@angular/core';
import { environment } from '../../environments/environment';
import { ConfigService } from './config.service';

/** URL base del API Gateway (`…/api`) según appsettings o entorno. */
@Injectable({ providedIn: 'root' })
export class ApiBaseService {
  private readonly config = inject(ConfigService);

  getApiBaseUrl(): string {
    const envBase = (environment.apiBaseUrl ?? '/api').replace(/\/$/, '');
    // Misma origen que la SPA: nginx en :8080 proxya /api → api-gateway (evita CORS y puerto 9080).
    if (typeof window !== 'undefined' && envBase.startsWith('/')) {
      return envBase || '/api';
    }
    if (envBase.startsWith('http')) {
      return envBase;
    }
    if (this.config.isConfigLoaded()) {
      const base = this.config.getCurrentConfig().api.baseUrl.replace(/\/$/, '');
      return `${base}/api`;
    }
    const host = typeof window !== 'undefined' ? window.location.hostname : 'localhost';
    return `http://${host}:9080/api`;
  }
}
