import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';
import { faCalendar, faClock } from '@fortawesome/pro-regular-svg-icons';

@Component({
  selector: 'app-vista-fecha-hora-render',
  templateUrl: './vista-fecha-hora-render.component.html',
  styleUrls: ['./vista-fecha-hora-render.component.scss'],
  standalone: false,
})
export class VistaFechaHoraRenderComponent implements ICellRendererAngularComp {

  farCalendar = faCalendar;
  farClock = faClock;

  fecha: string = '';
  hora: string = '';
  vertical: boolean = false;

  private parentComponent: any;
  private params: ICellRendererParams | undefined;


  agInit(params: ICellRendererParams): void {
    this.params = params;
    this.parentComponent = params.context.componentParent;
    this.vertical = (params as any).vertical ?? false;
    this.parsearFecha(params.value);
  }

  refresh(params: ICellRendererParams): boolean {
    this.vertical = (params as any).vertical ?? false;
    this.parsearFecha(params.value);
    return true;
  }

  private parsearFecha(value: any): void {
    if (!value) {
      this.fecha = '-';
      this.hora = '';
      return;
    }
    const date = new Date(value);
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = date.getFullYear();
    this.fecha = `${day}/${month}/${year}`;

    const hours = date.getHours();
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const ampm = hours >= 12 ? 'PM' : 'AM';
    const h12 = hours % 12 || 12;
    this.hora = `${h12}:${minutes} ${ampm}`;
  }

  onDetalleClick(event: Event): void {
    event.stopPropagation();
    if (this.parentComponent && this.parentComponent.onVerDetalle) {
      this.parentComponent.onVerDetalle(this.params?.data);
    }
  }
}
