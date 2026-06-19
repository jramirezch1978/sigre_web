import { Component, EventEmitter, Input, OnChanges, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatTableModule } from '@angular/material/table';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatTooltipModule } from '@angular/material/tooltip';
import { TablaColumna } from '../models/api-page.model';

@Component({
  selector: 'app-erp-data-table',
  standalone: true,
  imports: [
    CommonModule,
    MatTableModule,
    MatProgressSpinnerModule,
    MatIconModule,
    MatButtonModule,
    MatTooltipModule,
  ],
  templateUrl: './erp-data-table.component.html',
  styleUrls: ['./erp-data-table.component.scss'],
})
export class ErpDataTableComponent implements OnChanges {
  @Input({ required: true }) columnas: TablaColumna[] = [];
  @Input() filas: Record<string, unknown>[] = [];
  @Input() cargando = false;
  @Input() error = '';
  @Input() totalRegistros = 0;
  @Input() mostrarAcciones = false;

  @Output() editar = new EventEmitter<Record<string, unknown>>();
  @Output() anular = new EventEmitter<Record<string, unknown>>();
  @Output() eliminar = new EventEmitter<Record<string, unknown>>();

  displayedColumns: string[] = [];
  readonly columnaAcciones = '__acciones';

  ngOnChanges(): void {
    const cols = this.columnas.map(c => c.key);
    this.displayedColumns = this.mostrarAcciones ? [...cols, this.columnaAcciones] : cols;
  }

  valorCelda(fila: Record<string, unknown>, col: TablaColumna): string {
    const raw = fila[col.key];
    if (raw == null || raw === '') return '—';

    switch (col.format) {
      case 'estado':
        return raw === '1' || raw === 1 || raw === true ? 'Activo' : 'Inactivo';
      case 'fecha': {
        const d = new Date(String(raw));
        if (isNaN(d.getTime())) return String(raw);
        const dd = String(d.getDate()).padStart(2, '0');
        const mm = String(d.getMonth() + 1).padStart(2, '0');
        return `${dd}/${mm}/${d.getFullYear()}`;
      }
      case 'numero':
        return typeof raw === 'number' ? raw.toLocaleString('es-PE') : String(raw);
      default:
        return String(raw);
    }
  }

  estaActivo(fila: Record<string, unknown>): boolean {
    const estado = fila['flagEstado'];
    return estado === '1' || estado === 1 || estado === true;
  }
}
