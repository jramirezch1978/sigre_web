import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

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

  fechaActual = new Date();
  racionesDisponibles: RacionDisponible[] = [];
  racionesElegidas: RacionDisponible[] = [];
  esAntesMediodia: boolean = false;
  puedeSeleccionarMultiples: boolean = false;

  ngOnInit() {
    this.cargarRacionesDisponibles();
  }

  private cargarRacionesDisponibles() {
    const hora = new Date().getHours();
    this.esAntesMediodia = hora < 12;
    this.puedeSeleccionarMultiples = this.esAntesMediodia;
    
    console.log(`🕐 Hora actual: ${hora}:xx - ${this.esAntesMediodia ? 'ANTES' : 'DESPUÉS'} del mediodía`);
    
    const todasLasRaciones = [
      {
        id: 'ALMUERZO',
        nombre: 'Almuerzo',
        icono: 'lunch_dining',
        color: '#10b981',
        horario: '12:00 - 15:00',
        disponible: this.esAntesMediodia, // Solo antes del mediodía
        yaSeleccionada: false
      },
      {
        id: 'CENA',
        nombre: 'Cena',
        icono: 'dinner_dining',
        color: '#1e3a8a',
        horario: '18:00 - 21:00',
        disponible: true, // Siempre disponible
        yaSeleccionada: false
      }
    ];
    
    // Filtrar raciones disponibles según horario
    this.racionesDisponibles = todasLasRaciones.filter(racion => racion.disponible);
    
    console.log('📋 Raciones disponibles:', this.racionesDisponibles.map(r => r.nombre));
    console.log('💡 Modo selección:', this.puedeSeleccionarMultiples ? 
      'MÚLTIPLE (antes mediodía): puede elegir almuerzo, cena o ambos' : 
      'SIMPLE (después mediodía): solo cena');
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
