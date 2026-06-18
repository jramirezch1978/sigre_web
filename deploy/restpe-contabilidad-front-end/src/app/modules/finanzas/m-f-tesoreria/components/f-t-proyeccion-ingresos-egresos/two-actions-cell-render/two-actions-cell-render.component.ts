import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ICellRendererAngularComp } from 'ag-grid-angular';

// Font Awesome Icons
import { faEye, faScrewdriverWrench } from '@fortawesome/pro-regular-svg-icons';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';

// Font Awesome Icons

@Component({
  selector: 'app-two-actions-cell-render',
  templateUrl: './two-actions-cell-render.component.html',
  styleUrls: ['./two-actions-cell-render.component.scss'],
  standalone: true,
  imports: [CommonModule, FontAwesomeModule],
})
export class TwoActionsCellRenderComponent implements ICellRendererAngularComp {
  // Font Awesome Icons
  farEye = faEye;
  farScrewdriverWrench = faScrewdriverWrench;


  params: any;
  parentComponent: any;

  agInit(params: any): void {
    this.params = params;
    this.parentComponent = params.context?.componentParent;
  }

  refresh(params: any): boolean {
    this.params = params;
    return true;
  }

  onVerDetalleClick(event: Event) {
    event.stopPropagation();
    if (this.parentComponent && this.parentComponent.abrirModalDetalle) {
      this.parentComponent.abrirModalDetalle(this.params.data);
    }
  }

  onEliminarClick(event: Event) {
    event.stopPropagation();
    if (this.parentComponent && this.parentComponent.abrirModalEliminar) {
      this.parentComponent.abrirModalEliminar(this.params.data);
    }
  }
}
