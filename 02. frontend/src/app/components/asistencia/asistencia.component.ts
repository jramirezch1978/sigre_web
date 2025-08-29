import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSnackBarModule, MatSnackBar } from '@angular/material/snack-bar';
import { FormsModule } from '@angular/forms';
import { RacionSelectionComponent } from '../racion-selection/racion-selection.component';

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
    MatSnackBarModule
  ],
  template: `
    <div class="container">
      <div class="welcome-section">
        <mat-card class="welcome-card">
          <mat-card-header>
            <mat-card-title>
              <mat-icon class="welcome-icon">person_add</mat-icon>
              Bienvenido al Sistema de Asistencia
            </mat-card-title>
            <mat-card-subtitle>
              Por favor, ingrese su código de tarjeta de proximidad
            </mat-card-subtitle>
          </mat-card-header>
          
          <mat-card-content class="card-content">
            <div class="input-section">
              <mat-form-field appearance="outline" class="full-width">
                <mat-label>Código de Tarjeta</mat-label>
                <input 
                  matInput 
                  [(ngModel)]="codigoTarjeta" 
                  placeholder="Ej: 123456789"
                  (keyup.enter)="validarTarjeta()"
                  maxlength="20"
                  class="tarjeta-input"
                >
                <mat-icon matSuffix>credit_card</mat-icon>
              </mat-form-field>
              
              <button 
                mat-raised-button 
                color="primary" 
                (click)="validarTarjeta()"
                [disabled]="!codigoTarjeta || codigoTarjeta.length < 3"
                class="submit-button"
              >
                <mat-icon>login</mat-icon>
                Validar Tarjeta
              </button>
            </div>
            
            <div class="info-section">
              <div class="info-item">
                <mat-icon class="info-icon">info</mat-icon>
                <span>El sistema detectará automáticamente su tarjeta</span>
              </div>
              <div class="info-item">
                <mat-icon class="info-icon">schedule</mat-icon>
                <span>Horario disponible según la hora actual</span>
              </div>
            </div>
          </mat-card-content>
        </mat-card>
      </div>
    </div>
  `,
  styles: [`
    .container {
      max-width: 800px;
      margin: 0 auto;
      padding: 20px;
    }
    
    .welcome-section {
      margin-bottom: 32px;
    }
    
    .welcome-card {
      background: linear-gradient(135deg, white 0%, #f8fafc 100%);
      border-radius: 20px;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
      overflow: hidden;
    }
    
    .welcome-card mat-card-header {
      background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
      color: white;
      padding: 24px;
      margin: 0;
    }
    
    .welcome-card mat-card-title {
      display: flex;
      align-items: center;
      gap: 12px;
      font-size: 24px;
      font-weight: 600;
      margin: 0;
    }
    
    .welcome-icon {
      font-size: 28px;
      width: 28px;
      height: 28px;
    }
    
    .welcome-card mat-card-subtitle {
      color: rgba(255, 255, 255, 0.9);
      font-size: 16px;
      margin: 8px 0 0 0;
    }
    
    .card-content {
      padding: 32px;
    }
    
    .input-section {
      display: flex;
      flex-direction: column;
      gap: 24px;
      margin-bottom: 32px;
    }
    
    .full-width {
      width: 100%;
    }
    
    .tarjeta-input {
      font-size: 18px;
      font-family: 'Courier New', monospace;
      letter-spacing: 2px;
    }
    
    .submit-button {
      height: 56px;
      font-size: 18px;
      font-weight: 600;
      border-radius: 16px;
      box-shadow: 0 4px 20px rgba(30, 58, 138, 0.3);
      transition: all 0.3s ease;
    }
    
    .submit-button:hover:not(:disabled) {
      transform: translateY(-2px);
      box-shadow: 0 8px 30px rgba(30, 58, 138, 0.4);
    }
    
    .submit-button:disabled {
      opacity: 0.6;
    }
    
    .info-section {
      display: flex;
      flex-direction: column;
      gap: 16px;
      padding: 20px;
      background: rgba(14, 165, 233, 0.05);
      border-radius: 12px;
      border: 1px solid rgba(14, 165, 233, 0.1);
    }
    
    .info-item {
      display: flex;
      align-items: center;
      gap: 12px;
      color: var(--text-secondary);
    }
    
    .info-icon {
      color: var(--secondary-color);
      font-size: 20px;
      width: 20px;
      height: 20px;
    }
    
    @media (max-width: 768px) {
      .container {
        padding: 16px;
      }
      
      .card-content {
        padding: 24px 20px;
      }
      
      .welcome-card mat-card-title {
        font-size: 20px;
        flex-direction: column;
        text-align: center;
        gap: 8px;
      }
      
      .submit-button {
        height: 48px;
        font-size: 16px;
      }
    }
  `]
})
export class AsistenciaComponent implements OnInit {
  codigoTarjeta: string = '';

  constructor(
    private router: Router,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit() {
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
      this.mostrarMensaje('Tarjeta válida, redirigiendo...', 'success');
      
      // Navegar a la selección de ración
      setTimeout(() => {
        this.router.navigate(['/racion-selection'], { 
          queryParams: { tarjeta: this.codigoTarjeta } 
        });
      }, 1500);
    } else {
      this.mostrarMensaje('Tarjeta no válida, intente nuevamente', 'error');
    }
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
