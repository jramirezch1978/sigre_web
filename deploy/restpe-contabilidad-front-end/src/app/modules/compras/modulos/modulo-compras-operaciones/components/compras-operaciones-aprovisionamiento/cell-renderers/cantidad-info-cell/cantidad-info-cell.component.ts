import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

import { faInfoCircle } from '@fortawesome/pro-solid-svg-icons';


@Component({
  selector: 'app-cantidad-info-cell',
  templateUrl: './cantidad-info-cell.component.html',
  styleUrls: ['./cantidad-info-cell.component.scss'],
  standalone: false
})
export class CantidadInfoCellComponent implements ICellRendererAngularComp {

  // Font Awesome Icons
  fasInfoCircle = faInfoCircle;
  value: number = 0;
  showInfo: boolean = false;

  agInit(params: ICellRendererParams): void {
    this.value = params.value;
    const stockActual = params.data.stockActual;
    this.showInfo = this.value < stockActual;
  }

  refresh(params: ICellRendererParams): boolean {
    return false;
  }
}
