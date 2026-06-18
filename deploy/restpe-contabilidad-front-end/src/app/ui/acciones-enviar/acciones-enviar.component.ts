import { Component, OnInit } from '@angular/core';
import { faPaperPlane } from '@fortawesome/pro-regular-svg-icons';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-enterprise';

@Component({
  selector: 'app-acciones-enviar',
  templateUrl: './acciones-enviar.component.html',
  styleUrls: ['./acciones-enviar.component.scss'],
  standalone: false,
})
export class AccionesEnviarComponent  implements ICellRendererAngularComp {

  faPaperPlane = faPaperPlane;

  private params!: ICellRendererParams;
  private parentComponent: any;
  
  estaDeshabilitado: boolean = false;
  razonDeshabilitado: string = '';

  agInit(params: ICellRendererParams): void {
    this.params = params;
    this.parentComponent = params.context?.componentParent;
    this.actualizarEstado(params);
  }

  refresh(params: ICellRendererParams): boolean {
    this.params = params;
    this.actualizarEstado(params);
    return true;
  }

  private actualizarEstado(params: ICellRendererParams): void {
    const config = params.colDef?.cellRendererParams;
    if (config?.isDisabled && typeof config.isDisabled === 'function') {
      this.estaDeshabilitado = config.isDisabled(params.data);
      this.razonDeshabilitado = this.estaDeshabilitado ? (config.razonDeshabilitado || 'No disponible') : '';
    } else {
      this.razonDeshabilitado = params.data?.razon_deshabilitado || '';
      this.estaDeshabilitado = !!this.razonDeshabilitado;
    }
  }

  onEnviarClick(event: Event): void {
    event.stopPropagation();
    if (this.parentComponent && this.parentComponent.onEnviar) {
      this.parentComponent.onEnviar(this.params?.data);
    }
  }
}