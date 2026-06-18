import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

// Font Awesome Icons
import { faInfoCircle } from '@fortawesome/pro-regular-svg-icons';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
// Font Awesome Icons

@Component({
  selector: 'app-detail-cell-renderer',
  standalone: true,
  imports: [CommonModule, FontAwesomeModule],
  templateUrl: './detail-cell-renderer.component.html',
  styleUrls: ['./detail-cell-renderer.component.scss']
})
export class DetailCellRendererComponent implements ICellRendererAngularComp {
  // Font Awesome Icons
  farInfoCircle = faInfoCircle;


  params!: ICellRendererParams;
  data: any;
  detalleIngresos: any[] = [];
  detalleEgresos: any[] = [];
  estado: string = '';
  tipoAlerta: 'success' | 'warning' | 'danger' | 'info' = 'info';
  mensajeAlerta: string = '';

  agInit(params: ICellRendererParams): void {
    this.params = params;
    this.data = params.data;
    this.detalleIngresos = this.data.pie_detalleIngresos || [];
    this.detalleEgresos = this.data.pie_detalleEgresos || [];
    this.estado = this.data.pie_estado || '';
    this.configurarAlerta();
  }

  configurarAlerta(): void {
    switch (this.estado) {
      case 'Superavit':
      case 'Superávit':
        this.tipoAlerta = 'success';
        this.mensajeAlerta = '<strong>Proyección favorable.</strong> Se esperan mayores ingresos por eventos corporativos';
        break;
      case 'Déficit':
      case 'Deficit':
        this.tipoAlerta = 'danger';
        this.mensajeAlerta = '<strong>Alerta.</strong> Saldo proyectado por debajo del mínimo operativo. Revisar cobranzas pendientes.';
        break;
      case 'Equilibrado':
        this.tipoAlerta = 'info';
        this.mensajeAlerta = 'Es conforme con los estándares considerados para las proyecciones.';
        break;
      default:
        this.tipoAlerta = 'info';
        this.mensajeAlerta = 'Información de proyección.';
    }
  }

  refresh(params: ICellRendererParams): boolean {
    return false;
  }
}
