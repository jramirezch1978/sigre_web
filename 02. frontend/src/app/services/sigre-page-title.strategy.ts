import { Injectable } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { RouterStateSnapshot, TitleStrategy } from '@angular/router';
import { ConfigService } from './config.service';

/**
 * Construye el titulo de la pestana del navegador como
 * "<Titulo de ruta> - <Nombre de empresa>" para el modulo de asistencia.
 */
@Injectable({ providedIn: 'root' })
export class SigrePageTitleStrategy extends TitleStrategy {
  constructor(
    private readonly title: Title,
    private readonly configService: ConfigService
  ) {
    super();
  }

  override updateTitle(snapshot: RouterStateSnapshot): void {
    const tituloRuta = this.buildTitle(snapshot);
    if (!tituloRuta) {
      return;
    }

    const nombreEmpresa = this.configService.getCompanyName();
    const tituloCompleto = nombreEmpresa
      ? `${tituloRuta} - ${nombreEmpresa}`
      : tituloRuta;

    this.title.setTitle(tituloCompleto);
  }
}
