import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

export interface TipoMovimiento {
  numero: number;
  nombre: string;
  icono: string;
  color: string;
  codigo: string;
}

@Component({
  selector: 'app-popup-movimientos',
  standalone: true,
  imports: [
    CommonModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule
  ],
  templateUrl: './popup-movimientos.component.html',
  styleUrls: ['./popup-movimientos.component.scss']
})
export class PopupMovimientosComponent implements OnInit {
  @Input() tipoMarcaje: string = '';
  @Input() nombreTrabajador: string = '';
  @Output() movimientoSeleccionado = new EventEmitter<TipoMovimiento>();
  @Output() cerrar = new EventEmitter<void>();

  movimientosDisponibles: TipoMovimiento[] = [];

  ngOnInit() {
    this.cargarMovimientosPorTipo();
  }

  private cargarMovimientosPorTipo() {
    switch (this.tipoMarcaje) {
      case 'puerta-principal':
        this.movimientosDisponibles = [
          { numero: 1, nombre: 'Ingreso a Planta', icono: 'input', color: 'linear-gradient(135deg, #10b981 0%, #059669 100%)', codigo: 'INGRESO_PLANTA' },
          { numero: 2, nombre: 'Salida de Planta', icono: 'output', color: 'linear-gradient(135deg, #ef4444 0%, #dc2626 100%)', codigo: 'SALIDA_PLANTA' },
          { numero: 3, nombre: 'Ingreso a Almorzar', icono: 'restaurant', color: 'linear-gradient(135deg, #f59e0b 0%, #d97706 100%)', codigo: 'INGRESO_ALMORZAR' },
          { numero: 4, nombre: 'Salida de Almorzar', icono: 'restaurant_menu', color: 'linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%)', codigo: 'SALIDA_ALMORZAR' }
        ];
        break;
      
      case 'area-produccion':
        this.movimientosDisponibles = [
          { numero: 1, nombre: 'Ingreso a Producción', icono: 'precision_manufacturing', color: 'linear-gradient(135deg, #10b981 0%, #059669 100%)', codigo: 'INGRESO_PRODUCCION' },
          { numero: 2, nombre: 'Salida de Producción', icono: 'engineering', color: 'linear-gradient(135deg, #ef4444 0%, #dc2626 100%)', codigo: 'SALIDA_PRODUCCION' }
        ];
        break;
      
      default:
        this.movimientosDisponibles = [];
    }
  }

  seleccionarMovimiento(movimiento: TipoMovimiento) {
    this.movimientoSeleccionado.emit(movimiento);
  }

  cerrarPopup() {
    this.cerrar.emit();
  }
}
