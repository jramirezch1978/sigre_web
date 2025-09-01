import { Component, OnInit } from '@angular/core';
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
  
  // IP del dispositivo
  private deviceIP: string = '';

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private snackBar: MatSnackBar,
    private http: HttpClient,
    private configService: ConfigService,
    private dialog: MatDialog
  ) {}

  async ngOnInit() {
    // Obtener el tipo de marcaje de los query params
    this.tipoMarcaje = this.route.snapshot.queryParams['tipoMarcaje'] || '';
    
    // Inicializar configuración
    await this.configService.waitForConfig();
    
    // Capturar IP del dispositivo
    await this.capturarIPDispositivo();
    
    console.log('🔧 Componente inicializado - Tipo marcaje:', this.tipoMarcaje, 'IP:', this.deviceIP);
  }

  /**
   * PASO 1: Validar código de entrada (DNI, código trabajador o código tarjeta)
   */
  async validarCodigo() {
    if (!this.codigoInput || this.codigoInput.length < 3) {
      this.mostrarMensaje('Por favor, ingrese un código válido (mínimo 3 caracteres)', 'error');
      return;
    }

    this.procesandoValidacion = true;
    
    try {
      const apiUrl = this.configService.getApiUrl() + '/api/asistencia/validar-codigo';
      
      const response = await this.http.post<any>(apiUrl, {
        codigo: this.codigoInput.trim()
      }).toPromise();
      
      if (response.valido) {
        this.nombreTrabajador = response.nombreTrabajador;
        this.codigoTrabajador = response.codigoTrabajador;
        
        this.mostrarMensaje(`Trabajador encontrado: ${this.nombreTrabajador}`, 'success');
        console.log('✅ Trabajador validado:', response);
        
        // PASO 2: Mostrar popup de tipo de asistencia inmediatamente
        setTimeout(() => this.mostrarPopupMovimientos = true, 500);
        
      } else {
        // Error de validación - mostrar popup con mensaje específico
        this.mostrarErrorValidacion(response.mensajeError || 'Código no encontrado');
      }
      
    } catch (error) {
      console.error('❌ Error validando código:', error);
      this.mostrarErrorValidacion('Error de conexión. Intente nuevamente.');
    } finally {
      this.procesandoValidacion = false;
    }
  }
  
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
        console.log('🔄 Regresando a ventana original de marcación');
        this.codigoInput = '';
        this.nombreTrabajador = '';
        this.codigoTrabajador = '';
      }
    });
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
      // PASO 3: Mostrar popup de selección de raciones
      console.log('📍 Ingreso a Planta detectado - Mostrando popup de raciones');
      this.mostrarPopupRaciones = true;
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
  async procesarMarcacionFinal(raciones: RacionDisponible[]) {
    this.procesandoMarcacion = true;
    
    try {
      console.log('🔄 Procesando marcación final - Raciones:', raciones);
      
      // Preparar raciones para la API
      const fechaServicio = new Date();
      fechaServicio.setHours(0, 0, 0, 0); // Truncar a fecha sin hora
      
      const racionesParaApi = raciones.map(racion => ({
        tipoRacion: racion.id,        // ✅ Usar racion.id (no racion.codigo)
        codigoRacion: racion.id,      // ✅ Código de ración
        nombreRacion: racion.nombre,
        fechaServicio: fechaServicio.toISOString() // String ISO para el DTO
      }));
      
      const request = {
        codigoInput: this.codigoInput.trim(),
        tipoMarcaje: this.tipoMarcaje,
        tipoMovimiento: this.tipoMovimientoSeleccionado,
        direccionIp: this.deviceIP,
        fechaMarcacion: new Date().toISOString(),
        racionesSeleccionadas: racionesParaApi
      };
      
      console.log('📤 Enviando request a API:', request);
      
      const apiUrl = this.configService.getApiUrl() + '/api/asistencia/procesar';
      const response = await this.http.post<any>(apiUrl, request).toPromise();
      
      if (!response.error) {
        this.mostrarMensaje(`✅ Marcación procesada exitosamente. Ticket: ${response.ticketId}`, 'success');
        console.log('✅ Ticket creado:', response);
      } else {
        // Error al grabar ticket - según prompt-final, este es el ÚNICO caso donde se detiene el proceso
        this.mostrarErrorCritico(response.mensajeError);
        console.error('❌ Error crítico en API:', response);
        return; // No limpiar campos - permitir reintento
      }
      
    } catch (error) {
      console.error('❌ Error llamando API de marcación:', error);
      // Error crítico de conexión - también detiene el proceso
      this.mostrarErrorCritico('Error de conexión con el servidor. Los datos no se pudieron procesar.');
      this.procesandoMarcacion = false;
      return; // No ejecutar finally para no limpiar campos
    } finally {
      this.procesandoMarcacion = false;
      
      // Solo limpiar campos si llegamos aquí (sin errores críticos)
      setTimeout(() => this.limpiarCamposParaSiguienteTrabajador(), 2000);
    }
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
  }

  volverMenuPrincipal() {
    this.router.navigate(['/']);
  }

  private mostrarMensaje(mensaje: string, tipo: 'success' | 'error') {
    this.snackBar.open(mensaje, '', {
      duration: tipo === 'success' ? 1000 : 3000, // 1 seg para éxito, 3 seg para errores
      horizontalPosition: 'center',
      verticalPosition: 'bottom',
      panelClass: tipo === 'success' ? 'success-snackbar' : 'error-snackbar'
    });
  }
}
