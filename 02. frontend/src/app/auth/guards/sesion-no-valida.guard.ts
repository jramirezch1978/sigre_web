import { Injectable, inject } from '@angular/core';
import { CanActivate, Router, UrlTree } from '@angular/router';
import { StorageService } from '../../core/services/storage.service';
import { PostAuthIntentService } from '../../admin/services/post-auth-intent.service';

/**
 * Impide acceder al login si ya hay sesión ERP completa (misma regla que erpSessionGuard).
 * Usa UrlTree para evitar bucles de navegación que congelan la UI.
 */
@Injectable({
  providedIn: 'root'
})
export class SesionNoValidaGuard implements CanActivate {
  private readonly router = inject(Router);
  private readonly storage = inject(StorageService);
  private readonly postAuthIntent = inject(PostAuthIntentService);

  canActivate(): boolean | UrlTree {
    const token = this.storage.getToken();
    if (!token) {
      return true;
    }

    const payload = decodeJwtPayload(token);
    if (!payload || payload.temporal === true || payload.empresaId == null) {
      return this.router.createUrlTree(['/auth/seleccion-razon-social']);
    }

    const dest = this.postAuthIntent.isAdminTarget() ? '/admin/inicio' : '/sigre/dashboard';
    return this.router.createUrlTree([dest]);
  }
}

function decodeJwtPayload(token: string): { temporal?: boolean; empresaId?: number | string } | null {
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
