import { inject, Injectable, Injector } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { ActivatedRouteSnapshot, Router, RouterStateSnapshot } from '@angular/router';
import { ConfigService } from './config.service';

/**
 * Actualiza el titulo de la pestana del navegador de forma centralizada.
 * Formato: "<Titulo de ruta> - <Nombre de empresa>".
 *
 * Usa Injector para resolver ConfigService y Router en tiempo de uso y
 * evitar dependencias circulares al arrancar (TitleStrategy + APP_INITIALIZER).
 */
@Injectable({ providedIn: 'root' })
export class PageTitleService {
  private readonly injector = inject(Injector);
  private readonly title = inject(Title);

  private obtenerConfigService(): ConfigService | null {
    try {
      return this.injector.get(ConfigService);
    } catch {
      return null;
    }
  }

  private obtenerRouter(): Router | null {
    try {
      return this.injector.get(Router);
    } catch {
      return null;
    }
  }

  /**
   * Resuelve el titulo definido en la ruta activa (propiedad `title` de Routes).
   */
  resolverTituloRuta(snapshot: RouterStateSnapshot): string | undefined {
    let route: ActivatedRouteSnapshot | null = snapshot.root;
    let titulo: string | undefined;

    while (route) {
      if (typeof route.title === 'string' && route.title.trim()) {
        titulo = route.title.trim();
      }
      route = route.firstChild;
    }

    return titulo;
  }

  async aplicarTitulo(tituloRuta: string): Promise<void> {
    if (!tituloRuta.trim()) {
      return;
    }

    let nombreEmpresa = 'SIGRE';
    const configService = this.obtenerConfigService();

    if (configService) {
      try {
        await configService.waitForConfig();
        if (typeof configService.getCompanyName === 'function') {
          nombreEmpresa = configService.getCompanyName() || nombreEmpresa;
        }
      } catch {
        // Si falla la config, usamos el titulo de ruta con nombre por defecto.
      }
    }

    this.title.setTitle(`${tituloRuta} - ${nombreEmpresa}`);
  }

  /** Lee la ruta actual y aplica el titulo correspondiente. */
  actualizarDesdeRouter(): void {
    const router = this.obtenerRouter();
    if (!router?.routerState?.snapshot) {
      return;
    }

    const titulo = this.resolverTituloRuta(router.routerState.snapshot);
    if (titulo) {
      void this.aplicarTitulo(titulo);
    }
  }
}
