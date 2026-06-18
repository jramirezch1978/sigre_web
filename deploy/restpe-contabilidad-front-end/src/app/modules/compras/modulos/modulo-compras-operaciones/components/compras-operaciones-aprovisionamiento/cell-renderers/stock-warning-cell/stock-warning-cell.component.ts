import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

import { faExclamationTriangle } from '@fortawesome/pro-solid-svg-icons';


@Component({
  selector: 'app-stock-warning-cell',
  templateUrl: './stock-warning-cell.component.html',
  styleUrls: ['./stock-warning-cell.component.scss'],
  standalone: false
})
export class StockWarningCellComponent implements ICellRendererAngularComp {

  // Font Awesome Icons
  fasExclamationTriangle = faExclamationTriangle;
  value: number = 0;
  showWarning: boolean = false;

  agInit(params: ICellRendererParams): void {
    this.value = params.value;
    const cantidadSugerida = params.data.cantidadSugerida;
    this.showWarning = this.value < cantidadSugerida;
  }

  refresh(params: ICellRendererParams): boolean {
    return false;
  }
}
