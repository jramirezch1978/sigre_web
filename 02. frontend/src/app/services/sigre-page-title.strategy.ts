import { Injectable } from '@angular/core';
import { RouterStateSnapshot, TitleStrategy } from '@angular/router';
import { PageTitleService } from './page-title.service';

/**
 * Construye el titulo de la pestana del navegador como
 * "<Titulo de ruta> - <Nombre de empresa>" para el modulo de asistencia.
 */
@Injectable({ providedIn: 'root' })
export class SigrePageTitleStrategy extends TitleStrategy {
  constructor(private readonly pageTitleService: PageTitleService) {
    super();
  }

  override updateTitle(snapshot: RouterStateSnapshot): void {
    const tituloRuta = this.buildTitle(snapshot);
    if (tituloRuta) {
      void this.pageTitleService.aplicarTitulo(tituloRuta);
    }
  }
}
