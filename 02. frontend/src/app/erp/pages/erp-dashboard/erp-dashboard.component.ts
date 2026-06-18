import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { ErpMenuService, MenuModulo } from '../../services/erp-menu.service';
import { ErpLayoutService } from '../../services/erp-layout.service';

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

  modulos: MenuModulo[] = [];

  ngOnInit(): void {
    this.menuService.obtenerMiMenu().subscribe({
      next: modulos => (this.modulos = modulos),
    });
  }

  abrirModulo(modulo: MenuModulo): void {
    this.layout.seleccionarModulo(modulo);
  }
}
