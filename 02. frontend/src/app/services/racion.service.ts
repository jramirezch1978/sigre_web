import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';
import { ConfigService } from './config.service';

export interface RacionResponse {
  id: string;
  nombre: string;
  descripcion: string;
  icono: string;
  disponible: boolean;
  color: string;
  horario: string;
}

export interface RacionSelectionRequest {
  codigoTarjeta: string;
  racionId: string;
}

@Injectable({
  providedIn: 'root'
})
export class RacionService {
  constructor(
    private http: HttpClient,
    private configService: ConfigService
  ) {}

  getRacionesDisponibles(): Observable<RacionResponse[]> {
    const apiUrl = this.configService.getApiUrl('raciones');
    return this.http.get<RacionResponse[]>(`${apiUrl}/disponibles`)
      .pipe(
        catchError(error => {
          console.error('Error al obtener raciones:', error);
          // Fallback con datos mockeados
          return this.getMockRaciones();
        })
      );
  }

  seleccionarRacion(request: RacionSelectionRequest): Observable<string> {
    const apiUrl = this.configService.getApiUrl('raciones');
    return this.http.post<string>(`${apiUrl}/seleccionar`, request)
      .pipe(
        catchError(error => {
          console.error('Error al seleccionar ración:', error);
          return of(`Ración ${request.racionId} seleccionada (modo offline)`);
        })
      );
  }

  getHorarioInfo(): Observable<string> {
    const apiUrl = this.configService.getApiUrl('raciones');
    return this.http.get<string>(`${apiUrl}/horario-info`)
      .pipe(
        catchError(error => {
          console.error('Error al obtener info de horario:', error);
          return of('Información de horario no disponible');
        })
      );
  }

  private getMockRaciones(): Observable<RacionResponse[]> {
    const currentHour = new Date().getHours();
    
    const mockRaciones: RacionResponse[] = [
      {
        id: 'desayuno',
        nombre: 'Desayuno',
        descripcion: 'Incluye café, pan, mantequilla, mermelada y fruta fresca',
        icono: 'free_breakfast',
        disponible: currentHour >= 6 && currentHour < 9,
        color: '#f59e0b',
        horario: '06:00 - 09:00'
      },
      {
        id: 'almuerzo',
        nombre: 'Almuerzo',
        descripcion: 'Plato principal con ensalada, sopa y postre',
        icono: 'lunch_dining',
        disponible: currentHour < 12,
        color: '#10b981',
        horario: '12:00 - 15:00'
      },
      {
        id: 'cena',
        nombre: 'Cena',
        descripcion: 'Cena ligera con ensalada y proteína',
        icono: 'dinner_dining',
        disponible: currentHour >= 12,
        color: '#1e3a8a',
        horario: '18:00 - 21:00'
      }
    ];

    return of(mockRaciones);
  }
}
