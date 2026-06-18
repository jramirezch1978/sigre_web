import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

// Font Awesome Icons
import { faBook, faEye } from '@fortawesome/pro-regular-svg-icons';

@Component({
  selector: 'app-acciones-cell-render',
  template: `
    <div class="flex justify-center items-center h-full">
      <button
        class="btn-icon2"
        [class.text-primary]="!isEyeDisabled"
        [class.text-gray-300]="isEyeDisabled"
        [class.cursor-not-allowed]="isEyeDisabled"
        [disabled]="isEyeDisabled"
        (click)="onEyeClick($event)"
        title="Ver detalle">
        <fa-icon [icon]="farEye" class="!text-xxs"></fa-icon>
      </button>
      <button
        class="btn-icon2"
        [class.text-primary]="!isBookDisabled"
        [class.text-gray-300]="isBookDisabled"
        [class.cursor-not-allowed]="isBookDisabled"
        [disabled]="isBookDisabled"
        (click)="onBookClick($event)"
        title="Ver libro">
        <fa-icon [icon]="farBook" class="!text-xxs" ></fa-icon>
      </button>
    </div>
  `,
  standalone: false,
})
export class AccionesCellRenderComponent implements ICellRendererAngularComp {
  // Font Awesome Icons
  farBook = faBook;
  farEye = faEye;

  private params!: ICellRendererParams;
  private parentComponent: any;
  isEyeDisabled: boolean = false;
  isBookDisabled: boolean = false;

  agInit(params: ICellRendererParams): void {
    this.params = params;
    this.parentComponent = params.context?.componentParent;
    
    // Obtener configuración de disabled desde cellRendererParams
    if (params.colDef?.cellRendererParams) {
      const config = params.colDef.cellRendererParams;
      
      // Puede ser una función que reciba el data de la fila
      if (typeof config.isEyeDisabled === 'function') {
        this.isEyeDisabled = config.isEyeDisabled(params.data);
      } else if (typeof config.isEyeDisabled === 'boolean') {
        this.isEyeDisabled = config.isEyeDisabled;
      }
      
      if (typeof config.isBookDisabled === 'function') {
        this.isBookDisabled = config.isBookDisabled(params.data);
      } else if (typeof config.isBookDisabled === 'boolean') {
        this.isBookDisabled = config.isBookDisabled;
      }
    }
  }

  refresh(params: ICellRendererParams): boolean {
    return false;
  }

  onEyeClick(event: Event): void {
    event.stopPropagation();
    if (this.isEyeDisabled) return;
    
    if (this.parentComponent && this.parentComponent.abrirModalDetalleCuenta) {
      this.parentComponent.abrirModalDetalleCuenta(this.params?.data);
    }
  }

  onBookClick(event: Event): void {
    event.stopPropagation();
    if (this.isBookDisabled) return;
    
    if (this.parentComponent && this.parentComponent.abrirModalLibro) {
      this.parentComponent.abrirModalLibro(this.params?.data);
    }
  }
}
