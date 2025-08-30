import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { ClockComponent } from '../clock/clock.component';
import { ConfigService } from '../../services/config.service';

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

  constructor(
    private router: Router,
    private configService: ConfigService
  ) {}

  async ngOnInit() {
    try {
      // Esperar a que se cargue la configuración
      await this.configService.waitForConfig();
      
      // Cargar configuración desde appsettings.json
      this.companyName = this.configService.getCompanyName();
      this.companyLogo = this.configService.getCompanyLogo();
      this.companySucursal = this.configService.getCompanySucursal();
    } catch (error) {
      console.warn('No se pudo cargar la configuración, usando valores por defecto:', error);
      // Los valores por defecto ya están establecidos en las propiedades
    }
  }

  seleccionarTipoMarcaje(tipo: string) {
    // Navegar al componente de asistencia con el tipo de marcaje
    this.router.navigate(['/asistencia'], { 
      queryParams: { tipoMarcaje: tipo } 
    });
  }
}
