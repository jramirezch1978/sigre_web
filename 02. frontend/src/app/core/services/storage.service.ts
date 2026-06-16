import { Injectable } from '@angular/core';

const TOKEN_KEY = 'rpe_access_token';
const REFRESH_KEY = 'rpe_refresh_token';
const USER_KEY = 'rpe_user';
const SESSION_KEY = 'session';

/**
 * Servicio de almacenamiento local para gestión de sesión.
 * Encapsula el acceso a localStorage para facilitar testing y migración.
 *
 * Mantiene compatibilidad con el formato de sesión legacy ('session')
 * y el nuevo formato con tokens separados.
 */
@Injectable({ providedIn: 'root' })
export class StorageService {

  // ── Token de acceso ────────────────────────────────────────────────────

  getToken(): string | null {
    const token = localStorage.getItem(TOKEN_KEY);
    if (token) {
      // No se limpia la sesión al expirar: el refresh token (y la sesión legacy)
      // deben sobrevivir para que el interceptor pueda renovar el access token.
      return this.isTokenValid(token) ? token : null;
    }

    const session = this.getLegacySession();
    const legacyToken = session ? session['authToken'] ?? null : null;
    if (!legacyToken) {
      return null;
    }

    return this.isTokenValid(legacyToken) ? legacyToken : null;
  }

  /**
   * Devuelve el access token tal cual está guardado, SIN validar expiración.
   * Útil para adjuntarlo y dejar que el backend (401) o el chequeo de expiración
   * disparen la renovación con el refresh token.
   */
  getAccessTokenRaw(): string | null {
    const token = localStorage.getItem(TOKEN_KEY);
    if (token) {
      return token;
    }
    const session = this.getLegacySession();
    return session ? session['authToken'] ?? null : null;
  }

  /** True si el access token está vencido o vencerá dentro de `skewSeconds`. */
  isAccessTokenExpired(skewSeconds: number = 0): boolean {
    const token = this.getAccessTokenRaw();
    if (!token) {
      return true;
    }
    const payload = this.decodeJwtPayload(token);
    if (!payload || typeof payload.exp !== 'number') {
      // Si no se puede leer el exp, NO se asume vencido para no botar la sesión:
      // que sea el backend (401) quien decida.
      return false;
    }
    const nowInSeconds = Math.floor(Date.now() / 1000) + skewSeconds;
    return payload.exp <= nowInSeconds;
  }

  setToken(token: string): void {
    localStorage.setItem(TOKEN_KEY, token);
  }

  // ── Refresh token ──────────────────────────────────────────────────────

  getRefreshToken(): string | null {
    return localStorage.getItem(REFRESH_KEY);
  }

  setRefreshToken(token: string): void {
    localStorage.setItem(REFRESH_KEY, token);
  }

  /** True si existe un refresh token y aún no está vencido (según su claim exp). */
  isRefreshTokenValid(): boolean {
    const token = this.getRefreshToken();
    if (!token) {
      return false;
    }
    const payload = this.decodeJwtPayload(token);
    if (!payload) {
      return false;
    }
    // Si el refresh token no trae exp legible, se considera válido (no se descarta):
    // será el endpoint /auth/refresh quien lo rechace si ya no sirve.
    if (typeof payload.exp !== 'number') {
      return true;
    }
    return payload.exp > Math.floor(Date.now() / 1000);
  }

  // ── Datos de usuario ───────────────────────────────────────────────────

  getUser<T = unknown>(): T | null {
    const raw = localStorage.getItem(USER_KEY);
    if (raw) return JSON.parse(raw) as T;

    const session = this.getLegacySession();
    return session ? (session as unknown as T) : null;
  }

  setUser<T>(user: T): void {
    localStorage.setItem(USER_KEY, JSON.stringify(user));
  }

  // ── Sesión ─────────────────────────────────────────────────────────────

  clearSession(): void {
    localStorage.removeItem(TOKEN_KEY);
    localStorage.removeItem(REFRESH_KEY);
    localStorage.removeItem(USER_KEY);
    localStorage.removeItem(SESSION_KEY);
  }

  /** Tokens, usuario, sesión legacy y claves temporales de auth en el navegador. */
  purgeAuthState(): void {
    this.clearSession();
    try {
      sessionStorage.removeItem('rpe_post_auth_target');
    } catch {
      /* entorno sin sessionStorage */
    }
  }

  isAuthenticated(): boolean {
    // Se considera autenticado si hay access token válido o un refresh token
    // vigente con el que renovarlo (el interceptor hará la renovación).
    return !!this.getToken() || this.isRefreshTokenValid();
  }

  // ── Legacy session (compatibilidad con UtilityService) ────────────────

  private getLegacySession(): Record<string, string> | null {
    const raw = localStorage.getItem(SESSION_KEY);
    if (!raw) return null;
    try {
      return JSON.parse(raw);
    } catch {
      return null;
    }
  }

  private isTokenValid(token: string): boolean {
    const payload = this.decodeJwtPayload(token);
    if (!payload) {
      return false;
    }
    // Sin exp legible no se invalida el token (evita botar la sesión por un
    // formato inesperado): el backend lo rechazará con 401 si ya no sirve.
    if (typeof payload.exp !== 'number') {
      return true;
    }
    return payload.exp > Math.floor(Date.now() / 1000);
  }

  /**
   * Decodifica el payload de un JWT. Los JWT usan Base64URL (`-`, `_`, sin
   * relleno `=`), que `atob` NO acepta directamente: hay que convertirlo a
   * Base64 estándar. Antes se usaba `atob` crudo y, cuando el payload contenía
   * `-`/`_`, lanzaba excepción y se trataba el token como inválido → la sesión
   * se cerraba "sola". Devuelve null si no se puede decodificar.
   */
  private decodeJwtPayload(token: string): { exp?: number } | null {
    try {
      const parts = token.split('.');
      if (parts.length !== 3) {
        return null;
      }
      let base64 = parts[1].replace(/-/g, '+').replace(/_/g, '/');
      // Restaurar el relleno que Base64URL omite.
      const padding = base64.length % 4;
      if (padding === 2) {
        base64 += '==';
      } else if (padding === 3) {
        base64 += '=';
      } else if (padding === 1) {
        // Longitud inválida para Base64.
        return null;
      }
      const json = decodeURIComponent(
        atob(base64)
          .split('')
          .map((c) => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
          .join('')
      );
      return JSON.parse(json) as { exp?: number };
    } catch {
      return null;
    }
  }
}
