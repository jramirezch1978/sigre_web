import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-enterprise';

// Font Awesome Icons
import { faDownload, faEye, faPrint } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-acciones-ver-desc-imp',
  templateUrl: './acciones-ver-desc-imp.component.html',
  styleUrls: ['./acciones-ver-desc-imp.component.scss'],
  standalone: false,
})
export class AccionesVerDescImpComponent  implements ICellRendererAngularComp {
  // Font Awesome Icons
  farDownload = faDownload;
  farEye = faEye;
  farPrint = faPrint;


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
    if (this.parentComponent && this.parentComponent.onVer) {
      this.parentComponent.onVer(this.params?.data);
    }
  }

  onImprimirClick(event: Event): void {
    event.stopPropagation();
    if (this.parentComponent && this.parentComponent.onImprimir) {
      this.parentComponent.onImprimir(this.params?.data);
    }
  }

  onDescClick(event: Event): void {
    event.stopPropagation();
    if (this.parentComponent && this.parentComponent.onDescargar) {
      this.parentComponent.onDescargar(this.params?.data);
    }
  }
}

