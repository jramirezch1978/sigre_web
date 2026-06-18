import { HttpInterceptorFn } from '@angular/common/http';
import { inject } from '@angular/core';
import { StorageService } from '../services/storage.service';
import { environment } from '../../../environments/environment';

/**
 * Interceptor funcional que adjunta el token JWT en el header Authorization
 * para todas las peticiones dirigidas al API backend.
 */
export const jwtInterceptor: HttpInterceptorFn = (req, next) => {
  const storage = inject(StorageService);
  const token = storage.getToken();

  const isApiUrl = req.url.startsWith(environment.apiBaseUrl);

  if (token && isApiUrl) {
    const cloned = req.clone({
      setHeaders: {
        Authorization: `Bearer ${token}`,
      },
    });
    return next(cloned);
  }

  return next(req);
};
