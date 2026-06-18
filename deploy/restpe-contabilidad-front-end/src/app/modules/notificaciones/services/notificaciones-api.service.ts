import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { StorageService } from '../../../core/services/storage.service';

export interface NotificacionApiItem {
  id: number;
  empresaId: number;
  titulo: string;
  descripcion: string;
  tipo: string;
  leido: boolean;
  creadoEn: string;
}

export interface NotificacionApiResponse {
  success: boolean;
  message: string;
  errorCode?: string;
  data?: NotificacionApiItem[];
}

export interface NotificacionMarcarLeidaResponse {
  success: boolean;
  message: string;
  errorCode?: string;
  data?: boolean;
}

@Injectable({ providedIn: 'root' })
export class NotificacionesApiService {
  private readonly http = inject(HttpClient);
  private readonly storage = inject(StorageService);
  private readonly baseUrl = environment.apiBaseUrl;

  listar(): Observable<NotificacionApiResponse> {
    return this.http.get<NotificacionApiResponse>(`${this.baseUrl}/notificaciones`, {
      headers: this.authHeaders()
    });
  }

  marcarComoLeida(notificacionId: number): Observable<NotificacionMarcarLeidaResponse> {
    return this.http.post<NotificacionMarcarLeidaResponse>(
      `${this.baseUrl}/notificaciones/leer`,
      { notificacionId },
      { headers: this.authHeaders() }
    );
  }

  private authHeaders(): HttpHeaders {
    const token = this.storage.getToken();
    return new HttpHeaders({
      Authorization: `Bearer ${token}`
    });
  }
}
