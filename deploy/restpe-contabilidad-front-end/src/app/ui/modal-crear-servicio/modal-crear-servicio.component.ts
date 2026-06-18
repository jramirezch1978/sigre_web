import { Component, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-modal-crear-servicio',
  templateUrl: './modal-crear-servicio.component.html',
  styleUrls: ['./modal-crear-servicio.component.scss'],
  standalone: false,
})
export class ModalCrearServicioComponent  implements OnInit {
  // Font Awesome Icons
  fasXmark = faXmark;



  // Arrays para selectores
  tiposServicio = [
    { value: 'mantenimiento', label: 'Mantenimiento' },
    { value: 'consultoria', label: 'Consultoria' },
    { value: 'transporte', label: 'Transporte' },
    { value: 'limpieza', label: 'Limpieza' },
    { value: 'software', label: 'Software' }
  ];

  // unidadesMedida = [
  //   { value: 'und', label: 'UND' },
  //   { value: 'kg', label: 'KG' },
  //   { value: 'gr', label: 'GR' },
  //   { value: 'ml', label: 'ML' },
  //   { value: 'l', label: 'L' }
  // ];

  // Arrays para autocomplete
  cuentasContablesInventario = [
    { id: '20111', nombre: '20111 - Mercaderías manufacturadas' },
    { id: '20112', nombre: '20112 - Mercaderías de extracción' },
    { id: '20113', nombre: '20113 - Mercaderías agropecuarias' },
    { id: '20114', nombre: '20114 - Mercaderías inmuebles' },
    { id: '20115', nombre: '20115 - Existencias por recibir' }
  ];

  cuentasContablesCosto = [
    { id: '60111', nombre: '60111 - Mercaderías manufacturadas' },
    { id: '60112', nombre: '60112 - Mercaderías de extracción' },
    { id: '60113', nombre: '60113 - Mercaderías agropecuarias' },
    { id: '60114', nombre: '60114 - Mercaderías inmuebles' },
    { id: '69111', nombre: '69111 - Costo de ventas' }
  ];

  constructor(private modalController: ModalController) { }

  ngOnInit() {}

  onCuentaInventarioSelected(cuenta: any) {
    console.log('Cuenta inventario seleccionada:', cuenta);
  }

  onCuentaCostoSelected(cuenta: any) {
    console.log('Cuenta costo seleccionada:', cuenta);
  }
  cerrarModal() {
    this.modalController.dismiss();
  }
}
