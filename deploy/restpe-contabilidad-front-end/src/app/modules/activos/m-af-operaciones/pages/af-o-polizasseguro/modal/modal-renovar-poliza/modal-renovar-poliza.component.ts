import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faCircleXmark } from '@fortawesome/pro-regular-svg-icons';
import { faXmark } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-modal-renovar-poliza',
  templateUrl: './modal-renovar-poliza.component.html',
  styleUrls: ['./modal-renovar-poliza.component.scss'],
  standalone: false
})
export class ModalRenovarPolizaComponent implements OnInit {
  // Font Awesome Icons
  farCircleXmark = faCircleXmark;
  fasXmark = faXmark;



  @Input() poliza: any;
  
  // Campos editables para la renovación
  numeroPoliza: string = '';
  fechaInicio?: Date;
  fechaVencimiento?: Date;
  documentoSoporte: string = '';
  sumaAsegurada: string = '';
  primaTotal: string = '';
  deducible: string = '';
  tipoDeducible: string = '%';

  constructor(
    private modalController: ModalController
  ) { }

  ngOnInit() {
    console.log('Póliza recibida:', this.poliza);
    // Pre-llenar los campos con los datos de la póliza actual
    if (this.poliza) {
      // Generar nuevo número de póliza (ejemplo: agregar sufijo)
      this.numeroPoliza = 'POL-0012346';
      // Convertir fechas de formato DD/MM/YYYY a Date
      this.fechaInicio = this.convertStringToDate(this.poliza.fechaInicio) || new Date(2025, 9, 27);
      this.fechaVencimiento = this.convertStringToDate(this.poliza.fechaVencimiento) || new Date(2026, 9, 27);
      this.sumaAsegurada = this.poliza.sumaAsegurada || '100000';
      this.primaTotal = this.poliza.primaTotal || '120000';
      this.deducible = '10';
    }
  }

  convertStringToDate(dateStr: string): Date | undefined {
    if (!dateStr) return undefined;
    // Convertir de DD/MM/YYYY a Date
    const parts = dateStr.split('/');
    if (parts.length === 3) {
      const day = parseInt(parts[0], 10);
      const month = parseInt(parts[1], 10) - 1; // Los meses en JS van de 0-11
      const year = parseInt(parts[2], 10);
      return new Date(year, month, day);
    }
    return undefined;
  }

  convertDateToInputFormat(dateStr: string): string {
    if (!dateStr) return '';
    // Convertir de DD/MM/YYYY a YYYY-MM-DD
    const parts = dateStr.split('/');
    if (parts.length === 3) {
      return `${parts[2]}-${parts[1]}-${parts[0]}`;
    }
    return dateStr;
  }

  onFechaInicioSelected(date: Date) {
    this.fechaInicio = date;
  }

  onFechaVencimientoSelected(date: Date) {
    this.fechaVencimiento = date;
  }

  cerrarModal() {
    this.modalController.dismiss();
  }

  cancelarRenovacion() {
    this.modalController.dismiss();
  }

  renovarPoliza() {
    // Validaciones básicas
    if (!this.numeroPoliza || !this.fechaInicio || !this.fechaVencimiento || !this.sumaAsegurada || !this.primaTotal) {
      return;
    }
    
    this.modalController.dismiss({
      renovada: true,
      datos: {
        numeroPoliza: this.numeroPoliza,
        fechaInicio: this.fechaInicio,
        fechaVencimiento: this.fechaVencimiento,
        documentoSoporte: this.documentoSoporte,
        sumaAsegurada: this.sumaAsegurada,
        primaTotal: this.primaTotal,
        deducible: this.deducible,
        tipoDeducible: this.tipoDeducible
      }
    });
  }

  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      this.documentoSoporte = file.name;
    }
  }

  removeFile() {
    this.documentoSoporte = '';
  }

}
