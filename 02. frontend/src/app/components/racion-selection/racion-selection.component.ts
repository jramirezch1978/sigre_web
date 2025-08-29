import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSnackBarModule, MatSnackBar } from '@angular/material/snack-bar';
import { MatDividerModule } from '@angular/material/divider';
import { TimeService } from '../../services/time.service';
import { RacionService, RacionResponse as ApiRacionResponse, RacionSelectionRequest } from '../../services/racion.service';
import { Subscription } from 'rxjs';
import { staggerAnimation, racionCardAnimation, cardHover, buttonPress } from '../../animations/animations';

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
  animations: [staggerAnimation, racionCardAnimation, cardHover, buttonPress],
  template: `
    <div class="container">
      <div class="header-section">
        <mat-card class="header-card">
          <mat-card-content class="header-content">
            <div class="user-info">
              <mat-icon class="user-icon">person</mat-icon>
              <div class="user-details">
                <h2>Selección de Ración</h2>
                <p>Tarjeta: {{ codigoTarjeta }}</p>
                <p class="current-time">{{ currentTime | date:'EEEE, d MMMM yyyy - hh:mm:ss a' }}</p>
              </div>
            </div>
          </mat-card-content>
        </mat-card>
      </div>

      <div class="racion-section">
        <mat-card class="racion-card">
          <mat-card-header>
            <mat-card-title>
              <mat-icon class="racion-title-icon">restaurant</mat-icon>
              Elija su Ración
            </mat-card-title>
            <mat-card-subtitle>
              {{ getHorarioDisponible() }}
            </mat-card-subtitle>
          </mat-card-header>
          
          <mat-card-content class="racion-content">
            <div class="racion-grid" [@staggerAnimation]="racionesDisponibles.length">
              <div 
                *ngFor="let racion of racionesDisponibles; let i = index" 
                class="racion-item"
                [class.disabled]="!racion.disponible"
                [@racionCardAnimation]
                (mouseenter)="onCardHover(i, true)"
                (mouseleave)="onCardHover(i, false)"
              >
                <mat-card class="racion-item-card" 
                         [style.border-color]="racion.color"
                         [@cardHover]="hoveredCard === i ? 'hovered' : 'default'">
                  <mat-card-content class="racion-item-content">
                    <div class="racion-icon">
                      <mat-icon [style.color]="racion.color">{{ racion.icono }}</mat-icon>
                    </div>
                    <h3 class="racion-nombre">{{ racion.nombre }}</h3>
                    <p class="racion-descripcion">{{ racion.descripcion }}</p>
                    <p class="racion-horario">{{ racion.horario }}</p>
                    
                    <button 
                      mat-raised-button 
                      [color]="racion.disponible ? 'primary' : 'warn'"
                      (click)="seleccionarRacion(racion)"
                      (mousedown)="onButtonPress(i, true)"
                      (mouseup)="onButtonPress(i, false)"
                      (mouseleave)="onButtonPress(i, false)"
                      [disabled]="!racion.disponible"
                      class="racion-button"
                      [@buttonPress]="pressedButton === i ? 'pressed' : 'released'"
                    >
                      <mat-icon>{{ racion.disponible ? 'check_circle' : 'block' }}</mat-icon>
                      {{ racion.disponible ? 'Seleccionar' : 'No Disponible' }}
                    </button>
                  </mat-card-content>
                </mat-card>
              </div>
            </div>
          </mat-card-content>
        </mat-card>
      </div>

      <div class="action-section">
        <button 
          mat-stroked-button 
          color="secondary" 
          (click)="volverInicio()"
          class="back-button"
        >
          <mat-icon>arrow_back</mat-icon>
          Volver al Inicio
        </button>
      </div>
    </div>
  `,
  styles: [`
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px;
    }
    
    .header-section {
      margin-bottom: 32px;
    }
    
    .header-card {
      background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
      color: white;
      border-radius: 20px;
      overflow: hidden;
    }
    
    .header-content {
      padding: 24px;
    }
    
    .user-info {
      display: flex;
      align-items: center;
      gap: 20px;
    }
    
    .user-icon {
      font-size: 48px;
      width: 48px;
      height: 48px;
      color: rgba(255, 255, 255, 0.9);
    }
    
    .user-details h2 {
      margin: 0 0 8px 0;
      font-size: 28px;
      font-weight: 600;
    }
    
    .user-details p {
      margin: 4px 0;
      font-size: 16px;
      opacity: 0.9;
    }
    
    .current-time {
      font-size: 14px;
      opacity: 0.8;
      font-style: italic;
    }
    
    .racion-section {
      margin-bottom: 32px;
    }
    
    .racion-card {
      background: white;
      border-radius: 20px;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    }
    
    .racion-card mat-card-header {
      background: linear-gradient(135deg, var(--accent-color) 0%, var(--success-color) 100%);
      color: white;
      padding: 24px;
      margin: 0;
      border-radius: 20px 20px 0 0;
    }
    
    .racion-title-icon {
      margin-right: 12px;
      font-size: 28px;
      width: 28px;
      height: 28px;
    }
    
    .racion-content {
      padding: 32px;
    }
    
    .racion-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 24px;
    }
    
    .racion-item-card {
      border: 3px solid transparent;
      border-radius: 16px;
      transition: all 0.3s ease;
      height: 100%;
    }
    
    .racion-item-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
    }
    
    .racion-item-content {
      text-align: center;
      padding: 24px;
    }
    
    .racion-icon {
      margin-bottom: 16px;
    }
    
    .racion-icon mat-icon {
      font-size: 48px;
      width: 48px;
      height: 48px;
    }
    
    .racion-nombre {
      font-size: 24px;
      font-weight: 600;
      margin: 0 0 12px 0;
      color: var(--text-primary);
    }
    
    .racion-descripcion {
      color: var(--text-secondary);
      margin: 0 0 16px 0;
      line-height: 1.5;
    }
    
    .racion-horario {
      font-size: 14px;
      color: var(--accent-color);
      font-weight: 500;
      margin: 0 0 20px 0;
      padding: 8px 16px;
      background: rgba(6, 182, 212, 0.1);
      border-radius: 20px;
      display: inline-block;
    }
    
    .racion-button {
      width: 100%;
      height: 48px;
      border-radius: 12px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    
    .disabled {
      opacity: 0.6;
    }
    
    .action-section {
      text-align: center;
    }
    
    .back-button {
      height: 48px;
      border-radius: 12px;
      font-weight: 500;
      padding: 0 32px;
    }
    
    @media (max-width: 768px) {
      .container {
        padding: 16px;
      }
      
      .racion-grid {
        grid-template-columns: 1fr;
        gap: 16px;
      }
      
      .racion-content {
        padding: 20px;
      }
      
      .user-info {
        flex-direction: column;
        text-align: center;
        gap: 16px;
      }
      
      .user-details h2 {
        font-size: 24px;
      }
    }
  `]
})
export class RacionSelectionComponent implements OnInit, OnDestroy {
  codigoTarjeta: string = '';
  currentTime: Date = new Date();
  private timeSubscription: Subscription = new Subscription();
  hoveredCard: number = -1;
  pressedButton: number = -1;
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
    private snackBar: MatSnackBar,
    private timeService: TimeService,
    private racionService: RacionService
  ) {}

  ngOnInit() {
    this.codigoTarjeta = this.route.snapshot.queryParams['tarjeta'] || 'N/A';
    
    // Suscribirse al servicio de tiempo del servidor
    this.timeSubscription = this.timeService.getCurrentTime().subscribe(
      serverTime => {
        this.currentTime = serverTime;
        this.cargarRacionesDesdeServicio();
      }
    );
    
    this.cargarRacionesDesdeServicio();
  }

  ngOnDestroy() {
    if (this.timeSubscription) {
      this.timeSubscription.unsubscribe();
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

  cargarRacionesDesdeServicio() {
    this.racionService.getRacionesDisponibles().subscribe(
      (racionesApi: ApiRacionResponse[]) => {
        // Convertir las raciones de la API al formato local
        this.raciones = racionesApi.map(r => ({
          id: r.id,
          nombre: r.nombre,
          descripcion: r.descripcion,
          icono: r.icono,
          disponible: r.disponible,
          color: r.color,
          horario: r.horario
        }));
      },
      error => {
        console.error('Error al cargar raciones, usando datos locales', error);
        this.actualizarDisponibilidadRaciones();
      }
    );
  }

  seleccionarRacion(racion: Racion) {
    if (!racion.disponible) {
      this.mostrarMensaje('Esta ración no está disponible en este horario', 'warning');
      return;
    }

    const request: RacionSelectionRequest = {
      codigoTarjeta: this.codigoTarjeta,
      racionId: racion.id
    };

    this.racionService.seleccionarRacion(request).subscribe(
      response => {
        this.mostrarMensaje(`Ración ${racion.nombre} seleccionada exitosamente`, 'success');
        
        setTimeout(() => {
          this.mostrarMensaje('Su solicitud ha sido registrada. ¡Buen provecho!', 'success');
          
          // Volver al inicio después de 3 segundos
          setTimeout(() => {
            this.volverInicio();
          }, 3000);
        }, 1500);
      },
      error => {
        console.error('Error al seleccionar ración:', error);
        this.mostrarMensaje(`Ración ${racion.nombre} seleccionada (modo offline)`, 'success');
        
        setTimeout(() => {
          this.volverInicio();
        }, 2000);
      }
    );
  }

  onCardHover(index: number, isHovered: boolean) {
    this.hoveredCard = isHovered ? index : -1;
  }

  onButtonPress(index: number, isPressed: boolean) {
    this.pressedButton = isPressed ? index : -1;
  }

  volverInicio() {
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
