import { Injectable } from '@angular/core';

/**
 * Destino de navegación tras completar la selección de empresa/sucursal.
 * Encapsula sessionStorage para no acoplar componentes de auth a rutas concretas.
 */
@Injectable({ providedIn: 'root' })
export class PostAuthIntentService {

  private static readonly STORAGE_KEY = 'rpe_post_auth_target';

  /** Tras login, el usuario irá al panel admin en lugar de al ERP. */
  markAdmin(): void {
    sessionStorage.setItem(PostAuthIntentService.STORAGE_KEY, 'admin');
  }

  /** Flujo estándar hacia el ERP. */
  markDefault(): void {
    sessionStorage.removeItem(PostAuthIntentService.STORAGE_KEY);
  }

  /** Indica si el flujo actual debe ir al admin (p. ej. URL con returnUrl=/admin). */
  isAdminTarget(): boolean {
    return sessionStorage.getItem(PostAuthIntentService.STORAGE_KEY) === 'admin';
  }

  /**
   * Obtiene la ruta home y limpia la intención (un solo uso).
   */
  consumeHomeRoute(): '/admin/inicio' | '/sigre/app' {
    const raw = sessionStorage.getItem(PostAuthIntentService.STORAGE_KEY);
    sessionStorage.removeItem(PostAuthIntentService.STORAGE_KEY);
    return raw === 'admin' ? '/admin/inicio' : '/sigre/app';
  }
}
