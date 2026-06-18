import { Component, Input, OnInit } from '@angular/core';
import { AbstractControl, FormBuilder, FormControl, FormGroup, ValidationErrors, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { CountryService } from 'src/app/ui/services/countryservice.service';

// Font Awesome Icons
import { faUserPlus, faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modals-agregar-cuenta',
  templateUrl: './modals-agregar-cuenta.component.html',
  styleUrls: ['./modals-agregar-cuenta.component.scss'],
  standalone: false,
})
export class ModalsAgregarCuentaComponent  implements OnInit {
  // Font Awesome Icons
  farUserPlus = faUserPlus;
  farXmark = faXmark;


  @Input() cuentaEditar: any = null;
  @Input() modoEdicion: boolean = false;
  pais= this.countryService.getCountryCode();
  AgregarCuentaForm!: FormGroup;
  tituloModal: string = 'Agregar una cuenta bancaria';

  /** Límites por campo de la cuenta bancaria. */
  readonly limites = {
    numeroCuenta: 30,
    cci: 20,
  };

  /** Rechaza valores que solo contienen espacios en blanco. */
  static noSoloEspacios(control: AbstractControl): ValidationErrors | null {
    const valor = control.value;
    if (valor == null || valor === '') {
      return null;
    }
    return String(valor).trim().length === 0 ? { soloEspacios: true } : null;
  }

  listaBancos = [
    { value: 'BCP', label: 'Banco de Crédito del Perú (BCP)' },
    { value: 'BBVA', label: 'BBVA Continental' },
    { value: 'Interbank', label: 'Interbank' },
    { value: 'Scotiabank', label: 'Scotiabank Perú' },
    { value: 'BanBif', label: 'BanBif' },
    { value: 'Pichincha', label: 'Banco Pichincha' },
    { value: 'GNB', label: 'Banco GNB' },
    { value: 'Falabella', label: 'Banco Falabella' },
    { value: 'Ripley', label: 'Banco Ripley' },
    { value: 'Santander', label: 'Banco Santander' },
    { value: 'Citibank', label: 'Citibank Perú' },
  ];

  tiposCuenta = [
    { value: 'Corriente', label: 'Cuenta Corriente' },
    { value: 'Ahorros', label: 'Cuenta de Ahorros' },
    { value: 'CTS', label: 'Cuenta CTS' },
    { value: 'Plazo Fijo', label: 'Cuenta a Plazo Fijo' },
    { value: 'detraccion', label: 'Cuenta de Detracción' },
  ];

  monedas = [
    { value: 'Soles', label: 'Soles' },
    { value: 'Dólares', label: 'Dólares' },
    { value: 'Euros', label: 'Euros' },
  ];

  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private countryService: CountryService,
  ) { }

  ngOnInit() {
    // Cambiar título si es modo edición
    if (this.modoEdicion) {
      this.tituloModal = 'Editar cuenta bancaria';
    }

    const cciValidators = this.pais === 'GT'
      ? []
      : [Validators.required, Validators.pattern(/^[0-9]{20}$/)];

    this.AgregarCuentaForm = this.formBuilder.group({
      banco: new FormControl('', [Validators.required]),
      numeroCuenta: new FormControl('', [
        Validators.required,
        ModalsAgregarCuentaComponent.noSoloEspacios,
        Validators.pattern(/^[0-9-]+$/),
        Validators.maxLength(this.limites.numeroCuenta),
      ]),
      cci: new FormControl('', cciValidators),
      tipoCuenta: new FormControl('', [Validators.required]),
      moneda: new FormControl('', [Validators.required]),
      estado: new FormControl('Activo', [Validators.required]),
    });

    // Restricciones aplicadas sobre el modelo (tope real al escribir o pegar)
    this.restringirCampo('numeroCuenta', this.limites.numeroCuenta, /[^0-9-]/g);
    this.restringirCampo('cci', this.limites.cci, /\D/g);

    // Si hay datos para editar, llenar el formulario
    if (this.cuentaEditar) {
      this.AgregarCuentaForm.patchValue({
        banco: this.cuentaEditar.cuenta_bancaria_banco,
        numeroCuenta: this.cuentaEditar.cuenta_bancaria_numero_cuenta,
        cci: this.cuentaEditar.cuenta_bancaria_cci,
        tipoCuenta: this.cuentaEditar.cuenta_bancaria_tipo,
        moneda: this.cuentaEditar.cuenta_bancaria_moneda,
        estado: this.cuentaEditar.cuenta_bancaria_estado || 'Activo'
      });
    }
  }

  /**
   * Restringe un control: elimina caracteres no permitidos (regex `quitar`) y
   * trunca a `max`. Garantiza el tope independientemente de ion-input.
   */
  private restringirCampo(control: string, max: number, quitar: RegExp): void {
    const c = this.AgregarCuentaForm.get(control);
    if (!c) {
      return;
    }
    c.valueChanges.subscribe((valor) => {
      if (valor == null) {
        return;
      }
      const original = String(valor);
      let limpio = original.replace(quitar, '');
      if (limpio.length > max) {
        limpio = limpio.slice(0, max);
      }
      if (limpio !== original) {
        c.setValue(limpio, { emitEvent: false });
      }
    });
  }

  cerrarModal() {
    this.modalController.dismiss();
  }

  cancelar() {
    this.modalController.dismiss();
  }

  agregarCuenta() {
    if (this.AgregarCuentaForm.valid) {
      const cuentaData = this.AgregarCuentaForm.value;
      // El componente padre espera 'guardar' al editar y 'agregar' al crear.
      const accion = this.modoEdicion ? 'guardar' : 'agregar';

      this.modalController.dismiss({
        cuenta: cuentaData,
        accion: accion
      });
    } else {
      // Marcar todos los campos como touched para mostrar errores
      Object.keys(this.AgregarCuentaForm.controls).forEach(key => {
        this.AgregarCuentaForm.get(key)?.markAsTouched();
      });
    }
  }

  get textoBotonGuardar(): string {
    return this.modoEdicion ? 'Actualizar cuenta' : 'Agregar cuenta';
  }

}
