import { Injectable } from '@angular/core';
import { Subject, Observable } from 'rxjs';

type NotificationType = 'success' | 'error' | 'warning' | 'info';

export interface Notification {
  message: string;
  type: NotificationType;
  duration: number;
}

/**
 * Servicio global de notificaciones al usuario.
 * Emite notificaciones que el ToastContainerComponent consume para mostrar.
 *
 * Ejemplo:
 *   this.notification.success('Registro guardado correctamente');
 *   this.notification.error('No se pudo conectar con el servidor');
 */
@Injectable({ providedIn: 'root' })
export class NotificationService {
  private readonly notificationSubject = new Subject<Notification>();

  readonly notification$: Observable<Notification> = this.notificationSubject.asObservable();

  success(message: string, duration = 3000): void {
    this.show(message, 'success', duration);
  }

  error(message: string, duration = 6000): void {
    this.show(message, 'error', duration);
  }

  warning(message: string, duration = 5000): void {
    this.show(message, 'warning', duration);
  }

  info(message: string, duration = 4000): void {
    this.show(message, 'info', duration);
  }

  private show(message: string, type: NotificationType, duration: number): void {
    this.notificationSubject.next({ message, type, duration });
  }
}
