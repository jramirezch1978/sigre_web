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
  @Output() racionSeleccionada = new EventEmitter<RacionDisponible>();
  @Output() racionOmitida = new EventEmitter<void>();
  @Output() cerrar = new EventEmitter<void>();

  fechaActual = new Date();
  racionesDisponibles: RacionDisponible[] = [];

  ngOnInit() {
    this.cargarRacionesDisponibles();
  }

  private cargarRacionesDisponibles() {
    const hora = new Date().getHours();
    
    this.racionesDisponibles = [
      {
        id: 'desayuno',
        nombre: 'Desayuno',
        icono: 'free_breakfast',
        color: '#f59e0b',
        horario: '06:00 - 09:00',
        disponible: hora >= 6 && hora < 9,
        yaSeleccionada: false // TODO: Consultar API si ya fue seleccionada hoy
      },
      {
        id: 'almuerzo',
        nombre: 'Almuerzo',
        icono: 'lunch_dining',
        color: '#10b981',
        horario: '12:00 - 15:00',
        disponible: hora < 12,
        yaSeleccionada: false // TODO: Consultar API si ya fue seleccionada hoy
      },
      {
        id: 'cena',
        nombre: 'Cena',
        icono: 'dinner_dining',
        color: '#1e3a8a',
        horario: '18:00 - 21:00',
        disponible: hora >= 12,
        yaSeleccionada: false // TODO: Consultar API si ya fue seleccionada hoy
      }
    ];
  }

  seleccionarRacion(racion: RacionDisponible) {
    if (!racion.disponible || racion.yaSeleccionada) {
      return;
    }
    
    this.racionSeleccionada.emit(racion);
  }

  omitirRacion() {
    this.racionOmitida.emit();
  }

  cerrarPopup() {
    this.cerrar.emit();
  }
}
