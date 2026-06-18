import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

// Font Awesome Icons
import { faEdit } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-acciones-editar',
  templateUrl: './acciones-editar.component.html',
  styleUrls: ['./acciones-editar.component.scss'],
  standalone: false,

})
export class AccionesEditarComponent  implements ICellRendererAngularComp {
  // Font Awesome Icons
  farEdit = faEdit;


  private params!: ICellRendererParams;
  private parentComponent: any;
  estaDeshabilitado: boolean = false;
  razonDeshabilitado: string = '';

  agInit(params: ICellRendererParams): void {
    this.params = params;
    this.parentComponent = params.context?.componentParent;
    const ejercicioCerrado = params.context?.ejercicioCerrado;
    
    // Deshabilitar si el estado de la fila es 'Cerrado'
    if (params.data?.estado === 'Cerrado') {
      this.estaDeshabilitado = true;
      this.razonDeshabilitado = 'No se puede editar registros cerrados';
    } 
    // O si el ejercicio principal está cerrado
    else if (ejercicioCerrado) {
      this.estaDeshabilitado = true;
      this.razonDeshabilitado = 'No se puede editar cuando el ejercicio está cerrado';
    }
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

  
}

