import { Injectable, inject } from '@angular/core';
import { environment } from '../../environments/environment';
import { ConfigService } from './config.service';

/** URL base del API Gateway (`…/api`) según appsettings o entorno. */
@Injectable({ providedIn: 'root' })
export class ApiBaseService {
  private readonly config = inject(ConfigService);

  getApiBaseUrl(): string {
    if (this.config.isConfigLoaded()) {
      const base = this.config.getCurrentConfig().api.baseUrl.replace(/\/$/, '');
      return `${base}/api`;
    }
    const envBase = environment.apiBaseUrl.replace(/\/$/, '');
    if (envBase.startsWith('http')) {
      return envBase;
    }
    const host = typeof window !== 'undefined' ? window.location.hostname : 'localhost';
    return `http://${host}:9080/api`;
  }
}
