import { ErrorHandler, Injectable } from '@angular/core';

/**
 * Intercepta ChunkLoadError (lazy-loading de módulos Angular).
 * Ocurre cuando el navegador tiene cacheado un index.html antiguo y los chunks
 * del nuevo build ya no existen. La solución es forzar recarga completa.
 */
@Injectable()
export class ChunkLoadErrorHandler implements ErrorHandler {

  private reloadScheduled = false;

  handleError(error: unknown): void {
    if (this.isChunkLoadError(error)) {
      if (!this.reloadScheduled) {
        this.reloadScheduled = true;
        console.warn('[ChunkLoadError] Detectado chunk obsoleto. Recargando aplicación...');
        window.location.reload();
      }
      return;
    }
    console.error(error);
  }

  private isChunkLoadError(error: unknown): boolean {
    if (!(error instanceof Error)) {
      return false;
    }
    return (
      error.name === 'ChunkLoadError' ||
      error.message?.includes('Loading chunk') ||
      error.message?.includes('ChunkLoadError') ||
      error.message?.includes('Failed to fetch dynamically imported module')
    );
  }
}
