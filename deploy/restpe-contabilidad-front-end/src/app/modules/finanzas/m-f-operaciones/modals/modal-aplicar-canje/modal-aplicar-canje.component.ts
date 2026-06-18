import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faInfoCircle, faXmark } from '@fortawesome/pro-regular-svg-icons';
import { faExchange } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-modal-aplicar-canje',
  templateUrl: './modal-aplicar-canje.component.html',
  styleUrls: ['./modal-aplicar-canje.component.scss'],
  standalone: false,
})
export class ModalAplicarCanjeComponent  implements OnInit {
  // Font Awesome Icons
  farInfoCircle = faInfoCircle;
  farXmark = faXmark;
  fasExchange = faExchange;




  @Input() razonS: string = '';
  @Input() proveedor: string = '';
  @Input() nDocumento: string = '';
  @Input() montoP: any = 0;
  canjeForm!: FormGroup

  Documentos = [
    { nombre: 'F001-00123'},
    { nombre: 'F001-00124'},
    { nombre: 'F001-00125'},
    { nombre: 'F001-00126'},
    { nombre: 'F001-00127'},
    { nombre: 'F001-00128'},
    { nombre: 'F001-00129'},
    { nombre: 'F001-00130'},
  ];
  tipos = [
    'Canje total',
    'Canje parcial',
  ];

  constructor(
    private modalCtrl: ModalController,
    private formBuilder: FormBuilder
  ) { }

  ngOnInit() {
    this.canjeForm = this.formBuilder.group({
      docDxD: [ '', Validators.required ],
      tipo: ['', Validators.required],
      montoPendiente: [this.montoP, Validators.required],
      montoAplicado: ['', Validators.required],
      saldoRemanente: [''],
    });

    // Suscribirse a cambios en montoAplicado y montoPendiente para calcular saldo remanente
    this.canjeForm.get('montoAplicado')?.valueChanges.subscribe(() => {
      this.calcularSaldoRemanente();
    });
    
    this.canjeForm.get('montoPendiente')?.valueChanges.subscribe(() => {
      this.calcularSaldoRemanente();
    });
  }

  calcularSaldoRemanente() {
    // Obtener valores del formulario
    const montoPendienteStr = this.canjeForm.get('montoPendiente')?.value || '0';
    const montoAplicadoStr = this.canjeForm.get('montoAplicado')?.value || '0';
    
    // Convertir a número (eliminar comas si las hay)
    const montoPendiente = parseFloat(String(montoPendienteStr).replace(/,/g, '')) || 0;
    const montoAplicado = parseFloat(String(montoAplicadoStr).replace(/,/g, '')) || 0;
    
    // Calcular saldo remanente: monto pendiente - monto aplicado
    const saldoRemanente = montoPendiente - montoAplicado;
    
    this.canjeForm.patchValue({
      saldoRemanente: saldoRemanente >= 0 ? saldoRemanente.toFixed(2) : '0.00'
    });
  }

  
  onDocumentoSeleccionado(documento: any) {
    console.log('Documento seleccionado:', documento);
    this.canjeForm.patchValue({
      docDxD: documento.nombre
    })
  }

  cerrarModal(tipo: boolean) {
    // Lógica para cerrar el modal y devolver el resultado
    if(tipo === true){
      // Validar que el formulario sea válido
      if (!this.canjeForm.valid) {
        // Marcar todos los controles como tocados para mostrar errores
        Object.keys(this.canjeForm.controls).forEach(key => {
          this.canjeForm.get(key)?.markAsTouched();
        });
        
        return;
      }
      // Aquí puedes agregar la lógica para guardar los cambios antes de cerrar el modal
      this.modalCtrl.dismiss(true);
    } else {
      this.modalCtrl.dismiss(false);
    }
  }

}