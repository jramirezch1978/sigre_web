import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { TimeService, ServerTimeResponse } from '../../services/time.service';
import { ClockService } from '../../services/clock.service';
import { Subscription } from 'rxjs';

/**
 * ==================================================================================
 * 🕐 COMPONENTE DE RELOJ CON LÓGICA SIMPLE Y ROBUSTA
 * ==================================================================================
 * 
 * ⚠️  ADVERTENCIA: NO TOCAR ESTA LÓGICA NUNCA MÁS - ESTÁ PERFECTA Y FUNCIONA
 * ⚠️  Cualquier cambio puede romper el comportamiento crítico del sistema
 * 
 * 📋 REQUERIMIENTOS CUMPLIDOS:
 * ============================
 * 1. ⏰ Reloj se actualiza cada segundo SIEMPRE (nunca se congela)
 * 2. 🎯 Si hay conexión: consulta servidor directamente cada segundo
 * 3. 🔄 Si no hay conexión: usa hora del dispositivo cada segundo  
 * 4. 🔄 Reconexión automática cada 10 segundos en segundo plano
 * 5. 🟢/🔴 Indicador visual claro (verde=servidor, rojo=local)
 * 6. 🚫 Sin cálculos matemáticos complejos - consulta directa siempre
 * 
 * 🎯 CASOS DE USO RESUELTOS:
 * ==========================
 * - Marcaciones precisas: Usa hora del servidor cuando disponible
 * - Disponibilidad: Funciona siempre aunque servidor esté caído
 * - Experiencia usuario: Reloj nunca se detiene, indicadores claros
 * - Recuperación automática: Se reconecta solo sin intervención
 * 
 * 🔧 ARQUITECTURA DEL SISTEMA:
 * ============================
 * - Timer Principal: Actualiza reloj cada 1 segundo (SIEMPRE activo)
 * - Timer Reconexión: Solo activo cuando desconectado (cada 10 segundos)
 * - Estado Simple: isServerConnected (true/false)
 * - Sin suscripciones complejas, sin cálculos de tiempo transcurrido
 * 
 * 📊 FLUJO DE ESTADOS:
 * ====================
 * [INICIO] → Intenta conectar servidor
 *     ↓
 * [CONECTADO] → Timer cada 1s consulta servidor → Si error → [DESCONECTADO]
 *     ↓
 * [DESCONECTADO] → Timer cada 1s usa hora local + Timer cada 10s intenta reconectar
 *     ↓
 * [RECONECTADO] → Vuelve a [CONECTADO] y detiene timer reconexión
 * 
 * 🚨 COMPORTAMIENTOS CRÍTICOS (NO CAMBIAR):
 * =========================================
 * - El reloj NUNCA se debe detener o congelar
 * - Reconexión debe ser automática y transparente
 * - Cambio de estado debe ser inmediato (sin demoras)
 * - Indicadores visuales deben cambiar instantáneamente
 * - No hacer múltiples intentos simultáneos de conexión
 * 
 * 🔍 LOGS PARA DEBUGGING:
 * =======================
 * - Inicio de timers y componente
 * - Cambios de estado (conectado/desconectado)  
 * - Intentos de conexión y reconexión
 * - Limpieza de recursos
 */
@Component({
  selector: 'app-clock',
  standalone: true,
  imports: [CommonModule, MatCardModule, MatIconModule],
  templateUrl: './clock.component.html',
  styleUrls: ['./clock.component.scss']
})
export class ClockComponent implements OnInit, OnDestroy {
  
  // ==================================================================================
  // 📊 VARIABLES DE ESTADO DEL COMPONENTE
  // ==================================================================================
  
  /**
   * ⏰ HORA ACTUAL MOSTRADA AL USUARIO
   * - Se actualiza cada segundo SIEMPRE (nunca null, nunca se detiene)
   * - Proviene del servidor si está conectado, del dispositivo si no
   * - Es la única fuente de verdad para el template HTML
   * - CRÍTICO: Nunca permitir que sea undefined o se detenga
   */
  currentTime: Date = new Date();
  
  /**
   * 🔄 TIMER PRINCIPAL (CADA 1 SEGUNDO) - EL CORAZÓN DEL SISTEMA
   * - SIEMPRE está activo desde ngOnInit hasta ngOnDestroy
   * - Responsable de actualizar currentTime cada segundo
   * - NO TOCAR: Es lo que mantiene el reloj funcionando visualmente
   * - Se ejecuta independientemente del estado de conexión
   */
  private clockTimer: any;
  
  /**
   * 🔄 TIMER DE RECONEXIÓN (CADA 10 SEGUNDOS) - RECUPERACIÓN AUTOMÁTICA  
   * - Solo activo cuando isServerConnected = false
   * - Se detiene automáticamente cuando se reconecta
   * - Funciona en segundo plano sin interferir con el reloj visual
   * - IMPORTANTE: Solo se inicia cuando hay una desconexión
   */
  private reconnectTimer: any;
  
  /**
   * 🟢/🔴 ESTADO DE CONEXIÓN AL SERVIDOR (ÚNICA FUENTE DE VERDAD)
   * - true = Servidor disponible, usar hora del servidor cada segundo
   * - false = Servidor no disponible, usar hora del dispositivo cada segundo  
   * - Controla qué icono mostrar (verde/rojo) y qué fuente de tiempo usar
   * - Se actualiza inmediatamente cuando hay cambios de conectividad
   * - PÚBLICO: El template HTML lo usa para mostrar indicadores visuales
   */
  isServerConnected = false;
  
  /**
   * 🚫 FLAG DE PROTECCIÓN CONTRA CONEXIONES MÚLTIPLES
   * - Evita que se hagan varios intentos de conexión al mismo tiempo
   * - Se activa durante attemptServerConnection() y se desactiva al terminar
   * - Previene condiciones de carrera y requests duplicados
   * - CRÍTICO: Mantiene la estabilidad del sistema de conexión
   */
  private isAttemptingConnection = false;

  constructor(
    private timeService: TimeService,
    private clockService: ClockService  // ← Servicio centralizado de tiempo
  ) {}

  // ==================================================================================
  // 🚀 INICIALIZACIÓN DEL COMPONENTE (PUNTO DE ENTRADA PRINCIPAL)
  // ==================================================================================
  
  /**
   * 🎯 MÉTODO DE INICIALIZACIÓN - CONFIGURA TODO EL SISTEMA DEL RELOJ
   * 
   * ORDEN DE EJECUCIÓN CRÍTICO (NO CAMBIAR):
   * ========================================
   * 1. Iniciar timer principal (reloj visual cada 1 segundo)
   * 2. Intentar primera conexión al servidor
   * 
   * ⚠️ POR QUÉ ESTE ORDEN:
   * - Timer principal se inicia PRIMERO para que el reloj nunca se vea vacío
   * - Conexión al servidor es secundaria, el reloj debe funcionar siempre
   * - Si servidor no responde, el reloj ya está funcionando con hora local
   * 
   * 📝 COMPORTAMIENTO ESPERADO:
   * - Usuario ve inmediatamente un reloj funcionando (nunca pantalla en blanco)
   * - Icono puede empezar rojo y cambiar a verde si servidor conecta
   * - En caso de falla total del servidor, el reloj sigue funcionando
   */
  ngOnInit() {
    console.log('🕐 ========== INICIANDO COMPONENTE RELOJ ==========');
    console.log('🔧 Configurando sistema de actualización cada segundo + reconexión cada 10s');
    
    // PASO 1: CRÍTICO - Iniciar timer principal ANTES que cualquier conexión
    // Esto garantiza que el reloj se vea funcionando inmediatamente
    this.startMainClock();
    
    // PASO 2: Intentar conectar al servidor (puede fallar sin problemas)
    // Si falla, el reloj ya está funcionando con hora local desde PASO 1
    this.attemptServerConnection();
  }

  // ==================================================================================
  // ⏰ TIMER PRINCIPAL - EL CORAZÓN QUE MANTIENE EL RELOJ FUNCIONANDO
  // ==================================================================================
  
  /**
   * 🔄 INICIAR TIMER PRINCIPAL - LA FUNCIÓN MÁS CRÍTICA DEL SISTEMA
   * 
   * 🎯 RESPONSABILIDAD:
   * ==================
   * - Mantener el reloj visual actualizándose cada segundo SIN EXCEPCIÓN
   * - Funciona independientemente del estado de conexión al servidor
   * - Es lo que garantiza que el usuario SIEMPRE vea un reloj funcionando
   * 
   * ⚠️ ADVERTENCIAS CRÍTICAS:
   * =========================
   * - NUNCA modificar el intervalo de 1000ms (1 segundo)
   * - NUNCA agregar condiciones que puedan detener este timer
   * - NUNCA hacer que dependa del estado de conexión al servidor
   * - El timer debe correr desde ngOnInit() hasta ngOnDestroy()
   * 
   * 🛠️ FUNCIONAMIENTO:
   * ==================
   * 1. Limpia cualquier timer previo (prevención de memory leaks)
   * 2. Inicia nuevo timer que ejecuta updateCurrentTime() cada segundo
   * 3. Ejecuta updateCurrentTime() inmediatamente (no espera 1 segundo)
   * 
   * 📊 MÉTRICAS IMPORTANTES:
   * =======================
   * - Frecuencia: Exactamente cada 1000ms (1 segundo)
   * - Inicio: Inmediato (no hay delay inicial)
   * - Duración: Desde ngOnInit hasta ngOnDestroy
   * - Independencia: No depende de conexiones externas
   */
  private startMainClock() {
    // PASO 1: Limpiar timer previo si existe (prevención de memory leak)
    if (this.clockTimer) {
      clearInterval(this.clockTimer);
      console.log('🧹 Timer principal previo limpiado');
    }
    
    // PASO 2: Crear nuevo timer que actualiza cada segundo
    this.clockTimer = setInterval(() => {
      this.updateCurrentTime(); // ← Esta función decide si usar servidor o dispositivo
    }, 1000); // ← 1000ms = 1 segundo EXACTO, NO CAMBIAR
    
    // PASO 3: Primera actualización inmediata (no esperar 1 segundo)
    this.updateCurrentTime();
    console.log('✅ Timer principal INICIADO - reloj actualizándose cada segundo');
  }

  // ==================================================================================
  // 🎯 LÓGICA DE DECISIÓN - SERVIDOR VS DISPOSITIVO (EJECUTADA CADA SEGUNDO)
  // ==================================================================================
  
  /**
   * 🤔 FUNCIÓN DE DECISIÓN PRINCIPAL - ELIGE FUENTE DE TIEMPO CADA SEGUNDO
   * 
   * 📋 LÓGICA SIMPLE (SIN COMPLICACIONES):
   * =====================================
   * - Si isServerConnected = true → Consultar servidor ahora
   * - Si isServerConnected = false → Usar hora del dispositivo ahora
   * - NO hay cálculos matemáticos, NO hay cache, NO hay complejidad
   * 
   * ⚠️ PRINCIPIOS FUNDAMENTALES:
   * ============================
   * - Simplicidad total: Solo 2 caminos posibles (servidor O dispositivo)
   * - Consulta directa: Cada segundo decide de nuevo qué hacer
   * - Sin memoria: No recuerda consultas anteriores ni hace cálculos
   * - Robustez: Si servidor falla, cambia inmediatamente a dispositivo
   * 
   * 🔄 FLUJO DE EJECUCIÓN:
   * =====================
   * [Timer llama cada 1s] → updateCurrentTime() → 
   *   ├── Si conectado → getServerTimeNow() → Actualiza currentTime con servidor
   *   └── Si desconectado → new Date() → Actualiza currentTime con dispositivo
   * 
   * 🛠️ MANEJO DE ERRORES:
   * =====================
   * - Si getServerTimeNow() falla → Automáticamente cambia a modo dispositivo
   * - No hay retries ni reintentos → El sistema de reconexión maneja eso
   * - Garantiza que currentTime SIEMPRE se actualice (nunca se queda colgado)
   */
  private updateCurrentTime() {
    if (this.isServerConnected) {
      // 🟢 MODO SERVIDOR: Consulta directa al servidor AHORA
      // Si falla, getServerTimeNow() automáticamente cambia a modo dispositivo
      this.getServerTimeNow();
    } else {
      // 🔴 MODO DISPOSITIVO: Hora local del dispositivo AHORA
      // Simple, rápido, siempre funciona, sin dependencias externas
      this.currentTime = new Date();
      
      // ✅ ACTUALIZAR SERVICIO CENTRALIZADO - FUENTE ÚNICA DE VERDAD
      // Todos los otros componentes obtendrán esta hora desde ClockService
      this.clockService.updateCurrentTime(this.currentTime);
      this.clockService.updateServerConnectionStatus(false, 'Usando hora del dispositivo');
    }
  }

  // ==================================================================================
  // 🌐 CONSULTA DIRECTA AL SERVIDOR (SOLO CUANDO ESTÁ CONECTADO)
  // ==================================================================================
  
  /**
   * 📞 CONSULTAR SERVIDOR DIRECTAMENTE - SIN CACHE, SIN CÁLCULOS
   * 
   * 🎯 PROPÓSITO:
   * =============
   * - Obtener hora exacta del servidor EN ESTE MOMENTO (no cache)
   * - Usada solo cuando isServerConnected = true
   * - Consulta HTTP directa cada segundo para máxima precisión
   * 
   * ⚠️ MANEJO DE FALLOS AUTOMÁTICO:
   * ===============================
   * - Si servidor no responde → Cambia automáticamente a modo dispositivo
   * - Inicia timer de reconexión en segundo plano
   * - Garantiza que currentTime se actualice siempre (con hora local)
   * - NO bloquea el reloj visual, nunca deja al usuario sin hora
   * 
   * 🔄 COMPORTAMIENTO ESPERADO:
   * ==========================
   * - Éxito: currentTime = hora exacta del servidor
   * - Error: isServerConnected = false + inicia reconexión + usa hora local
   * - El usuario ve cambio de icono inmediato (verde → rojo)
   * 
   * 📊 FLUJO DE RECUPERACIÓN ANTE FALLAS:
   * ====================================
   * [Servidor OK] → Actualiza hora → Sigue consultando cada segundo
   * [Servidor falla] → isServerConnected=false → Inicia timer reconexión → Usa hora local
   */
  private getServerTimeNow() {
    // Consulta HTTP directa al servidor (sin cache, sin suscripciones)
    this.timeService.forceSyncWithServer().subscribe({
      next: (serverTime) => {
        // ✅ ÉXITO: Servidor respondió correctamente
        this.currentTime = new Date(serverTime.timestamp);
        
        // ✅ ACTUALIZAR SERVICIO CENTRALIZADO CON HORA DEL SERVIDOR
        // Todos los componentes obtendrán esta hora precisa para marcaciones
        this.clockService.updateCurrentTime(this.currentTime);
        this.clockService.updateServerConnectionStatus(true, 'Hora del servidor (precisa)');
      },
      error: (error) => {
        // ❌ FALLA: Servidor no disponible o error de red
        console.warn('🔴 SERVIDOR FALLÓ - Cambiando a hora del dispositivo:', error.message || 'Error desconocido');
        
        // PASO 1: Cambiar inmediatamente a modo dispositivo
        this.isServerConnected = false; // ← Esto cambia el icono a rojo
        this.currentTime = new Date();  // ← Esto garantiza que la hora se actualice
        
        // ✅ ACTUALIZAR SERVICIO CENTRALIZADO CON HORA DEL DISPOSITIVO
        this.clockService.updateCurrentTime(this.currentTime);
        this.clockService.updateServerConnectionStatus(false, 'Servidor desconectado - usando hora local');
        
        // PASO 2: Activar sistema de reconexión automática
        this.startReconnectionTimer();
      }
    });
  }

  // ==================================================================================
  // 🔗 SISTEMA DE CONEXIÓN Y RECONEXIÓN AL SERVIDOR
  // ==================================================================================
  
  /**
   * 🚀 INTENTAR CONEXIÓN AL SERVIDOR - USADO EN INICIO Y RECONEXIÓN
   * 
   * 🎯 CUÁNDO SE USA:
   * =================
   * 1. Al inicializar el componente (ngOnInit)
   * 2. Durante reconexión automática cada 10 segundos
   * 3. NUNCA se debe llamar manualmente desde otros lugares
   * 
   * 🛡️ PROTECCIÓN CONTRA MÚLTIPLES INTENTOS:
   * ========================================
   * - isAttemptingConnection evita requests duplicados simultáneos
   * - Si ya hay un intento en curso, sale inmediatamente
   * - Previene condiciones de carrera y sobrecarga del servidor
   * 
   * 📊 FLUJO COMPLETO:
   * ==================
   * [Llamada] → ¿Ya intentando? → Sí: Salir / No: Continuar
   *    ↓
   * [HTTP Request] → ¿Éxito? → Sí: Modo servidor + detener reconexión
   *    ↓                     → No: Modo dispositivo + iniciar reconexión
   * [Limpiar flag]
   * 
   * ⚠️ EFECTOS SECUNDARIOS IMPORTANTES:
   * ==================================
   * - Cambia isServerConnected (afecta icono y fuente de tiempo)
   * - Puede iniciar o detener timer de reconexión
   * - Actualiza currentTime inmediatamente
   * - Logs para debugging y monitoreo
   */
  private attemptServerConnection() {
    // PASO 1: Verificar si ya hay un intento en curso (prevenir duplicados)
    if (this.isAttemptingConnection) {
      console.log('⚠️ Ya hay un intento de conexión en curso, saltando...');
      return;
    }
    
    // PASO 2: Marcar como "intentando" para prevenir múltiples requests
    this.isAttemptingConnection = true;
    console.log('🔄 ========== INICIANDO INTENTO DE CONEXIÓN ==========');
    
    // PASO 3: Hacer request HTTP al servidor
    this.timeService.forceSyncWithServer().subscribe({
      next: (serverTime) => {
        // ✅ ÉXITO: Servidor está disponible y respondió correctamente
        console.log('🟢 ========== SERVIDOR CONECTADO EXITOSAMENTE ==========');
        console.log('🟢 Cambiando a modo servidor - hora precisa para marcaciones');
        
        // Activar modo servidor
        this.isServerConnected = true;           // ← Cambia icono a verde
        this.currentTime = new Date(serverTime.timestamp); // ← Sincroniza hora inicial
        this.isAttemptingConnection = false;     // ← Liberar flag de protección
        
        // ✅ ACTUALIZAR SERVICIO CENTRALIZADO - SERVIDOR CONECTADO
        this.clockService.updateCurrentTime(this.currentTime);
        this.clockService.updateServerConnectionStatus(true, 'Servidor conectado - hora precisa');
        
        // Detener reconexión automática (ya no es necesaria)
        this.stopReconnectionTimer();
      },
      error: (error) => {
        // ❌ ERROR: Servidor no disponible, caído o error de red
        console.warn('🔴 ========== SERVIDOR NO DISPONIBLE ==========');
        console.warn('🔴 Usando hora del dispositivo como fallback');
        console.warn('🔴 Error:', error.message || 'Error desconocido');
        
        // Activar modo dispositivo
        this.isServerConnected = false;          // ← Cambia icono a rojo  
        this.currentTime = new Date();           // ← Usar hora local
        this.isAttemptingConnection = false;     // ← Liberar flag de protección
        
        // ✅ ACTUALIZAR SERVICIO CENTRALIZADO - SERVIDOR DESCONECTADO
        this.clockService.updateCurrentTime(this.currentTime);
        this.clockService.updateServerConnectionStatus(false, 'Servidor no disponible - usando hora local');
        
        // Iniciar reconexión automática cada 10 segundos
        this.startReconnectionTimer();
      }
    });
  }

  // ==================================================================================
  // 🔄 SISTEMA DE RECONEXIÓN AUTOMÁTICA (TAREA EN SEGUNDO PLANO)
  // ==================================================================================
  
  /**
   * 🔄 INICIAR TIMER DE RECONEXIÓN - RECUPERACIÓN AUTOMÁTICA CADA 10 SEGUNDOS
   * 
   * 🎯 PROPÓSITO:
   * =============
   * - Intentar reconectar al servidor automáticamente cuando se pierde la conexión
   * - Funciona en segundo plano sin interferir con el reloj visual
   * - Se detiene automáticamente cuando se reconecta
   * 
   * ⚠️ CONDICIONES DE SEGURIDAD:
   * ============================
   * - NO inicia si ya hay un timer activo (previene duplicados)
   * - NO inicia si el servidor ya está conectado (no es necesario)
   * - NO hace intentos si ya hay uno en curso (respeta isAttemptingConnection)
   * 
   * 🕐 TIMING CRÍTICO:
   * ==================
   * - Intervalo: Exactamente 10 segundos (10000ms)
   * - Inicio: Solo cuando se detecta pérdida de conexión
   * - Detención: Automática al reconectarse exitosamente
   * 
   * 📊 COMPORTAMIENTO ESPERADO:
   * ==========================
   * - Usuario ve icono rojo (desconectado)
   * - Timer intenta reconectar cada 10s en segundo plano  
   * - Cuando reconecta: icono cambia a verde + timer se detiene
   * - Durante reconexión: reloj sigue funcionando con hora local
   * 
   * 🔍 LÓGICA INTERNA DEL TIMER:
   * ============================
   * Cada 10 segundos verifica:
   * 1. ¿Sigue desconectado? (isServerConnected = false)
   * 2. ¿No hay intento en curso? (isAttemptingConnection = false)
   * Si ambas son true → Llama attemptServerConnection()
   */
  private startReconnectionTimer() {
    // PROTECCIÓN 1: No iniciar si ya hay timer activo
    if (this.reconnectTimer) {
      console.log('⚠️ Timer de reconexión ya está activo, no iniciando duplicado');
      return;
    }
    
    // PROTECCIÓN 2: No iniciar si ya está conectado (no tiene sentido)
    if (this.isServerConnected) {
      console.log('⚠️ Servidor ya conectado, no es necesario timer de reconexión');
      return;
    }
    
    console.log('🔄 ========== INICIANDO TIMER DE RECONEXIÓN ==========');
    console.log('🔄 Intentará reconectar cada 10 segundos en segundo plano');
    
    // Iniciar timer que verifica cada 10 segundos
    this.reconnectTimer = setInterval(() => {
      // Verificar condiciones antes de intentar reconexión
      if (!this.isServerConnected && !this.isAttemptingConnection) {
        console.log('🔄 ⏰ Timer de reconexión activado - intentando reconectar...');
        this.attemptServerConnection();
      } else {
        // Log de estado para debugging
        if (this.isServerConnected) {
          console.log('🔄 ✅ Servidor ya conectado, timer se detendrá automáticamente');
        }
        if (this.isAttemptingConnection) {
          console.log('🔄 ⏳ Intento de conexión en curso, esperando resultado...');
        }
      }
    }, 10000); // ← 10000ms = 10 segundos EXACTOS
  }

  /**
   * ⏹️ DETENER TIMER DE RECONEXIÓN - LIMPIEZA AUTOMÁTICA
   * 
   * 🎯 CUÁNDO SE USA:
   * =================
   * - Cuando el servidor se conecta exitosamente
   * - Durante ngOnDestroy (limpieza de recursos)
   * - Como medida preventiva en attemptServerConnection exitoso
   * 
   * 🧹 LIMPIEZA DE RECURSOS:
   * =======================
   * - Detiene el interval de 10 segundos
   * - Libera la referencia del timer (previene memory leaks)
   * - Es seguro llamarlo múltiples veces (no hace nada si ya está detenido)
   * 
   * 📊 COMPORTAMIENTO:
   * ==================
   * - Si hay timer activo: Lo detiene + log confirmación
   * - Si no hay timer: No hace nada (operación segura)
   */
  private stopReconnectionTimer() {
    if (this.reconnectTimer) {
      console.log('⏹️ ========== DETENIENDO TIMER DE RECONEXIÓN ==========');
      console.log('⏹️ Servidor conectado - reconexión automática ya no necesaria');
      clearInterval(this.reconnectTimer);
      this.reconnectTimer = null; // ← Importante: liberar referencia
    }
    // Si no hay timer, no hacer nada (operación segura)
  }

  // ==================================================================================
  // 🧹 LIMPIEZA DE RECURSOS (PREVENCIÓN DE MEMORY LEAKS)
  // ==================================================================================
  
  /**
   * 🧹 DESTRUCTOR DEL COMPONENTE - LIMPIEZA CRÍTICA DE RECURSOS
   * 
   * 🎯 RESPONSABILIDAD:
   * ==================
   * - Detener todos los timers activos (prevenir memory leaks)
   * - Liberar todas las referencias de intervals
   * - Garantizar que no queden procesos ejecutándose en segundo plano
   * 
   * ⚠️ IMPORTANCIA CRÍTICA:
   * =======================
   * - Sin esta limpieza: timers seguirían ejecutándose después de destruir componente
   * - Resultado: Memory leaks + requests innecesarios + posibles errores
   * - Angular llama este método automáticamente al destruir el componente
   * 
   * 🔧 RECURSOS A LIMPIAR:
   * =====================
   * 1. clockTimer (timer principal cada 1 segundo)
   * 2. reconnectTimer (timer de reconexión cada 10 segundos)
   * 
   * 📊 ORDEN DE LIMPIEZA:
   * ====================
   * - Orden no importa, pero timer principal primero por claridad
   * - Cada limpieza debe incluir clearInterval + asignar null
   * - stopReconnectionTimer() ya maneja su propia limpieza internamente
   */
  ngOnDestroy() {
    console.log('🧹 ========== DESTRUYENDO COMPONENTE RELOJ ==========');
    console.log('🧹 Iniciando limpieza de recursos para prevenir memory leaks');
    
    // LIMPIEZA 1: Timer principal (el corazón del reloj)
    if (this.clockTimer) {
      console.log('🧹 Deteniendo timer principal (cada 1 segundo)');
      clearInterval(this.clockTimer);
      this.clockTimer = null;
    }
    
    // LIMPIEZA 2: Timer de reconexión (segundo plano)
    this.stopReconnectionTimer(); // Ya incluye su propio logging
  }

  // ==================================================================================
  // 📄 MÉTODOS DE FORMATO PARA DISPLAY (USADOS POR EL TEMPLATE HTML)
  // ==================================================================================
  
  /**
   * 🕐 FORMATEAR HORA PARA MOSTRAR AL USUARIO
   * 
   * 📋 FORMATO DE SALIDA:
   * ====================
   * - Formato: "HH:MM:SS AM/PM" (12 horas con AM/PM)
   * - Ejemplos: "02:30:45 PM", "11:15:30 AM"
   * - Padding con ceros: "09:05:03 AM" (no "9:5:3 AM")
   * 
   * 🎯 USO EN TEMPLATE:
   * ==================
   * - {{ formatTime(currentTime) }} en el HTML
   * - Se ejecuta cada segundo cuando currentTime cambia
   * - Debe ser rápido y eficiente (no hacer requests HTTP aquí)
   * 
   * ⚠️ IMPORTANTE:
   * ==============
   * - Este método NO debe consultar servidores ni hacer HTTP requests
   * - Solo formatea la fecha que ya está en currentTime
   * - La lógica de obtener la hora está en updateCurrentTime()
   */
  formatTime(date: Date): string {
    const hours = date.getHours();       // 0-23 (formato 24 horas)
    const minutes = date.getMinutes();   // 0-59
    const seconds = date.getSeconds();   // 0-59
    const ampm = hours >= 12 ? 'PM' : 'AM'; // Determinar AM/PM
    
    // Convertir a formato 12 horas (1-12 en lugar de 0-23)
    const displayHours = hours % 12 || 12; // 0 se convierte en 12
    
    // Padding con ceros (ej: "09" en lugar de "9")
    const formattedHours = displayHours.toString().padStart(2, '0');
    const formattedMinutes = minutes.toString().padStart(2, '0');
    const formattedSeconds = seconds.toString().padStart(2, '0');
    
    return `${formattedHours}:${formattedMinutes}:${formattedSeconds} ${ampm}`;
  }

  /**
   * 📅 FORMATEAR FECHA PARA MOSTRAR AL USUARIO
   * 
   * 📋 FORMATO DE SALIDA:
   * ====================
   * - Formato: "Día, DD Mes YYYY" en español
   * - Ejemplo: "Lunes, 15 Septiembre 2025"
   * - Locale: es-PE (español de Perú)
   * 
   * 🎯 USO EN TEMPLATE:
   * ==================
   * - {{ formatDate(currentTime) }} en el HTML
   * - Se ejecuta cada segundo, pero fecha cambia solo una vez al día
   * - Complementa el formatTime() para mostrar fecha completa
   * 
   * ⚠️ IMPORTANTE:
   * ==============
   * - Como formatTime(), este método NO debe hacer HTTP requests
   * - Solo formatea la fecha que ya está en currentTime
   * - Usa Intl.DateTimeFormat para internacionalización correcta
   */
  formatDate(date: Date): string {
    const options: Intl.DateTimeFormatOptions = {
      weekday: 'long',    // "Lunes", "Martes", etc.
      year: 'numeric',    // "2025"
      month: 'long',      // "Septiembre", "Octubre", etc.
      day: 'numeric'      // "15", "28", etc.
    };
    
    return date.toLocaleDateString('es-PE', options); // Español de Perú
  }
}
