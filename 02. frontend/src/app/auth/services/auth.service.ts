import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';
import { BehaviorSubject, Observable, tap, catchError, throwError, firstValueFrom, switchMap, map } from 'rxjs';
import { ApiBaseService } from '../../services/api-base.service';
import { StorageService } from '../../core/services/storage.service';
import { SessionIdleService } from '../../core/services/session-idle.service';
import { CryptoService } from '../../core/services/crypto.service';
import { SanitizerService } from '../../core/services/sanitizer.service';
import { UtilityService } from '../../services/utility.service';
import { PostAuthIntentService } from '../../admin/services/post-auth-intent.service';

export interface LoginApiResponse {
  success: boolean;
  message: string;
  errorCode?: string;
  data?: LoginData;
}

export interface LoginData {
  accessToken: string;
  refreshToken?: string;
  tokenType: string;
  expiresInSeconds: number;
  temporal: boolean;
  userId: number;
  email: string;
  username: string;
  nombres: string;
  apellidos: string;
  nombreCompleto: string;
  /** Coincide con auth.usuario.flag_admin_sistema = '1'. */
  adminSistema?: boolean;
  empresaId?: number;
  empresaCodigo?: string;
  empresaNombre?: string;
  empresaRuc?: string;
  sucursalId?: number;
  sucursalNombre?: string;
}

export interface EmpresaUsuario {
  empresaId: number;
  codigo: string;
  razonSocial: string;
  ruc: string;
  dbName: string;
}

export interface EmpresasApiResponse {
  success: boolean;
  message: string;
  errorCode?: string;
  data?: EmpresaUsuario[];
}

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  private readonly http = inject(HttpClient);
  private readonly router = inject(Router);
  private readonly storage = inject(StorageService);
  private readonly crypto = inject(CryptoService);
  private readonly sanitizer = inject(SanitizerService);
  private readonly utilityService = inject(UtilityService);
  private readonly sessionIdle = inject(SessionIdleService);
  private readonly postAuthIntent = inject(PostAuthIntentService);

  private readonly apiBase = inject(ApiBaseService);

  private get baseUrl(): string {
    return this.apiBase.getApiBaseUrl();
  }

  private loginLoadingSubject = new BehaviorSubject<boolean>(false);
  private loginErrorSubject = new BehaviorSubject<boolean>(false);

  public readonly loginLoading$ = this.loginLoadingSubject.asObservable();
  public readonly loginError$ = this.loginErrorSubject.asObservable();

  signIn(email: string, password: string, ipAddress: string,
         browser: string, sistemaOperativo: string, ipPrivada?: string,
         turnstileToken?: string): Observable<LoginApiResponse> {

    this.loginLoadingSubject.next(true);
    this.loginErrorSubject.next(false);

    const cleanEmail = this.sanitizer.sanitize(email);
    const encryptedPassword = this.crypto.encrypt(password);
    const passwordHash = this.crypto.hash(password);

    const body: Record<string, string> = {
      email: cleanEmail,
      password: encryptedPassword,
      passwordHash,
      ipAddress: this.sanitizer.sanitize(ipAddress),
      ipPrivada: this.sanitizer.sanitize(ipPrivada ?? ''),
      browser,
      sistemaOperativo: this.sanitizer.sanitize(sistemaOperativo)
    };
    if (turnstileToken) {
      body['turnstileToken'] = turnstileToken;
    }

    return this.http.post<LoginApiResponse>(`${this.baseUrl}/auth/login`, body).pipe(
      tap(response => {
        this.loginLoadingSubject.next(false);
        this.sessionIdle.stop();
        if (response.success && response.data) {
          this.storage.setToken(response.data.accessToken);
          if (response.data.refreshToken) {
            this.storage.setRefreshToken(response.data.refreshToken);
          }
          this.storage.setUser(response.data);
        }
      }),
      catchError(err => {
        this.loginLoadingSubject.next(false);
        this.loginErrorSubject.next(true);
        return throwError(() => err);
      })
    );
  }

  listarEmpresas(): Observable<EmpresasApiResponse> {
    return this.http.get<EmpresasApiResponse>(`${this.baseUrl}/auth/empresas`, {
      headers: this.authHeaders()
    });
  }

  seleccionarEmpresa(empresaId: number, ipAddress: string, browser: string,
                     sistemaOperativo: string, sucursalId?: number, ipPrivada?: string): Observable<LoginApiResponse> {

    const body: Record<string, any> = {
      empresaId,
      ipAddress,
      ipPrivada: ipPrivada ?? '',
      browser,
      sistemaOperativo
    };
    if (sucursalId) {
      body['sucursalId'] = sucursalId;
    }

    return this.http.post<LoginApiResponse>(`${this.baseUrl}/auth/seleccionar-empresa`, body, {
      headers: this.authHeaders()
    }).pipe(
      tap(response => {
        if (response.success && response.data) {
          this.storage.setToken(response.data.accessToken);
          if (response.data.refreshToken) {
            this.storage.setRefreshToken(response.data.refreshToken);
          }
          this.storage.setUser(response.data);
          if (response.data.temporal === false) {
            this.sessionIdle.start();
          } else {
            this.sessionIdle.stop();
          }
        }
      })
    );
  }

  /**
   * Renueva el access token usando el refresh token guardado.
   * Devuelve el nuevo access token o lanza error si no se pudo renovar.
   */
  refreshAccessToken(): Observable<string> {
    const refreshToken = this.storage.getRefreshToken();
    if (!refreshToken) {
      return throwError(() => new Error('NO_REFRESH_TOKEN'));
    }

    return this.http
      .post<LoginApiResponse>(`${this.baseUrl}/auth/refresh`, { refreshToken })
      .pipe(
        map(response => {
          if (!response.success || !response.data?.accessToken) {
            throw new Error('REFRESH_FAILED');
          }
          this.storage.setToken(response.data.accessToken);
          if (response.data.refreshToken) {
            this.storage.setRefreshToken(response.data.refreshToken);
          }
          return response.data.accessToken;
        })
      );
  }

  /**
   * Tras login con token temporal: toma la primera empresa y primera sucursal asignadas
   * y obtiene JWT definitivo. Usado en flujo /admin sin pantalla de selección.
   */
  completarContextoConPrimeraEmpresaYSucursal(
    ipAddress: string,
    browser: string,
    sistemaOperativo: string,
    ipPrivada?: string
  ): Observable<LoginApiResponse> {
    return this.listarEmpresas().pipe(
      switchMap(res => {
        if (!res.success || !res.data?.length) {
          return throwError(
            () => new Error('No tiene empresas asignadas. Contacte al administrador del sistema.')
          );
        }
        const empresa = res.data[0];
        return this.listarSucursales(empresa.empresaId).pipe(
          map((sucRes: { success?: boolean; data?: unknown[]; message?: string }) => ({
            empresa,
            sucRes
          }))
        );
      }),
      switchMap(({ empresa, sucRes }) => {
        if (!sucRes.success || !Array.isArray(sucRes.data) || sucRes.data.length === 0) {
          const msg =
            sucRes.message ??
            'No tiene sucursales asignadas para la empresa. Contacte al administrador del sistema.';
          return throwError(() => new Error(msg));
        }
        const sucursal = sucRes.data[0] as { id: number };
        return this.seleccionarEmpresa(
          empresa.empresaId,
          ipAddress,
          browser,
          sistemaOperativo,
          sucursal.id,
          ipPrivada
        );
      })
    );
  }

  /** Sucursales asignadas al usuario para la empresa (ms-core-maestros). */
  listarSucursales(empresaId: number): Observable<any> {
    return this.http.get(`${this.baseUrl}/core/empresas/${empresaId}/sucursales/mias`, {
      headers: this.authHeaders()
    });
  }

  obtenerEmailOfuscado(username: string): Observable<any> {
    return this.http.post(`${this.baseUrl}/auth/recuperar/obtener-email-ofuscado`, { username });
  }

  verificarEmail(email: string): Observable<any> {
    return this.http.post(`${this.baseUrl}/auth/recuperar/verificar-email`, { email });
  }

  enviarCodigo(email: string): Observable<any> {
    return this.http.post(`${this.baseUrl}/auth/recuperar/enviar-codigo`, { email });
  }

  validarCodigo(email: string, codigo: string): Observable<any> {
    return this.http.post(`${this.baseUrl}/auth/recuperar/validar-codigo`, { email, codigo });
  }

  cambiarPassword(email: string, codigo: string, nuevaPassword: string): Observable<any> {
    const encryptedPassword = this.crypto.encrypt(nuevaPassword);
    const nuevaPasswordHash = this.crypto.hash(nuevaPassword);
    return this.http.post(`${this.baseUrl}/auth/recuperar/cambiar-password`, {
      email,
      codigo,
      nuevaPassword: encryptedPassword,
      nuevaPasswordHash
    });
  }

  limpiarCodigosExpirados(): Observable<any> {
    return this.http.post(`${this.baseUrl}/auth/recuperar/limpiar-expirados`, {});
  }

  isAuthenticated(): boolean {
    return this.storage.isAuthenticated();
  }

  getAuthToken(): string | null {
    return this.storage.getToken();
  }

  /** Limpia tokens y estado local de inmediato (sin esperar al servidor). */
  purgeSessionLocal(): void {
    this.sessionIdle.stop();
    this.loginLoadingSubject.next(false);
    this.loginErrorSubject.next(false);
    this.postAuthIntent.markDefault();
    this.utilityService.signOut();
    this.storage.purgeAuthState();
  }

  /** Cierra sesión local y en servidor sin redirigir (p. ej. antes de mostrar el login). */
  async invalidateSession(): Promise<void> {
    const token = this.storage.getToken() ?? this.storage.getAccessTokenRaw();
    this.purgeSessionLocal();
    if (token) {
      try {
        await firstValueFrom(
          this.http.post(
            `${this.baseUrl}/auth/logout`,
            {},
            { headers: { Authorization: `Bearer ${token}` } }
          )
        );
      } catch {
        /* ignorar */
      }
    }
  }

  async signOut(options?: { returnUrl?: string; redirectTo?: string }): Promise<void> {
    await this.invalidateSession();

    const redirectTo = options?.redirectTo?.trim();
    if (redirectTo) {
      await this.router.navigateByUrl(redirectTo);
      return;
    }

    const returnUrl = options?.returnUrl?.trim();
    if (returnUrl?.startsWith('/admin')) {
      await this.router.navigateByUrl('/admin/login');
      return;
    }
    if (returnUrl) {
      await this.router.navigate(['/auth/signin'], { queryParams: { returnUrl } });
      return;
    }

    const loginUrl = this.router.url.startsWith('/admin') ? '/admin/login' : '/auth/signin';
    await this.router.navigateByUrl(loginUrl);
  }

  private authHeaders(): HttpHeaders {
    const token = this.storage.getToken();
    return new HttpHeaders({
      Authorization: `Bearer ${token}`
    });
  }
}
