import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { StorageService } from '../../core/services/storage.service';
import { JwtClaimsReaderService } from '../services/jwt-claims-reader.service';
import { PostAuthIntentService } from '../services/post-auth-intent.service';

/**
 * Operaciones de día a día (RBAC, etc.): JWT definitivo con empresa/sucursal ya elegidas.
 */
export const adminOperativeSessionGuard: CanActivateFn = () => {
  const storage = inject(StorageService);
  const router = inject(Router);
  const claims = inject(JwtClaimsReaderService);
  const intent = inject(PostAuthIntentService);

  const token = storage.getToken();
  if (!token) {
    intent.markAdmin();
    return router.createUrlTree(['/admin/login']);
  }

  if (claims.isTemporal(token) || !claims.hasEmpresaContext(token)) {
    intent.markAdmin();
    return router.createUrlTree(['/auth/seleccion-razon-social']);
  }

  return true;
};
