import { Component, OnInit, AfterViewInit, OnDestroy, NgZone, inject, HostBinding } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NavigationEnd, Router } from '@angular/router';
import { filter } from 'rxjs';
import { ViewWillEnter } from '@ionic/angular';
import { AuthService } from '../../services/auth.service';
import { PostAuthIntentService } from '../../../admin/services/post-auth-intent.service';
import { ErpLayoutService } from '../../../erp/services/erp-layout.service';
import { CryptoService } from '@core/services/crypto.service';
import { ConfigService } from '../../../services/config.service';

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

  @HostBinding('class.sigre-auth-page') readonly authPageClass = true;

  vistaVerif = false;
  mostrarClave = false;
  isLoading = false;
  errorMessage = '';
  turnstileToken: string | null = null;
  turnstileError = false;
  turnstileEnabled = false;
  turnstileSiteKey = '';
  private turnstileWidgetId: string | null = null;

  private readonly zone = inject(NgZone);
  private readonly fb = inject(FormBuilder);
  private readonly authService = inject(AuthService);
  private readonly cryptoService = inject(CryptoService);
  private readonly configService = inject(ConfigService);
  private readonly router = inject(Router);
  private readonly postAuthIntent = inject(PostAuthIntentService);
  private readonly erpLayout = inject(ErpLayoutService);

  private static readonly REMEMBER_LOGIN_COOKIE = 'sigre_erp_remember_login';
  private static readonly REMEMBER_LOGIN_DAYS = 30;

  loginForm!: FormGroup;

  private ipAddress = '';
  private ipPrivada = '';

  ngOnInit(): void {
    document.body.classList.add('sigre-auth-body');
    this.authService.purgeSessionLocal();
    this.erpLayout.seleccionarModulo(null);
    this.initializeForm();
    this.cargarCredencialesRecordadas();
    this.suscribirRecargaCredencialesAlVolverALogin();
    this.obtenerIpPublica();
    void this.configService.waitForConfig().then(() => {
      this.turnstileEnabled = this.configService.isTurnstileEnabled();
      this.turnstileSiteKey = this.configService.getTurnstileSiteKey();
      if (this.turnstileEnabled) {
        this.renderTurnstile();
      }
    });
  }

  ngAfterViewInit(): void {
    if (this.configService.isConfigLoaded() && this.configService.isTurnstileEnabled()) {
      this.turnstileEnabled = true;
      this.turnstileSiteKey = this.configService.getTurnstileSiteKey();
      this.renderTurnstile();
    }
  }

  ngOnDestroy(): void {
    document.body.classList.remove('sigre-auth-body');
    this.removeTurnstile();
  }

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
      usuario: ['', [Validators.required, Validators.minLength(2)]],
      clave: ['', [Validators.required, Validators.minLength(1)]],
      recordar: [false],
    });
  }

  private obtenerIpPublica(): void {
    fetch('https://api.ipify.org?format=json')
      .then(r => r.json())
      .then((data: { ip: string }) => { this.ipAddress = data.ip; })
      .catch(() => { this.ipAddress = 'unknown'; });
  }

  toggleClave(): void {
    this.mostrarClave = !this.mostrarClave;
  }

  cambioVistaVerif(): void {
    this.errorMessage = '';
    this.vistaVerif = !this.vistaVerif;
  }

  campoInvalido(nombre: string): boolean {
    const control = this.loginForm.get(nombre);
    return !!(control && control.invalid && (control.dirty || control.touched));
  }

  private renderTurnstile(): void {
    if (!this.turnstileEnabled || !this.turnstileSiteKey) {
      return;
    }
    const tryRender = () => {
      const container = document.getElementById('cf-turnstile-container');
      if (!container || !window.turnstile) {
        setTimeout(tryRender, 200);
        return;
      }
      if (this.turnstileWidgetId) {
        return;
      }
      this.turnstileWidgetId = window.turnstile.render(container, {
        sitekey: this.turnstileSiteKey,
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

  onSubmit(): void {
    this.errorMessage = '';

    if (this.turnstileEnabled && !this.turnstileToken) {
      this.turnstileError = true;
      return;
    }

    if (this.loginForm.invalid) {
      this.loginForm.markAllAsTouched();
      return;
    }

    this.isLoading = true;
    const { usuario, clave, recordar } = this.loginForm.getRawValue();
    const browser = navigator.userAgent;
    const sistemaOperativo = this.detectarSO();

    this.postAuthIntent.markDefault();

    this.authService.signIn(
      usuario, clave, this.ipAddress, browser, sistemaOperativo, this.ipPrivada, this.turnstileToken ?? undefined
    )
      .subscribe({
        next: (response) => {
          if (!response.success) {
            this.isLoading = false;
            this.errorMessage = response.message ?? 'No se pudo iniciar sesión.';
            return;
          }

          this.gestionarGuardadoCredenciales(!!recordar, usuario, clave);
          this.isLoading = false;
          this.loginForm.reset();
          void this.router.navigateByUrl('/auth/seleccion-razon-social');
        },
        error: (err) => {
          this.isLoading = false;
          this.resetTurnstile();
          this.errorMessage = this.mensajeErrorLogin(err);
        }
      });
  }

  private mensajeErrorLogin(err: { status?: number; error?: { message?: string; errorCode?: string } }): string {
    const code = err?.error?.errorCode ?? '';
    const msg = err?.error?.message ?? '';

    if (code === 'TURNSTILE_REQUERIDO' || code === 'TURNSTILE_INVALIDO' || code === 'TURNSTILE_ERROR') {
      return msg || 'Complete la verificación de seguridad e intente de nuevo.';
    }
    if (code === 'USUARIO_BLOQUEADO' || err?.status === 403) {
      return msg || 'Usuario bloqueado por intentos fallidos. Espere 24 horas o contacte al administrador.';
    }
    if (code === 'CREDENCIALES_INVALIDAS' || err?.status === 401) {
      return msg || 'Usuario o contraseña incorrectos.';
    }
    return msg || 'Error de autenticación. Verifique usuario y contraseña.';
  }

  private cargarCredencialesRecordadas(): void {
    if (!this.loginForm) {
      this.initializeForm();
    }

    const rememberedRaw = this.getCookie(SignInComponent.REMEMBER_LOGIN_COOKIE)
      ?? this.getCookie('rpe_remember_login');
    if (!rememberedRaw) {
      this.loginForm.patchValue({
        usuario: '',
        clave: '',
        recordar: false,
      });
      return;
    }

    try {
      const remembered = JSON.parse(rememberedRaw) as { usuario: string; password?: string; clave?: string };
      const encrypted = remembered.password ?? remembered.clave ?? '';
      const decryptedPassword = this.cryptoService.decrypt(encrypted);

      this.loginForm.patchValue({
        usuario: remembered.usuario ?? '',
        clave: decryptedPassword ?? '',
        recordar: true,
      });
    } catch {
      this.deleteCookie(SignInComponent.REMEMBER_LOGIN_COOKIE);
      this.deleteCookie('rpe_remember_login');
    }
  }

  private gestionarGuardadoCredenciales(guardar: boolean, usuario: string, passwordPlano: string): void {
    if (!guardar) {
      this.deleteCookie(SignInComponent.REMEMBER_LOGIN_COOKIE);
      this.deleteCookie('rpe_remember_login');
      return;
    }

    const payload = {
      usuario,
      clave: this.cryptoService.encrypt(passwordPlano),
    };

    this.setCookie(
      SignInComponent.REMEMBER_LOGIN_COOKIE,
      JSON.stringify(payload),
      SignInComponent.REMEMBER_LOGIN_DAYS
    );
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
}
