import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';

// Font Awesome Icons
import { faScrewdriverWrench } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-acciones-herramientas-cell-render',
  templateUrl: './acciones-herramientas-cell-render.component.html',
  styleUrls: ['./acciones-herramientas-cell-render.component.scss'],
  standalone: false,
})
export class AccionesHerramientasCellRenderComponent implements ICellRendererAngularComp {
  // Font Awesome Icons
  farScrewdriverWrench = faScrewdriverWrench;



  private params: any;
  value: string = '';
  parentComponent: any;

  constructor() {}

  // ag-grid init
  agInit(params: any): void {
    this.params = params;
    this.value = params.value || '-';
    // Obtener referencia al componente padre a través de context
    this.parentComponent = params.context?.componentParent;
  }

  refresh(params: any): boolean {
    this.params = params;
    this.value = params.value || '-';
    return true;
  }

  abrirModalAcciones(event: Event) {
    event.stopPropagation();
    if (this.parentComponent && this.parentComponent.abrirModalAcciones) {
      this.parentComponent.abrirModalAcciones(this.value, this.params?.data);
    }
  }
}
