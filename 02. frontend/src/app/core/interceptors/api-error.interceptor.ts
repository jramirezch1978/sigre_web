import { Injectable, Injector } from '@angular/core';
import {
  HttpInterceptor, HttpRequest, HttpHandler, HttpEvent, HttpErrorResponse,
} from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { SigreModalService, extraerMensajeErrorApi } from '@sigre-common';

/**
 * Interceptor global: NINGÚN error de API puede ser silencioso. Ante cualquier respuesta de error
 * HTTP muestra un modal popup con el detalle (mensaje del backend + método, endpoint y código HTTP).
 *
 * - Excluye 401 (la gestión de sesión la hace AuthInterceptor con su propio modal).
 * - Una petición puede excluirse explícitamente enviando la cabecera 'X-Skip-Error-Modal'
 *   (p. ej. si un flujo ya muestra su propio error). Ese flujo debe garantizar que no quede silencioso.
 * - Un único modal a la vez (guard) para no apilar varios cuando fallan llamadas en paralelo.
 */
@Injectable()
export class ApiErrorInterceptor implements HttpInterceptor {

  /** Evita apilar varios modales de error simultáneos. */
  private static mostrando = false;

  constructor(private readonly injector: Injector) {}

  intercept(req: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    const omitir = req.headers.has('X-Skip-Error-Modal');
    const limpio = omitir ? req.clone({ headers: req.headers.delete('X-Skip-Error-Modal') }) : req;

    return next.handle(limpio).pipe(
      catchError((error: HttpErrorResponse) => {
        if (!omitir && this.debeMostrar(req, error)) {
          this.mostrarModal(req, error);
        }
        return throwError(() => error);
      }),
    );
  }

  private debeMostrar(req: HttpRequest<unknown>, error: HttpErrorResponse): boolean {
    if (ApiErrorInterceptor.mostrando) return false;       // ya hay un modal de error abierto
    if (error.status === 401) return false;                // sesión: lo maneja AuthInterceptor
    if (this.isLocalAsset(req.url)) return false;          // assets locales, no API
    return true;
  }

  private mostrarModal(req: HttpRequest<unknown>, error: HttpErrorResponse): void {
    ApiErrorInterceptor.mostrando = true;
    const modal = this.injector.get(SigreModalService);

    const mensaje = extraerMensajeErrorApi(error, 'Ocurrió un error al procesar la operación.');
    const codigo = error.status ? `HTTP ${error.status}` : 'sin conexión';
    const detalle = `${mensaje}  (${req.method} ${this.endpoint(req.url)} — ${codigo})`;
    const titulo = error.status ? `Error ${error.status}` : 'Error de conexión';

    void modal.error(detalle, titulo).finally(() => {
      ApiErrorInterceptor.mostrando = false;
    });
  }

  /** Ruta relativa del endpoint (sin protocolo/host) para un mensaje legible. */
  private endpoint(url: string): string {
    const i = url.indexOf('/api/');
    if (i >= 0) return url.substring(i);
    try { return new URL(url).pathname; } catch { return url; }
  }

  private isLocalAsset(url: string): boolean {
    return url.includes('/assets/') || (url.endsWith('.json') && !url.includes('/api/'));
  }
}
