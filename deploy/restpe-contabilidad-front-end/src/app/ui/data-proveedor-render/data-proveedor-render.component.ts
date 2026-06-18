import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

@Component({
  selector: 'app-data-proveedor-render',
  templateUrl: './data-proveedor-render.component.html',
  styleUrls: ['./data-proveedor-render.component.scss'],
  standalone: false,
})
export class DataProveedorRenderComponent implements ICellRendererAngularComp {

  documento: string = '';
  estados: { texto: string; tipo: 'badge-green' | 'badge-red' | 'badge-yellow' }[] = [];

  agInit(params: ICellRendererParams): void {
    this.parsear(params.value);
  }

  refresh(params: ICellRendererParams): boolean {
    this.parsear(params.value);
    return true;
  }

  private parsear(value: any): void {
    if (!value || !value.documento) {
      this.documento = '';
      this.estados = [];
      return;
    }

    this.documento = value.documento;
    this.estados = (value.estados || []).map((estado: string) => {
      const lower = estado.toLowerCase();
      if (lower === 'activo' || lower === 'aceptado en sunat' || lower === 'baja aceptada') {
        return { texto: estado, tipo: 'badge-green' as const };
      }
      if (lower === 'anulado') {
        return { texto: estado, tipo: 'badge-red' as const };
      }
      return { texto: estado, tipo: 'badge-grey' as const };
    });
  }
}
