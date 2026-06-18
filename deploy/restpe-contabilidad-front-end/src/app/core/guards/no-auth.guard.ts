import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { StorageService } from '../services/storage.service';

/**
 * Guard funcional que impide acceso a rutas públicas (login) si el usuario
 * ya está autenticado. Redirige al inicio si ya tiene sesión activa.
 */
export const noAuthGuard: CanActivateFn = () => {
  const storage = inject(StorageService);
  const router = inject(Router);

  if (!storage.getToken()) {
    return true;
  }

  return router.createUrlTree(['/inicio']);
};
