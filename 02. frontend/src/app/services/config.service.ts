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

/**
 * Perfil de una empresa (assets/empresas/<empresa>.json). Un archivo por
 * empresa/cliente; agregar una nueva empresa NO requiere tocar código, solo
 * crear su archivo y apuntar EMPRESA_ACTIVA a su nombre en el docker-compose
 * del servidor correspondiente.
 */
export interface EmpresaPerfil extends CompanyConfig {
  apiBaseUrl: string;
}

/** Apuntador assets/empresa-activa.json: qué perfil de empresa cargar. */
export interface EmpresaActivaPointer {
  empresa: string;
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

export interface TurnstileConfig {
  enabled: boolean;
  siteKey: string;
}

export interface SecurityConfig {
  turnstile: TurnstileConfig;
}

export interface AppSettings {
  company: CompanyConfig;
  api: ApiConfig;
  raciones: RacionesConfig;
  security?: SecurityConfig;
}

@Injectable({
  providedIn: 'root'
})
export class ConfigService {
  private configSubject = new BehaviorSubject<AppSettings | null>(null);
  private isLoading = false;
  private loadPromise: Promise<AppSettings> | null = null;

  /** Perfil de respaldo si no se puede leer el archivo de la empresa activa (nunca debe dejar la app sin marca). */
  private static readonly EMPRESA_POR_DEFECTO: EmpresaPerfil = {
    name: 'SIGRE',
    logoPath: 'assets/imagenes/auth/logo-sigre.png',
    sector: 'Gestión Empresarial',
    sucursal: '',
    codOrigen: 'SE',
    apiBaseUrl: 'http://10.100.14.102:9080'
  };

  constructor(private http: HttpClient) {
    this.loadConfig();
  }

  private loadConfig(): void {
    if (this.isLoading || this.loadPromise) {
      return;
    }

    this.isLoading = true;
    this.loadPromise = firstValueFrom(
      this.http.get<{ appSettings: AppSettings }>('assets/appsettings.json')
    ).then(async response => {
      const appSettings = response.appSettings;
      const empresa = await this.cargarPerfilEmpresaActiva();

      appSettings.company = {
        name: empresa.name,
        logoPath: empresa.logoPath,
        sector: empresa.sector,
        sucursal: empresa.sucursal,
        codOrigen: empresa.codOrigen
      };
      appSettings.api.baseUrl = empresa.apiBaseUrl;

      console.log('Configuración cargada:', appSettings);
      this.configSubject.next(appSettings);
      this.isLoading = false;
      return appSettings;
    }).catch(error => {
      console.error('ERROR CRÍTICO: No se pudo cargar el archivo appsettings.json', error);
      this.isLoading = false;
      this.loadPromise = null;
      throw new Error('Configuración requerida no encontrada: appsettings.json');
    });
  }

  /**
   * Lee assets/empresa-activa.json (apuntador, sobrescrito por
   * docker-entrypoint.sh segun EMPRESA_ACTIVA) y luego carga
   * assets/empresas/<empresa>.json con los datos exclusivos de esa empresa.
   * Ante cualquier fallo, devuelve un perfil de respaldo para no romper el arranque.
   */
  private async cargarPerfilEmpresaActiva(): Promise<EmpresaPerfil> {
    let empresa = 'transmarina';
    try {
      const pointer = await firstValueFrom(
        this.http.get<EmpresaActivaPointer>('assets/empresa-activa.json')
      );
      if (pointer?.empresa) {
        empresa = pointer.empresa;
      }
    } catch (error) {
      console.warn('No se pudo leer assets/empresa-activa.json, usando empresa por defecto:', empresa, error);
    }

    try {
      const perfil = await firstValueFrom(
        this.http.get<EmpresaPerfil>(`assets/empresas/${empresa}.json`)
      );
      return perfil;
    } catch (error) {
      console.error(`No se pudo cargar assets/empresas/${empresa}.json, usando perfil por defecto:`, error);
      return ConfigService.EMPRESA_POR_DEFECTO;
    }
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
    return config?.company?.name || 'SIGRE';
  }

  getCompanyLogo(): string {
    const config = this.configSubject.value;
    return config?.company?.logoPath || 'assets/imagenes/auth/logo-sigre.png';
  }

  getCompanySector(): string {
    const config = this.configSubject.value;
    return config?.company?.sector || 'Gestión Empresarial';
  }

  getCompanySucursal(): string {
    const config = this.configSubject.value;
    return config?.company?.sucursal || '';
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

  /** Site key pública de Cloudflare Turnstile (sin secret). */
  getTurnstileSiteKey(): string {
    const config = this.configSubject.value;
    return config?.security?.turnstile?.siteKey?.trim() ?? '';
  }

  /** Activa captcha solo con site key real (no claves 1x/2x/3x de prueba de Cloudflare). */
  isTurnstileEnabled(): boolean {
    const config = this.configSubject.value;
    const ts = config?.security?.turnstile;
    if (ts?.enabled === false) {
      return false;
    }
    const siteKey = ts?.siteKey?.trim() ?? '';
    return siteKey.length > 0 && !/^[123]x/.test(siteKey);
  }
}