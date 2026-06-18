import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';
import { faPenToSquare } from '@fortawesome/pro-regular-svg-icons';

@Component({
  selector: 'app-fecha-edit-cell-renderer',
  templateUrl: './fecha-edit-cell-renderer.component.html',
  styleUrls: ['./fecha-edit-cell-renderer.component.scss'],
  standalone: false,
})
export class FechaEditCellRendererComponent implements ICellRendererAngularComp {
  farPenToSquare = faPenToSquare;

  params!: ICellRendererParams;
  fechaTexto: string = '';

  agInit(params: ICellRendererParams): void {
    this.params = params;
    this.fechaTexto = this.formatFecha(params.value);
  }

  refresh(params: ICellRendererParams): boolean {
    this.params = params;
    this.fechaTexto = this.formatFecha(params.value);
    return true;
  }

  private formatFecha(value: any): string {
    if (!value) return '';
    if (typeof value === 'string') return value;
    if (value instanceof Date) {
      const d = value.getDate().toString().padStart(2, '0');
      const m = (value.getMonth() + 1).toString().padStart(2, '0');
      const y = value.getFullYear();
      return `${d}/${m}/${y}`;
    }
    return '';
  }

  onEditClick(event: Event): void {
    event.stopPropagation();
    if (this.params.api && this.params.column && this.params.node) {
      this.params.api.startEditingCell({
        rowIndex: this.params.node.rowIndex!,
        colKey: this.params.column.getColId(),
      });
    }
  }
}
