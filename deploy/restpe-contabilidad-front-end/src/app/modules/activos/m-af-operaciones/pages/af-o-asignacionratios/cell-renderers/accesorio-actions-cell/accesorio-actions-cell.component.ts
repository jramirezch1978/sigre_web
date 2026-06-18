import { Component } from '@angular/core';
import { ICellRendererParams } from 'ag-grid-community';
import { ICellRendererAngularComp } from 'ag-grid-angular';

// Font Awesome Icons
import { faTrashCan } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-accesorio-actions-cell',
  templateUrl: './accesorio-actions-cell.component.html',
  styleUrls: ['./accesorio-actions-cell.component.scss'],
  standalone: false
})
export class AccesorioActionsCellComponent implements ICellRendererAngularComp {
  // Font Awesome Icons
  farTrashCan = faTrashCan;


  private params!: ICellRendererParams;

  agInit(params: ICellRendererParams): void {
    this.params = params;
  }

  refresh(params: ICellRendererParams): boolean {
    this.params = params;
    return true;
  }

  onDelete(): void {
    const contextParent = this.params?.context?.componentParent;
    if (contextParent && typeof contextParent.eliminarCentroCosto === 'function') {
      contextParent.eliminarCentroCosto(this.params.data);
    } else {
      console.log('Eliminar centro de costo', this.params?.data);
    }
  }
}
