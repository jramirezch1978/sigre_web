import { Component, OnInit } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';

// Font Awesome Icons
import { faTrashAlt } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-boton-acciones',
  templateUrl: './boton-acciones.component.html',
  styleUrls: ['./boton-acciones.component.scss'],
  standalone: false,
})
export class BotonAccionesComponent implements OnInit, ICellRendererAngularComp {
  // Font Awesome Icons
  farTrashAlt = faTrashAlt;



  params: any;
  requerimientoAnulado: boolean = false;
  esEditable: boolean = true;

  constructor() { }

  ngOnInit() { }

  agInit(params: any): void {
    this.params = params;
    // Obtener el estado de anulado del componente padre
    const contextParent = params?.context?.componentParent;
    if (contextParent) {
      this.requerimientoAnulado = contextParent.requerimientoAnulado || false;
    }
    
    // Obtener el estado de editable del contexto
    const esEditableFn = params?.context?.esEditable;
    if (typeof esEditableFn === 'function') {
      this.esEditable = esEditableFn();
    }
  }

  refresh(): boolean {
    // Actualizar esEditable cuando se refresque la celda
    const esEditableFn = this.params?.context?.esEditable;
    if (typeof esEditableFn === 'function') {
      this.esEditable = esEditableFn();
    }
    return true;
  }

  onDelete(): void {
    const contextParent = this.params?.context?.componentParent;
    if (contextParent && typeof contextParent.eliminarArticulo === 'function') {
      contextParent.eliminarArticulo(this.params.data);
    } else {
      console.log('Eliminar artículo', this.params?.data);
    }
  }


}
