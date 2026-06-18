import { Component, OnInit } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';

// Font Awesome Icons
import { faMoneyBill } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-billete-cell-render',
  templateUrl: './billete-cell-render.component.html',
  styleUrls: ['./billete-cell-render.component.scss'],
  standalone: false,
})
export class BilleteCellRenderComponent implements ICellRendererAngularComp {
  // Font Awesome Icons
  farMoneyBill = faMoneyBill;



  private params: any;
  value: string = '';
  parentComponent: any;

  constructor() {}

  // ag-grid init
  agInit(params: any): void {
    this.params = params;
    this.value = params.value || '';
    // Obtener referencia al componente padre a través de context
    this.parentComponent = params.context?.componentParent;
  }

  refresh(params: any): boolean {
    this.params = params;
    this.value = params.value || '';
    return true;
  }

  abrirModalPago(event: Event) {
    event.stopPropagation();
    if (this.parentComponent && this.parentComponent.abrirModalPago) {
      this.parentComponent.abrirModalPago(this.value, this.params?.data);
    }
  }
}
