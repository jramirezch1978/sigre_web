import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

// Font Awesome Icons
import { faExclamationTriangle } from '@fortawesome/pro-regular-svg-icons';

@Component({
  selector: 'app-diferencia-cell-renderer',
  template: `
    <div class="flex flex-row items-center justify-end gap-1 h-full w-full"
         [ngClass]="{'text-danger font-semibold': value !== 0}">
      <fa-icon [icon]="farExclamationTriangle" *ngIf="value < 0"/>
      <span>{{ formattedValue }}</span>
    </div>
  `,
  standalone: false
})
export class DiferenciaCellRendererComponent implements ICellRendererAngularComp {
  // Font Awesome Icons
  farExclamationTriangle = faExclamationTriangle;

  value: number = 0;
  formattedValue: string = '';

  agInit(params: ICellRendererParams): void {
    this.value = params.value;
    
    // Formatear el valor
    if (params.colDef?.cellRendererParams?.valueFormatter) {
      this.formattedValue = params.colDef.cellRendererParams.valueFormatter(this.value);
    } else {
      this.formattedValue = this.formatValue(this.value);
    }
  }

  refresh(params: ICellRendererParams): boolean {
    return false;
  }

  private formatValue(value: number): string {
    if (value !== null && value !== undefined) {
      const absValue = Math.abs(value);
      const formatted = new Intl.NumberFormat('es-PE', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
      }).format(absValue);
      
      // Si es negativo, mostrar entre paréntesis
      if (value < 0) {
        return `(${formatted})`;
      }
      return formatted;
    }
    return '';
  }
}
