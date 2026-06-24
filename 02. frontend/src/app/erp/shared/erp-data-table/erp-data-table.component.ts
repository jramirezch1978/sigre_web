import { Component, EventEmitter, Input, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TablaColumna } from '../models/api-page.model';

@Component({
  selector: 'app-erp-data-table',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './erp-data-table.component.html',
  styleUrls: ['./erp-data-table.component.scss'],
})
export class ErpDataTableComponent {
  @Input({ required: true }) columnas: TablaColumna[] = [];
  @Input() filas: Record<string, unknown>[] = [];
  @Input() cargando = false;
  @Input() error = '';
  @Input() totalRegistros = 0;
  @Input() mostrarAcciones = false;

  @Output() editar = new EventEmitter<Record<string, unknown>>();
  @Output() anular = new EventEmitter<Record<string, unknown>>();
  @Output() eliminar = new EventEmitter<Record<string, unknown>>();

  trackFila(row: Record<string, unknown>, index: number): string | number {
    const id = row['id'] ?? row['codigo'] ?? row['codMotivoTraslado'];
    return id != null ? String(id) : index;
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
    return this.estaActivoValor(estado);
  }

  estaActivoValor(valor: unknown): boolean {
    return valor === '1' || valor === 1 || valor === true;
  }
}
