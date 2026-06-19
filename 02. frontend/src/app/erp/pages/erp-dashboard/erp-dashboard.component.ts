import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { ErpMenuService, MenuModulo } from '../../services/erp-menu.service';
import { ErpLayoutService } from '../../services/erp-layout.service';
import { fusionarModulosConCatalogo } from '../../shared/erp-modulos-catalog.config';

interface ModuloGrid {
  codigo: string;
  nombre: string;
  icono: string;
  iconoSvg: string;
  moduloReal: MenuModulo | null;
}

@Component({
  selector: 'app-erp-dashboard',
  standalone: true,
  imports: [CommonModule, MatIconModule],
  templateUrl: './erp-dashboard.component.html',
  styleUrls: ['./erp-dashboard.component.scss'],
})
export class ErpDashboardComponent implements OnInit {
  private readonly menuService = inject(ErpMenuService);
  private readonly layout = inject(ErpLayoutService);
  private readonly router = inject(Router);

  modulos: ModuloGrid[] = [];

  ngOnInit(): void {
    this.layout.seleccionarModulo(null);
    this.menuService.obtenerMiMenu().subscribe({
      next: modulosApi => {
        const fusionados = fusionarModulosConCatalogo(modulosApi, false);
        this.modulos = fusionados.map(m => ({
          codigo: m.codigo,
          nombre: m.nombre,
          icono: m.icono,
          iconoSvg: m.iconoSvg,
          moduloReal: m.secciones.length > 0 ? m : null,
        }));
      },
    });
  }

  abrirModulo(modulo: ModuloGrid): void {
    const mod = modulo.moduloReal ?? {
      moduloId: 0,
      codigo: modulo.codigo,
      nombre: modulo.nombre,
      icono: modulo.icono,
      iconoSvg: modulo.iconoSvg,
      secciones: [],
    };
    this.layout.seleccionarModulo(mod);
    void this.router.navigateByUrl(this.menuService.rutaDashboardModulo(modulo.codigo));
  }
}
