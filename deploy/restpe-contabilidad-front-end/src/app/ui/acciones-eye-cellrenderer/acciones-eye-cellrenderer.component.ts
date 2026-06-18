import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

// Font Awesome Icons
import { faEye } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-acciones-eye-cellrenderer',
  templateUrl: './acciones-eye-cellrenderer.component.html',
  styleUrls: ['./acciones-eye-cellrenderer.component.scss'],
  standalone: false,
})
export class AccionesEyeCellrendererComponent  implements ICellRendererAngularComp {
  // Font Awesome Icons
  farEye = faEye;


  private params!: ICellRendererParams;
  private parentComponent: any;

  agInit(params: ICellRendererParams): void {
    this.params = params;
    this.parentComponent = params.context?.componentParent;
  }

  refresh(params: ICellRendererParams): boolean {
    return false;
  }

  onVerClick(event: Event): void {
    event.stopPropagation();
    if (this.parentComponent && this.parentComponent.onVerDetalle) {
      this.parentComponent.onVerDetalle(this.params?.data);
    }
  }
}

