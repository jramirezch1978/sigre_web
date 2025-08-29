import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet } from '@angular/router';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { ClockComponent } from './components/clock/clock.component';
import { ConfigService } from './services/config.service';

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
          <img [src]="companyLogo" [alt]="companyName + ' Logo'" class="company-logo">
          <div class="company-info">
            <span class="company-name">{{ companyName }}</span>
            <span class="company-sucursal">{{ companySucursal }}</span>
          </div>
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
      background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 50%, #fef2f2 100%);
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
      height: 80px;
      border-bottom: 3px solid #e11d48;
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
      gap: 16px;
    }
    
    .company-logo {
      height: 50px;
      width: auto;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
    }
    
    .company-info {
      display: flex;
      flex-direction: column;
      gap: 2px;
    }
    
    .company-name {
      font-size: 18px;
      font-weight: 700;
      color: #1e293b;
      letter-spacing: 1px;
    }
    
    .company-sector {
      font-size: 11px;
      color: #64748b;
      font-weight: 400;
    }
    
    .company-sucursal {
      font-size: 12px;
      color: #e11d48;
      font-weight: 600;
      letter-spacing: 0.5px;
    }
    
    .clock-section {
      flex: 1;
      display: flex;
      justify-content: center;
    }
    
    .title-section h1 {
      color: #1e293b;
      font-size: 22px;
      font-weight: 600;
      margin: 0;
      text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
      background: linear-gradient(135deg, #1e293b 0%, #e11d48 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
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
export class AppComponent implements OnInit {
  title = 'SIGRE - Módulo de Asistencia';
  companyName = 'Transmarina del PERU SAC';
  companyLogo = 'assets/logo-transmarina.png';
  companySucursal = 'PIURA - SECHURA';

  constructor(private configService: ConfigService) {}

  ngOnInit() {
    // Cargar configuración desde appsettings.json
    setTimeout(() => {
      this.companyName = this.configService.getCompanyName();
      this.companyLogo = this.configService.getCompanyLogo();
      this.companySucursal = this.configService.getCompanySucursal();
    }, 100);
  }
}
