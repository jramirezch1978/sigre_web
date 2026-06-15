import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { StorageService } from '../../core/services/storage.service';
import { JwtClaimsReaderService } from '../services/jwt-claims-reader.service';

/** Si ya hay sesión admin válida, no mostrar login. */
export const adminLoginGuard: CanActivateFn = () => {
  const storage = inject(StorageService);
  const router = inject(Router);
  const claims = inject(JwtClaimsReaderService);

  const token = storage.getToken();
  if (token && !claims.isTemporal(token) && claims.hasEmpresaContext(token)) {
    return router.createUrlTree(['/admin/inicio']);
  }
  return true;
};
