import { Component, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ICellRendererAngularComp } from 'ag-grid-angular';

// Font Awesome Icons
import { faEye } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-vista-cell-render',
  templateUrl: './vista-cell-render.component.html',
  styleUrls: ['./vista-cell-render.component.scss'],
  standalone: false,
})
export class VistaCellRenderComponent implements ICellRendererAngularComp {
  // Font Awesome Icons
  farEye = faEye;



  private params: any;
    value: string = '';
    parentComponent: any;
  
   
    constructor() {}

    private resolveValue(params: any): string {
      if (params?.htmlValue) {
        return params.htmlValue;
      }
      return params.valueFormatted !== undefined && params.valueFormatted !== null
        ? params.valueFormatted
        : (params.value || '-');
    }
  
    // ag-grid init
    agInit(params: any): void {
        this.params = params;
      this.value = this.resolveValue(params);
    // Obtener referencia al componente padre a través de context
    this.parentComponent = params.context?.componentParent;
  }

  refresh(params: any): any {
    this.params = params;
      this.value = this.resolveValue(params);
    }
    abrirModal(event: Event) {
    event.stopPropagation();
      if (this.parentComponent && this.parentComponent.abrirModal) {
        this.parentComponent.abrirModal(this.value, this.params?.data);
      }
    }
  }


