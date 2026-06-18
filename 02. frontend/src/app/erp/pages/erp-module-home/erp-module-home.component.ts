import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { ErpMenuService, MenuModulo, MenuSeccion } from '../../services/erp-menu.service';
import { ErpLayoutService } from '../../services/erp-layout.service';

@Component({
  selector: 'app-erp-module-home',
  standalone: true,
  imports: [CommonModule, MatIconModule],
  templateUrl: './erp-module-home.component.html',
  styleUrls: ['./erp-module-home.component.scss'],
})
export class ErpModuleHomeComponent implements OnInit {
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  private readonly menuService = inject(ErpMenuService);
  private readonly layout = inject(ErpLayoutService);

  modulo: MenuModulo | null = null;
  cargando = true;

  ngOnInit(): void {
    const codigo = (this.route.snapshot.paramMap.get('codigo') ?? '').toUpperCase();
    this.menuService.obtenerMiMenu().subscribe({
      next: modulos => {
        this.modulo = modulos.find(m => m.codigo.toUpperCase() === codigo) ?? null;
        if (this.modulo) {
          this.layout.seleccionarModulo(this.modulo);
        }
        this.cargando = false;
      },
      error: () => {
        this.cargando = false;
      },
    });
  }

  abrirOpcion(seccion: MenuSeccion, codigo: string, ruta: string | null): void {
    const destino = this.menuService.resolverRutaFrontend(codigo, ruta);
    if (!destino) return;
    void this.router.navigateByUrl(destino);
  }

  iconoSeccion(codigo: string): string {
    if (codigo.includes('TABLAS')) return 'table_chart';
    if (codigo.includes('OPERACIONES')) return 'sync_alt';
    if (codigo.includes('CONSULTAS')) return 'search';
    if (codigo.includes('REPORTES')) return 'assessment';
    if (codigo.includes('PROCESOS')) return 'settings_suggest';
    return 'folder';
  }
}
