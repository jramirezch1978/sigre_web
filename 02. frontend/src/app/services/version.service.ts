import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';

export interface VersionInfo {
  version: string;
  buildTimestamp: string;
  buildDate: Date;
}

@Injectable({
  providedIn: 'root'
})
export class VersionService {

  constructor(private http: HttpClient) { }

  /**
   * Obtener información de versión desde archivo version.json
   */
  getVersionInfo(): Observable<VersionInfo> {
    return this.http.get<VersionInfo>('/assets/version.json').pipe(
      catchError(error => {
        console.warn('No se pudo cargar version.json, usando valores por defecto:', error);
        // Valores por defecto si no se puede cargar el archivo
        return of({
          version: '1.0.0',
          buildTimestamp: new Date().toISOString(),
          buildDate: new Date()
        });
      }),
      map(info => ({
        ...info,
        buildDate: new Date(info.buildTimestamp)
      }))
    );
  }

  /**
   * Obtener versión de la aplicación
   */
  getAppVersion(): Observable<string> {
    return this.getVersionInfo().pipe(
      map(info => info.version)
    );
  }

  /**
   * Obtener timestamp formateado de build
   */
  getBuildTimestamp(): Observable<string> {
    return this.getVersionInfo().pipe(
      map(info => this.formatBuildDate(info.buildDate))
    );
  }

  /**
   * Formatear fecha de build para mostrar
   */
  private formatBuildDate(date: Date): string {
    return date.toLocaleDateString('es-PE', {
      day: '2-digit',
      month: '2-digit',
      hour: '2-digit',
      minute: '2-digit'
    });
  }
}
