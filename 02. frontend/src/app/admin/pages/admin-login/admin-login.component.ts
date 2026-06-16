import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../../auth/services/auth.service';
import { CryptoService } from '../../../core/services/crypto.service';
import { PostAuthIntentService } from '../../services/post-auth-intent.service';

@Component({
  selector: 'app-admin-login',
  templateUrl: './admin-login.component.html',
  styleUrls: ['./admin-login.component.scss'],
  standalone: false,
})
export class AdminLoginComponent implements OnInit {

  private static readonly REMEMBER_COOKIE = 'sigre_admin_remember_login';

  private readonly fb = inject(FormBuilder);
  private readonly authService = inject(AuthService);
  private readonly crypto = inject(CryptoService);
  private readonly router = inject(Router);
  private readonly postAuthIntent = inject(PostAuthIntentService);

  loginForm!: FormGroup;
  mostrarClave = false;
  vistaRecuperacion = false;
  isLoading = false;
  errorMessage = '';

  private ipAddress = 'unknown';
  private ipPrivada = '';

  ngOnInit(): void {
    this.loginForm = this.fb.group({
      usuario: ['', [Validators.required, Validators.minLength(2)]],
      clave: ['', [Validators.required]],
      recordar: [false],
    });
    this.cargarCredencialesRecordadas();
    this.obtenerIpPublica();
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

  mostrarRecuperacion(): void {
    this.errorMessage = '';
    this.vistaRecuperacion = true;
  }

  ocultarRecuperacion(): void {
    this.vistaRecuperacion = false;
  }

  onSubmit(): void {
    this.errorMessage = '';
    if (this.loginForm.invalid) {
      this.loginForm.markAllAsTouched();
      return;
    }

    this.isLoading = true;
    const { usuario, clave, recordar } = this.loginForm.getRawValue();
    const browser = navigator.userAgent;
    const so = this.detectarSO();

    this.postAuthIntent.markAdmin();

    this.authService.signIn(usuario, clave, this.ipAddress, browser, so, this.ipPrivada).subscribe({
      next: (response) => {
        if (!response.success) {
          this.isLoading = false;
          this.errorMessage = response.message ?? 'No se pudo iniciar sesión.';
          return;
        }

        if (response.data?.adminSistema !== true) {
          this.isLoading = false;
          this.errorMessage = 'No tiene permisos de administrador de sistema.';
          void this.authService.signOut();
          return;
        }

        this.gestionarRecordar(!!recordar, usuario, clave);

        this.authService
          .completarContextoConPrimeraEmpresaYSucursal(this.ipAddress, browser, so, this.ipPrivada)
          .subscribe({
            next: (sel) => {
              this.isLoading = false;
              if (sel.success && sel.data) {
                void this.router.navigateByUrl('/admin/inicio');
                this.loginForm.reset();
              } else {
                this.errorMessage = sel.message ?? 'No se pudo completar el acceso al panel.';
                void this.authService.signOut();
              }
            },
            error: (err: unknown) => {
              this.isLoading = false;
              this.errorMessage = err instanceof Error ? err.message : 'Error al preparar la sesión admin.';
              void this.authService.signOut();
            },
          });
      },
      error: (err) => {
        this.isLoading = false;
        this.errorMessage = this.mensajeErrorLogin(err);
      },
    });
  }

  private mensajeErrorLogin(err: { status?: number; error?: { message?: string; errorCode?: string } }): string {
    const code = err?.error?.errorCode ?? '';
    const msg = err?.error?.message ?? '';

    if (code === 'USUARIO_BLOQUEADO' || err?.status === 403) {
      return msg || 'Usuario bloqueado por intentos fallidos. Espere 24 horas o contacte al administrador.';
    }
    if (code === 'CREDENCIALES_INVALIDAS' || err?.status === 401) {
      return msg || 'Usuario o contraseña incorrectos.';
    }
    return msg || 'Error de autenticación. Verifique usuario y contraseña.';
  }

  campoInvalido(nombre: string): boolean {
    const c = this.loginForm.get(nombre);
    return !!(c && c.invalid && (c.dirty || c.touched));
  }

  private cargarCredencialesRecordadas(): void {
    const raw = this.getCookie(AdminLoginComponent.REMEMBER_COOKIE);
    if (!raw) {
      return;
    }
    try {
      const data = JSON.parse(raw) as { usuario: string; clave: string };
      this.loginForm.patchValue({
        usuario: data.usuario ?? '',
        clave: this.crypto.decrypt(data.clave) ?? '',
        recordar: true,
      });
    } catch {
      this.deleteCookie(AdminLoginComponent.REMEMBER_COOKIE);
    }
  }

  private gestionarRecordar(guardar: boolean, usuario: string, clave: string): void {
    if (!guardar) {
      this.deleteCookie(AdminLoginComponent.REMEMBER_COOKIE);
      return;
    }
    this.setCookie(
      AdminLoginComponent.REMEMBER_COOKIE,
      JSON.stringify({ usuario, clave: this.crypto.encrypt(clave) }),
      30
    );
  }

  private detectarSO(): string {
    const ua = navigator.userAgent;
    if (ua.includes('Windows')) return 'Windows';
    if (ua.includes('Mac OS')) return 'macOS';
    if (ua.includes('Linux')) return 'Linux';
    if (ua.includes('Android')) return 'Android';
    if (ua.includes('iPhone') || ua.includes('iPad')) return 'iOS';
    return 'Desconocido';
  }

  private getCookie(name: string): string | null {
    const prefix = encodeURIComponent(name) + '=';
    for (const entry of document.cookie.split('; ')) {
      if (entry.startsWith(prefix)) {
        return decodeURIComponent(entry.substring(prefix.length));
      }
    }
    return null;
  }

  private setCookie(name: string, value: string, days: number): void {
    const maxAge = Math.floor(days * 86400);
    const secure = location.protocol === 'https:' ? '; Secure' : '';
    document.cookie = `${encodeURIComponent(name)}=${encodeURIComponent(value)}; Path=/; Max-Age=${maxAge}; SameSite=Lax${secure}`;
  }

  private deleteCookie(name: string): void {
    document.cookie = `${encodeURIComponent(name)}=; Path=/; Max-Age=0; SameSite=Lax`;
  }
}
