import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

/**
 * ==================================================================================
 * 🕐 SERVICIO CENTRALIZADO DE TIEMPO - ÚNICA FUENTE DE VERDAD
 * ==================================================================================
 * 
 * ⚠️ ADVERTENCIA: NO TOCAR ESTA LÓGICA - ESTÁ PERFECTA Y FUNCIONA
 * ⚠️ Este servicio centraliza la hora para toda la aplicación
 * 
 * 🎯 PROPÓSITO:
 * =============
 * - Proveer hora actual a TODOS los componentes de la aplicación
 * - Evitar múltiples consultas al servidor desde diferentes componentes  
 * - Garantizar que TODOS usen exactamente la misma hora (consistencia total)
 * - Centralizar la lógica de servidor vs dispositivo en un solo lugar
 * 
 * 📊 FLUJO DE DATOS:
 * ==================
 * [Clock Component] → Actualiza cada segundo → [ClockService] → [Otros Componentes]
 *        ↑                                            ↓
 *  (Único escritor)                           (Múltiples lectores)
 * 
 * 🔧 ARQUITECTURA:
 * ================
 * - ESCRITOR ÚNICO: Solo Clock Component puede actualizar la hora
 * - LECTORES MÚLTIPLES: Cualquier componente puede suscribirse a la hora
 * - CONSISTENCIA: Todos ven exactamente la misma hora al mismo tiempo
 * - EFICIENCIA: Una sola consulta al servidor, compartida por todos
 * 
 * 🚨 REGLAS CRÍTICAS:
 * ===================
 * - NUNCA consultar servidor desde otros servicios si existe este
 * - NUNCA crear múltiples fuentes de tiempo en la aplicación
 * - SIEMPRE usar este servicio para obtener hora en marcaciones
 * - Clock Component es el ÚNICO autorizado para escribir aquí
 */
@Injectable({
  providedIn: 'root' // Singleton - una sola instancia para toda la app
})
export class ClockService {

  // ==================================================================================
  // 📊 ESTADO INTERNO DEL SERVICIO (FUENTE ÚNICA DE VERDAD)
  // ==================================================================================

  /**
   * 🕐 HORA ACTUAL CENTRALIZADA
   * - Se actualiza cada segundo por Clock Component
   * - Es la hora que usan TODOS los componentes de la aplicación
   * - Puede venir del servidor (precisa) o dispositivo (fallback)
   * - BehaviorSubject: Siempre tiene valor + emite a nuevos suscriptores
   */
  private currentTimeSubject = new BehaviorSubject<Date>(new Date());

  /**
   * 🟢/🔴 ESTADO DE CONEXIÓN AL SERVIDOR
   * - true = Hora viene del servidor (precisa para marcaciones)
   * - false = Hora viene del dispositivo (fallback)
   * - Se actualiza por Clock Component según estado de conexión
   * - Permite a otros componentes mostrar indicadores si es necesario
   */
  private isServerConnectedSubject = new BehaviorSubject<boolean>(false);

  /**
   * 📝 INFORMACIÓN ADICIONAL SOBRE LA FUENTE DE TIEMPO
   * - Descripción legible del origen de la hora
   * - Útil para debugging y display de información al usuario
   * - Ejemplos: "Servidor conectado", "Dispositivo local", "Reconectando..."
   */
  private timeSourceInfoSubject = new BehaviorSubject<string>('Inicializando...');

  // ==================================================================================
  // 📖 MÉTODOS PÚBLICOS PARA LEER DATOS (USADOS POR OTROS COMPONENTES)  
  // ==================================================================================

  /**
   * 🕐 OBTENER HORA ACTUAL COMO OBSERVABLE
   * 
   * 🎯 USO PRINCIPAL:
   * =================
   * Para componentes que necesitan reaccionar a cambios de hora en tiempo real
   * 
   * 📝 EJEMPLO DE USO:
   * ==================
   * ```typescript
   * constructor(private clockService: ClockService) {}
   * 
   * ngOnInit() {
   *   this.clockService.getCurrentTime().subscribe(time => {
   *     console.log('Hora actual:', time);
   *     // Usar time para marcaciones, displays, etc.
   *   });
   * }
   * ```
   */
  getCurrentTime(): Observable<Date> {
    return this.currentTimeSubject.asObservable();
  }

  /**
   * 🕐 OBTENER HORA ACTUAL DE FORMA SÍNCRONA  
   * 
   * 🎯 USO PRINCIPAL:
   * =================
   * Para componentes que necesitan la hora AHORA MISMO (sin suscripción)
   * 
   * 📝 EJEMPLO DE USO:
   * ==================
   * ```typescript
   * const horaParaMarcacion = this.clockService.getCurrentTimeSync();
   * const request = {
   *   fechaMarcacion: horaParaMarcacion.toISOString(),
   *   codigo: this.codigoInput
   * };
   * ```
   */
  getCurrentTimeSync(): Date {
    return this.currentTimeSubject.value;
  }

  /**
   * 🟢/🔴 OBTENER ESTADO DE CONEXIÓN AL SERVIDOR
   * 
   * 🎯 USO PRINCIPAL:
   * =================
   * Para componentes que necesitan mostrar indicadores de conexión
   * 
   * 📝 EJEMPLO DE USO:
   * ==================
   * ```typescript
   * this.clockService.isServerConnected().subscribe(connected => {
   *   this.showServerWarning = !connected;
   *   this.connectionIcon = connected ? 'wifi' : 'wifi_off';
   * });
   * ```
   */
  isServerConnected(): Observable<boolean> {
    return this.isServerConnectedSubject.asObservable();
  }

  /**
   * 🟢/🔴 OBTENER ESTADO DE CONEXIÓN SÍNCRONO
   */
  isServerConnectedSync(): boolean {
    return this.isServerConnectedSubject.value;
  }

  /**
   * 📝 OBTENER INFORMACIÓN DE LA FUENTE DE TIEMPO
   * 
   * 🎯 USO PRINCIPAL:
   * =================
   * Para mostrar información al usuario sobre de dónde viene la hora
   */
  getTimeSourceInfo(): Observable<string> {
    return this.timeSourceInfoSubject.asObservable();
  }

  // ==================================================================================
  // ✏️ MÉTODOS PARA ACTUALIZAR DATOS (SOLO PARA CLOCK COMPONENT)
  // ==================================================================================

  /**
   * ✏️ ACTUALIZAR HORA ACTUAL - SOLO PARA CLOCK COMPONENT
   * 
   * ⚠️ RESTRICCIÓN CRÍTICA:
   * =======================
   * - SOLO Clock Component debe llamar este método
   * - NUNCA llamar desde otros componentes o servicios
   * - Es la única entrada de datos de tiempo al sistema
   * 
   * 🎯 CUÁNDO LLAMAR:
   * =================
   * - Cada segundo desde Clock Component
   * - Después de obtener hora del servidor o dispositivo
   * - NUNCA desde componentes de marcación o asistencia
   */
  updateCurrentTime(time: Date): void {
    this.currentTimeSubject.next(time);
  }

  /**
   * ✏️ ACTUALIZAR ESTADO DE CONEXIÓN - SOLO PARA CLOCK COMPONENT  
   * 
   * 🎯 CUÁNDO LLAMAR:
   * =================
   * - Cuando se conecta/desconecta del servidor
   * - Para mantener sincronizado el estado de conexión
   */
  updateServerConnectionStatus(isConnected: boolean, sourceInfo?: string): void {
    this.isServerConnectedSubject.next(isConnected);
    
    if (sourceInfo) {
      this.timeSourceInfoSubject.next(sourceInfo);
    } else {
      // Info por defecto basada en estado
      const info = isConnected 
        ? 'Hora del servidor (precisa)' 
        : 'Hora del dispositivo (fallback)';
      this.timeSourceInfoSubject.next(info);
    }
  }

  // ==================================================================================
  // 🔧 MÉTODOS DE UTILIDAD PARA MARCACIONES
  // ==================================================================================

  /**
   * 📅 OBTENER FECHA/HORA EN FORMATO PARA MARCACIÓN
   * 
   * 🎯 PROPÓSITO:
   * =============
   * - Devolver fecha en formato exacto que espera el backend
   * - Usar la hora centralizada (servidor o dispositivo según disponibilidad)
   * - Método de conveniencia para componentes de marcación
   * 
   * 📝 EJEMPLO DE USO EN MARCACIÓN:
   * ===============================
   * ```typescript
   * const request = {
   *   codigoInput: this.codigo,
   *   fechaMarcacion: this.clockService.getDateTimeForMarcacion(),
   *   tipoMovimiento: this.tipoMovimiento
   * };
   * ```
   */
  getDateTimeForMarcacion(): string {
    const currentTime = this.getCurrentTimeSync();
    // Formato: "2025-09-15 18:30:45"
    return currentTime.toISOString().slice(0, 19).replace('T', ' ');
  }

  /**
   * 📊 OBTENER INFORMACIÓN COMPLETA DEL ESTADO ACTUAL
   * 
   * 🎯 PROPÓSITO:
   * =============
   * - Método de conveniencia para debugging
   * - Información completa del estado del sistema de tiempo
   */
  getCurrentTimeInfo(): {
    time: Date;
    isServerConnected: boolean;
    sourceInfo: string;
    formattedForMarcacion: string;
  } {
    return {
      time: this.getCurrentTimeSync(),
      isServerConnected: this.isServerConnectedSync(),
      sourceInfo: this.timeSourceInfoSubject.value,
      formattedForMarcacion: this.getDateTimeForMarcacion()
    };
  }
}
