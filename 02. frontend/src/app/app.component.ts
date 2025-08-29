import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet } from '@angular/router';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { ClockComponent } from './components/clock/clock.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    CommonModule,
    RouterOutlet,
    MatToolbarModule,
    MatIconModule,
    MatButtonModule,
    ClockComponent
  ],
  template: `
    <mat-toolbar color="primary" class="toolbar">
      <div class="toolbar-content">
        <div class="logo-section">
          <mat-icon class="logo-icon">water</mat-icon>
          <span class="logo-text">SIGRE</span>
        </div>
        <div class="clock-section">
          <app-clock></app-clock>
        </div>
        <div class="title-section">
          <h1>Módulo de Asistencia</h1>
        </div>
      </div>
    </mat-toolbar>
    
    <main class="main-content">
      <router-outlet></router-outlet>
    </main>
  `,
  styles: [`
    .toolbar {
      background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
      height: 80px;
    }
    
    .toolbar-content {
      display: flex;
      align-items: center;
      justify-content: space-between;
      width: 100%;
      padding: 0 24px;
    }
    
    .logo-section {
      display: flex;
      align-items: center;
      gap: 12px;
    }
    
    .logo-icon {
      font-size: 32px;
      width: 32px;
      height: 32px;
      color: white;
    }
    
    .logo-text {
      font-size: 24px;
      font-weight: 700;
      color: white;
      letter-spacing: 2px;
    }
    
    .clock-section {
      flex: 1;
      display: flex;
      justify-content: center;
    }
    
    .title-section h1 {
      color: white;
      font-size: 20px;
      font-weight: 500;
      margin: 0;
    }
    
    .main-content {
      min-height: calc(100vh - 80px);
      padding: 24px;
    }
    
    @media (max-width: 768px) {
      .toolbar-content {
        flex-direction: column;
        gap: 8px;
        padding: 8px 16px;
      }
      
      .toolbar {
        height: auto;
        min-height: 80px;
      }
      
      .title-section h1 {
        font-size: 16px;
      }
      
      .main-content {
        padding: 16px;
      }
    }
  `]
})
export class AppComponent {
  title = 'SIGRE - Módulo de Asistencia';
}
