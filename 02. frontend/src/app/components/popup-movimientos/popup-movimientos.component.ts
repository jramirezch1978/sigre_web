import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { ConfigService } from '../../services/config.service';
import { ClockService } from '../../services/clock.service';

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
  @Input() modoMarcaje: string = 'completo';
  @Input() nombreTrabajador: string = '';
  @Input() ultimoMovimiento: number = 0;
  @Output() movimientoSeleccionado = new EventEmitter<TipoMovimiento>();
  @Output() cerrar = new EventEmitter<void>();

  movimientosDisponibles: TipoMovimiento[] = [];
  mensajeAdvertencia: string = '';

  constructor(
    private configService: ConfigService,
    private clockService: ClockService
  ) {}

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
      { numero: 8, nombre: 'Salida de Producción', icono: 'engineering', color: 'linear-gradient(135deg, #dc2626 0%, #b91c1c 100%)', codigo: 'SALIDA_PRODUCCION' },
      { numero: 9, nombre: 'Salida a Cenar', icono: 'dinner_dining', color: 'linear-gradient(135deg, #f59e0b 0%, #d97706 100%)', codigo: 'SALIDA_CENAR' },
      { numero: 10, nombre: 'Regreso de Cenar', icono: 'restaurant', color: 'linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%)', codigo: 'REGRESO_CENAR' }
    ];
    
    console.log(`📋 Filtrando movimientos | Tipo: ${this.tipoMarcaje} | Último: ${this.ultimoMovimiento}`);
    
    // Aplicar lógica de filtrado según el último movimiento
    let movimientosFiltrados = this.filtrarMovimientosPorLogica(todosLosMovimientos);
    
    // Aplicar filtros de horario para movimientos de almuerzo y cena
    this.movimientosDisponibles = this.aplicarFiltrosDeHorario(movimientosFiltrados);
    
    console.log(`✅ Movimientos disponibles (${this.movimientosDisponibles.length}):`, 
                this.movimientosDisponibles.map(m => `${m.numero}-${m.nombre}`));
  }
  
  private filtrarMovimientosPorLogica(todosMovimientos: TipoMovimiento[]): TipoMovimiento[] {
    const ultimo = this.ultimoMovimiento;
    const esSimplificado = this.modoMarcaje === 'simplificado';
    
    // MODO SIMPLIFICADO: solo movimientos 1 (ingreso) y 2 (salida)
    if (esSimplificado) {
      if (ultimo === 0 || ultimo === 2) {
        return todosMovimientos.filter(m => m.numero === 1);
      }
      return todosMovimientos.filter(m => m.numero === 2);
    }
    
    // ÁREA DE PRODUCCIÓN: solo 7 después de 1, solo 8 después de 7
    // El backend ya valida que el trabajador pueda marcar en producción
    if (this.tipoMarcaje === 'area-produccion') {
      if (ultimo === 1) {
        return todosMovimientos.filter(m => m.numero === 7);
      }
      if (ultimo === 7) {
        return todosMovimientos.filter(m => m.numero === 8);
      }
      return [];
    }

    // MODO COMPLETO (puerta-principal): lógica con todas las reglas

    // REGLA 0: Si último = 7 (ingresó a producción sin salir) → bloquear con advertencia
    if (ultimo === 7) {
      this.mensajeAdvertencia = 'No puede marcar salida de planta. Tiene pendiente una marcación de SALIDA del Área de Producción. Por favor, marque primero la salida de producción en la ventana "Marcaje Área de Producción".';
      return [];
    }

    // REGLA 1: Si último = 2 (salida) O no tiene movimientos (0) → solo movimiento 1
    if (ultimo === 2 || ultimo === 0) {
      return todosMovimientos.filter(m => m.numero === 1);
    }
    
    // REGLA 2: Si último = 1 (ingreso) → mostrar 2, 3, 5, 9
    if (ultimo === 1) {
      return todosMovimientos.filter(m => [2, 3, 5, 9].includes(m.numero));
    }
    
    // REGLA 4: Si último = 3 (salida almorzar) → solo movimiento 4
    if (ultimo === 3) {
      return todosMovimientos.filter(m => m.numero === 4);
    }
    
    // REGLA 5: Si último = 5 (salida comisión) → solo movimiento 6
    if (ultimo === 5) {
      return todosMovimientos.filter(m => m.numero === 6);
    }
    
    // REGLA 6: Si último = 9 (salida cenar) → solo movimiento 10
    if (ultimo === 9) {
      return todosMovimientos.filter(m => m.numero === 10);
    }
    
    console.warn(`⚠️ Caso no contemplado: último movimiento ${ultimo} con tipo ${this.tipoMarcaje}`);
    return todosMovimientos;
  }

  private aplicarFiltrosDeHorario(movimientos: TipoMovimiento[]): TipoMovimiento[] {
    const horaActual = this.clockService.getCurrentTimeSync();
    
    return movimientos.filter(mov => {
      // Movimiento 3 (Salida a Almorzar): Solo activo de 12:00 a 15:00
      if (mov.numero === 3) {
        return this.estaEnHorarioPermitido(horaActual, 'botonMarcacionSalidaAlmorzar');
      }
      
      // Movimiento 9 (Salida a Cenar): Solo activo de 19:30 a 21:00
      if (mov.numero === 9) {
        return this.estaEnHorarioPermitido(horaActual, 'botonMarcacionSalidaCenar');
      }
      
      // Los demás movimientos no tienen restricción de horario
      return true;
    });
  }

  private estaEnHorarioPermitido(horaActual: Date, configKey: string): boolean {
    try {
      const config = this.configService.getCurrentConfig();
      const horarioConfig = (config as any)?.raciones?.reglas?.[configKey];
      
      if (!horarioConfig?.inicio || !horarioConfig?.fin) {
        console.warn(`⚠️ No se encontró configuración de horario para ${configKey}`);
        return false; // Si no hay configuración, no mostrar el botón
      }
      
      const horaActualStr = `${horaActual.getHours().toString().padStart(2, '0')}:${horaActual.getMinutes().toString().padStart(2, '0')}`;
      
      console.log(`🕐 Validando horario (24h) | Actual: ${horaActualStr} | Permitido: ${horarioConfig.inicio} - ${horarioConfig.fin} | Config: ${configKey}`);
      
      return this.estaEnRangoHorario(horaActualStr, horarioConfig.inicio, horarioConfig.fin);
      
    } catch (error) {
      console.error(`❌ Error al validar horario para ${configKey}:`, error);
      return false;
    }
  }

  private estaEnRangoHorario(horaActual: string, horaInicio: string, horaFin: string): boolean {
    const actual = this.convertirHoraAMinutos(horaActual);
    const inicio = this.convertirHoraAMinutos(horaInicio);
    const fin = this.convertirHoraAMinutos(horaFin);
    
    return actual >= inicio && actual <= fin;
  }

  private convertirHoraAMinutos(hora: string): number {
    const [horas, minutos] = hora.split(':').map(Number);
    return horas * 60 + minutos;
  }

  seleccionarMovimiento(movimiento: TipoMovimiento) {
    this.movimientoSeleccionado.emit(movimiento);
  }

  cerrarPopup() {
    this.cerrar.emit();
  }
}
