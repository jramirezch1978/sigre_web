import { HttpInterceptorFn } from '@angular/common/http';
import { inject } from '@angular/core';
import { TenantService } from '../services/tenant.service';
import { environment } from '../../../environments/environment';

/**
 * Interceptor funcional que adjunta el header X-Tenant-ID en todas las
 * peticiones al API backend, permitiendo al servidor identificar la empresa activa.
 */
export const tenantInterceptor: HttpInterceptorFn = (req, next) => {
  const tenantService = inject(TenantService);
  const tenantId = tenantService.getCurrentTenantId();

  const isApiUrl = req.url.startsWith(environment.apiBaseUrl);

  if (tenantId && isApiUrl) {
    const cloned = req.clone({
      setHeaders: {
        'X-Tenant-ID': tenantId,
      },
    });
    return next(cloned);
  }

  return next(req);
};
