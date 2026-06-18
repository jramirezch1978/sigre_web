import { Component } from '@angular/core';
import { faEye } from '@fortawesome/pro-regular-svg-icons';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

@Component({
  selector: 'app-informacion-fe-render',
  templateUrl: './informacion-fe-render.component.html',
  styleUrls: ['./informacion-fe-render.component.scss'],
  standalone: false,
})
export class InformacionFeRenderComponent implements ICellRendererAngularComp {

  farEye = faEye;

  informacion: any[] = [];

  agInit(params: ICellRendererParams): void {
    this.parsear(params.value);
  }

  refresh(params: ICellRendererParams): boolean {
    this.parsear(params.value);
    return true;
  }

  private parsear(value: any): void {
    if (!value) {
      this.informacion = [];
      return;
    }
    this.informacion = [value];
  }

  onLinkClick(event: Event, enlace: string): void {
    event.stopPropagation();
    if (enlace) {
      window.open(enlace, '_blank', 'noopener,noreferrer');
    }
  }
}
