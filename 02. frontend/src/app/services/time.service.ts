import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';
import { ConfigService } from './config.service';

export interface ServerTimeResponse {
  timestamp: string;
  formattedTime: string;    // hh:mm:ss a
  formattedDate: string;    // EEEE, d MMMM yyyy
  fullDateTime: string;     // yyyy-MM-dd HH:mm:ss
  hour: number;
  minute: number;
  second: number;
}

@Injectable({
  providedIn: 'root'
})
export class TimeService {
  
  private currentServerTime = new BehaviorSubject<ServerTimeResponse | null>(null);
  public serverTime$ = this.currentServerTime.asObservable();
  private syncInterval: any;

  constructor(
    private http: HttpClient,
    private configService: ConfigService
  ) {
    this.initTimeSync();
  }

  /**
   * Inicializar sincronización de tiempo con el servidor
   */
  private initTimeSync() {
    // Sincronizar inmediatamente
    this.syncWithServer();
    
    // Sincronizar cada 10 segundos para mantener conexión actualizada
    this.syncInterval = setInterval(() => {
      this.syncWithServer();
    }, 1000);
  }

  /**
   * Sincronizar con el servidor para obtener la hora exacta
   */
  private syncWithServer() {
    const timeEndpoint = this.configService.getApiUrl() + '/api/asistencia/api/time/current';
    
    this.http.get<ServerTimeResponse>(timeEndpoint).subscribe({
      next: (serverTime) => {
        this.currentServerTime.next(serverTime);
      },
      error: (error) => {
        console.error('❌ Error sincronizando tiempo con servidor:', error);
        // En caso de error, mantener el último tiempo conocido
      }
    });
  }

  /**
   * Obtener la fecha/hora actual del servidor (sincrónicamente)
   */
  getCurrentServerTime(): ServerTimeResponse | null {
    return this.currentServerTime.value;
  }

  /**
   * Obtener la fecha/hora actual del servidor como Observable
   */
  getCurrentServerTimeObservable(): Observable<ServerTimeResponse | null> {
    return this.serverTime$;
  }

  /**
   * Obtener la fecha/hora actual del servidor para marcación
   * Devuelve el formato exacto que espera el backend
   */
  getMarcacionDateTime(): string {
    const serverTime = this.getCurrentServerTime();
    if (serverTime) {
      return serverTime.fullDateTime; // Formato: yyyy-MM-dd HH:mm:ss
    } else {
      // Fallback: usar hora local del dispositivo (NO recomendado)
      console.warn('⚠️ No se pudo obtener hora del servidor, usando hora local');
      return new Date().toISOString().slice(0, 19).replace('T', ' ');
    }
  }

  /**
   * Forzar una nueva sincronización con el servidor
   */
  forceSyncWithServer(): Observable<ServerTimeResponse> {
    const timeEndpoint = this.configService.getApiUrl() + '/api/asistencia/api/time/current';
    
    return new Observable(observer => {
      this.http.get<ServerTimeResponse>(timeEndpoint).subscribe({
        next: (serverTime) => {
          this.currentServerTime.next(serverTime);
          observer.next(serverTime);
          observer.complete();
        },
        error: (error) => {
          console.error('❌ Error en sincronización forzada:', error);
          observer.error(error);
        }
      });
    });
  }

  /**
   * Limpiar intervalo de sincronización
   */
  ngOnDestroy() {
    if (this.syncInterval) {
      clearInterval(this.syncInterval);
    }
  }
}