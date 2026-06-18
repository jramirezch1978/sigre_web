import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ICellRendererAngularComp } from 'ag-grid-angular';

// Font Awesome Icons
import { faEye } from '@fortawesome/pro-regular-svg-icons';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
// Font Awesome Icons

@Component({
  selector: 'app-eye-cell-asiento',
  templateUrl: './eye-cell-asiento.component.html',
  styleUrls: ['./eye-cell-asiento.component.scss'],
  standalone: true,
  imports: [CommonModule, FontAwesomeModule],
})
export class EyeCellAsientoComponent implements ICellRendererAngularComp {
  // Font Awesome Icons
  farEye = faEye;



  params: any;
  showEye = false;
  nroAsiento = '';

  agInit(params: any): void {
    this.params = params;
    this.nroAsiento = params.value || '';
    // Mostrar el ojo si hay número de asiento
    this.showEye = this.nroAsiento.trim() !== '';
  }

  refresh(params: any): boolean {
    this.params = params;
    this.nroAsiento = params.value || '';
    this.showEye = this.nroAsiento.trim() !== '';
    return true;
  }

  onEyeClick() {
    if (this.params?.context?.componentParent?.abrirModalDetalleAsiento) {
      this.params.context.componentParent.abrirModalDetalleAsiento(this.params.data);
    }
  }
}
