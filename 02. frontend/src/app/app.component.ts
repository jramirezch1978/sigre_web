import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet } from '@angular/router';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { ClockComponent } from './components/clock/clock.component';
import { AdminUiModule } from './ui/admin-ui.module';
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
    ClockComponent,
    AdminUiModule
  ],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {
  title = 'SIGRE ERP';
  companyName = 'SIGRE';
  companyLogo = 'assets/imagenes/auth/logo-sigre.png';
  companySector = 'Gestión Empresarial';
  companySucursal = '';

  constructor(private configService: ConfigService) {}

  ngOnInit() {
    // Cargar configuración desde appsettings.json
    setTimeout(() => {
      this.companyName = this.configService.getCompanyName();
      this.companyLogo = this.configService.getCompanyLogo();
      this.companySector = this.configService.getCompanySector();
      this.companySucursal = this.configService.getCompanySucursal();
    }, 100);
  }
}
