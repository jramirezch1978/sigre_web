import {
  Component,
  EventEmitter,
  OnDestroy,
  OnInit,
  Output,
  QueryList,
  ViewChildren,
  ElementRef,
  inject,
} from '@angular/core';
import { AbstractControl, FormBuilder, FormGroup, ValidationErrors, ValidatorFn, Validators } from '@angular/forms';
import { AuthService } from '../../../auth/services/auth.service';

@Component({
  selector: 'app-admin-password-recovery',
  templateUrl: './admin-password-recovery.component.html',
  styleUrls: ['./admin-password-recovery.component.scss'],
  standalone: false,
})
export class AdminPasswordRecoveryComponent implements OnInit, OnDestroy {

  @Output() volverLogin = new EventEmitter<void>();
  @ViewChildren('codigoInput') codigoInputs!: QueryList<ElementRef<HTMLInputElement>>;

  paso = 1;
  mostrarClave = false;
  mostrarConfirmar = false;
  emailOculto = '';
  emailCompleto = '';
  usernameIngresado = '';
  /** false cuando el paso 1 fue un correo: no se muestra confirmación de email. */
  confirmacionEmailRequerida = true;
  contador = 300;
  timerActivo = false;
  codigoInvalido = false;
  isLoading = false;
  errorMessage = '';
  successMessage = '';

  usernameForm!: FormGroup;
  validarEmailForm!: FormGroup;
  codigoForm!: FormGroup;
  nuevaClaveForm!: FormGroup;

  private timerRef: ReturnType<typeof setInterval> | null = null;
  private readonly fb = inject(FormBuilder);
  private readonly authService = inject(AuthService);

  ngOnInit(): void {
    this.usernameForm = this.fb.group({
      username: ['', [Validators.required, Validators.maxLength(80)]],
    });
    this.validarEmailForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
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
    this.nuevaClaveForm = this.fb.group(
      {
        clave: ['', [Validators.required, Validators.minLength(8), this.validarComplejidad()]],
        confirmarClave: ['', [Validators.required, Validators.minLength(8)]],
      },
      { validators: this.validadorClaveIgual() }
    );
  }

  ngOnDestroy(): void {
    this.detenerContador();
  }

  get tituloActual(): string {
    return this.paso === 4 ? 'Nueva contraseña' : 'Recuperar contraseña';
  }

  regresar(): void {
    this.limpiarMensajes();
    if (this.paso === 3 && !this.confirmacionEmailRequerida) {
      this.paso = 1;
      this.detenerContador();
      return;
    }
    if (this.paso > 1) {
      this.paso--;
      if (this.paso !== 3) {
        this.detenerContador();
      }
    } else {
      this.volverLogin.emit();
    }
  }

  get contadorFormato(): string {
    const min = Math.floor(this.contador / 60);
    const seg = this.contador % 60;
    return `${min.toString().padStart(2, '0')}:${seg.toString().padStart(2, '0')}`;
  }

  continuarPaso1(): void {
    this.limpiarMensajes();
    this.usernameForm.markAllAsTouched();
    if (!this.usernameForm.valid) {
      return;
    }

    this.isLoading = true;
    const username = (this.usernameForm.value.username as string).trim();
    this.usernameIngresado = username;

    this.authService.obtenerEmailOfuscado(username).subscribe({
      next: (res) => {
        if (res.success && res.data?.emailOculto) {
          this.emailOculto = res.data.emailOculto;
          if (this.esCorreoElectronico(username)) {
            this.confirmacionEmailRequerida = false;
            this.emailCompleto = username;
            this.enviarCodigoYAvanzar();
          } else {
            this.confirmacionEmailRequerida = true;
            this.isLoading = false;
            this.paso = 2;
          }
        } else {
          this.isLoading = false;
        }
      },
      error: (err) => {
        this.isLoading = false;
        this.errorMessage = this.leerErrorApi(
          err,
          'No se encontró una cuenta con ese usuario o correo. Verifique e intente nuevamente.'
        );
      },
    });
  }

  continuarPaso2(): void {
    this.limpiarMensajes();
    this.validarEmailForm.markAllAsTouched();
    if (!this.validarEmailForm.valid) {
      return;
    }

    this.isLoading = true;
    this.emailCompleto = this.validarEmailForm.value.email as string;

    this.authService.verificarEmail(this.emailCompleto).subscribe({
      next: (res) => {
        if (res.success) {
          this.enviarCodigoYAvanzar();
        } else {
          this.isLoading = false;
        }
      },
      error: (err) => {
        this.isLoading = false;
        this.errorMessage = this.leerErrorApi(err, 'El correo ingresado no coincide con el registrado.');
      },
    });
  }

  continuarPaso3(): void {
    this.limpiarMensajes();
    const codigo = this.getCodigoCompleto();
    if (codigo.length !== 8) {
      this.codigoInvalido = true;
      this.errorMessage = 'Ingrese el código de 8 caracteres.';
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
      error: (err) => {
        this.isLoading = false;
        this.codigoInvalido = true;
        this.codigoForm.reset();
        this.focusCodigo(0);
        this.errorMessage = this.leerErrorApi(
          err,
          'El código no es válido o ha expirado. Solicite uno nuevo.'
        );
      },
    });
  }

  reenviarCodigo(): void {
    if (this.timerActivo) {
      return;
    }
    this.limpiarMensajes();
    this.codigoForm.reset();
    this.codigoInvalido = false;
    this.isLoading = true;

    this.authService.enviarCodigo(this.emailCompleto).subscribe({
      next: () => {
        this.isLoading = false;
        this.iniciarContador();
        this.successMessage = 'Código reenviado a su correo.';
      },
      error: (err) => {
        this.isLoading = false;
        this.errorMessage = this.leerErrorApi(err, 'No se pudo reenviar el código.');
      },
    });
  }

  cambiarPassword(): void {
    this.limpiarMensajes();
    this.nuevaClaveForm.markAllAsTouched();
    if (!this.nuevaClaveForm.valid) {
      return;
    }

    this.isLoading = true;
    const codigo = this.getCodigoCompleto();
    const nuevaPassword = this.nuevaClaveForm.value.clave as string;

    this.authService.cambiarPassword(this.emailCompleto, codigo, nuevaPassword).subscribe({
      next: () => {
        this.isLoading = false;
        this.successMessage = 'Contraseña restablecida correctamente. Redirigiendo al login…';
        setTimeout(() => this.volverLogin.emit(), 1200);
      },
      error: (err) => {
        this.isLoading = false;
        this.errorMessage = this.leerErrorApi(err, 'No se pudo cambiar la contraseña.');
      },
    });
  }

  onCodigoInput(event: Event, index: number): void {
    const target = event.target as HTMLInputElement;
    let valor = target.value.replace(/[^A-Za-z0-9]/g, '');
    if (valor.length > 1) {
      valor = valor.charAt(valor.length - 1);
    }

    const controlName = `c${index + 1}`;
    this.codigoForm.controls[controlName].setValue(valor, { emitEvent: false });
    target.value = valor;

    if (this.codigoInvalido && valor) {
      this.codigoInvalido = false;
    }

    if (valor.length === 1 && index < 7) {
      this.focusCodigo(index + 1);
    }
  }

  onCodigoPaste(event: ClipboardEvent, index: number): void {
    event.preventDefault();
    const texto = (event.clipboardData?.getData('text') ?? '').replace(/[^A-Za-z0-9]/g, '');
    if (!texto) {
      return;
    }

    for (let i = 0; i < texto.length && index + i < 8; i++) {
      const controlName = `c${index + i + 1}`;
      this.codigoForm.controls[controlName].setValue(texto[i], { emitEvent: false });
      const input = this.codigoInputs.get(index + i)?.nativeElement;
      if (input) {
        input.value = texto[i];
      }
    }

    if (this.codigoInvalido) {
      this.codigoInvalido = false;
    }
    this.focusCodigo(Math.min(index + texto.length, 7));
  }

  onCodigoKeydown(event: KeyboardEvent, index: number): void {
    if (event.key !== 'Backspace') {
      return;
    }
    const controlName = `c${index + 1}`;
    const valor = this.codigoForm.controls[controlName].value as string;
    if (!valor && index > 0) {
      this.focusCodigo(index - 1);
    }
  }

  campoInvalido(form: FormGroup, control: string): boolean {
    const campo = form.controls[control];
    return !!(campo && campo.invalid && (campo.dirty || campo.touched));
  }

  claveInvalida(campo: string): boolean {
    const control = this.nuevaClaveForm.get(campo);
    if (!control || !(control.dirty || control.touched)) {
      return false;
    }
    if (control.invalid) {
      return true;
    }
    return campo === 'confirmarClave' && !!this.nuevaClaveForm.errors?.['clavesNoCoinciden'];
  }

  get claveValue(): string {
    return (this.nuevaClaveForm.get('clave')?.value as string) ?? '';
  }

  get reglaMinLength(): boolean {
    return this.claveValue.length >= 8;
  }
  get reglaMayuscula(): boolean {
    return /[A-Z]/.test(this.claveValue);
  }
  get reglaMinuscula(): boolean {
    return /[a-z]/.test(this.claveValue);
  }
  get reglaNumero(): boolean {
    return /\d/.test(this.claveValue);
  }
  get reglaEspecial(): boolean {
    return /[!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]/.test(this.claveValue);
  }

  private enviarCodigoYAvanzar(): void {
    this.authService.enviarCodigo(this.emailCompleto).subscribe({
      next: () => {
        this.isLoading = false;
        this.paso = 3;
        this.iniciarContador();
        this.successMessage = 'Se envió un código a su correo (válido 5 minutos).';
      },
      error: (err) => {
        this.isLoading = false;
        this.errorMessage = this.leerErrorApi(err, 'No se pudo enviar el código por correo.');
      },
    });
  }

  private getCodigoCompleto(): string {
    return ['c1', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7', 'c8']
      .map((k) => (this.codigoForm.controls[k].value as string) ?? '')
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

  private focusCodigo(index: number): void {
    setTimeout(() => this.codigoInputs.get(index)?.nativeElement.focus(), 0);
  }

  private limpiarMensajes(): void {
    this.errorMessage = '';
    this.successMessage = '';
  }

  /** Igual que restpe: paso 2 solo si el paso 1 fue nombre de usuario, no correo. */
  private esCorreoElectronico(valor: string): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(valor.trim());
  }

  private leerErrorApi(
    err: { status?: number; error?: { message?: string; errorCode?: string } },
    fallback: string
  ): string {
    if (err?.status === 403) {
      return 'Acceso denegado al servicio de autenticación. Verifique la URL o contacte soporte.';
    }
    if (err?.status === 0 || err?.status === 502 || err?.status === 504) {
      return 'No se pudo contactar al servidor. Intente nuevamente en unos segundos.';
    }
    return err?.error?.message?.trim() || fallback;
  }

  private validarComplejidad(): ValidatorFn {
    return (control: AbstractControl): ValidationErrors | null => {
      const val = control.value as string;
      if (!val) {
        return null;
      }
      const errors: Record<string, boolean> = {};
      if (!/[A-Z]/.test(val)) errors['sinMayuscula'] = true;
      if (!/[a-z]/.test(val)) errors['sinMinuscula'] = true;
      if (!/\d/.test(val)) errors['sinNumero'] = true;
      if (!/[!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]/.test(val)) errors['sinEspecial'] = true;
      return Object.keys(errors).length ? errors : null;
    };
  }

  private validadorClaveIgual(): ValidatorFn {
    return (group: AbstractControl): ValidationErrors | null => {
      const clave = group.get('clave')?.value as string;
      const confirmar = group.get('confirmarClave')?.value as string;
      if (!clave || !confirmar) {
        return null;
      }
      return clave === confirmar ? null : { clavesNoCoinciden: true };
    };
  }
}
