import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { ClockComponent } from '../clock/clock.component';
import { ConfigService } from '../../services/config.service';
import { VersionService } from '../../services/version.service';
import { IpRoutingService } from '../../services/ip-routing.service';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-menu-inicial',
  standalone: true,
  imports: [
    CommonModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule,
    MatProgressSpinnerModule,
    ClockComponent
  ],
  templateUrl: './menu-inicial.component.html',
  styleUrls: ['./menu-inicial.component.scss']
})
export class MenuInicialComponent implements OnInit {
  companyName = 'SIGRE';
  companyLogo = 'assets/imagenes/auth/logo-sigre.png';
  companySucursal = '';
  mostrarPopupModo = false;

  // Mientras se evalúa la IP del equipo para decidir si se abre una pantalla
  // de marcaje automáticamente, se oculta el menú para evitar el parpadeo.
  resolviendoRutaAutomatica = true;

  appVersion$!: Observable<string>;
  buildTimestamp$!: Observable<string>;

  constructor(
    private router: Router,
    private configService: ConfigService,
    private versionService: VersionService,
    private ipRoutingService: IpRoutingService
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

    await this.intentarRedireccionAutomaticaPorIp();
  }

  /**
   * Consulta al backend si la IP privada del dispositivo (capturada en el
   * navegador vía WebRTC) tiene asignada una pantalla de marcaje por defecto.
   * Si no hay coincidencia o no se puede capturar la IP, se muestra el menú manual.
   */
  private async intentarRedireccionAutomaticaPorIp(): Promise<void> {
    try {
      const ruta = await this.ipRoutingService.resolverRutaAutomatica();
      if (ruta) {
        const queryParams: Record<string, string> = { tipoMarcaje: ruta.tipoMarcaje };
        if (ruta.modoMarcaje) {
          queryParams['modoMarcaje'] = ruta.modoMarcaje;
        }
        console.log('🧭 IP reconocida - redirigiendo automáticamente a:', queryParams);
        await this.router.navigate(['/asistencia'], { queryParams, replaceUrl: true });
        return;
      }
    } catch (error) {
      console.warn('⚠️ Error resolviendo ruta automática por IP, se muestra el menú por defecto:', error);
    }
    this.resolviendoRutaAutomatica = false;
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
