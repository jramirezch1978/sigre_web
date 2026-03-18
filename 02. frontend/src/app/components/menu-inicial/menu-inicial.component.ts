import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { ClockComponent } from '../clock/clock.component';
import { ConfigService } from '../../services/config.service';
import { VersionService } from '../../services/version.service';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-menu-inicial',
  standalone: true,
  imports: [
    CommonModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule,
    ClockComponent
  ],
  templateUrl: './menu-inicial.component.html',
  styleUrls: ['./menu-inicial.component.scss']
})
export class MenuInicialComponent implements OnInit {
  companyName = 'Transmarina del PERU SAC';
  companyLogo = 'assets/logo-transmarina.png';
  companySucursal = 'PIURA - SECHURA';
  mostrarPopupModo = false;

  appVersion$!: Observable<string>;
  buildTimestamp$!: Observable<string>;

  constructor(
    private router: Router,
    private configService: ConfigService,
    private versionService: VersionService
  ) {}

  async ngOnInit() {
    try {
      await this.configService.waitForConfig();
      this.companyName = this.configService.getCompanyName();
      this.companyLogo = this.configService.getCompanyLogo();
      this.companySucursal = this.configService.getCompanySucursal();
    } catch (error) {
      console.warn('No se pudo cargar la configuración, usando valores por defecto:', error);
    }

    this.appVersion$ = this.versionService.getAppVersion();
    this.buildTimestamp$ = this.versionService.getBuildTimestamp();
  }

  seleccionarTipoMarcaje(tipo: string) {
    if (tipo === 'puerta-principal') {
      this.mostrarPopupModo = true;
      return;
    }
    this.router.navigate(['/asistencia'], {
      queryParams: { tipoMarcaje: tipo }
    });
  }

  seleccionarModoPuertaPrincipal(modo: 'completo' | 'simplificado') {
    this.mostrarPopupModo = false;
    this.router.navigate(['/asistencia'], {
      queryParams: { tipoMarcaje: 'puerta-principal', modoMarcaje: modo }
    });
  }

  cerrarPopupModo() {
    this.mostrarPopupModo = false;
  }

  irADashboard() {
    this.router.navigate(['/dashboard']);
  }
}
