import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { ErpMenuService, MenuModulo } from '../../services/erp-menu.service';
import { ErpLayoutService } from '../../services/erp-layout.service';
import { ERP_MODULOS_CATALOGO, fusionarModulosConCatalogo } from '../../shared/erp-modulos-catalog.config';
import { iconoModulo } from '../../shared/modulos-iconos';

interface ModuloAcceso {
  codigo: string;
  nombre: string;
  iconoSvg: string;
  moduloReal: MenuModulo | null;
}

@Component({
  selector: 'app-erp-dashboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './erp-dashboard.component.html',
  styleUrls: ['./erp-dashboard.component.scss'],
})
export class ErpDashboardComponent implements OnInit {
  private readonly menuService = inject(ErpMenuService);
  private readonly layout = inject(ErpLayoutService);
  private readonly router = inject(Router);

  accesosRapidos: ModuloAcceso[] = [];
  resumen = { modulosActivos: ERP_MODULOS_CATALOGO.length };

  ngOnInit(): void {
    this.layout.seleccionarModulo(null);
    this.menuService.obtenerMiMenu().subscribe({
      next: modulosApi => {
        const fusionados = fusionarModulosConCatalogo(modulosApi, false);
        this.accesosRapidos = fusionados.slice(0, 5).map(m => ({
          codigo: m.codigo,
          nombre: m.nombre,
          iconoSvg: m.iconoSvg || iconoModulo(m.codigo),
          moduloReal: m.secciones.length > 0 ? m : null,
        }));
      },
    });
  }

  abrirModulo(modulo: ModuloAcceso): void {
    const mod = modulo.moduloReal ?? {
      moduloId: 0,
      codigo: modulo.codigo,
      nombre: modulo.nombre,
      icono: 'apps',
      iconoSvg: modulo.iconoSvg,
      secciones: [],
    };
    this.layout.seleccionarModulo(mod);
    void this.router.navigateByUrl(this.menuService.rutaDashboardModulo(modulo.codigo));
  }
}
