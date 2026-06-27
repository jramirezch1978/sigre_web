import { Injectable, Injector } from '@angular/core';
import { HttpInterceptor, HttpRequest, HttpHandler, HttpEvent, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError, BehaviorSubject } from 'rxjs';
import { catchError, filter, take, switchMap } from 'rxjs/operators';
import { Router } from '@angular/router';
import { StorageService } from '../../core/services/storage.service';
import { SigreModalService, SigreOverlayService } from '@sigre-common';
import { AuthService } from '../services/auth.service';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {

  /** Indica si hay una renovación de token en curso (evita refrescos simultáneos). */
  private refreshing = false;
  /** Emite el nuevo access token cuando termina la renovación, para reintentar las peticiones en cola. */
  private readonly tokenRefreshed$ = new BehaviorSubject<string | null>(null);
  /** Evita mostrar múltiples modales de sesión expirada. */
  private sessionModalShown = false;

  constructor(
    private storage: StorageService,
    private router: Router,
    private injector: Injector
  ) {}

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    // Peticiones a assets locales nunca llevan token ni disparan refresh.
    if (this.isLocalAsset(req.url)) {
      return next.handle(req);
    }

    // Los endpoints de autenticación no llevan bearer ni disparan refresh (evita bucles
    // y que el filtro de seguridad rechace /auth/refresh por un access token vencido).
    if (this.isAuthEndpoint(req.url)) {
      return next.handle(this.addToken(req, null));
    }

    // Si estamos en una ruta pública no requiere autenticación: pasar sin token.
    if (this.isPublicRoute()) {
      return next.handle(this.addToken(req, null));
    }

    // Renovación proactiva: si el access token está vencido o por vencer (30s) y hay
    // refresh token, se renueva antes de enviar la petición.
    if (this.storage.isAccessTokenExpired(30) && this.storage.getRefreshToken()) {
      return this.handleWithRefresh(req, next);
    }

    return next.handle(this.addToken(req, this.storage.getAccessTokenRaw())).pipe(
      catchError((error: HttpErrorResponse) => {
        // Solo se actúa ante 401 de SESIÓN (token expirado/inválido o sesión revocada).
        // Otros 401 (validación, permisos, etc.) se propagan sin cerrar la sesión,
        // igual que el comportamiento original.
        if (error.status === 401 && this.esErrorDeSesion(error)) {
          if (this.storage.getRefreshToken()) {
            return this.handleWithRefresh(req, next, error);
          }
          void this.handleSessionExpired(error);
        }
        return throwError(() => error);
      })
    );
  }

  /** True si el 401 corresponde a un problema de sesión/token (no a validación/permisos). */
  private esErrorDeSesion(error: HttpErrorResponse): boolean {
    const code = error?.error?.errorCode ?? '';
    return (
      code === 'TOKEN_EXPIRADO' ||
      code === 'TOKEN_INVALIDO' ||
      code === 'TOKEN_REQUERIDO' ||
      code === 'SESION_REVOADA' ||
      code === 'SESION_REVOCADA' ||
      code === 'REFRESH_TOKEN_INVALIDO'
    );
  }

  /** Renueva el token (o espera la renovación en curso) y reintenta la petición. */
  private handleWithRefresh(
    req: HttpRequest<any>,
    next: HttpHandler,
    originalError?: HttpErrorResponse
  ): Observable<HttpEvent<any>> {
    if (this.refreshing) {
      // Ya hay una renovación en curso: esperar el nuevo token y reintentar.
      return this.tokenRefreshed$.pipe(
        filter((token): token is string => token != null),
        take(1),
        switchMap((token) => next.handle(this.addToken(req, token)))
      );
    }

    this.refreshing = true;
    this.tokenRefreshed$.next(null);
    const auth = this.injector.get(AuthService);

    return auth.refreshAccessToken().pipe(
      switchMap((newToken) => {
        this.refreshing = false;
        this.tokenRefreshed$.next(newToken);
        return next.handle(this.addToken(req, newToken));
      }),
      catchError((refreshError) => {
        this.refreshing = false;
        void this.handleSessionExpired(originalError ?? refreshError);
        return throwError(() => refreshError);
      })
    );
  }

  /** Adjunta el token (si existe) y mantiene el Content-Type JSON. */
  private addToken(req: HttpRequest<any>, token: string | null): HttpRequest<any> {
    const headers: Record<string, string> = { 'Content-Type': 'application/json' };
    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
      const claims = this.decodeJwtPayload(token);
      if (claims?.['empresaId'] != null) {
        headers['X-Empresa-Id'] = String(claims['empresaId']);
      }
      if (claims?.['sucursalId'] != null) {
        headers['X-Sucursal-Id'] = String(claims['sucursalId']);
      }
    }
    return req.clone({ setHeaders: headers });
  }

  private decodeJwtPayload(token: string): Record<string, unknown> | null {
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

  private isLocalAsset(url: string): boolean {
    return url.includes('/assets/') || url.endsWith('.json') && !url.includes('/api/');
  }

  private isAuthEndpoint(url: string): boolean {
    return (
      url.includes('/auth/login') ||
      url.includes('/auth/refresh') ||
      url.includes('/auth/recuperar') ||
      url.includes('/registro-demo') ||
      url.includes('/landing/')
    );
  }

  private isPublicRoute(): boolean {
    const url = this.router.url;
    return (
      url.startsWith('/sigre/inicio') ||
      url.startsWith('/sigre/modulo') ||
      url.startsWith('/sigre/registro') ||
      url === '/' ||
      url.startsWith('/asistencia') ||
      url.startsWith('/dashboard')
    );
  }

  private async handleSessionExpired(error: HttpErrorResponse): Promise<void> {
    if (this.sessionModalShown || this.isPublicRoute()) {
      return;
    }
    this.sessionModalShown = true;

    // Cierra cualquier modal/popup abierto (MatDialog del ERP + overlays Ionic de admin)
    // antes de avisar y redirigir al login, para que no quede nada encima.
    await this.injector.get(SigreOverlayService).cerrarTodos();

    const message = error?.error?.message ?? 'Su sesión ha expirado. Inicie sesión nuevamente.';
    const modalService = this.injector.get(SigreModalService);
    await modalService.error(message, 'Sesión expirada');

    this.storage.clearSession();
    this.sessionModalShown = false;
    const loginUrl = this.router.url.startsWith('/admin') ? '/admin/login' : '/auth/signin';
    await this.router.navigateByUrl(loginUrl);
  }
}
