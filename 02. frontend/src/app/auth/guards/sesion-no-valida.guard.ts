import { Injectable, inject } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { StorageService } from '../../core/services/storage.service';
import { PostAuthIntentService } from '../../admin/services/post-auth-intent.service';

/**
 * Impide acceder al login si ya hay sesión activa.
 * Redirige al ERP (/sigre/dashboard) o a selección de empresa si el token es temporal.
 */
@Injectable({
  providedIn: 'root'
})
export class SesionNoValidaGuard implements CanActivate {
  private readonly router = inject(Router);
  private readonly storage = inject(StorageService);
  private readonly postAuthIntent = inject(PostAuthIntentService);

  async canActivate(): Promise<boolean> {
    if (!this.storage.isAuthenticated()) {
      return true;
    }

    const token = this.storage.getAccessTokenRaw() ?? this.storage.getToken();
    const payload = token ? decodeJwtPayload(token) : null;

    if (payload?.temporal === true || !payload?.empresaId) {
      await this.router.navigateByUrl('/auth/seleccion-razon-social');
      return false;
    }

    const dest = this.postAuthIntent.isAdminTarget() ? '/admin/inicio' : '/sigre/dashboard';
    await this.router.navigateByUrl(dest);
    return false;
  }
}

function decodeJwtPayload(token: string): { temporal?: boolean; empresaId?: number } | null {
  try {
    const parts = token.split('.');
    if (parts.length !== 3) return null;
    let base64 = parts[1].replace(/-/g, '+').replace(/_/g, '/');
    while (base64.length % 4 !== 0) base64 += '=';
    return JSON.parse(atob(base64));
  } catch {
    return null;
  }
}
