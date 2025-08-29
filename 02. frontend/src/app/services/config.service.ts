import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject } from 'rxjs';

export interface CompanyConfig {
  name: string;
  logoPath: string;
  sector: string;
  sucursal: string;
}

export interface ApiConfig {
  baseUrl: string;
  endpoints: {
    time: string;
    raciones: string;
  };
}

export interface AppSettings {
  company: CompanyConfig;
  api: ApiConfig;
}

@Injectable({
  providedIn: 'root'
})
export class ConfigService {
  private configSubject = new BehaviorSubject<AppSettings | null>(null);

  constructor(private http: HttpClient) {
    this.loadConfig();
  }

  private loadConfig(): void {
    this.http.get<{appSettings: AppSettings}>('assets/appsettings.json').subscribe({
      next: (response) => {
        console.log('Configuración cargada:', response.appSettings);
        this.configSubject.next(response.appSettings);
      },
      error: (error) => {
        console.error('ERROR CRÍTICO: No se pudo cargar el archivo appsettings.json', error);
        alert('ERROR: No se pudo cargar la configuración de la aplicación. Verifique que el archivo appsettings.json exista.');
        throw new Error('Configuración requerida no encontrada: appsettings.json');
      }
    });
  }

  getCurrentConfig(): AppSettings {
    const config = this.configSubject.value;
    if (!config) {
      throw new Error('Configuración no disponible. El archivo appsettings.json no se ha cargado correctamente.');
    }
    return config;
  }

  getCompanyName(): string {
    return this.getCurrentConfig().company.name;
  }

  getCompanyLogo(): string {
    return this.getCurrentConfig().company.logoPath;
  }

  getCompanySector(): string {
    return this.getCurrentConfig().company.sector;
  }

  getCompanySucursal(): string {
    return this.getCurrentConfig().company.sucursal;
  }

  getApiUrl(endpoint: 'time' | 'raciones'): string {
    const config = this.getCurrentConfig();
    return `${config.api.baseUrl}${config.api.endpoints[endpoint]}`;
  }
}
