import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { CountryService } from 'src/app/ui/services/countryservice.service';

// Font Awesome Icons
import { faPlusCircle } from '@fortawesome/pro-regular-svg-icons';
import { faXmark } from '@fortawesome/pro-solid-svg-icons';



interface CuentaBancaria {
  entidadFinanciera: string;
  tipoCuenta: string;
  moneda: string;
  nroCuenta: string;
  cci: string;
}

@Component({
  selector: 'app-modal-cuenta-bancaria',
  templateUrl: './modal-cuenta-bancaria.component.html',
  styleUrls: ['./modal-cuenta-bancaria.component.scss'],
  standalone: false,
})
export class ModalCuentaBancariaComponent implements OnInit {
  // Font Awesome Icons
  farPlusCircle = faPlusCircle;
  fasXmark = faXmark;


  @Input() cuentaEditar: CuentaBancaria | null = null;
  pais= this.countryService.getCountryCode();
  countries=ALL_COUNTRIES;
  formulario!: FormGroup;

  monedas = [
    { value: 'soles', label: 'Soles' },
    { value: 'dolares', label: 'Dólares' }
  ];

  tiposCuenta: any= [
    { id: 'sueldo', nombre: 'Sueldo' },
    { id: 'cts', nombre: 'CTS' },
    { id: 'corriente', nombre: 'Corriente' },
    { id: 'ahorros', nombre: 'Ahorros' },
    { id: 'linea', nombre: 'Línea de crédito' },
    { id: 'otros', nombre: 'Otros' }
  ];

  constructor(
    private modalController: ModalController,
    private formBuilder: FormBuilder,
    private countryService: CountryService
  ) {}

  ngOnInit() {
    this.obtenerdatospais();
    this.crearFormulario();
    if (this.cuentaEditar) {
      this.formulario.patchValue(this.cuentaEditar);
    }
  }
  obtenerdatospais(){
    this.countries.find(country => {
      if(country.codigo === this.pais){
        this.tiposCuenta = country.tiposCuenta;
      }
    });
  }

  crearFormulario() {
    this.formulario = this.formBuilder.group({
      entidadFinanciera: ['', [Validators.required]],
      tipoCuenta: ['', [Validators.required]],
      moneda: ['', [Validators.required]],
      nroCuenta: ['', [Validators.required, Validators.minLength(8)]],
      cci: ['', [Validators.required, Validators.minLength(20)]]
    });
  }

  registrarCuenta() {
    if (this.formulario.valid) {
      this.modalController.dismiss(this.formulario.value);
    }
  }

  closemodal() {
    this.modalController.dismiss();
  }
}
