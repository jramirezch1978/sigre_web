import { Injectable } from '@angular/core';

export interface JwtClaims {
  userId?: number;
  empresaId?: number;
  temporal?: boolean;
  exp?: number;
}

/**
 * Lectura de claims JWT (solo payload; sin verificar firma).
 * La validez de firma y exp la gestiona StorageService al exponer el token.
 */
@Injectable({ providedIn: 'root' })
export class JwtClaimsReaderService {

  parsePayload(token: string): JwtClaims | null {
    try {
      const parts = token.split('.');
      if (parts.length !== 3) {
        return null;
      }
      // Los JWT usan Base64URL (`-`, `_`, sin relleno); atob solo acepta Base64
      // estándar. Sin esta conversión, los tokens con `-`/`_` fallaban al leer.
      let base64 = parts[1].replace(/-/g, '+').replace(/_/g, '/');
      const padding = base64.length % 4;
      if (padding === 2) {
        base64 += '==';
      } else if (padding === 3) {
        base64 += '=';
      } else if (padding === 1) {
        return null;
      }
      const json = decodeURIComponent(
        atob(base64)
          .split('')
          .map((c) => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
          .join('')
      );
      const payload = JSON.parse(json) as Record<string, unknown>;
      return {
        userId: this.asNumber(payload['userId']),
        empresaId: this.asNumber(payload['empresaId']),
        temporal: payload['temporal'] === true,
        exp: this.asNumber(payload['exp']),
      };
    } catch {
      return null;
    }
  }

  isTemporal(token: string): boolean {
    const c = this.parsePayload(token);
    return c?.temporal === true;
  }

  hasEmpresaContext(token: string): boolean {
    const c = this.parsePayload(token);
    return c != null && c.empresaId != null && !c.temporal;
  }

  getEmpresaId(token: string): number | null {
    const c = this.parsePayload(token);
    return c?.empresaId ?? null;
  }

  private asNumber(v: unknown): number | undefined {
    if (typeof v === 'number' && !Number.isNaN(v)) {
      return v;
    }
    return undefined;
  }
}
