import { Component, OnDestroy, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NavigationEnd, Router, RouterOutlet } from '@angular/router';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { ClockComponent } from './components/clock/clock.component';
import { AdminUiModule } from './ui/admin-ui.module';
import { ConfigService } from './services/config.service';
import { filter, Subscription } from 'rxjs';

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
export class AppComponent implements OnInit, OnDestroy {
  title = 'SIGRE ERP';
  companyName = 'SIGRE';
  companyLogo = 'assets/imagenes/auth/logo-sigre.png';
  companySector = 'Gestión Empresarial';
  companySucursal = '';
  isPublicScrollPage = false;

  private routerSub?: Subscription;

  constructor(
    private configService: ConfigService,
    private router: Router,
  ) {}

  ngOnInit() {
    this.updatePublicScrollClass(this.router.url);
    this.routerSub = this.router.events
      .pipe(filter(event => event instanceof NavigationEnd))
      .subscribe(event => this.updatePublicScrollClass((event as NavigationEnd).urlAfterRedirects));

    // Cargar configuración desde appsettings.json
    setTimeout(() => {
      this.companyName = this.configService.getCompanyName();
      this.companyLogo = this.configService.getCompanyLogo();
      this.companySector = this.configService.getCompanySector();
      this.companySucursal = this.configService.getCompanySucursal();
    }, 100);
  }

  ngOnDestroy(): void {
    this.routerSub?.unsubscribe();
    document.body.classList.remove('public-scroll-page', 'erp-shell-active');
    document.documentElement.classList.remove('public-scroll-page', 'erp-shell-active');
  }

  private updatePublicScrollClass(url: string): void {
    const path = url.split('?')[0];

    // Páginas ERP públicas (sin sidebar/header fijos) que necesitan scroll de cuerpo completo
    const erpPublicPrefixes = ['/sigre/inicio', '/sigre/registro', '/sigre/modulo/'];
    const isErpPublicPage = erpPublicPrefixes.some(prefix => path.startsWith(prefix));

    // ERP shell = rutas autenticadas con sidebar + header fijos (solo .main-wrapper debe scrollear)
    const isErpShell = path.startsWith('/sigre') && !isErpPublicPage;

    this.isPublicScrollPage = !isErpShell;

    document.body.classList.toggle('public-scroll-page', !isErpShell);
    document.documentElement.classList.toggle('public-scroll-page', !isErpShell);
    document.body.classList.toggle('erp-shell-active', isErpShell);
    document.documentElement.classList.toggle('erp-shell-active', isErpShell);
  }
}
