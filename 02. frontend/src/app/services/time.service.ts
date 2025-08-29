import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, interval, switchMap, startWith, BehaviorSubject, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';

export interface ServerTimeResponse {
  timestamp: string;
  formattedTime: string;
  formattedDate: string;
  fullDateTime: string;
  hour: number;
  minute: number;
  second: number;
}

@Injectable({
  providedIn: 'root'
})
export class TimeService {
  private readonly API_URL = 'http://10.100.14.102:9080/api/asistencia/api/time';
  private currentTimeSubject = new BehaviorSubject<Date>(new Date());
  
  constructor(private http: HttpClient) {
    this.startTimeSync();
  }

  private startTimeSync() {
    // Sincronizar con el servidor cada 30 segundos
    interval(30000)
      .pipe(
        startWith(0),
        switchMap(() => this.getServerTime()),
        catchError(() => {
          // Si falla, usar hora local como fallback
          console.warn('No se pudo obtener la hora del servidor, usando hora local');
          return of(new Date());
        })
      )
      .subscribe(serverTime => {
        this.currentTimeSubject.next(serverTime);
      });

    // Actualizar cada segundo basado en la última sincronización
    interval(1000).subscribe(() => {
      const currentTime = this.currentTimeSubject.value;
      const newTime = new Date(currentTime.getTime() + 1000);
      this.currentTimeSubject.next(newTime);
    });
  }

  private getServerTime(): Observable<Date> {
    return this.http.get<ServerTimeResponse>(`${this.API_URL}/current`)
      .pipe(
        map(response => new Date(response.timestamp)),
        catchError(() => {
          // Fallback a hora local si falla la petición
          return of(new Date());
        })
      );
  }

  getCurrentTime(): Observable<Date> {
    return this.currentTimeSubject.asObservable();
  }

  getCurrentTimeSnapshot(): Date {
    return this.currentTimeSubject.value;
  }

  isBeforeNoon(): boolean {
    return this.getCurrentTimeSnapshot().getHours() < 12;
  }

  isAfterNoon(): boolean {
    return this.getCurrentTimeSnapshot().getHours() >= 12;
  }
}
