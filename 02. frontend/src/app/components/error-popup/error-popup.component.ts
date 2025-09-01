import { Component, Inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

export interface ErrorData {
  titulo: string;
  mensaje: string;
  codigoIngresado: string;
  tipoError: 'validacion' | 'procesamiento';
}

@Component({
  selector: 'app-error-popup',
  standalone: true,
  imports: [
    CommonModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule
  ],
  template: `
    <div class="error-popup-container">
      <mat-card class="error-card">
        <mat-card-header class="error-header">
          <mat-card-title>
            <mat-icon class="error-icon">error</mat-icon>
            {{ data.titulo }}
          </mat-card-title>
        </mat-card-header>
        
        <mat-card-content class="error-content">
          <div class="error-message">
            <p>{{ data.mensaje }}</p>
          </div>
          
          <div class="codigo-info" *ngIf="data.codigoIngresado">
            <strong>Código ingresado:</strong> {{ data.codigoIngresado }}
          </div>
          
          <div class="help-message">
            <mat-icon class="help-icon">help_outline</mat-icon>
            <span>Por favor validar con Recursos Humanos</span>
          </div>
        </mat-card-content>
        
        <mat-card-actions class="error-actions">
          <button 
            mat-raised-button 
            color="primary"
            (click)="cerrarYRegresar()"
            class="ok-button"
          >
            <mat-icon>check</mat-icon>
            Entendido
          </button>
        </mat-card-actions>
      </mat-card>
    </div>
  `,
  styles: [`
    .error-popup-container {
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 300px;
    }
    
    .error-card {
      max-width: 400px;
      width: 90%;
      box-shadow: 0 8px 25px rgba(244, 67, 54, 0.3);
      border: 2px solid #f44336;
    }
    
    .error-header {
      background: linear-gradient(135deg, #f44336 0%, #d32f2f 100%);
      color: white;
      padding: 20px;
    }
    
    .error-icon {
      font-size: 28px;
      margin-right: 10px;
    }
    
    .error-content {
      padding: 20px;
    }
    
    .error-message {
      margin-bottom: 15px;
      font-size: 16px;
      line-height: 1.5;
    }
    
    .codigo-info {
      background: #ffebee;
      border: 1px solid #f44336;
      padding: 10px;
      border-radius: 4px;
      margin: 15px 0;
      font-family: monospace;
      font-size: 14px;
    }
    
    .help-message {
      display: flex;
      align-items: center;
      color: #666;
      font-style: italic;
      margin-top: 15px;
    }
    
    .help-icon {
      margin-right: 8px;
      color: #ff9800;
    }
    
    .error-actions {
      padding: 20px;
      display: flex;
      justify-content: center;
    }
    
    .ok-button {
      min-width: 120px;
    }
  `]
})
export class ErrorPopupComponent {
  
  constructor(
    public dialogRef: MatDialogRef<ErrorPopupComponent>,
    @Inject(MAT_DIALOG_DATA) public data: ErrorData
  ) {}
  
  /**
   * Cerrar popup y regresar a la ventana de marcación
   */
  cerrarYRegresar(): void {
    this.dialogRef.close(true); // true indica que debe regresar a ventana original
  }
}
