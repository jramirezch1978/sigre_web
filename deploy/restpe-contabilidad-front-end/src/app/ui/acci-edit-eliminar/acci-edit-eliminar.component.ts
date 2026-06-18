import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

// Font Awesome Icons
import { faEdit, faTrashAlt } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-acci-edit-eliminar',
  templateUrl: './acci-edit-eliminar.component.html',
  standalone: false,
})
export class AcciEditEliminarComponent implements ICellRendererAngularComp {
  // Font Awesome Icons
  farEdit = faEdit;
  farTrashAlt = faTrashAlt;


  private params!: ICellRendererParams;
  private parentComponent: any;

  agInit(params: ICellRendererParams): void {
    this.params = params;
    this.parentComponent = params.context?.componentParent;
  }

  refresh(params: ICellRendererParams): boolean {
    return false;
  }

  onEditClick(event: Event): void {
    event.stopPropagation();
    if (this.parentComponent && this.parentComponent.onEditar) {
      this.parentComponent.onEditar(this.params?.data);
    }
  }

  onDeleteClick(event: Event): void {
    event.stopPropagation();
    if (this.parentComponent && this.parentComponent.onEliminar) {
      this.parentComponent.onEliminar(this.params?.data);
    }
  }
}
