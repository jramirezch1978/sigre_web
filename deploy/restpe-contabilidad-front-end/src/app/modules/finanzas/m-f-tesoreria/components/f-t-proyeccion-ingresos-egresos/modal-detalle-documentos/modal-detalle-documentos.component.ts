import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef } from 'ag-grid-community';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-detalle-documentos',
  templateUrl: './modal-detalle-documentos.component.html',
  styleUrls: ['./modal-detalle-documentos.component.scss'],
  standalone: false,
})
export class ModalDetalleDocumentosComponent implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;


  @Input() tituloModal: string = 'Detalle de documentos';
  @Input() widthModal: string = '850px';
  @Input() heightModal: string = '480px';
  @Input() sucursal: string = '';
  @Input() periodo: string = '';
  @Input() saldoInicial: number = 0;
  @Input() saldoFinal: number = 0;
  @Input() variacion: number = 0;
  
  // Datos para los tabs
  @Input() ingresosData: any[] = [];
  @Input() egresosData: any[] = [];
  @Input() colDefsIngresos: ColDef[] = [];
  @Input() colDefsEgresos: ColDef[] = [];

  tabSeleccionado: 'ingresos' | 'egresos' = 'ingresos';
  
  // Datos actuales según el tab
  currentColDefs: ColDef[] = [];
  currentRowData: any[] = [];

  constructor(private modalController: ModalController) {}

  ngOnInit() {
    // Inicializar con ingresos
    this.cambiarTab('ingresos');
  }

  cambiarTab(tab: 'ingresos' | 'egresos') {
    this.tabSeleccionado = tab;
    
    if (tab === 'ingresos') {
      this.currentColDefs = this.colDefsIngresos;
      this.currentRowData = this.ingresosData;
    } else {
      this.currentColDefs = this.colDefsEgresos;
      this.currentRowData = this.egresosData;
    }
  }

  cerrarModal() {
    this.modalController.dismiss();
  }

  formatearMonto(monto: number): string {
    const formattedValue = new Intl.NumberFormat('es-PE', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(Math.abs(monto));
    return `S/ ${formattedValue}`;
  }

  formatearVariacion(variacion: number): string {
    const formattedValue = new Intl.NumberFormat('es-PE', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(Math.abs(variacion));
    const signo = variacion >= 0 ? '+' : '-';
    return `${signo} S/ ${formattedValue}`;
  }
}
