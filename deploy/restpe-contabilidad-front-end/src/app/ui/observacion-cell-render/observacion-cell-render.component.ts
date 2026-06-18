import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

// Font Awesome Icons
import { faComment } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-observacion-cell-render',
  templateUrl: './observacion-cell-render.component.html',
  styleUrls: ['./observacion-cell-render.component.scss'],
  standalone: false,
})
export class ObservacionCellRenderComponent implements ICellRendererAngularComp {
  // Font Awesome Icons
  farComment = faComment;


  private params!: ICellRendererParams;

  agInit(params: ICellRendererParams): void {
    this.params = params;
  }

  refresh(params: ICellRendererParams): boolean {
    return false;
  }

  get isDisabled(): boolean {
    return this.params?.data?.estado === 'Conciliado';
  }

  onClickObservacion(event: Event) {
    event.stopPropagation();
    
    if (this.isDisabled) {
      return;
    }
    
    if (this.params.context && this.params.context.componentParent) {
      this.params.context.componentParent.abrirModalObservacion(this.params.data);
    }
  }
}
