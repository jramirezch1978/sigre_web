import { Component, OnInit } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';

@Component({
  selector: 'app-buttoneliminar',
  templateUrl: './buttoneliminar.component.html',
  styleUrls: ['./buttoneliminar.component.scss'],
  standalone: false,
})
export class ButtoneliminarComponent  implements ICellRendererAngularComp {

  params: any;
  agInit(params: any): void { this.params = params; }
  refresh(): boolean { return false; }
  onClick() { this.params.context.componentParent.eliminarFila(this.params.rowIndex);

  
  }

  constructor() { }

}
