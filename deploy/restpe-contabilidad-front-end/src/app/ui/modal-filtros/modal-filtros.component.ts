import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faInfoCircle, faXmark } from '@fortawesome/pro-regular-svg-icons';


export interface DetalleItem {
  label: string;
  value: string;
}

export interface MedioPago {
  id?: number;
  numero: number;
  medioPago: string;
  banco: string;
  numeroOperacion: string;
  moneda: string;
  monto: number;
}

@Component({
  selector: 'app-modal-filtros',
  templateUrl: './modal-filtros.component.html',
  styleUrls: ['./modal-filtros.component.scss'],
  standalone: false,
})
export class ModalFiltrosComponent implements OnInit {
  // Font Awesome Icons
  farInfoCircle = faInfoCircle;
  farXmark = faXmark;



  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  @Input() tituloModal: string = 'Filtros de los movimientos del sistema';
  @Input() widthModal: string = '450px';
  @Input() textoBotonConfirmar: string = 'Aplicar';
  @Input() textoBotonCancelar: string = 'Cancelar';


  bancoOrigen: string = '';


  bancos = [
    { id: 'bbva', nombre: 'BBVVA Continental' },
    { id: 'bcp', nombre: 'BCP' },
    { id: 'interbank', nombre: 'Interbank' },
  ];



  constructor(private modalController: ModalController) {
    const today = new Date();
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );
    this.maxDate = today;
  }

  ngOnInit() { }

  

  cerrarModal() {
    this.modalController.dismiss();
  }

  cancelar() {
    this.modalController.dismiss({ action: 'cancelar' });
  }

  agregar() {
    this.modalController.dismiss({ action: 'agregar' });
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos
    this.cargarDatos(range.start, range.end);
  }
  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }

}
