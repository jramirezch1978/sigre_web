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

export interface RacionConfig {
  inicio: string;
  fin: string;
  estado: string;
  hora_inicio_marcacion: string;
  hora_fin_marcacion: string;
}

export interface RacionesConfig {
  horarios: {
    desayuno: RacionConfig;
    almuerzo: RacionConfig;
    cena: RacionConfig;
  };
  reglas: {
    almuerzoCenaHastaMediodia: boolean;
    soloDesayunoEnHorario: boolean;
    botonMarcacionSalidaAlmorzar: {
      inicio: string;
      fin: string;
    };
    botonMarcacionSalidaCenar: {
      inicio: string;
      fin: string;
    };
  };
}

export interface AppSettings {
  company: CompanyConfig;
  api: ApiConfig;
  raciones: RacionesConfig;
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
      // Fallback: estructura consistente con appsettings.json
      const defaultBaseUrl = 'http://10.100.14.102:9080';
      
      if (!endpoint) {
        return defaultBaseUrl;
      }
      
      // Endpoints completos (igual que en appsettings.json)
      const defaultEndpoints = {
        time: '/api/asistencia/api/time',
        raciones: '/api/asistencia/api/raciones', 
        dashboard: '/api/asistencia/api/dashboard'
      };
      return `${defaultBaseUrl}${defaultEndpoints[endpoint]}`;
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

  // ===== MÉTODOS PARA RACIONES DINÁMICAS =====
  
  getRacionesConfig(): RacionesConfig {
    const config = this.configSubject.value;
    if (!config || !config.raciones) {
      throw new Error('Configuración de raciones no disponible');
    }
    return config.raciones;
  }

  getRacionConfig(tipoRacion: 'desayuno' | 'almuerzo' | 'cena'): RacionConfig {
    const racionesConfig = this.getRacionesConfig();
    return racionesConfig.horarios[tipoRacion];
  }

  /**
   * Verificar si una ración está disponible según estado y horario de marcación
   */
  isRacionDisponible(tipoRacion: 'desayuno' | 'almuerzo' | 'cena', horaActual?: Date): boolean {
    try {
      const racionConfig = this.getRacionConfig(tipoRacion);
      
      // Si estado es false, NO está disponible
      if (racionConfig.estado === 'false') {
        return false;
      }
      
      // Si estado es true, verificar horario de marcación
      const hora = horaActual || new Date();
      return this.isHoraEnRangoMarcacion(racionConfig, hora);
      
    } catch (error) {
      console.error(`Error verificando disponibilidad de ${tipoRacion}:`, error);
      return false; // Si hay error, no mostrar la ración
    }
  }

  /**
   * Verificar si la hora actual está en el rango de marcación de una ración
   */
  private isHoraEnRangoMarcacion(racionConfig: RacionConfig, horaActual: Date): boolean {
    const horaMinutos = horaActual.getHours() * 60 + horaActual.getMinutes();
    
    const [horaInicioH, horaInicioM] = racionConfig.hora_inicio_marcacion.split(':').map(n => parseInt(n));
    const [horaFinH, horaFinM] = racionConfig.hora_fin_marcacion.split(':').map(n => parseInt(n));
    
    const inicioMinutos = horaInicioH * 60 + horaInicioM;
    const finMinutos = horaFinH * 60 + horaFinM;
    
    return horaMinutos >= inicioMinutos && horaMinutos <= finMinutos;
  }

  /**
   * Obtener todas las raciones disponibles según configuración actual
   */
  getRacionesDisponibles(horaActual?: Date): Array<{tipo: string, config: RacionConfig, disponible: boolean}> {
    const tipos: Array<'desayuno' | 'almuerzo' | 'cena'> = ['desayuno', 'almuerzo', 'cena'];
    
    return tipos.map(tipo => ({
      tipo,
      config: this.getRacionConfig(tipo),
      disponible: this.isRacionDisponible(tipo, horaActual)
    }));
  }

  /**
   * Verificar si se debe mostrar la ventana de raciones
   * (si hay al menos una ración disponible)
   */
  deberMostrarVentanaRaciones(horaActual?: Date): boolean {
    const racionesDisponibles = this.getRacionesDisponibles(horaActual);
    return racionesDisponibles.some(r => r.disponible);
  }
}