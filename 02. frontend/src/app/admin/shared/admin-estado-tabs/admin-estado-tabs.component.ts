import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AdminTablaPageBase } from '../admin-tabla-page-base';

/**
 * Cabecera "Todos (N) · Activos (N) · Inactivos (N)" para páginas de admin,
 * igual que las ventanas del ERP. Reusa los contadores de AdminTablaPageBase.
 * Uso: <app-admin-estado-tabs [base]="this" /> antes de la tabla.
 */
@Component({
  selector: 'app-admin-estado-tabs',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="product-count d-flex align-items-center gap-3 gap-lg-4 mb-3 fw-medium flex-wrap">
      <a href="javascript:;" class="text-decoration-none"
         [class.text-primary]="base.filtroEstado === 'todos'"
         (click)="base.seleccionarFiltroEstado('todos')">
        <span class="me-1">Todos</span>
        <span class="text-secondary">({{ base.totalTodos }})</span>
      </a>
      <a href="javascript:;" class="text-decoration-none"
         [class.text-primary]="base.filtroEstado === 'activos'"
         (click)="base.seleccionarFiltroEstado('activos')">
        <span class="me-1">Activos</span>
        <span class="text-secondary">({{ base.totalActivosTab }})</span>
      </a>
      <a href="javascript:;" class="text-decoration-none"
         [class.text-primary]="base.filtroEstado === 'inactivos'"
         (click)="base.seleccionarFiltroEstado('inactivos')">
        <span class="me-1">Inactivos</span>
        <span class="text-secondary">({{ base.totalInactivosTab }})</span>
      </a>
    </div>
  `,
})
export class AdminEstadoTabsComponent {
  // `any` evita problemas de varianza al pasar [base]="this" desde cualquier página.
  @Input({ required: true }) base!: AdminTablaPageBase<any>;
}
