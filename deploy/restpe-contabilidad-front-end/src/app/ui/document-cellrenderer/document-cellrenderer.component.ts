import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

// Font Awesome Icons
import { faFileAlt } from '@fortawesome/pro-light-svg-icons';



@Component({
  selector: 'app-document-cellrenderer',
  templateUrl: './document-cellrenderer.component.html',
  styleUrls: ['./document-cellrenderer.component.scss'],
  standalone: false,
})
export class DocumentCellrendererComponent implements ICellRendererAngularComp {
  // Font Awesome Icons
  falFileAlt = faFileAlt;


  private params!: ICellRendererParams;
  private parentComponent: any;
  textoDocumento: string = 'Ver documento';

  agInit(params: ICellRendererParams): void {
    this.params = params;
    this.parentComponent = params.context?.componentParent;
    this.setTextoDocumento(params.data?.tipoAccion);
  }

  refresh(params: ICellRendererParams): boolean {
    return false;
  }

  private setTextoDocumento(tipoAccion: string): void {
    switch(tipoAccion) {
      case 'Sanción':
        this.textoDocumento = 'Ver memorando';
        break;
      case 'Renovación':
        this.textoDocumento = 'Ver contrato';
        break;
      default:
        this.textoDocumento = 'Ver documento';
    }
  }

  onVerDocumento(event: Event): void {
    event.stopPropagation();
    if (this.parentComponent && this.parentComponent.onVerDocumento) {
      this.parentComponent.onVerDocumento(this.params?.data);
    }
  }
}
