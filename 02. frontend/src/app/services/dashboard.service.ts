import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';
import { ConfigService } from './config.service';

// Interfaces para las respuestas del dashboard
export interface EstadisticasGenerales {
  totalRegistrosHoy: number;
  totalRegistrosDbLocal: number;
  totalRegistrosDbRemoto: number;
  ticketsPendientes: number;
  ticketsProcessed: number;
  ticketsError: number;
  ultimaActualizacion: string;
  estadoSincronizacion: string;
}

export interface MarcajesPorHora {
  horas: number[];
  cantidadPorHora: number[];
  cantidadAcumulada: number[];
  totalMarcajes: number;
  fecha: string;
}

export interface MarcajeDelDia {
  reckey: string;
  codigoTrabajador: string;
  nombreTrabajador: string;
  tipoMarcaje: string;
  tipoMovimiento: string;
  descripcionMovimiento: string;
  fechaMovimiento: string;
  centroCosto: string;
  turno: string;
  direccionIp: string;
  estadoSincronizacion: string;
}

export interface ResumenCentroCosto {
  centroCosto: string;
  descripcionCentroCosto: string;
  cantidadMarcajes: number;
  cantidadTrabajadores: number;
}

export interface RacionesPorTipo {
  desayunos: number;
  almuerzos: number;
  cenas: number;
  totalRaciones: number;
  fecha: string;
}

export interface IndicadorCentroCosto {
  tipoTrabajador: string;
  descTipoTrabajador: string;
  codArea: string;
  descArea: string;
  codSeccion: string;
  descSeccion: string;
  descCentroCosto: string;
  ingresoPlanta: number;
  salidaPlanta: number;
  salidaAlmorzar: number;
  regresoAlmorzar: number;
  salidaComision: number;
  retornoComision: number;
  ingresoProduccion: number;
  salidaProduccion: number;
  salidaCenar: number;
  regresoCenar: number;
  total: number;
}

export interface IndicadorArea {
  tipoTrabajador: string;
  descTipoTrabajador: string;
  codArea: string;
  descArea: string;
  descCentroCosto: string;
  ingresoPlanta: number;
  salidaPlanta: number;
  salidaAlmorzar: number;
  regresoAlmorzar: number;
  salidaComision: number;
  retornoComision: number;
  ingresoProduccion: number;
  salidaProduccion: number;
  salidaCenar: number;
  regresoCenar: number;
  total: number;
}

export interface IndicadorSeccion {
  tipoTrabajador: string;
  descTipoTrabajador: string;
  codArea: string;
  descArea: string;
  codSeccion: string;
  descSeccion: string;
  descCentroCosto: string;
  ingresoPlanta: number;
  salidaPlanta: number;
  salidaAlmorzar: number;
  regresoAlmorzar: number;
  salidaComision: number;
  retornoComision: number;
  ingresoProduccion: number;
  salidaProduccion: number;
  salidaCenar: number;
  regresoCenar: number;
  total: number;
}

export interface DashboardResponse {
  estadisticasGenerales: EstadisticasGenerales;
  marcajesDelDia: MarcajesPorHora;
  marcajesUltimas24Horas: MarcajesPorHora;
  listadoMarcajesHoy: MarcajeDelDia[];
  resumenPorCentroCosto: ResumenCentroCosto[];
}

@Injectable({
  providedIn: 'root'
})
export class DashboardService {
  
  private baseUrl: string;
  private dashboardDataSubject = new BehaviorSubject<DashboardResponse | null>(null);
  public dashboardData$ = this.dashboardDataSubject.asObservable();
  
  constructor(
    private http: HttpClient,
    private configService: ConfigService
  ) {
    this.baseUrl = this.configService.getApiUrl('dashboard');
    console.log('🔗 DashboardService - Base URL configurada:', this.baseUrl);
  }

  /**
   * Obtener dashboard completo
   */
  obtenerDashboardCompleto(): Observable<DashboardResponse> {
    const url = `${this.baseUrl}/completo`;
    console.log('📊 Llamando a dashboard completo:', url);
    return this.http.get<DashboardResponse>(url);
  }

  /**
   * Obtener estadísticas generales
   */
  obtenerEstadisticasGenerales(): Observable<EstadisticasGenerales> {
    return this.http.get<EstadisticasGenerales>(`${this.baseUrl}/estadisticas-generales`);
  }

  /**
   * Obtener marcajes del día actual por hora
   */
  obtenerMarcajesDelDia(): Observable<MarcajesPorHora> {
    return this.http.get<MarcajesPorHora>(`${this.baseUrl}/marcajes-del-dia`);
  }

  /**
   * Obtener marcajes de las últimas 24 horas por hora
   */
  obtenerMarcajes24Horas(): Observable<MarcajesPorHora> {
    return this.http.get<MarcajesPorHora>(`${this.baseUrl}/marcajes-24h`);
  }

  /**
   * Obtener listado detallado de marcajes del día
   */
  obtenerListadoMarcajes(): Observable<MarcajeDelDia[]> {
    return this.http.get<MarcajeDelDia[]>(`${this.baseUrl}/listado-marcajes`);
  }

  /**
   * Obtener resumen por centros de costo
   */
  obtenerResumenCentrosCosto(): Observable<ResumenCentroCosto[]> {
    return this.http.get<ResumenCentroCosto[]>(`${this.baseUrl}/resumen-centro-costo`);
  }

  /**
   * Obtener marcajes por centro de costo específico
   */
  obtenerMarcajesPorCentroCosto(centroCosto: string): Observable<any> {
    return this.http.get(`${this.baseUrl}/marcajes-centro-costo/${centroCosto}`);
  }

  /**
   * Actualizar datos del dashboard y notificar a los suscriptores
   */
  async actualizarDashboard(): Promise<void> {
    try {
      console.log('🔄 Iniciando actualización del dashboard...');
      console.log('🔗 URL base:', this.baseUrl);
      
      const data = await this.obtenerDashboardCompleto().toPromise();
      console.log('📊 Datos recibidos del dashboard:', data);
      
      if (data) {
        this.dashboardDataSubject.next(data);
        console.log('✅ Dashboard actualizado exitosamente');
      } else {
        console.warn('⚠️ No se recibieron datos del dashboard');
      }
    } catch (error) {
      console.error('❌ Error actualizando dashboard:', error);
      console.error('❌ Detalles del error:', {
        message: error instanceof Error ? error.message : 'Error desconocido',
        url: this.baseUrl,
        status: error instanceof Error && 'status' in error ? (error as any).status : 'N/A'
      });
      throw error; // Re-lanzar el error para que el componente lo maneje
    }
  }

  /**
   * Obtener datos en caché
   */
  obtenerDatosCache(): DashboardResponse | null {
    return this.dashboardDataSubject.value;
  }

  /**
   * Obtener raciones por tipo del día actual
   */
  obtenerRacionesPorTipo(): Observable<RacionesPorTipo> {
    return this.http.get<RacionesPorTipo>(`${this.baseUrl}/raciones-por-tipo`);
  }

  /**
   * Obtener total de trabajadores únicos que han marcado hoy
   */
  obtenerTrabajadoresUnicosHoy(): Observable<number> {
    return this.http.get<number>(`${this.baseUrl}/trabajadores-unicos-hoy`);
  }

  /**
   * Health check del dashboard
   */
  healthCheck(): Observable<string> {
    return this.http.get(`${this.baseUrl}/health`, { responseType: 'text' });
  }

  /**
   * Obtener indicadores de centros de costo con movimientos pivoteados
   */
  obtenerIndicadoresCentrosCosto(fecha?: string): Observable<IndicadorCentroCosto[]> {
    let url = `${this.baseUrl}/indicadores-centros-costo`;
    if (fecha) {
      url += `?fecha=${fecha}`;
    }
    console.log('🏢 Llamando indicadores centros de costo:', url);
    return this.http.get<IndicadorCentroCosto[]>(url);
  }

  /**
   * Obtener indicadores de áreas con movimientos pivoteados
   */
  obtenerIndicadoresAreas(fecha?: string): Observable<IndicadorArea[]> {
    let url = `${this.baseUrl}/indicadores-areas`;
    if (fecha) {
      url += `?fecha=${fecha}`;
    }
    console.log('🏭 Llamando indicadores áreas:', url);
    return this.http.get<IndicadorArea[]>(url);
  }

  /**
   * Obtener indicadores de secciones con movimientos pivoteados
   */
  obtenerIndicadoresSecciones(fecha?: string): Observable<IndicadorSeccion[]> {
    let url = `${this.baseUrl}/indicadores-secciones`;
    if (fecha) {
      url += `?fecha=${fecha}`;
    }
    console.log('📍 Llamando indicadores secciones:', url);
    return this.http.get<IndicadorSeccion[]>(url);
  }
}
