import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface SessionData {
  authToken: string;
  usuario_id: number;
  usuario_nick: string;
  usuario_email: string;
  storeId?: number;
  currentStore?: any;
  [key: string]: any;
}

export interface LoginCredentials {
  usuario_nick: string;
  usuario_clave: string;
}

@Injectable({
  providedIn: 'root'
})
export class UtilityService {
  private readonly http = inject(HttpClient);

  // *** CONFIGURACIÓN DE DESARROLLO ***
  // Cambia esto a false para usar el backend remoto durante desarrollo
  private static USE_LOCAL_BACKEND = false;

  // ==================== CONFIGURACIÓN DE DOMINIOS ====================
  public static dominios = ['restaurant.pe', 'quipupos.com', 'restpe.com', 'deliverygo.app'];
  public static restaurantpe = 'restaurant.pe';
  public static deliverygo = 'deliverygo.app';
  public static quipuposcom = 'quipupos.com';
  public static restpecom = 'restpe.com';

  public static getSubdomain(): string {
    const regexParse = new RegExp('[a-z\-0-9]{2,63}\.[a-z\.]{2,5}$');
    const urlParts: any = regexParse.exec(window.location.hostname);
    let subdominioretorno = window.location.hostname.replace(urlParts[0], '').slice(0, -1);
    
    if (Array.isArray(urlParts) && urlParts.length > 0) {
      const dominio = urlParts[0];
      if (dominio === this.quipuposcom || dominio === this.restaurantpe || dominio === this.deliverygo) {
        // Usar el subdominio real en dominios de producción
      } else {
        
        // subdominioretorno = 'desarrollo';
        // subdominioretorno = 'capacitaciones';
        subdominioretorno = 'demo18'; 
        // subdominioretorno = 'tu-subdominio-de-prueba';
      }
    }
    return subdominioretorno;
  }

  /**
   * Obtiene el dominio actual o uno configurado para desarrollo
   * Para desarrollo, puedes modificar la variable 'hostNameRetorno' en la sección comentada
   */
  public static getDominio(): string {
    const hostName = window.location.hostname;
    let hostNameRetorno = hostName.substring(hostName.lastIndexOf(".", hostName.lastIndexOf(".") - 1) + 1);

    if (hostNameRetorno == this.quipuposcom || hostNameRetorno == this.restaurantpe || hostNameRetorno == this.deliverygo) {
      // Usar el dominio real en dominios de producción
    } else {
      // *** CONFIGURACIÓN DE DESARROLLO ***
      // Descomenta la línea que necesites para desarrollo:
      
      // hostNameRetorno = this.quipuposcom;
      hostNameRetorno = this.restaurantpe;  // ← Cambiar aquí para desarrollo
      // hostNameRetorno = this.deliverygo;
    }

    return hostNameRetorno;
  }

  /**
   * Verifica si estamos en una versión online (dominio de producción)
   */
  public static esVersionOnline(): boolean {
    let esversiononline = false;
    for (let i = 0; i < this.dominios.length; i++) {
      const dominio = this.dominios[i];
      if (this.contiene(window.location.hostname, dominio)) {
        esversiononline = true;
        break;
      }
    }
    return esversiononline;
  }

  /**
   * Verifica si una cadena contiene una subcadena
   */
  public static contiene(string: string, substring: string): boolean {
    return string.indexOf(substring) !== -1;
  }

  /**
   * Obtiene la URL base del API REST
   */
  public static getREMOTE_API_URI(): string {
    if (this.esVersionOnline()) {
      return "//" + this.getSubdomain() + "." + this.getDominio() + "/restaurant/api/rest/";
    } else {
      // Para desarrollo: usar backend local o remoto según configuración
      if (this.USE_LOCAL_BACKEND) {
        return "http://localhost/webapp/api/rest/";
      } else {
        return "//" + this.getSubdomain() + "." + this.getDominio() + "/restaurant/api/rest/";
      }
    }
  }

  /**
   * Obtiene la URL base del restaurant
   */
  public static getBaseUrl(): string {
    if (this.esVersionOnline()) {
      return `//${this.getSubdomain()}.${this.getDominio()}/restaurant`;
    } else {
      // Para desarrollo: usar backend local o remoto según configuración
      if (this.USE_LOCAL_BACKEND) {
        return "http://localhost/webapp";
      } else {
        return `//${this.getSubdomain()}.${this.getDominio()}/restaurant`;
      }
    }
  }

  /**
   * Obtiene la URL base del lite
   */
  public static getLiteBaseUrl(): string {
    if (this.esVersionOnline()) {
      return `https://${this.getSubdomain()}.${this.getDominio()}/lite/`;
    } else {
      // Para desarrollo local, usar localhost/webapp
      return "http://localhost/webapp/lite/";
    }
  }

  /**
   * Obtiene la URL del API móvil
   */
  public static getREMOTE_MOVIL_URI(): string {
    if (this.esVersionOnline()) {
      return "//" + this.getSubdomain() + "." + this.getDominio() + "/restaurant/m/rest/";
    } else {
      // Para desarrollo: usar backend local o remoto según configuración
      if (this.USE_LOCAL_BACKEND) {
        return "http://localhost/webapp/m/rest/";
      } else {
        return "//" + this.getSubdomain() + "." + this.getDominio() + "/restaurant/m/rest/";
      }
    }
  }

  /**
   * Obtiene la URL del backend para API calls dinámicas
   */
  public static getBackendURI(): string {
    if (this.esVersionOnline()) {
      return "//" + this.getSubdomain() + '.' + this.getDominio() + '/restaurant/facebook/rest/';
    } else {
      // Para desarrollo local, usar localhost/webapp
      return "http://localhost/webapp/facebook/rest/";
    }
  }

  /**
   * Genera el dominio de Firebase para el nodo
   */
  public static domainFirebaseNodo(): string {
    return this.getSubdomain() + "" + this.getDominio().replace('.', '');
  }

  /**
   * Obtiene referencia del dominio Firebase para chat/billing/support
   */
  public static getReferenceDomaianFirebaseChatBillingSupport(): string {
    return "billing" + this.restaurantpe.replace(/\./g, "");
  }

  /**
   * Obtiene referencia del dominio Firebase
   */
  public static getReferenceDomaianFirebase(): string {
    return this.getSubdomain().replace(/\./g, "") + "" + this.getDominio().replace(/\./g, "");
  }

  // ==================== ESTADO DE LA SESIÓN ====================
  
  // BehaviorSubject para notificar cambios en la sesión
  private sessionSubject = new BehaviorSubject<SessionData | null>(null);
  public session$ = this.sessionSubject.asObservable();

  // BehaviorSubject para estado de carga de login
  private loginLoadingSubject = new BehaviorSubject<boolean>(false);
  public loginLoading$ = this.loginLoadingSubject.asObservable();

  // BehaviorSubject para errores de login
  private loginErrorSubject = new BehaviorSubject<boolean>(false);
  public loginError$ = this.loginErrorSubject.asObservable();

  constructor() {
    this.initializeSession();
  }


  /**
   * Inicializa la sesión desde localStorage al cargar el servicio
   */
  private initializeSession(): void {
    const sessionData = this.getSessionFromStorage();
    if (sessionData && this.isValidSession(sessionData)) {
      this.sessionSubject.next(sessionData);
    }
  }

  /**
   * Realiza el login del usuario
   */
  public signIn(credentials: LoginCredentials): Observable<any> {
    this.loginLoadingSubject.next(true);
    this.loginErrorSubject.next(false);

    // Agregar campos requeridos por el backend (igual que en delivery)
    const fullCredentials = {
      usuario_nick: credentials.usuario_nick,
      usuario_clave: credentials.usuario_clave,
      local_id: "1",
      caja_id: "1", 
      turno_id: "1",
      app: "Delivery"
    };

    // Usar la URL del API móvil para login (compatible con delivery)
    const apiUrl = UtilityService.getREMOTE_MOVIL_URI() + 'usuario/login';
    
    
    return new Observable(observer => {
      this.http.post<any>(apiUrl, fullCredentials).subscribe({
        next: (response) => {
          // Procesar respuesta según la estructura del proyecto delivery
          if (response && (response.tipo === '1' || response.tipo === 1)) { // SUCCESS
            
            // Mapear correctamente los datos según la respuesta real del servidor
            const sessionData: SessionData = {
              authToken: response.data.token || response.data.usuario_authToken || response.data.authToken || '',
              usuario_id: parseInt(response.data.usuario_id) || response.data.usuario_id,
              usuario_nick: response.data.usuario_nick || '',
              usuario_email: response.data.usuario_email || response.data.email || '',
              storeId: response.data.storeId || response.data.local_id || 1,
              // Agregar todos los datos adicionales de la respuesta
              ...response.data
            };
            // Verificar que tenemos los datos mínimos requeridos
            if (!sessionData.authToken || !sessionData.usuario_id || !sessionData.usuario_nick) {
              
              this.handleLoginError();
              observer.error('Datos de sesión incompletos');
              return;
            }
            
            this.saveSession(sessionData);
            this.sessionSubject.next(sessionData);
            this.loginLoadingSubject.next(false);
            observer.next(response);
            observer.complete();
          } else {
            this.handleLoginError();
            observer.error(response);
          }
        },
        error: (error) => {
          this.handleLoginError();
          observer.error(error);
        }
      });
    });
  }

  /**
   * Cierra la sesión del usuario
   */
  public signOut(): void {
    this.removeSession();
    this.sessionSubject.next(null);
  }

  /**
   * Verifica si existe una sesión válida
   */
  public hasValidSession(): boolean {
    const sessionData = this.getSessionFromStorage();
    const isValid = sessionData ? this.isValidSession(sessionData) : false;
    return isValid;
  }

  /**
   * Obtiene el token de autenticación
   */
  public getAuthToken(): string | null {
    const sessionData = this.getSessionFromStorage();
    return sessionData?.authToken || null;
  }

  /**
   * Obtiene los datos de la sesión actual
   */
  public getCurrentSession(): SessionData | null {
    return this.getSessionFromStorage();
  }

  /**
   * Obtiene el usuario actual
   */
  public getCurrentUser(): any {
    const session = this.getCurrentSession();
    if (!session) return null;
    
    return {
      id: session.usuario_id,
      nick: session.usuario_nick,
      email: session.usuario_email
    };
  }

  /**
   * Guarda la sesión en localStorage
   */
  private saveSession(sessionData: SessionData): void {
    try {
      localStorage.setItem('session', JSON.stringify(sessionData));
    } catch (error) {
      console.error('Error guardando sesión:', error);
    }
  }

  /**
   * Obtiene la sesión desde localStorage
   */
  private getSessionFromStorage(): SessionData | null {
    try {
      const sessionStr = localStorage.getItem('session');
      return sessionStr ? JSON.parse(sessionStr) : null;
    } catch (error) {
      console.error('Error recuperando sesión:', error);
      return null;
    }
  }

  /**
   * Elimina la sesión de localStorage
   */
  private removeSession(): void {
    try {
      localStorage.removeItem('session');
    } catch (error) {
      console.error('Error eliminando sesión:', error);
    }
  }

  /**
   * Valida si los datos de sesión son válidos
   */
  private isValidSession(sessionData: SessionData): boolean {
    return !!(sessionData.authToken && 
             sessionData.usuario_id && 
             sessionData.usuario_nick);
  }

  /**
   * Maneja errores de login
   */
  private handleLoginError(): void {
    this.loginLoadingSubject.next(false);
    this.loginErrorSubject.next(true);
  }

  /**
   * Obtiene el token para uso estático (para compatibilidad)
   */
  public static getToken(): string | null {
    try {
      const session = JSON.parse(localStorage.getItem('session') ?? '{}');
      return session?.authToken || session?.token || session?.usuario_authToken || null;
    } catch {
      return null;
    }
  }

  /**
   * Genera hash SHA1 (mantenido del código original)
   */
  public SHA1(msg: string): string {
    function rotate_left(n: number, s: number): number {
      return (n << s) | (n >>> (32 - s));
    }

    function lsb_hex(val: number): string {
      let str = '';
      for (let i = 0; i <= 6; i += 2) {
        const vh = (val >>> (i * 4 + 4)) & 0x0f;
        const vl = (val >>> (i * 4)) & 0x0f;
        str += vh.toString(16) + vl.toString(16);
      }
      return str;
    }

    function cvt_hex(val: number): string {
      let str = '';
      for (let i = 7; i >= 0; i--) {
        const v = (val >>> (i * 4)) & 0x0f;
        str += v.toString(16);
      }
      return str;
    }

    function Utf8Encode(string: string): string {
      string = string.replace(/\r\n/g, '\n');
      let utftext = '';
      for (let n = 0; n < string.length; n++) {
        const c = string.charCodeAt(n);
        if (c < 128) {
          utftext += String.fromCharCode(c);
        } else if ((c > 127) && (c < 2048)) {
          utftext += String.fromCharCode((c >> 6) | 192);
          utftext += String.fromCharCode((c & 63) | 128);
        } else {
          utftext += String.fromCharCode((c >> 12) | 224);
          utftext += String.fromCharCode(((c >> 6) & 63) | 128);
          utftext += String.fromCharCode((c & 63) | 128);
        }
      }
      return utftext;
    }

    let blockstart;
    let i, j;
    const W = new Array(80);
    let H0 = 0x67452301;
    let H1 = 0xEFCDAB89;
    let H2 = 0x98BADCFE;
    let H3 = 0x10325476;
    let H4 = 0xC3D2E1F0;
    let A, B, C, D, E;
    let temp;

    msg = Utf8Encode(msg);
    const msg_len = msg.length;
    const word_array = new Array();
    
    for (i = 0; i < msg_len - 3; i += 4) {
      j = msg.charCodeAt(i) << 24 | msg.charCodeAt(i + 1) << 16 |
        msg.charCodeAt(i + 2) << 8 | msg.charCodeAt(i + 3);
      word_array.push(j);
    }

    switch (msg_len % 4) {
      case 0:
        i = 0x080000000;
        break;
      case 1:
        i = msg.charCodeAt(msg_len - 1) << 24 | 0x0800000;
        break;
      case 2:
        i = msg.charCodeAt(msg_len - 2) << 24 | msg.charCodeAt(msg_len - 1) << 16 | 0x08000;
        break;
      case 3:
        i = msg.charCodeAt(msg_len - 3) << 24 | msg.charCodeAt(msg_len - 2) << 16 |
          msg.charCodeAt(msg_len - 1) << 8 | 0x80;
        break;
    }

    word_array.push(i);

    while ((word_array.length % 16) !== 14) word_array.push(0);

    word_array.push(msg_len >>> 29);
    word_array.push((msg_len << 3) & 0x0ffffffff);

    for (blockstart = 0; blockstart < word_array.length; blockstart += 16) {
      for (i = 0; i < 16; i++) W[i] = word_array[blockstart + i];
      for (i = 16; i <= 79; i++) W[i] = rotate_left(W[i - 3] ^ W[i - 8] ^ W[i - 14] ^ W[i - 16], 1);

      A = H0;
      B = H1;
      C = H2;
      D = H3;
      E = H4;

      for (i = 0; i <= 19; i++) {
        temp = (rotate_left(A, 5) + ((B & C) | (~B & D)) + E + W[i] + 0x5A827999) & 0x0ffffffff;
        E = D;
        D = C;
        C = rotate_left(B, 30);
        B = A;
        A = temp;
      }

      for (i = 20; i <= 39; i++) {
        temp = (rotate_left(A, 5) + (B ^ C ^ D) + E + W[i] + 0x6ED9EBA1) & 0x0ffffffff;
        E = D;
        D = C;
        C = rotate_left(B, 30);
        B = A;
        A = temp;
      }

      for (i = 40; i <= 59; i++) {
        temp = (rotate_left(A, 5) + ((B & C) | (B & D) | (C & D)) + E + W[i] + 0x8F1BBCDC) & 0x0ffffffff;
        E = D;
        D = C;
        C = rotate_left(B, 30);
        B = A;
        A = temp;
      }

      for (i = 60; i <= 79; i++) {
        temp = (rotate_left(A, 5) + (B ^ C ^ D) + E + W[i] + 0xCA62C1D6) & 0x0ffffffff;
        E = D;
        D = C;
        C = rotate_left(B, 30);
        B = A;
        A = temp;
      }

      H0 = (H0 + A) & 0x0ffffffff;
      H1 = (H1 + B) & 0x0ffffffff;
      H2 = (H2 + C) & 0x0ffffffff;
      H3 = (H3 + D) & 0x0ffffffff;
      H4 = (H4 + E) & 0x0ffffffff;
    }

    return (cvt_hex(H0) + cvt_hex(H1) + cvt_hex(H2) + cvt_hex(H3) + cvt_hex(H4)).toLowerCase();
  }

  /**
   * Maneja errores del servidor
   */
  public async handleError(errorServidor: any): Promise<void> {
    let mensajeError: string;
    if (errorServidor.error instanceof ErrorEvent) {
      mensajeError = `Ocurrió un error: ${errorServidor.error.message}`;
     
    } else {
      mensajeError = `Error del servidor: ${errorServidor.status} - ${errorServidor.message}`;
     
    }
  }

  // ==================== MÉTODOS DE UTILIDAD ADICIONALES ====================

  /**
   * Convierte valor string a boolean según estado
   */
  public static trueFalseSegunEstado(value: string): boolean {
    return value === "1";
  }

  /**
   * Convierte boolean a string de estado
   */
  public static parsearBooleanoAEstadoString(value: boolean): string {
    return value ? "1" : "0";
  }

  /**
   * Obtiene la fecha actual formateada
   */
  public getCurrentFormattedDate(): string {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const seconds = String(now.getSeconds()).padStart(2, '0');

    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  }

  /**
   * Crea un UUID único
   */
  public createUUID(): string {
    let dt = new Date().getTime();
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
      let r = (dt + Math.random() * 16) % 16 | 0;
      dt = Math.floor(dt / 16);
      return (c == 'x' ? r : (r & 0x3 | 0x8)).toString(16);
    });
  }

  /**
   * Obtiene el ID del local desde la sesión
   */
  public static get getLocalId(): number | null {
    let localId = null;
    const sessionAsString = localStorage.getItem('session');
    if (sessionAsString) {
      const sessionObj = JSON.parse(sessionAsString);
      localId = sessionObj.storeId;
    }
    return localId;
  }

  /**
   * Configura las URLs dinámicas basadas en el entorno
   */
  public static getApiUrl(): string {
    if (this.esVersionOnline()) {
      return this.getREMOTE_API_URI();
    } else {
      // Para desarrollo local
      return 'http://localhost:3000/api/';
    }
  }

}
