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
  @Input() ultimoMovimiento: number = 0;
  @Output() movimientoSeleccionado = new EventEmitter<TipoMovimiento>();
  @Output() cerrar = new EventEmitter<void>();

  movimientosDisponibles: TipoMovimiento[] = [];

  ngOnInit() {
    this.cargarMovimientosPorTipo();
  }

  private cargarMovimientosPorTipo() {
    // Definir todos los movimientos posibles
    const todosLosMovimientos = [
      { numero: 1, nombre: 'Ingreso a Planta', icono: 'input', color: 'linear-gradient(135deg, #10b981 0%, #059669 100%)', codigo: 'INGRESO_PLANTA' },
      { numero: 2, nombre: 'Salida de Planta', icono: 'output', color: 'linear-gradient(135deg, #ef4444 0%, #dc2626 100%)', codigo: 'SALIDA_PLANTA' },
      { numero: 3, nombre: 'Salida a Almorzar', icono: 'restaurant', color: 'linear-gradient(135deg, #f59e0b 0%, #d97706 100%)', codigo: 'SALIDA_ALMORZAR' },
      { numero: 4, nombre: 'Regreso de Almorzar', icono: 'restaurant_menu', color: 'linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%)', codigo: 'REGRESO_ALMORZAR' },
      { numero: 5, nombre: 'Salida de Comisión', icono: 'business_center', color: 'linear-gradient(135deg, #f97316 0%, #ea580c 100%)', codigo: 'SALIDA_COMISION' },
      { numero: 6, nombre: 'Retorno de Comisión', icono: 'work', color: 'linear-gradient(135deg, #06b6d4 0%, #0891b2 100%)', codigo: 'RETORNO_COMISION' },
      { numero: 7, nombre: 'Ingreso a Producción', icono: 'precision_manufacturing', color: 'linear-gradient(135deg, #16a34a 0%, #15803d 100%)', codigo: 'INGRESO_PRODUCCION' },
      { numero: 8, nombre: 'Salida de Producción', icono: 'engineering', color: 'linear-gradient(135deg, #dc2626 0%, #b91c1c 100%)', codigo: 'SALIDA_PRODUCCION' }
    ];
    
    console.log(`📋 Filtrando movimientos | Tipo: ${this.tipoMarcaje} | Último: ${this.ultimoMovimiento}`);
    
    // Aplicar lógica de filtrado según el último movimiento
    this.movimientosDisponibles = this.filtrarMovimientosPorLogica(todosLosMovimientos);
    
    console.log(`✅ Movimientos disponibles (${this.movimientosDisponibles.length}):`, 
                this.movimientosDisponibles.map(m => `${m.numero}-${m.nombre}`));
  }
  
  private filtrarMovimientosPorLogica(todosMovimientos: TipoMovimiento[]): TipoMovimiento[] {
    const ultimo = this.ultimoMovimiento;
    
    // REGLA 1: Si último = 2 (salida) O no tiene movimientos (0) → solo movimiento 1
    if (ultimo === 2 || ultimo === 0) {
      return todosMovimientos.filter(m => m.numero === 1);
    }
    
    // REGLA 2: Si último = 1 (ingreso) → mostrar 2, 3, 5 + (7 si tipo marcaje = 2)  
    if (ultimo === 1) {
      let movimientos = todosMovimientos.filter(m => [2, 3, 5].includes(m.numero));
      if (this.tipoMarcaje === 'area-produccion') {
        const mov7 = todosMovimientos.find(m => m.numero === 7);
        if (mov7) movimientos.push(mov7);
      }
      return movimientos;
    }
    
    // REGLA 3: Si tipo marcaje = 2 Y último = 7 → solo mostrar 8
    if (this.tipoMarcaje === 'area-produccion' && ultimo === 7) {
      return todosMovimientos.filter(m => m.numero === 8);
    }
    
    // REGLA 4: Si último = 3 (salida almorzar) → solo movimiento 4
    if (ultimo === 3) {
      return todosMovimientos.filter(m => m.numero === 4);
    }
    
    // REGLA 5: Si último = 5 (salida comisión) → solo movimiento 6
    if (ultimo === 5) {
      return todosMovimientos.filter(m => m.numero === 6);
    }
    
    // Por defecto, si hay algún caso no contemplado, mostrar todos
    console.warn(`⚠️ Caso no contemplado: último movimiento ${ultimo} con tipo ${this.tipoMarcaje}`);
    return todosMovimientos;
  }

  seleccionarMovimiento(movimiento: TipoMovimiento) {
    this.movimientoSeleccionado.emit(movimiento);
  }

  cerrarPopup() {
    this.cerrar.emit();
  }
}
