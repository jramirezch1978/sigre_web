import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { StorageService } from '../../core/services/storage.service';
import { PostAuthIntentService } from '../services/post-auth-intent.service';

/** Zona admin: requiere token (cualquier fase del login). */
export const adminZoneGuard: CanActivateFn = () => {
  const storage = inject(StorageService);
  const router = inject(Router);
  const intent = inject(PostAuthIntentService);

  if (storage.getToken()) {
    return true;
  }

  intent.markAdmin();
  return router.createUrlTree(['/auth/signin'], { queryParams: { returnUrl: '/admin' } });
};
