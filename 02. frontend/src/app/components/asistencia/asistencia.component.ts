import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, ActivatedRoute } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSnackBarModule, MatSnackBar } from '@angular/material/snack-bar';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatDialogModule, MatDialog } from '@angular/material/dialog';
import { FormsModule } from '@angular/forms';
import { HttpClientModule, HttpClient } from '@angular/common/http';
import { ClockComponent } from '../clock/clock.component';
import { PopupMovimientosComponent, TipoMovimiento } from '../popup-movimientos/popup-movimientos.component';
import { PopupRacionesComponent, RacionDisponible } from '../popup-raciones/popup-raciones.component';
import { ErrorPopupComponent, ErrorData } from '../error-popup/error-popup.component';
import { ConfigService } from '../../services/config.service';
import { ClockService } from '../../services/clock.service';
import { VersionService } from '../../services/version.service';
import { Observable } from 'rxjs';

export interface Racion {
  id: string;
  nombre: string;
  descripcion: string;
  icono: string;
  disponible: boolean;
  color: string;
}

@Component({
  selector: 'app-asistencia',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    HttpClientModule,
    MatCardModule,
    MatFormFieldModule,
    MatInputModule,
    MatButtonModule,
    MatIconModule,
    MatSnackBarModule,
    MatProgressSpinnerModule,
    MatDialogModule,
    ClockComponent,
    PopupMovimientosComponent,
    PopupRacionesComponent
  ],
  templateUrl: './asistencia.component.html',
  styleUrls: ['./asistencia.component.scss']
})
export class AsistenciaComponent implements OnInit {
  
  @ViewChild('codigoInputRef') codigoInputRef!: ElementRef;
  
  // Propiedades principales
  codigoInput: string = '';  // Cambié codigoTarjeta por codigoInput más general
  tipoMarcaje: string = '';
  nombreTrabajador = '';
  codigoTrabajador = '';
  
  // Estados de UI
  mostrarPopupMovimientos = false;
  mostrarPopupRaciones = false;
  procesandoValidacion = false;
  procesandoMarcacion = false;
  
  // Información temporal
  mensajeAsistencia = '';
  tipoMovimientoSeleccionado: string = '';
  racionesSeleccionadas: RacionDisponible[] = [];
  ultimoMovimiento: number = 0;
  requiereAutoCierre: boolean = false;
  
  // IP del dispositivo
  private deviceIP: string = '';

  // Propiedades observables para versión
  appVersion$!: Observable<string>;
  buildTimestamp$!: Observable<string>;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private snackBar: MatSnackBar,
    private http: HttpClient,
    private configService: ConfigService,
    private dialog: MatDialog,
    private clockService: ClockService,  // ← Usar servicio centralizado en lugar de TimeService
    private versionService: VersionService
  ) {}

  async ngOnInit() {
    // Obtener el tipo de marcaje de los query params
    this.tipoMarcaje = this.route.snapshot.queryParams['tipoMarcaje'] || '';
    
    // Inicializar configuración
    await this.configService.waitForConfig();
    
    // Capturar IP del dispositivo
    await this.capturarIPDispositivo();
    
    console.log('🔧 Componente inicializado - Tipo marcaje:', this.tipoMarcaje, 'IP:', this.deviceIP);
    
    // ENFOCAR input automáticamente para lector de tarjetas de proximidad
    setTimeout(() => {
      this.enfocarInput();
    }, 500); // Delay para que el DOM esté completamente cargado

    // Inicializar observables de versión
    this.appVersion$ = this.versionService.getAppVersion();
    this.buildTimestamp$ = this.versionService.getBuildTimestamp();
  }

  /**
   * PASO 1: Validar código de entrada (DNI, código trabajador o código tarjeta)
   */
  validarCodigo() {
    if (!this.codigoInput || this.codigoInput.length < 3) {
      this.mostrarMensaje('Por favor, ingrese un código válido (mínimo 3 caracteres)', 'error');
      return;
    }

    this.procesandoValidacion = true;
    
    try {
      const apiUrl = this.configService.getApiUrl() + '/api/asistencia/validar-codigo';
  
      this.http.post<any>(apiUrl, { 
        codigo: this.codigoInput.trim(),
        codOrigen: this.configService.getCodOrigen()  // ✅ Enviar código de origen
      }).subscribe(
        {
          next: (response) => {
            if (response.valido) {
              this.nombreTrabajador = response.nombreTrabajador;
              this.codigoTrabajador = response.codigoTrabajador;
              this.ultimoMovimiento = response.ultimoMovimiento; // ✅ DIRECTO desde validación
              this.mostrarMensaje(`Trabajador encontrado: ${this.nombreTrabajador}`, 'success');
              
              // 🔍 LOGGING DETALLADO para verificar recepción
              console.log('✅ Trabajador validado:', response);
              console.log('🔍 DEBUG Frontend - response.ultimoMovimiento:', response.ultimoMovimiento);
              console.log('🔍 DEBUG Frontend - this.ultimoMovimiento:', this.ultimoMovimiento);
              console.log('📋 Último movimiento desde validación - Trabajador:', this.codigoTrabajador, 'Último:', this.ultimoMovimiento);
              
              // ✅ MOSTRAR MOVIMIENTOS DIRECTAMENTE (sin llamada adicional)
              this.mostrarPopupMovimientos = true;
              
            } else {
              // Verificar si es error de tiempo mínimo
              if (response.mensajeError && response.mensajeError.startsWith('TIEMPO_MINIMO_ERROR|')) {
                console.log('⏰ Tiempo insuficiente detectado en validación de código');
                this.mostrarErrorTiempoMinimo(response.mensajeError);
              } else {
                this.mostrarErrorValidacion(response.mensajeError || 'Código no encontrado');
              }
            }
          },
          error: (error) => {
            console.error('❌ Error validando código:', error);
            this.mostrarErrorValidacion('Error de conexión');
          }
        }
      );
      
    } catch (error) {
      console.error('❌ Error validando código:', error);
      this.mostrarErrorValidacion('Error de conexión. Intente nuevamente.');
    } finally {
      this.procesandoValidacion = false;
    }
  }
  
  // Método eliminado: obtenerUltimoMovimiento() ya no se usa - toda la lógica está en validarCodigo()
  
  /**
   * Mostrar popup de error de validación según especificación del prompt-final
   */
  private mostrarErrorValidacion(mensaje: string) {
    const errorData: ErrorData = {
      titulo: 'Código No Válido',
      mensaje: mensaje,
      codigoIngresado: this.codigoInput,
      tipoError: 'validacion'
    };
    
    // Abrir popup modal de error
    const dialogRef = this.dialog.open(ErrorPopupComponent, {
      width: '400px',
      disableClose: true, // No permitir cerrar con ESC o click fuera
      data: errorData
    });
    
    // Al cerrar el popup, regresar a ventana original (limpiar campos)
    dialogRef.afterClosed().subscribe((regresarAOriginal: boolean) => {
      if (regresarAOriginal) {
        this.codigoInput = '';
        this.nombreTrabajador = '';
        this.codigoTrabajador = '';
      }
    });
  }
  
  /**
   * Mostrar popup específico para error de tiempo mínimo entre marcaciones
   */
  private mostrarErrorTiempoMinimo(mensajeCompleto: string) {
    try {
      // Parsear mensaje: "TIEMPO_MINIMO_ERROR|codigo|nombre|minutosMinimos|fechaUltimo|minutosRestantes"
      const partes = mensajeCompleto.split('|');
      
      if (partes.length >= 6) {
        const codigo = partes[1];
        const nombre = partes[2];
        const minutosMinimos = partes[3];
        const fechaUltimo = partes[4];
        const minutosRestantes = partes[5];
        
        // Formatear fecha para mostrar de manera amigable
        const fechaFormateada = new Date(fechaUltimo).toLocaleString('es-PE', {
          year: 'numeric',
          month: '2-digit',
          day: '2-digit',
          hour: '2-digit',
          minute: '2-digit',
          second: '2-digit'
        });
        
        const mensajeTiempo = `No se puede realizar otra marcación hasta que hayan pasado ${minutosMinimos} minutos.\n\n` +
                             `⏰ Faltan ${minutosRestantes} minutos para poder marcar nuevamente.\n\n` +
                             `📅 Último marcado: ${fechaFormateada}`;
        
        const errorData: ErrorData = {
          titulo: '⏰ Tiempo Mínimo Entre Marcaciones',
          mensaje: mensajeTiempo,
          codigoIngresado: codigo,
          tipoError: 'tiempo-minimo',
          trabajadorInfo: `${codigo} - ${nombre}`
        };
        
        console.log('⏰ Mostrando error de tiempo mínimo:', errorData);
        
        // Abrir popup modal específico para tiempo mínimo
        const dialogRef = this.dialog.open(ErrorPopupComponent, {
          width: '500px',
          disableClose: true,
          data: errorData
        });
        
        dialogRef.afterClosed().subscribe(() => {
          // Limpiar campos después de cerrar popup de tiempo mínimo
          this.limpiarCamposParaSiguienteTrabajador();
        });
        
      } else {
        // Si no se puede parsear, mostrar error genérico
        console.error('❌ Error parseando mensaje de tiempo mínimo:', mensajeCompleto);
        this.mostrarErrorCritico('Error de tiempo entre marcaciones');
      }
      
    } catch (error) {
      console.error('❌ Error procesando mensaje de tiempo mínimo:', error);
      this.mostrarErrorCritico('Error de tiempo entre marcaciones');
    }
  }
  
  /**
   * Mostrar popup de error crítico que detiene el proceso (solo para errores de grabación de ticket)
   */
  private mostrarErrorCritico(mensaje: string) {
    const errorData: ErrorData = {
      titulo: 'Error Crítico del Sistema',
      mensaje: mensaje,
      codigoIngresado: this.codigoInput,
      tipoError: 'procesamiento'
    };
    
    // Abrir popup modal de error crítico
    const dialogRef = this.dialog.open(ErrorPopupComponent, {
      width: '450px',
      disableClose: true,
      data: errorData
    });
    
    // Al cerrar, regresar a ventana original para permitir reintento
    dialogRef.afterClosed().subscribe((regresarAOriginal: boolean) => {
      if (regresarAOriginal) {
        console.log('🔄 Error crítico - Regresando a ventana original para reintento');
        // NO limpiar codigoInput ni trabajador - permitir reintento inmediato
        this.mostrarPopupMovimientos = false;
        this.mostrarPopupRaciones = false;
        this.procesandoMarcacion = false;
        this.procesandoValidacion = false;
      }
    });
  }

  /**
   * PASO 2: Manejar selección de tipo de movimiento/asistencia
   */
  onMovimientoSeleccionado(movimiento: TipoMovimiento) {
    console.log('✅ Movimiento seleccionado:', movimiento);
    this.mostrarPopupMovimientos = false;
    this.tipoMovimientoSeleccionado = movimiento.codigo;
    
    // Según el prompt-final: Si selecciona "Ingreso a Planta" → ir al Paso 3, sino al Paso 4
    if (movimiento.codigo === 'INGRESO_PLANTA') {
      // PASO 3: Validar si debe mostrar popup de selección de raciones según configuración
      // Capturar momento exacto de evaluación para consistencia temporal (hora del servidor)
      const horaEvaluacion = this.clockService.getCurrentTimeSync();
      const hayRacionesDisponibles = this.configService.deberMostrarVentanaRaciones(horaEvaluacion);
      
      if (hayRacionesDisponibles) {
        console.log('📍 Ingreso a Planta detectado - Mostrando popup de raciones');
        this.mostrarPopupRaciones = true;
      } else {
        console.log('📍 Ingreso a Planta detectado - NO hay raciones disponibles, procesando marcación directamente');
        this.procesarMarcacionFinal([]);
      }
    } else {
      // PASO 4: Ir directamente a procesar marcación (sin raciones)
      console.log('📍 Otro tipo de movimiento - Procesando marcación directamente');
      this.procesarMarcacionFinal([]);
    }
  }

  /**
   * PASO 3: Manejar selección de raciones (múltiples o simple según horario)
   */
  onRacionesSeleccionadas(raciones: RacionDisponible[]) {
    console.log('✅ Raciones confirmadas desde popup:', raciones.map(r => r.nombre));
    this.racionesSeleccionadas = [...raciones];
    
    // Cerrar popup y procesar marcación
    this.mostrarPopupRaciones = false;
    this.procesarMarcacionFinal(this.racionesSeleccionadas);
  }

  onRacionOmitida() {
    console.log('❌ Ración omitida por el usuario');
    this.mostrarPopupRaciones = false;
    
    // PASO 4: Procesar marcación sin raciones
    this.procesarMarcacionFinal([]);
  }

  onPopupCerrado(tipo: 'movimientos' | 'raciones') {
    if (tipo === 'movimientos') {
      this.mostrarPopupMovimientos = false;
    } else {
      this.mostrarPopupRaciones = false;
    }
  }

  getTituloSegunTipo(): string {
    switch (this.tipoMarcaje) {
      case 'puerta-principal':
        return 'Marcaje Puerta Principal';
      case 'area-produccion':
        return 'Marcaje Área de Producción';
      case 'comedor':
        return 'Control de Comedor';
      default:
        return 'Sistema de Asistencia';
    }
  }

  /**
   * PASO 4: Procesar marcación final con API asíncrona
   */
  procesarMarcacionFinal(raciones: RacionDisponible[]) 
  {
    this.procesandoMarcacion = true;
    
    // ⏱️ INICIAR MEDICIÓN DE TIEMPO DE API
    const tiempoInicio = performance.now();
    
    console.log('🔄 Procesando marcación final - Raciones:', raciones);
    
    // Preparar raciones para la API (usar hora del servidor)
    const fechaServicio = new Date(this.clockService.getCurrentTimeSync()); // ✅ CREAR COPIA
    fechaServicio.setHours(0, 0, 0, 0); // Truncar a fecha sin hora SIN afectar original
    
    const racionesParaApi = raciones.map(racion => ({
      tipoRacion: racion.id,        // ✅ Usar racion.id (no racion.codigo)
      codigoRacion: racion.id,      // ✅ Código de ración
      nombreRacion: racion.nombre,
      fechaServicio: fechaServicio.toISOString() // String ISO para el DTO
    }));
    
    // ✅ SOLUCIÓN MEJORADA: Usar tiempo del reloj centralizado (única fuente de verdad)
    const fechaMarcacionCentralizada = this.clockService.getDateTimeForMarcacion();
    const infoTiempo = this.clockService.getCurrentTimeInfo();
    
    console.log('🕐 Fecha de marcación centralizada:', fechaMarcacionCentralizada);
    console.log('🕐 Fuente de tiempo:', infoTiempo.sourceInfo);
    console.log('🟢/🔴 Servidor conectado:', infoTiempo.isServerConnected);

    // Obtener horarios permitidos desde configuración (para validación en backend)
    const config = this.configService.getCurrentConfig();
    const horariosPermitidos = {
      salidaAlmorzar: {
        inicio: config.raciones?.reglas?.botonMarcacionSalidaAlmorzar?.inicio || '12:00',
        fin: config.raciones?.reglas?.botonMarcacionSalidaAlmorzar?.fin || '15:00'
      },
      salidaCenar: {
        inicio: config.raciones?.reglas?.botonMarcacionSalidaCenar?.inicio || '19:30',
        fin: config.raciones?.reglas?.botonMarcacionSalidaCenar?.fin || '21:00'
      }
    };

    const request = {
      codigoInput: this.codigoInput.trim(),
      codOrigen: this.configService.getCodOrigen(), // Código de origen desde configuración
      tipoMarcaje: this.tipoMarcaje,
      tipoMovimiento: this.tipoMovimientoSeleccionado,
      direccionIp: this.deviceIP,
      fechaMarcacion: fechaMarcacionCentralizada, // ✅ Hora del reloj centralizado (servidor o dispositivo)
      racionesSeleccionadas: racionesParaApi,
      horariosPermitidos: horariosPermitidos // ✅ Horarios desde appsettings.json para validación backend
    };
    
    console.log('📤 Enviando request a API:', request);
    console.log('⏱️ Iniciando llamada API a las:', new Date().toLocaleTimeString());
    
    const apiUrl = this.configService.getApiUrl() + '/api/asistencia/procesar';
    
    this.http.post<any>(apiUrl, request).subscribe(
    {
      next: (response) => {
        // ⏱️ MEDIR TIEMPO DE RESPUESTA
        const tiempoTranscurrido = performance.now() - tiempoInicio;
        console.log(`⚡ API RESPONDIÓ EN: ${tiempoTranscurrido.toFixed(0)} ms (${(tiempoTranscurrido/1000).toFixed(2)} segundos)`);
        
        if (tiempoTranscurrido > 500) {
          console.warn(`⚠️ API MUY LENTA: ${tiempoTranscurrido.toFixed(0)} ms - OBJETIVO: <500ms`);
        } else {
          console.log(`✅ API RÁPIDA: ${tiempoTranscurrido.toFixed(0)} ms - DENTRO DEL OBJETIVO`);
        }
        
        if (!response.error) {
          // Mostrar mensaje destacado con el número de ticket hexadecimal
          this.mostrarMensajeTicket(response.numeroTicket, response.nombreTrabajador);
          console.log('✅ Ticket creado:', response);
          
          // Procesar success - continuar con limpieza
          this.finalizarProcesamiento(tiempoInicio);
          
        } else {
          // Verificar si es error de tiempo mínimo
          if (response.mensajeError && response.mensajeError.startsWith('TIEMPO_MINIMO_ERROR|')) {
            this.mostrarErrorTiempoMinimo(response.mensajeError);
          } else {
            // Error al grabar ticket - según prompt-final, este es el ÚNICO caso donde se detiene el proceso
            this.mostrarErrorCritico(response.mensajeError);
          }

          console.error('❌ Error crítico en API:', response);

          this.limpiarCamposParaSiguienteTrabajador();

          this.procesandoMarcacion = false;
          // No limpiar campos - permitir reintento
        }
      },
      error: (error) => {
        console.error('❌ Error llamando API de marcación:', error);
        
        // Construir mensaje de error más detallado
        let mensajeError = 'Error de conexión con el servidor.';
        
        if (error.status === 500) {
          mensajeError = 'Error interno del servidor al procesar la marcación. Por favor contacte al administrador.';
          console.error('🔴 Error 500 - Error interno del servidor:', error);
        } else if (error.status === 400) {
          mensajeError = error.error?.mensajeError || 'Datos inválidos. Verifique la información ingresada.';
          console.error('🟡 Error 400 - Solicitud incorrecta:', error);
        } else if (error.status === 0) {
          mensajeError = 'No se pudo conectar con el servidor. Verifique su conexión a internet.';
          console.error('🔴 Error de red - Sin conexión:', error);
        } else {
          mensajeError = `Error del servidor (${error.status}). ${error.error?.mensajeError || 'Por favor intente nuevamente.'}`;
          console.error('🔴 Error HTTP inesperado:', error);
        }

        // Error crítico - mostrar popup con detalles
        this.mostrarErrorCritico(mensajeError);

        this.limpiarCamposParaSiguienteTrabajador();
        
        this.procesandoMarcacion = false;
        // No limpiar campos - permitir reintento
      }
    });
  }
  
  private finalizarProcesamiento(tiempoInicio: number) {
    // ⏱️ MEDIR TIEMPO TOTAL (incluso con errores)
    const tiempoTotal = performance.now() - tiempoInicio;
    console.log(`⏱️ TIEMPO TOTAL DE PROCESAMIENTO: ${tiempoTotal.toFixed(0)} ms (${(tiempoTotal/1000).toFixed(2)} segundos)`);
    
    if (tiempoTotal > 1000) {
      console.error(`🚨 PROCESAMIENTO MUY LENTO: ${tiempoTotal.toFixed(0)} ms - REVISAR URGENTE`);
    }
    
    console.log('📍 PUNTO 1: API procesada - Loader sigue visible');
    
    // Limpiar campos Y ocultar loader al final
    console.log('📍 PUNTO 2: Iniciando limpieza de campos...');
    this.limpiarCamposParaSiguienteTrabajador();
    
    console.log('📍 PUNTO 3: Campos limpiados - Ocultando loader');
    this.procesandoMarcacion = false; // ← OCULTAR LOADER AL FINAL

    console.log('✅ SECUENCIA CORRECTA: API → Limpieza → Ocultar Loader');
  }
  
  /**
   * Capturar IP del dispositivo marcador (tablet, celular, etc.)
   * IMPORTANTE: IP del equipo marcador, NO del servidor frontend
   */
  async capturarIPDispositivo(): Promise<void> {
    try {
      // Método 1: Intentar WebRTC para obtener IP local real
      const localIP = await this.obtenerIPViaWebRTC();
      if (localIP && localIP !== '127.0.0.1') {
        this.deviceIP = localIP;
        console.log('🌐 IP local del dispositivo via WebRTC:', this.deviceIP);
        return;
      }
    } catch (error) {
      console.warn('⚠️ WebRTC no disponible:', error);
    }
    
    try {
      // Método 2: API externa para IP pública 
      const response = await this.http.get<any>('https://api.ipify.org?format=json').toPromise();
      this.deviceIP = response.ip;
      console.log('🌐 IP pública del dispositivo:', this.deviceIP);
    } catch (error) {
      // Método 3: Fallback - usar timestamp único como identificador
      this.deviceIP = `DEVICE-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
      console.warn('⚠️ No se pudo obtener IP, usando ID único del dispositivo:', this.deviceIP);
    }
  }
  
  /**
   * Obtener IP local usando WebRTC
   */
  private obtenerIPViaWebRTC(): Promise<string> {
    return new Promise((resolve, reject) => {
      try {
        const rtc = new RTCPeerConnection({ iceServers: [] });
        rtc.createDataChannel('');
        
        rtc.createOffer().then(offer => rtc.setLocalDescription(offer));
        
        rtc.onicecandidate = (ice) => {
          if (ice && ice.candidate && ice.candidate.candidate) {
            const candidate = ice.candidate.candidate;
            const ipMatch = candidate.match(/([0-9]{1,3}(\.[0-9]{1,3}){3})/);
            if (ipMatch) {
              rtc.close();
              resolve(ipMatch[1]);
            }
          }
        };
        
        setTimeout(() => {
          rtc.close();
          reject('WebRTC timeout');
        }, 2000);
        
      } catch (error) {
        reject(error);
      }
    });
  }
  


  limpiarCamposParaSiguienteTrabajador() {
    // Limpiar campos pero MANTENER el tipo de marcaje
    this.codigoInput = '';
    this.nombreTrabajador = '';
    this.codigoTrabajador = '';
    this.mensajeAsistencia = '';
    this.tipoMovimientoSeleccionado = '';
    this.racionesSeleccionadas = [];
    this.mostrarPopupMovimientos = false;
    this.mostrarPopupRaciones = false;
    this.procesandoValidacion = false;
    this.procesandoMarcacion = false;
    
    // NO limpiar this.tipoMarcaje - se mantiene para el siguiente trabajador
    console.log('🔄 Campos limpiados para siguiente trabajador. Tipo de marcaje mantenido:', this.tipoMarcaje);
    
    // ENFOCAR automáticamente el input para lector de tarjetas de proximidad
    setTimeout(() => {
      this.enfocarInput();
    }, 100); // Pequeño delay para asegurar que el DOM esté actualizado
  }

  /**
   * Enfocar el input para lector de tarjetas de proximidad
   */
  private enfocarInput() {
    if (this.codigoInputRef && this.codigoInputRef.nativeElement) {
      this.codigoInputRef.nativeElement.focus();
      console.log('🎯 Input enfocado automáticamente para lector de tarjetas');
    } else {
      console.warn('⚠️ Referencia al input no disponible');
    }
  }

  volverMenuPrincipal() {
    this.router.navigate(['/']);
  }

  private mostrarMensaje(mensaje: string, tipo: 'success' | 'error') {
    this.snackBar.open(mensaje, '', {
      duration: tipo === 'success' ? 1000 : 3000, // 1 seg para éxito, 3 seg para errores
      horizontalPosition: 'end', // Parte derecha de la pantalla
      verticalPosition: 'top',   // Parte superior de la pantalla
      panelClass: tipo === 'success' ? 'success-snackbar' : 'error-snackbar'
    });
  }

  /**
   * Mostrar mensaje destacado con el número de ticket generado
   */
  private mostrarMensajeTicket(numeroTicket: string, nombreTrabajador: string) {
    const mensaje = `🎫 TICKET GENERADO: ${numeroTicket}\n✅ ${nombreTrabajador}\n📋 Procesando en segundo plano...`;
    
    this.snackBar.open(mensaje, '✅ ACEPTAR', {
      duration: 3000, // 3 segundos para que lean el número de ticket
      horizontalPosition: 'end', // Parte derecha de la pantalla  
      verticalPosition: 'top',   // Parte superior de la pantalla
      panelClass: 'ticket-success-snackbar'
    });

    // También mostrar en consola para debugging
    console.log(`🎫 TICKET GENERADO: ${numeroTicket} para ${nombreTrabajador}`);
  }

}
