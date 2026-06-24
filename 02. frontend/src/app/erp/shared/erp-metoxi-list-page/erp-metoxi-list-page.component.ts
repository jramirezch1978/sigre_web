import { Component, EventEmitter, Input, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

export type ErpMetoxiFiltroTab = 'todos' | 'activos' | 'inactivos';

@Component({
  selector: 'app-erp-metoxi-list-page',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './erp-metoxi-list-page.component.html',
  styleUrls: ['./erp-metoxi-list-page.component.scss'],
})
export class ErpMetoxiListPageComponent {
  @Input({ required: true }) modulo = '';
  @Input({ required: true }) titulo = '';
  @Input() subtitulo = '';
  @Input() totalRegistros = 0;
  @Input() totalActivos = 0;
  @Input() totalInactivos = 0;
  @Input() mostrarTabsEstado = true;
  @Input() puedeGestionar = false;
  @Input() cargando = false;
  @Input() textoBotonAnadir = 'Añadir registro';
  @Input() placeholderBusqueda = 'Buscar registros';

  @Input() busqueda = '';
  @Output() busquedaChange = new EventEmitter<string>();

  @Input() filtroTab: ErpMetoxiFiltroTab = 'todos';
  @Output() filtroTabChange = new EventEmitter<ErpMetoxiFiltroTab>();

  @Output() anadir = new EventEmitter<void>();
  @Output() recargar = new EventEmitter<void>();
  @Output() exportar = new EventEmitter<void>();

  onBusquedaInput(valor: string): void {
    this.busqueda = valor;
    this.busquedaChange.emit(valor);
  }

  seleccionarTab(tab: ErpMetoxiFiltroTab): void {
    this.filtroTab = tab;
    this.filtroTabChange.emit(tab);
  }
}
