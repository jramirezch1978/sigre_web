import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable, firstValueFrom } from 'rxjs';
import { filter, map } from 'rxjs/operators';

export interface CompanyConfig {
  name: string;
  logoPath: string;
  sector: string;
  sucursal: string;
  codOrigen: string;
}

export interface ApiConfig {
  baseUrl: string;
  endpoints: {
    time: string;
    raciones: string;
    dashboard: string;
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
  private isLoading = false;
  private loadPromise: Promise<AppSettings> | null = null;

  constructor(private http: HttpClient) {
    this.loadConfig();
  }

  private loadConfig(): void {
    if (this.isLoading || this.loadPromise) {
      return;
    }

    this.isLoading = true;
    this.loadPromise = firstValueFrom(
      this.http.get<{appSettings: AppSettings}>('assets/appsettings.json')
    ).then(response => {
      console.log('Configuración cargada:', response.appSettings);
      this.configSubject.next(response.appSettings);
      this.isLoading = false;
      return response.appSettings;
    }).catch(error => {
      console.error('ERROR CRÍTICO: No se pudo cargar el archivo appsettings.json', error);
      this.isLoading = false;
      this.loadPromise = null;
      throw new Error('Configuración requerida no encontrada: appsettings.json');
    });
  }

  async waitForConfig(): Promise<AppSettings> {
    if (this.configSubject.value) {
      return this.configSubject.value;
    }
    
    if (this.loadPromise) {
      return this.loadPromise;
    }
    
    // Si no hay promesa de carga, intentar cargar de nuevo
    this.loadConfig();
    return this.loadPromise!;
  }

  getConfig$(): Observable<AppSettings> {
    return this.configSubject.pipe(
      filter(config => config !== null),
      map(config => config!)
    );
  }

  getCurrentConfig(): AppSettings {
    const config = this.configSubject.value;
    if (!config) {
      throw new Error('Configuración no disponible. El archivo appsettings.json no se ha cargado correctamente.');
    }
    return config;
  }

  getCompanyName(): string {
    const config = this.configSubject.value;
    return config?.company?.name || 'Transmarina del PERU SAC';
  }

  getCompanyLogo(): string {
    const config = this.configSubject.value;
    return config?.company?.logoPath || 'assets/logo-transmarina.png';
  }

  getCompanySector(): string {
    const config = this.configSubject.value;
    return config?.company?.sector || 'Empresa Hidrobiológica';
  }

  getCompanySucursal(): string {
    const config = this.configSubject.value;
    return config?.company?.sucursal || 'PIURA - SECHURA';
  }

  getCodOrigen(): string {
    const config = this.configSubject.value;
    return config?.company?.codOrigen || 'SE';
  }

  getApiUrl(endpoint?: 'time' | 'raciones' | 'dashboard'): string {
    const config = this.configSubject.value;
    
    if (!config) {
      // URL base por defecto si no hay configuración
      const defaultBaseUrl = 'http://10.100.14.102:9080/api/asistencia';
      
      if (!endpoint) {
        return defaultBaseUrl;
      }
      
      const defaultUrls = {
        time: defaultBaseUrl + '/api/time',
        raciones: defaultBaseUrl + '/api/raciones',
        dashboard: defaultBaseUrl + '/api/dashboard'
      };
      return defaultUrls[endpoint];
    }
    
    // Si no se especifica endpoint, retornar URL base
    if (!endpoint) {
      return config.api.baseUrl;
    }
    
    return `${config.api.baseUrl}${config.api.endpoints[endpoint]}`;
  }

  isConfigLoaded(): boolean {
    return this.configSubject.value !== null;
  }
}