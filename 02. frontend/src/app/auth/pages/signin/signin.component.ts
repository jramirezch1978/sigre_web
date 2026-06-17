import { Component, OnInit, AfterViewInit, OnDestroy, NgZone, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, NavigationEnd, Router } from '@angular/router';
import { Observable, filter } from 'rxjs';
import { AuthService } from '../../services/auth.service';
import { PostAuthIntentService } from '../../../admin/services/post-auth-intent.service';
import { ModalController, ViewWillEnter } from '@ionic/angular';
import { ModalConfirmationComponent } from '@ui/modal-confirmation/modal-confirmation.component';
import { CryptoService } from '@core/services/crypto.service';
import { environment } from '../../../../environments/environment';

declare global {
  interface Window {
    turnstile?: {
      render: (container: string | HTMLElement, options: Record<string, unknown>) => string;
      reset: (widgetId: string) => void;
      remove: (widgetId: string) => void;
    };
  }
}

@Component({
  selector: 'app-signin',
  templateUrl: './signin.component.html',
  styleUrls: ['./signin.component.scss'],
  standalone: false
})
export class SignInComponent implements OnInit, AfterViewInit, OnDestroy, ViewWillEnter {

  vistaVerif = false;
  mostrar = false;
  isLoading = false;
  turnstileToken: string | null = null;
  turnstileError = false;
  private turnstileWidgetId: string | null = null;
  private readonly zone = inject(NgZone);

  private readonly fb = inject(FormBuilder);
  private readonly authService = inject(AuthService);
  private readonly cryptoService = inject(CryptoService);
  private readonly router = inject(Router);
  private readonly route = inject(ActivatedRoute);
  private readonly postAuthIntent = inject(PostAuthIntentService);
  private readonly modalController = inject(ModalController);
  private static readonly REMEMBER_LOGIN_COOKIE = 'rpe_remember_login';
  private static readonly REMEMBER_LOGIN_DAYS = 30;

  public loginForm!: FormGroup;
  public readonly loginLoading$: Observable<boolean> = this.authService.loginLoading$;
  public readonly loginError$: Observable<boolean> = this.authService.loginError$;
  public APP_VERSION = '1.0.0';

  private ipAddress = '';
  private ipPrivada = '';

  ngOnInit(): void {
    this.initializeForm();
    this.cargarCredencialesRecordadas();
    this.suscribirRecargaCredencialesAlVolverALogin();
    this.obtenerIpPublica();
  }

  ngAfterViewInit(): void {
    this.renderTurnstile();
  }

  ngOnDestroy(): void {
    this.removeTurnstile();
  }

  /**
   * Con IonicRouteStrategy la vista de login puede reutilizarse desde caché;
   * al volver tras cerrar sesión, ngOnInit no se ejecuta de nuevo.
   * Aquí sí se vuelve a entrar y se reaplican credenciales guardadas.
   */
  ionViewWillEnter(): void {
    this.cargarCredencialesRecordadas();
  }

  private suscribirRecargaCredencialesAlVolverALogin(): void {
    this.router.events
      .pipe(filter((event): event is NavigationEnd => event instanceof NavigationEnd))
      .subscribe(event => {
        if (event.urlAfterRedirects.startsWith('/auth/signin')) {
          this.cargarCredencialesRecordadas();
        }
      });
  }

  private initializeForm(): void {
    this.loginForm = this.fb.group({
      usuario_nombre: ['', [Validators.required, Validators.minLength(2)]],
      usuario_clave: ['', [Validators.required, Validators.minLength(1)]],
      guardar_datos: [false]
    });
  }

  private obtenerIpPublica(): void {
    fetch('https://api.ipify.org?format=json')
      .then(r => r.json())
      .then((data: { ip: string }) => this.ipAddress = data.ip)
      .catch(() => this.ipAddress = 'unknown');
  }

  mostrarOcultar(event?: Event) {
    event?.preventDefault();
    event?.stopPropagation();
    this.mostrar = !this.mostrar;
  }

  cambioVistaVerif() {
    this.vistaVerif = !this.vistaVerif;
  }

  private renderTurnstile(): void {
    const tryRender = () => {
      const container = document.getElementById('cf-turnstile-container');
      if (!container || !window.turnstile) {
        setTimeout(tryRender, 200);
        return;
      }
      this.turnstileWidgetId = window.turnstile.render(container, {
        sitekey: environment.turnstileSiteKey,
        theme: 'light',
        callback: (token: string) => {
          this.zone.run(() => {
            this.turnstileToken = token;
            this.turnstileError = false;
          });
        },
        'expired-callback': () => {
          this.zone.run(() => { this.turnstileToken = null; });
        },
        'error-callback': () => {
          this.zone.run(() => { this.turnstileToken = null; });
        },
      });
    };
    tryRender();
  }

  private removeTurnstile(): void {
    if (this.turnstileWidgetId && window.turnstile) {
      window.turnstile.remove(this.turnstileWidgetId);
      this.turnstileWidgetId = null;
    }
  }

  private resetTurnstile(): void {
    if (this.turnstileWidgetId && window.turnstile) {
      window.turnstile.reset(this.turnstileWidgetId);
    }
    this.turnstileToken = null;
  }

  public onSubmit(): void {
    if (!this.turnstileToken) {
      this.turnstileError = true;
      return;
    }

    if (!this.loginForm.valid) {
      this.markFormGroupTouched();
      return;
    }

    this.isLoading = true;
    const raw = this.loginForm.getRawValue();
    const email = raw.usuario_nombre ?? '';
    const password = raw.usuario_clave ?? '';
    const guardarDatos = !!raw.guardar_datos;
    const browser = navigator.userAgent;
    const sistemaOperativo = this.detectarSO();

    this.authService.signIn(email, password, this.ipAddress, browser, sistemaOperativo, this.ipPrivada)
      .subscribe({
        next: (response) => {
          if (!response.success) {
            this.isLoading = false;
            return;
          }

          this.gestionarGuardadoCredenciales(guardarDatos, email, password);
          const returnUrl = this.route.snapshot.queryParamMap.get('returnUrl') ?? '';
          const esLoginAdministracion = returnUrl.startsWith('/admin');

          if (esLoginAdministracion) {
            this.postAuthIntent.markAdmin();
            if (response.data?.adminSistema !== true) {
              void this.accesoAdminDenegadoTrasLogin();
              return;
            }

            this.authService
              .completarContextoConPrimeraEmpresaYSucursal(
                this.ipAddress,
                browser,
                sistemaOperativo,
                this.ipPrivada
              )
              .subscribe({
                next: (sel) => {
                  this.isLoading = false;
                  if (sel.success && sel.data) {
                    const dest = this.postAuthIntent.consumeHomeRoute();
                    void this.router.navigateByUrl(dest);
                  } else {
                    void this.autoContextoAdminFallido(sel.message ?? 'No se pudo completar el acceso.');
                  }
                  this.loginForm.reset();
                },
                error: (err: unknown) => {
                  this.isLoading = false;
                  const msg =
                    err instanceof Error
                      ? err.message
                      : 'No se pudo preparar el acceso al panel de administración.';
                  void this.autoContextoAdminFallido(msg);
                  this.loginForm.reset();
                }
              });
            return;
          }

          this.postAuthIntent.markDefault();
          this.isLoading = false;
          this.router.navigate(['/auth/seleccion-razon-social']);
          this.loginForm.reset();
        },
        error: (err) => {
          this.isLoading = false;
          this.resetTurnstile();
          const errorBody = err.error;
          const message = errorBody?.message ?? 'Error al iniciar sesión';
          const errorCode = errorBody?.errorCode ?? '';
          this.showErrorModal(message, errorCode);
        }
      });

  }

  private cargarCredencialesRecordadas(): void {
    if (!this.loginForm) {
      this.initializeForm();
    }

    const rememberedRaw = this.getCookie(SignInComponent.REMEMBER_LOGIN_COOKIE);
    if (!rememberedRaw) {
      this.loginForm.patchValue({
        usuario_nombre: '',
        usuario_clave: '',
        guardar_datos: false
      });
      return;
    }

    try {
      const remembered = JSON.parse(rememberedRaw) as { usuario: string; password: string };
      const decryptedPassword = this.cryptoService.decrypt(remembered.password);

      this.loginForm.patchValue({
        usuario_nombre: remembered.usuario ?? '',
        usuario_clave: decryptedPassword ?? '',
        guardar_datos: true
      });
    } catch {
      this.deleteCookie(SignInComponent.REMEMBER_LOGIN_COOKIE);
    }
  }

  private gestionarGuardadoCredenciales(guardar: boolean, usuario: string, passwordPlano: string): void {
    if (!guardar) {
      this.deleteCookie(SignInComponent.REMEMBER_LOGIN_COOKIE);
      return;
    }

    const payload = {
      usuario,
      password: this.cryptoService.encrypt(passwordPlano)
    };

    this.setCookie(
      SignInComponent.REMEMBER_LOGIN_COOKIE,
      JSON.stringify(payload),
      SignInComponent.REMEMBER_LOGIN_DAYS
    );
  }

  private getCookie(name: string): string | null {
    const encodedName = encodeURIComponent(name) + '=';
    const entries = document.cookie ? document.cookie.split('; ') : [];
    for (const entry of entries) {
      if (entry.startsWith(encodedName)) {
        return decodeURIComponent(entry.substring(encodedName.length));
      }
    }
    return null;
  }

  private setCookie(name: string, value: string, days: number): void {
    const maxAge = Math.max(1, Math.floor(days * 24 * 60 * 60));
    const secure = window.location.protocol === 'https:' ? '; Secure' : '';
    document.cookie = `${encodeURIComponent(name)}=${encodeURIComponent(value)}; Path=/; Max-Age=${maxAge}; SameSite=Lax${secure}`;
  }

  private deleteCookie(name: string): void {
    document.cookie = `${encodeURIComponent(name)}=; Path=/; Max-Age=0; SameSite=Lax`;
  }

  public onGuardarDatosIonChange(event: Event): void {
    const checked = (event as CustomEvent<{ checked: boolean }>).detail?.checked ?? false;
    this.loginForm.patchValue({ guardar_datos: checked }, { emitEvent: true });
  }

  private async accesoAdminDenegadoTrasLogin(): Promise<void> {
    this.isLoading = false;
    this.postAuthIntent.markDefault();
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: '',
        tipemodal: 'error',
        title: 'Acceso denegado',
        message:
          'No tiene permisos de administrador de sistema. Solo los usuarios autorizados pueden acceder al panel de administración.',
        btnOkTxt: 'Aceptar',
        mostrarCancelar: false
      }
    });
    await modal.present();
    await modal.onDidDismiss();
    this.loginForm.reset();
    await this.authService.signOut({ returnUrl: '/admin' });
  }

  private async autoContextoAdminFallido(mensaje: string): Promise<void> {
    this.postAuthIntent.markDefault();
    await this.showErrorModal(mensaje, '');
    await this.authService.signOut({ returnUrl: '/admin' });
  }

  private detectarSO(): string {
    const ua = navigator.userAgent;
    if (ua.includes('Windows NT 10')) return 'Windows 10/11';
    if (ua.includes('Windows NT 6.3')) return 'Windows 8.1';
    if (ua.includes('Windows NT 6.2')) return 'Windows 8';
    if (ua.includes('Mac OS X')) return 'macOS';
    if (ua.includes('Linux')) return 'Linux';
    if (ua.includes('Android')) return 'Android';
    if (ua.includes('iPhone') || ua.includes('iPad')) return 'iOS';
    return 'Desconocido';
  }

  private async showErrorModal(message: string, errorCode: string): Promise<void> {
    const titulo = errorCode === 'USUARIO_BLOQUEADO'
      ? 'Cuenta bloqueada'
      : 'Error de autenticación';

    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: '',
        tipemodal: 'error',
        title: titulo,
        message: message,
        btnOkTxt: 'Aceptar',
        mostrarCancelar: false
      }
    });
    await modal.present();
    await modal.onDidDismiss();
  }

  private markFormGroupTouched(): void {
    Object.keys(this.loginForm.controls).forEach(key => {
      const control = this.loginForm.get(key);
      control?.markAsTouched();
    });
  }

  public isFieldInvalid(fieldName: string): boolean {
    const field = this.loginForm.get(fieldName);
    return !!(field && field.invalid && (field.dirty || field.touched));
  }

  public getFieldError(fieldName: string): string {
    const field = this.loginForm.get(fieldName);
    if (field?.errors) {
      if (field.errors['required']) return `El campo es requerido`;
      if (field.errors['minlength']) return `Mínimo ${field.errors['minlength'].requiredLength} caracteres`;
    }
    return '';
  }
}
