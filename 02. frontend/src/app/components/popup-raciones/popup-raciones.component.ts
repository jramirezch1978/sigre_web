import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { ConfigService } from '../../services/config.service';
import { ClockService } from '../../services/clock.service';

export interface RacionDisponible {
  id: string;
  nombre: string;
  icono: string;
  color: string;
  horario: string;
  disponible: boolean;
  yaSeleccionada: boolean;
}

@Component({
  selector: 'app-popup-raciones',
  standalone: true,
  imports: [
    CommonModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule
  ],
  templateUrl: './popup-raciones.component.html',
  styleUrls: ['./popup-raciones.component.scss']
})
export class PopupRacionesComponent implements OnInit {
  @Input() nombreTrabajador: string = '';
  @Input() codigoTrabajador: string = '';
  @Input() mensajeAsistencia: string = '';
  @Output() racionesSeleccionadas = new EventEmitter<RacionDisponible[]>();
  @Output() racionOmitida = new EventEmitter<void>();
  @Output() cerrar = new EventEmitter<void>();

  fechaActual = new Date(); // Se actualiza en ngOnInit con hora del servidor
  racionesDisponibles: RacionDisponible[] = [];
  racionesElegidas: RacionDisponible[] = [];
  esAntesMediodia: boolean = false;
  puedeSeleccionarMultiples: boolean = false;

  constructor(
    private configService: ConfigService,
    private clockService: ClockService
  ) {}

  ngOnInit() {
    // Actualizar fecha con hora del servidor
    this.fechaActual = this.clockService.getCurrentTimeSync();
    this.cargarRacionesDisponibles();
  }

  private cargarRacionesDisponibles() {
    const horaActual = this.clockService.getCurrentTimeSync();
    const hora = horaActual.getHours();
    
    console.log(`🕐 Hora actual del servidor: ${hora}:${horaActual.getMinutes().toString().padStart(2, '0')}`);
    
    try {
      // Obtener configuración dinámica de raciones
      const racionesConfig = this.configService.getRacionesDisponibles(horaActual);
      
      // Mapear solo las raciones que están disponibles según configuración
      this.racionesDisponibles = racionesConfig
        .filter(config => config.disponible) // Solo raciones disponibles
        .map(config => {
          // Mapear tipo de ración a código y configuración visual
          const racionInfo = this.mapearTipoRacion(config.tipo);
          
          return {
            id: racionInfo.codigo,
            nombre: racionInfo.nombre,
            icono: racionInfo.icono,
            color: racionInfo.color,
            horario: `${config.config.inicio} - ${config.config.fin}`,
            disponible: true, // Ya filtrado arriba
            yaSeleccionada: false
          };
        });
      
      // Determinar lógica de selección múltiple
      // Si hay más de una ración disponible, permitir selección múltiple
      this.puedeSeleccionarMultiples = this.racionesDisponibles.length > 1;
      
      // Para compatibilidad, mantener esAntesMediodia
      this.esAntesMediodia = this.puedeSeleccionarMultiples;
      
      console.log('📋 Raciones disponibles:', this.racionesDisponibles.map(r => `${r.nombre} (${r.horario})`));
      console.log('💡 Modo selección:', this.puedeSeleccionarMultiples ? 
        'MÚLTIPLE: puede elegir varias raciones' : 
        'SIMPLE: solo una ración disponible');
        
    } catch (error) {
      console.error('❌ Error cargando configuración de raciones:', error);
      
      // Fallback: no mostrar raciones si hay error de configuración
      this.racionesDisponibles = [];
      this.puedeSeleccionarMultiples = false;
      this.esAntesMediodia = false;
      
      console.warn('⚠️ Sin configuración de raciones disponible - modo fallback');
    }
  }

  /**
   * Mapear tipo de ración a configuración visual
   */
  private mapearTipoRacion(tipo: string) {
    const mapeo = {
      'desayuno': {
        codigo: 'D',
        nombre: 'Desayuno',
        icono: 'free_breakfast',
        color: '#f59e0b'
      },
      'almuerzo': {
        codigo: 'A', 
        nombre: 'Almuerzo',
        icono: 'lunch_dining',
        color: '#10b981'
      },
      'cena': {
        codigo: 'C',
        nombre: 'Cena', 
        icono: 'dinner_dining',
        color: '#1e3a8a'
      }
    };
    
    return mapeo[tipo] || {
      codigo: tipo.charAt(0).toUpperCase(),
      nombre: tipo.charAt(0).toUpperCase() + tipo.slice(1),
      icono: 'restaurant',
      color: '#6b7280'
    };
  }

  seleccionarRacion(racion: RacionDisponible) {
    if (!racion.disponible) {
      return;
    }
    
    if (this.esAntesMediodia) {
      // ANTES DEL MEDIODÍA: Selección múltiple con toggle
      if (racion.yaSeleccionada) {
        // Deseleccionar ración
        racion.yaSeleccionada = false;
        this.racionesElegidas = this.racionesElegidas.filter(r => r.id !== racion.id);
        console.log('❌ Ración deseleccionada:', racion.nombre);
      } else {
        // Seleccionar ración
        racion.yaSeleccionada = true;
        this.racionesElegidas.push(racion);
        console.log('✅ Ración seleccionada:', racion.nombre);
      }
      
      console.log('📋 Raciones elegidas:', this.racionesElegidas.map(r => r.nombre));
      // NO emitir aún - esperar a que presione "Aceptar"
      
    } else {
      // DESPUÉS DEL MEDIODÍA: Solo cena disponible, cierre inmediato
      console.log('✅ Ración seleccionada (después mediodía - cierre inmediato):', racion.nombre);
      this.racionesSeleccionadas.emit([racion]);
    }
  }
  
  /**
   * Confirmar selección de raciones (solo antes del mediodía)
   */
  confirmarSeleccion() {
    if (this.racionesElegidas.length === 0) {
      console.log('⚠️ No hay raciones seleccionadas');
      return;
    }
    
    console.log('✅ Confirmando selección de raciones:', this.racionesElegidas.map(r => r.nombre));
    this.racionesSeleccionadas.emit([...this.racionesElegidas]);
  }

  omitirRacion() {
    this.racionOmitida.emit();
  }

  cerrarPopup() {
    this.cerrar.emit();
  }
}
