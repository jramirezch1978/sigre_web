import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSnackBarModule, MatSnackBar } from '@angular/material/snack-bar';
import { MatDividerModule } from '@angular/material/divider';

export interface Racion {
  id: string;
  nombre: string;
  descripcion: string;
  icono: string;
  disponible: boolean;
  color: string;
  horario: string;
}

@Component({
  selector: 'app-racion-selection',
  standalone: true,
  imports: [
    CommonModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule,
    MatSnackBarModule,
    MatDividerModule
  ],
  templateUrl: './racion-selection.component.html',
  styleUrls: ['./racion-selection.component.scss']
})
export class RacionSelectionComponent implements OnInit, OnDestroy {
  codigoTarjeta: string = '';
  currentTime: Date = new Date();
  private timer: any;
  
  raciones: Racion[] = [
    {
      id: 'desayuno',
      nombre: 'Desayuno',
      descripcion: 'Incluye café, pan, mantequilla, mermelada y fruta fresca',
      icono: 'free_breakfast',
      disponible: false,
      color: '#f59e0b',
      horario: '06:00 - 09:00'
    },
    {
      id: 'almuerzo',
      nombre: 'Almuerzo',
      descripcion: 'Plato principal con ensalada, sopa y postre',
      icono: 'lunch_dining',
      disponible: true,
      color: '#10b981',
      horario: '12:00 - 15:00'
    },
    {
      id: 'cena',
      nombre: 'Cena',
      descripcion: 'Cena ligera con ensalada y proteína',
      icono: 'dinner_dining',
      disponible: true,
      color: '#1e3a8a',
      horario: '18:00 - 21:00'
    }
  ];

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit() {
    this.codigoTarjeta = this.route.snapshot.queryParams['tarjeta'] || 'N/A';
    
    // Actualizar tiempo cada segundo
    this.timer = setInterval(() => {
      this.currentTime = new Date();
      this.actualizarDisponibilidadRaciones();
    }, 1000);
    
    this.actualizarDisponibilidadRaciones();
  }

  ngOnDestroy() {
    if (this.timer) {
      clearInterval(this.timer);
    }
  }

  get racionesDisponibles(): Racion[] {
    return this.raciones.filter(r => r.disponible);
  }

  actualizarDisponibilidadRaciones() {
    const hora = this.currentTime.getHours();
    
    // Desayuno: solo disponible de 6:00 a 9:00
    this.raciones[0].disponible = hora >= 6 && hora < 9;
    
    // Almuerzo: disponible hasta mediodía (12:00)
    this.raciones[1].disponible = hora < 12;
    
    // Cena: siempre disponible después de las 12:00
    this.raciones[2].disponible = hora >= 12;
  }

  getHorarioDisponible(): string {
    const hora = this.currentTime.getHours();
    
    if (hora < 12) {
      return 'Hasta mediodía puede elegir Almuerzo y/o Cena';
    } else {
      return 'Solo disponible Cena después del mediodía';
    }
  }

  seleccionarRacion(racion: Racion) {
    if (!racion.disponible) {
      this.mostrarMensaje('Esta ración no está disponible en este horario', 'warning');
      return;
    }

    this.mostrarMensaje(`Ración ${racion.nombre} seleccionada exitosamente`, 'success');
    
    setTimeout(() => {
      this.mostrarMensaje('Su solicitud ha sido registrada. ¡Buen provecho!', 'success');
      
      setTimeout(() => {
        this.volverMenuPrincipal();
      }, 3000);
    }, 1500);
  }

  volverMenuPrincipal() {
    this.router.navigate(['/']);
  }

  private mostrarMensaje(mensaje: string, tipo: 'success' | 'error' | 'warning') {
    this.snackBar.open(mensaje, 'Cerrar', {
      duration: 4000,
      horizontalPosition: 'center',
      verticalPosition: 'bottom',
      panelClass: `${tipo}-snackbar`
    });
  }
}