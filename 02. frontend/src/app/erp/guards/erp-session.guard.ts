import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { StorageService } from '../../core/services/storage.service';

/**
 * Guard que verifica sesión ERP completa:
 * - Token válido (no expirado)
 * - Token definitivo (no temporal) → tiene empresaId en claims
 * Si falla, redirige al login operativo.
 */
export const erpSessionGuard: CanActivateFn = () => {
  const storage = inject(StorageService);
  const router = inject(Router);

  const token = storage.getToken();
  if (!token) {
    return router.createUrlTree(['/auth/signin']);
  }

  const payload = decodeJwtPayload(token);
  if (!payload || !sesionErpCompleta(payload)) {
    return router.createUrlTree(['/auth/signin']);
  }

  return true;
};

function sesionErpCompleta(payload: { temporal?: boolean | string; empresaId?: number | string | null }): boolean {
  const temporal = payload.temporal;
  const isTemporal = temporal === true || temporal === 'true';
  const empresaId = payload.empresaId;
  return !isTemporal && empresaId != null && String(empresaId).trim() !== '';
}

function decodeJwtPayload(token: string): { temporal?: boolean | string; empresaId?: number | string; [key: string]: unknown } | null {
  try {
    const parts = token.split('.');
    if (parts.length !== 3) return null;
    let base64 = parts[1].replace(/-/g, '+').replace(/_/g, '/');
    while (base64.length % 4 !== 0) base64 += '=';
    const json = atob(base64);
    return JSON.parse(json);
  } catch {
    return null;
  }
}
