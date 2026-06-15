import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { StorageService } from '../../core/services/storage.service';
import { JwtClaimsReaderService } from '../services/jwt-claims-reader.service';
import { PostAuthIntentService } from '../services/post-auth-intent.service';

/**
 * Aprovisionar empresa: el backend exige JWT temporal (claims.temporal = true).
 */
export const adminProvisioningSessionGuard: CanActivateFn = () => {
  const storage = inject(StorageService);
  const router = inject(Router);
  const claims = inject(JwtClaimsReaderService);
  const intent = inject(PostAuthIntentService);

  const token = storage.getToken();
  if (!token) {
    intent.markAdmin();
    return router.createUrlTree(['/admin/login']);
  }

  if (!claims.isTemporal(token)) {
    return router.createUrlTree(['/admin', 'inicio'], { queryParams: { aviso: 'provision-temporal' } });
  }

  return true;
};
