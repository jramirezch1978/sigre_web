import { Injectable } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { ActivatedRouteSnapshot, Router, RouterStateSnapshot } from '@angular/router';
import { ConfigService } from './config.service';

/**
 * Actualiza el titulo de la pestana del navegador de forma centralizada.
 * Formato: "<Titulo de ruta> - <Nombre de empresa>".
 */
@Injectable({ providedIn: 'root' })
export class PageTitleService {
  constructor(
    private readonly title: Title,
    private readonly configService: ConfigService,
    private readonly router: Router
  ) {}

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

    try {
      await this.configService.waitForConfig();
    } catch {
      // Si falla la config, igual mostramos el titulo de ruta.
    }

    const nombreEmpresa = this.configService.getCompanyName();
    const tituloCompleto = nombreEmpresa
      ? `${tituloRuta} - ${nombreEmpresa}`
      : tituloRuta;

    this.title.setTitle(tituloCompleto);
  }

  /** Lee la ruta actual y aplica el titulo correspondiente. */
  actualizarDesdeRouter(): void {
    const titulo = this.resolverTituloRuta(this.router.routerState.snapshot);
    if (titulo) {
      void this.aplicarTitulo(titulo);
    }
  }
}
