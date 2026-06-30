import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AdminTablaPageBase } from '../admin-tabla-page-base';

/**
 * Barra de paginación + "Mostrar N registros" para páginas de admin con tabla propia
 * (Empresas, Licencias, etc.). Reusa el estado de paginación de AdminTablaPageBase.
 * Uso: <app-admin-paginacion [base]="this" /> debajo de la tabla.
 */
@Component({
  selector: 'app-admin-paginacion',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="row align-items-center mt-3 g-2">
      <div class="col-sm-12 col-md-6 d-flex align-items-center gap-3">
        <label class="d-inline-flex align-items-center gap-2 mb-0">
          Mostrar
          <select class="form-select form-select-sm w-auto"
                  [(ngModel)]="base.tamanoPagina" (ngModelChange)="base.onTamanoPaginaChange()">
            @for (opt of base.opcionesTamanoPagina; track opt) {
              <option [ngValue]="opt">{{ opt }}</option>
            }
          </select>
          registros
        </label>
        <span class="text-muted small">{{ base.textoInfoPaginacion }}</span>
      </div>
      <div class="col-sm-12 col-md-6">
        <ul class="pagination pagination-sm mb-0 justify-content-md-end">
          <li class="page-item" [class.disabled]="base.paginaActual === 1">
            <a class="page-link" href="javascript:;" (click)="base.paginaAnterior()">Anterior</a>
          </li>
          @for (p of base.paginasVisibles; track p) {
            <li class="page-item" [class.active]="p === base.paginaActual">
              <a class="page-link" href="javascript:;" (click)="base.irAPagina(p)">{{ p }}</a>
            </li>
          }
          <li class="page-item" [class.disabled]="base.paginaActual === base.totalPaginas">
            <a class="page-link" href="javascript:;" (click)="base.paginaSiguiente()">Siguiente</a>
          </li>
        </ul>
      </div>
    </div>
  `,
})
export class AdminPaginacionComponent {
  // `any` evita problemas de varianza al pasar [base]="this" desde cualquier página.
  @Input({ required: true }) base!: AdminTablaPageBase<any>;
}
