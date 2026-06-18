import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';

// Font Awesome Icons
import { faFileLines } from '@fortawesome/pro-light-svg-icons';
import { faFolderOpen } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-icon-cell',
  templateUrl: './icon-cell.component.html',
  styleUrls: ['./icon-cell.component.scss'],
  standalone: false,
})
export class IconCellComponent implements ICellRendererAngularComp {
  // Font Awesome Icons
  falFileLines = faFileLines;
  fasFolderOpen = faFolderOpen;


  
  params: any;
  nivel = 0;

  agInit(params: any): void {
    this.params = params;
    this.calcularNivel();
  }

  refresh(params: any): boolean {
    this.params = params;
    this.calcularNivel();
    return true;
  }

  private calcularNivel() {
    // En Tree Data, `params.node.level` indica el nivel jerárquico (0, 1, 2, ...)
    this.nivel = this.params.node ? this.params.node.level : 0;
  }
}
