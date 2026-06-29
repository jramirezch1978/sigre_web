import { Injectable, NgZone, inject } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { firstValueFrom } from 'rxjs';
import { environment } from '../../../environments/environment';
import { StorageService } from './storage.service';
import { SigreOverlayService } from '@sigre-common';

/**
 * Cierra sesión tras 30 min de inactividad (prompt login): invalida token en servidor y redirige al login.
 */
@Injectable({ providedIn: 'root' })
export class SessionIdleService {

  private readonly http = inject(HttpClient);
  private readonly storage = inject(StorageService);
  private readonly router = inject(Router);
  private readonly zone = inject(NgZone);
  private readonly overlay = inject(SigreOverlayService);

  private readonly idleMs = 30 * 60 * 1000;
  private timer: ReturnType<typeof setTimeout> | null = null;
  private readonly boundActivity = () => this.onActivity();

  start(): void {
    this.stop();
    this.zone.runOutsideAngular(() => {
      ['click', 'keydown', 'scroll', 'touchstart'].forEach(ev =>
        document.addEventListener(ev, this.boundActivity, { passive: true }));
    });
    this.schedule();
  }

  stop(): void {
    if (this.timer != null) {
      clearTimeout(this.timer);
      this.timer = null;
    }
    this.zone.runOutsideAngular(() => {
      ['click', 'keydown', 'scroll', 'touchstart'].forEach(ev =>
        document.removeEventListener(ev, this.boundActivity));
    });
  }

  private onActivity(): void {
    this.zone.run(() => this.schedule());
  }

  private schedule(): void {
    if (this.timer != null) {
      clearTimeout(this.timer);
    }
    this.timer = setTimeout(() => void this.zone.run(() => void this.onIdle()), this.idleMs);
  }

  private async onIdle(): Promise<void> {
    this.stop();
    const token = this.storage.getToken();
    if (token) {
      try {
        await firstValueFrom(
          this.http.post(
            `${environment.apiBaseUrl}/auth/logout`,
            {},
            { headers: { Authorization: `Bearer ${token}` } }
          )
        );
      } catch {
        /* ignorar error de red */
      }
    }
    this.storage.clearSession();
    // Cierra cualquier modal/popup abierto (MatDialog del ERP, overlays Ionic) para que
    // no quede ninguna ventana encima del login al expirar la sesión por inactividad.
    await this.overlay.cerrarTodos();
    const loginUrl = this.router.url.startsWith('/admin') ? '/admin/login' : '/auth/signin';
    await this.router.navigateByUrl(loginUrl);
  }
}
