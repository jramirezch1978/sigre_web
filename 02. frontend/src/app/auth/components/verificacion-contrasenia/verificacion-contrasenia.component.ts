import { Component, EventEmitter, OnDestroy, OnInit, Output, QueryList, ViewChildren, inject } from '@angular/core';
import { AbstractControl, FormBuilder, FormGroup, ValidationErrors, ValidatorFn, Validators } from '@angular/forms';
import { IonInput, ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from '@ui/modal-confirmation/modal-confirmation.component';
import { ToastService } from '@ui/services/toast.service';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-verificacion-contrasenia',
  templateUrl: './verificacion-contrasenia.component.html',
  styleUrls: ['./verificacion-contrasenia.component.scss'],
  standalone: false,
})
export class VerificacionContraseniaComponent implements OnInit, OnDestroy {

  paso = 1;
  mostrar1 = false;
  mostrar2 = false;
  emailOculto = '';
  emailCompleto = '';
  usernameIngresado = '';
  contador = 300;
  timerActivo = false;
  codigoInvalido = false;
  isLoading = false;

  private timerRef: ReturnType<typeof setInterval> | null = null;
  @Output() volverLogin = new EventEmitter<void>();

  @ViewChildren('codigoInput') codigoInputs!: QueryList<IonInput>;

  usernameForm!: FormGroup;
  validarEmailForm!: FormGroup;
  codigoForm!: FormGroup;
  nuevaClave!: FormGroup;

  private readonly fb = inject(FormBuilder);
  private readonly modalController = inject(ModalController);
  private readonly toast = inject(ToastService);
  private readonly authService = inject(AuthService);

  ngOnInit() {
    this.usernameForm = this.fb.group({
      username: ['', [Validators.required, Validators.maxLength(80)]]
    });

    this.validarEmailForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]]
    });

    this.codigoForm = this.fb.group({
      c1: ['', [Validators.required, Validators.pattern(/^[A-Za-z0-9]$/)]],
      c2: ['', [Validators.required, Validators.pattern(/^[A-Za-z0-9]$/)]],
      c3: ['', [Validators.required, Validators.pattern(/^[A-Za-z0-9]$/)]],
      c4: ['', [Validators.required, Validators.pattern(/^[A-Za-z0-9]$/)]],
      c5: ['', [Validators.required, Validators.pattern(/^[A-Za-z0-9]$/)]],
      c6: ['', [Validators.required, Validators.pattern(/^[A-Za-z0-9]$/)]],
      c7: ['', [Validators.required, Validators.pattern(/^[A-Za-z0-9]$/)]],
      c8: ['', [Validators.required, Validators.pattern(/^[A-Za-z0-9]$/)]],
    });

    this.nuevaClave = this.fb.group({
      clave: ['', [Validators.required, Validators.minLength(8), this.validarComplejidad()]],
      confirmarClave: ['', [Validators.required, Validators.minLength(8)]],
    }, { validators: this.validadorClaveIgual() });
  }

  ngOnDestroy(): void {
    this.detenerContador();
  }

  volverALogin() {
    this.volverLogin.emit();
  }

  get tituloActual(): string {
    if (this.paso === 4) return 'Ingresar nueva contraseña';
    return 'Recuperar contraseña';
  }

  regresar(): void {
    if (this.paso > 1) {
      this.paso--;
      if (this.paso !== 3) this.detenerContador();
    } else {
      this.volverALogin();
    }
  }

  mostrarOcultar1(event?: Event) {
    event?.preventDefault();
    event?.stopPropagation();
    this.mostrar1 = !this.mostrar1;
  }

  mostrarOcultar2(event?: Event) {
    event?.preventDefault();
    event?.stopPropagation();
    this.mostrar2 = !this.mostrar2;
  }

  get contadorFormato(): string {
    const min = Math.floor(this.contador / 60);
    const seg = this.contador % 60;
    return `${min.toString().padStart(2, '0')}:${seg.toString().padStart(2, '0')}`;
  }

  /** Paso 1: enviar username → obtener email ofuscado */
  continuarPaso1(): void {
    this.usernameForm.markAllAsTouched();
    if (!this.usernameForm.valid) return;

    this.isLoading = true;
    this.usernameIngresado = this.usernameForm.value.username;

    this.authService.obtenerEmailOfuscado(this.usernameIngresado).subscribe({
      next: (res: any) => {
        this.isLoading = false;
        if (res.success && res.data?.emailOculto) {
          this.emailOculto = res.data.emailOculto;
          this.paso = 2;
        }
      },
      error: (err: any) => {
        this.isLoading = false;
        this.showError(err.error?.titulo ?? 'Usuario no encontrado', err.error?.mensaje ?? 'El nombre de usuario ingresado no existe, por favor verifica e intenta nuevamente.');
      }
    });
  }

  /** Paso 2: verificar email completo → enviar código */
  continuarPaso2(): void {
    this.validarEmailForm.markAllAsTouched();
    if (!this.validarEmailForm.valid) return;

    this.isLoading = true;
    this.emailCompleto = this.validarEmailForm.value.email;

    this.authService.verificarEmail(this.emailCompleto).subscribe({
      next: (res: any) => {
        if (res.success) {
          this.enviarCodigoYAvanzar();
        }
      },
      error: (err: any) => {
        this.isLoading = false;
        this.showError(err.error?.titulo ?? 'Error al verificar correo', err.error?.mensaje ?? 'El correo ingresado no coincide con el registrado');
      }
    });
  }

  private enviarCodigoYAvanzar(): void {
    this.authService.enviarCodigo(this.emailCompleto).subscribe({
      next: () => {
        this.isLoading = false;
        this.paso = 3;
        this.iniciarContador();
      },
      error: (err: any) => {
        this.isLoading = false;
        this.showError(err.error?.titulo ?? 'Error al enviar código', err.error?.mensaje ?? 'No se pudo enviar el código. Intenta nuevamente más tarde.');
      }
    });
  }

  /** Paso 3: validar código de 8 caracteres */
  continuarPaso3(): void {
    const codigo = this.getCodigoCompleto();
    if (codigo.length !== 8) {
      this.codigoInvalido = true;
      return;
    }

    this.isLoading = true;
    this.authService.validarCodigo(this.emailCompleto, codigo).subscribe({
      next: () => {
        this.isLoading = false;
        this.codigoInvalido = false;
        this.detenerContador();
        this.paso = 4;
      },
      error: (err: any) => {
        this.isLoading = false;
        this.codigoInvalido = true;
        this.codigoForm.reset();
        const inputs = this.codigoInputs.toArray();
        if (inputs.length > 0) void inputs[0].setFocus();
        this.showError(
          err.error?.titulo ?? 'Código inválido',
          err.error?.mensaje ?? 'El código ingresado no es válido o ha expirado. Por favor, solicita uno nuevo.'
        );
      }
    });
  }

  reenviarCodigo(): void {
    this.codigoForm.reset();
    this.codigoInvalido = false;
    this.isLoading = true;
    this.authService.enviarCodigo(this.emailCompleto).subscribe({
      next: () => {
        this.isLoading = false;
        this.iniciarContador();
        this.toast.success('Código reenviado a tu correo');
      },
      error: (err: any) => {
        this.isLoading = false;
        this.showError(err.error?.titulo ?? 'Error al reenviar código', err.error?.mensaje ?? 'No se pudo reenviar el código. Intenta nuevamente más tarde.');
      }
    });
  }

  /** Paso 4: cambiar contraseña */
  enviar(): void {
    this.nuevaClave.markAllAsTouched();
    if (!this.nuevaClave.valid) return;

    this.isLoading = true;
    const codigo = this.getCodigoCompleto();
    const nuevaPassword = this.nuevaClave.value.clave;

    this.authService.cambiarPassword(this.emailCompleto, codigo, nuevaPassword).subscribe({
      next: () => {
        this.isLoading = false;
        this.toast.success('¡Contraseña restablecida exitosamente!');
        setTimeout(() => this.volverALogin(), 500);
      },
      error: (err: any) => {
        this.isLoading = false;
        this.showError(err.error?.titulo ?? 'Error al cambiar contraseña', err.error?.mensaje ?? 'No se pudo cambiar la contraseña. Intenta nuevamente más tarde.');
      }
    });
  }

  private getCodigoCompleto(): string {
    return ['c1', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7', 'c8']
      .map(k => (this.codigoForm.controls[k].value as string) ?? '')
      .join('');
  }

  private iniciarContador(): void {
    this.detenerContador();
    this.contador = 300;
    this.timerActivo = true;
    this.timerRef = setInterval(() => {
      this.contador--;
      if (this.contador <= 0) {
        this.contador = 0;
        this.timerActivo = false;
        this.detenerContador();
        this.authService.limpiarCodigosExpirados().subscribe();
      }
    }, 1000);
  }

  private detenerContador(): void {
    if (this.timerRef !== null) {
      clearInterval(this.timerRef);
      this.timerRef = null;
    }
  }

  claveInvalida(campo: string): boolean {
    const control = this.nuevaClave.get(campo);
    if (!control || !(control.dirty || control.touched)) return false;
    if (control.invalid) return true;
    if (campo === 'confirmarClave' && this.nuevaClave.errors?.['clavesNoCoinciden']) return true;
    return false;
  }

  campoInvalido(form: FormGroup, control: string): boolean {
    const campo = form.controls[control];
    return !!campo && campo.invalid && (campo.dirty || campo.touched);
  }

  public getCampoError(fieldName: string): string {
    const field = this.nuevaClave.get(fieldName);
    if (field?.errors) {
      if (field.errors['required']) return `El campo es requerido`;
      if (field.errors['minlength']) return `Mínimo ${field.errors['minlength'].requiredLength} caracteres`;
      if (field.errors['sinMayuscula']) return `Debe contener al menos una letra mayúscula`;
      if (field.errors['sinMinuscula']) return `Debe contener al menos una letra minúscula`;
      if (field.errors['sinNumero']) return `Debe contener al menos un número`;
      if (field.errors['sinEspecial']) return `Debe contener al menos un carácter especial (!@#$%...)`;
    }
    if (fieldName === 'confirmarClave' && this.nuevaClave.errors?.['clavesNoCoinciden']) {
      return `Las contraseñas no coinciden`;
    }
    return '';
  }

  onCodigoInput(event: Event, index: number): void {
    const target = event.target as HTMLIonInputElement | null;
    let valor = (typeof target?.value === 'string' ? target.value : String(target?.value ?? '')).replace(/[^A-Za-z0-9]/g, '');
    if (valor.length > 1) valor = valor.charAt(valor.length - 1);

    const controlName = `c${index + 1}`;
    this.codigoForm.controls[controlName].setValue(valor, { emitEvent: false });
    if (target) target.value = valor;

    if (this.codigoInvalido && valor) this.codigoInvalido = false;

    if (valor.length === 1 && index < 7) {
      const inputs = this.codigoInputs.toArray();
      void inputs[index + 1]?.setFocus();
    }
  }

  onCodigoPaste(event: ClipboardEvent, index: number): void {
    event.preventDefault();
    const texto = (event.clipboardData?.getData('text') ?? '').replace(/[^A-Za-z0-9]/g, '');
    if (!texto) return;

    const inputs = this.codigoInputs.toArray();
    for (let i = 0; i < texto.length && (index + i) < 8; i++) {
      const controlName = `c${index + i + 1}`;
      this.codigoForm.controls[controlName].setValue(texto[i], { emitEvent: false });
      inputs[index + i].value = texto[i];
    }

    if (this.codigoInvalido) this.codigoInvalido = false;

    const ultimoIndex = Math.min(index + texto.length, 7);
    void inputs[ultimoIndex]?.setFocus();
  }

  onCodigoKeydown(event: KeyboardEvent, index: number): void {
    if (event.key === 'Backspace') {
      const controlName = `c${index + 1}`;
      const valor = this.codigoForm.controls[controlName].value as string;
      if (!valor && index > 0) {
        const inputs = this.codigoInputs.toArray();
        void inputs[index - 1]?.setFocus();
      }
    }
  }

  get claveValue(): string {
    return (this.nuevaClave?.get('clave')?.value as string) ?? '';
  }

  get reglaMinLength(): boolean { return this.claveValue.length >= 8; }
  get reglaMayuscula(): boolean { return /[A-Z]/.test(this.claveValue); }
  get reglaMinuscula(): boolean { return /[a-z]/.test(this.claveValue); }
  get reglaNumero(): boolean { return /\d/.test(this.claveValue); }
  get reglaEspecial(): boolean { return /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(this.claveValue); }

  private validarComplejidad(): ValidatorFn {
    return (control: AbstractControl): ValidationErrors | null => {
      const val = control.value as string;
      if (!val) return null;
      const errors: Record<string, boolean> = {};
      if (!/[A-Z]/.test(val)) errors['sinMayuscula'] = true;
      if (!/[a-z]/.test(val)) errors['sinMinuscula'] = true;
      if (!/\d/.test(val)) errors['sinNumero'] = true;
      if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(val)) errors['sinEspecial'] = true;
      return Object.keys(errors).length ? errors : null;
    };
  }

  private validadorClaveIgual(): ValidatorFn {
    return (group: AbstractControl): ValidationErrors | null => {
      const clave = group.get('clave')?.value as string;
      const confirmar = group.get('confirmarClave')?.value as string;
      if (!clave || !confirmar) return null;
      return clave === confirmar ? null : { clavesNoCoinciden: true };
    };
  }

  private async showError(titulo: string, mensaje: string): Promise<void> {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: '',
        tipemodal: 'error',
        title: titulo,
        message: mensaje,
        btnOkTxt: 'Aceptar',
        mostrarCancelar: false
      }
    });
    await modal.present();
  }
}
