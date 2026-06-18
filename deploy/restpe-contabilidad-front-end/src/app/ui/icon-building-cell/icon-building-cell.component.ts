import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';

// Font Awesome Icons
import { faBuilding } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-icon-building-cell',
  templateUrl: './icon-building-cell.component.html',
  styleUrls: ['./icon-building-cell.component.scss'],
  standalone: false,
})
export class IconBuildingCellComponent implements ICellRendererAngularComp {
  // Font Awesome Icons
  farBuilding = faBuilding;


  
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
