import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, ActivatedRoute } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSnackBarModule, MatSnackBar } from '@angular/material/snack-bar';
import { FormsModule } from '@angular/forms';
import { ClockComponent } from '../clock/clock.component';
import { PopupMovimientosComponent, TipoMovimiento } from '../popup-movimientos/popup-movimientos.component';
import { PopupRacionesComponent, RacionDisponible } from '../popup-raciones/popup-raciones.component';

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
    MatCardModule,
    MatFormFieldModule,
    MatInputModule,
    MatButtonModule,
    MatIconModule,
    MatSnackBarModule,
    ClockComponent,
    PopupMovimientosComponent,
    PopupRacionesComponent
  ],
  templateUrl: './asistencia.component.html',
  styleUrls: ['./asistencia.component.scss']
})
export class AsistenciaComponent implements OnInit {
  codigoTarjeta: string = '';
  tipoMarcaje: string = '';
  mostrarPopupMovimientos = false;
  mostrarPopupRaciones = false;
  nombreTrabajador = '';
  codigoTrabajador = '';
  mensajeAsistencia = '';

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit() {
    // Obtener el tipo de marcaje de los query params
    this.tipoMarcaje = this.route.snapshot.queryParams['tipoMarcaje'] || '';
    
    // Simular lectura automática de tarjeta (para demo)
    setTimeout(() => {
      this.codigoTarjeta = '123456789';
    }, 2000);
  }

  validarTarjeta() {
    if (!this.codigoTarjeta || this.codigoTarjeta.length < 3) {
      this.mostrarMensaje('Por favor, ingrese un código válido', 'error');
      return;
    }

    // Simular validación de tarjeta
    if (this.codigoTarjeta === '123456789') {
      this.nombreTrabajador = 'Juan Pérez Rodríguez';
      this.codigoTrabajador = 'EMP001';
      this.mostrarMensaje('Trabajador encontrado: ' + this.nombreTrabajador, 'success');
      
      // Mostrar popup de movimientos después de un breve delay
      setTimeout(() => {
        this.mostrarPopupMovimientos = true;
      }, 1000);
    } else {
      this.mostrarMensaje('Tarjeta no válida, intente nuevamente', 'error');
    }
  }

  onMovimientoSeleccionado(movimiento: TipoMovimiento) {
    console.log('Movimiento seleccionado:', movimiento);
    this.mostrarPopupMovimientos = false;
    this.mensajeAsistencia = `Marcaje registrado: ${movimiento.nombre}`;
    
    // Solo mostrar popup de raciones si es "Ingreso a Planta"
    if (movimiento.codigo === 'INGRESO_PLANTA') {
      this.mostrarMensaje('Marcaje registrado exitosamente', 'success');
      setTimeout(() => {
        this.mostrarPopupRaciones = true;
      }, 1000);
    } else {
      // Para otros tipos de marcaje, mostrar mensaje y volver al menú
      this.mostrarMensaje(this.mensajeAsistencia, 'success');
      setTimeout(() => {
        this.volverMenuPrincipal();
      }, 2000);
    }
  }

  onRacionSeleccionada(racion: RacionDisponible) {
    console.log('Ración seleccionada:', racion);
    this.mostrarPopupRaciones = false;
    this.mostrarMensaje(`Ración ${racion.nombre} registrada exitosamente`, 'success');
    
    setTimeout(() => {
      this.volverMenuPrincipal();
    }, 2000);
  }

  onPopupCerrado(tipo: 'movimientos' | 'raciones') {
    if (tipo === 'movimientos') {
      this.mostrarPopupMovimientos = false;
    } else {
      this.mostrarPopupRaciones = false;
    }
  }

  volverMenuPrincipal() {
    this.router.navigate(['/']);
  }

  private mostrarMensaje(mensaje: string, tipo: 'success' | 'error') {
    this.snackBar.open(mensaje, 'Cerrar', {
      duration: 3000,
      horizontalPosition: 'center',
      verticalPosition: 'bottom',
      panelClass: tipo === 'success' ? 'success-snackbar' : 'error-snackbar'
    });
  }
}
