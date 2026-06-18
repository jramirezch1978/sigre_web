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
  get iconColor(): string {
    // Si se pasa un color personalizado en cellRendererParams, usarlo
    const customParams = this.params as any;
    if (customParams?.color) {
      return customParams.color;
    }
    return 'text-danger';
  }

  agInit(params: ICellRendererParams): void {
    this.params = params;
  }

  refresh(params: ICellRendererParams): boolean {
    this.params = params;
    return true;
  }

  onDelete(): void {
    const contextParent = this.params?.context?.componentParent;
    if (contextParent && typeof contextParent.eliminarAccesorio === 'function') {
      contextParent.eliminarAccesorio(this.params.data);
    } else {
      console.log('Eliminar accesorio', this.params?.data);
    }
  }
}
