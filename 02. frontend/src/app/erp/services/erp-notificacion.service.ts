import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map } from 'rxjs';
import { ApiBaseService } from '../../services/api-base.service';
import { ApiResponse } from '../../shared/models/api-response.model';

export interface NotificacionItem {
  id: number;
  titulo: string;
  descripcion: string;
  tipo: string;          // I=info, S=success, W=warning, E=error
  destino_tipo: string;  // U / G
  leido: boolean;
  enviado_en: string;
  origen: string;
}

export interface NotificacionResumen {
  noLeidas: number;
  items: NotificacionItem[];
}

@Injectable({ providedIn: 'root' })
export class ErpNotificacionService {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);

  private get base(): string {
    return `${this.apiBase.getApiBaseUrl()}/auth/seguridad/notificaciones`;
  }

  getResumen(): Observable<NotificacionResumen> {
    return this.http
      .get<ApiResponse<NotificacionResumen>>(this.base)
      .pipe(map(r => r.data ?? { noLeidas: 0, items: [] }));
  }

  marcarTodasLeidas(): Observable<ApiResponse<unknown>> {
    return this.http.post<ApiResponse<unknown>>(`${this.base}/leer-todas`, {});
  }
}
