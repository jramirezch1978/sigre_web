import { Component, OnInit } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

// Font Awesome Icons
import { faCalendar, faClock } from '@fortawesome/pro-light-svg-icons';



@Component({
  selector: 'app-entrada-salida-cell-renderer',
  templateUrl: './entrada-salida-cell-renderer.component.html',
  styleUrls: ['./entrada-salida-cell-renderer.component.scss'],
  standalone: false,
})
export class EntradaSalidaCellRendererComponent implements ICellRendererAngularComp {
  // Font Awesome Icons
  falCalendar = faCalendar;
  falClock = faClock;



  datos: any | null = null;

  constructor() { }

  agInit(params: ICellRendererParams): void {
    this.datos = params.value;
  }

  refresh(params: ICellRendererParams): boolean {
    this.datos = params.value;
    return true;
  }

}
