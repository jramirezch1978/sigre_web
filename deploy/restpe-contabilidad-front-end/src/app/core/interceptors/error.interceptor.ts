import { HttpInterceptorFn, HttpErrorResponse } from '@angular/common/http';
import { inject } from '@angular/core';
import { Router } from '@angular/router';
import { catchError, throwError } from 'rxjs';
import { StorageService } from '../services/storage.service';

/**
 * Interceptor funcional global de errores HTTP.
 * - 401: redirige a login y limpia sesión.
 * - 403: registra acceso denegado.
 * - 0:   sin conexión al servidor.
 * - 5xx: registra error del servidor.
 */
export const errorInterceptor: HttpInterceptorFn = (req, next) => {
  const router = inject(Router);
  const storage = inject(StorageService);

  return next(req).pipe(
    catchError((error: HttpErrorResponse) => {
      switch (error.status) {
        case 401:
          storage.clearSession();
          router.navigate(['/auth/signin']);
          break;

        case 403:
          console.warn('[403] Acceso denegado:', req.url);
          break;

        case 0:
          console.error('[Network] Sin conexión al servidor:', req.url);
          break;

        default:
          if (error.status >= 500) {
            console.error(`[${error.status}] Error del servidor:`, error.message);
          }
          break;
      }

      return throwError(() => error);
    })
  );
};
