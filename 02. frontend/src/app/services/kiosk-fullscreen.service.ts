import { Injectable } from '@angular/core';

/**
 * Activa pantalla completa y meta tags de app web en dispositivos kiosco
 * (tablets con IP fija de garita o producción).
 *
 * Los navegadores exigen un gesto del usuario para entrar en fullscreen;
 * si falla al cargar, la UI debe invocar solicitarPantallaCompleta() tras un toque.
 */
@Injectable({
  providedIn: 'root'
})
export class KioskFullscreenService {
  private metaTagsAgregados: HTMLMetaElement[] = [];
  private claseBodyActiva = false;

  estaEnPantallaCompleta(): boolean {
    const doc = document as Document & {
      webkitFullscreenElement?: Element;
      msFullscreenElement?: Element;
    };
    return !!(doc.fullscreenElement || doc.webkitFullscreenElement || doc.msFullscreenElement);
  }

  async solicitarPantallaCompleta(): Promise<boolean> {
    if (this.estaEnPantallaCompleta()) {
      return true;
    }

    const elemento = document.documentElement as HTMLElement & {
      webkitRequestFullscreen?: () => Promise<void>;
      msRequestFullscreen?: () => Promise<void>;
    };

    try {
      if (elemento.requestFullscreen) {
        await elemento.requestFullscreen();
      } else if (elemento.webkitRequestFullscreen) {
        await elemento.webkitRequestFullscreen();
      } else if (elemento.msRequestFullscreen) {
        await elemento.msRequestFullscreen();
      } else {
        return false;
      }
      return this.estaEnPantallaCompleta();
    } catch (error) {
      console.warn('⚠️ No se pudo activar pantalla completa (requiere gesto del usuario):', error);
      return false;
    }
  }

  aplicarMetaTagsApp(): void {
    this.agregarMetaTag('mobile-web-app-capable', 'yes');
    this.agregarMetaTag('apple-mobile-web-app-capable', 'yes');
    this.agregarMetaTag('apple-mobile-web-app-status-bar-style', 'black-translucent');
  }

  activarClaseBodyKiosco(): void {
    if (this.claseBodyActiva) {
      return;
    }
    document.body.classList.add('asistencia-kiosk');
    this.claseBodyActiva = true;
  }

  desactivarModoKiosco(): void {
    document.body.classList.remove('asistencia-kiosk');
    this.claseBodyActiva = false;

    for (const meta of this.metaTagsAgregados) {
      meta.remove();
    }
    this.metaTagsAgregados = [];
  }

  private agregarMetaTag(nombre: string, contenido: string): void {
    if (document.querySelector(`meta[name="${nombre}"]`)) {
      return;
    }
    const meta = document.createElement('meta');
    meta.name = nombre;
    meta.content = contenido;
    document.head.appendChild(meta);
    this.metaTagsAgregados.push(meta);
  }
}
