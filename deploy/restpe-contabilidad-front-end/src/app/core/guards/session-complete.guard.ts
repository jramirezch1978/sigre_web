import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { StorageService } from '../services/storage.service';

interface SessionUser {
  temporal?: boolean;
  empresaId?: number;
  sucursalId?: number;
}

/**
 * Guard que exige sesión completa: token válido + empresa + sucursal.
 * Si el token es temporal o falta contexto, limpia sesión y redirige al login.
 * Se aplica a las rutas del ERP principal (no a auth ni admin).
 */
export const sessionCompleteGuard: CanActivateFn = () => {
  const storage = inject(StorageService);
  const router  = inject(Router);

  // Sesión viva = access token válido o refresh token vigente (el interceptor renueva).
  if (!storage.isAuthenticated()) {
    return router.createUrlTree(['/auth/signin']);
  }

  const user = storage.getUser<SessionUser>();
  if (!user || user.temporal === true || !user.empresaId || !user.sucursalId) {
    storage.clearSession();
    return router.createUrlTree(['/auth/signin']);
  }

  return true;
};
