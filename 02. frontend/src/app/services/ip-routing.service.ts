import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { firstValueFrom } from 'rxjs';
import { ConfigService } from './config.service';

export interface RutaMarcajePorIp {
  tipoMarcaje: string;
  modoMarcaje?: string;
}

interface RutaPorIpResponse {
  tipoMarcaje?: string | null;
  modoMarcaje?: string | null;
  ipDetectada?: string | null;
}

/**
 * Resuelve, al abrir el menú inicial, si el equipo debe entrar directamente a
 * una pantalla de marcaje (garita -> simplificado, producción -> área de
 * producción) según la IP del dispositivo.
 *
 * Se combinan dos fuentes de IP (igual que valida el backend):
 * 1. La IP local capturada en el navegador vía WebRTC (mejor opción cuando el
 *    equipo está detrás de un proxy que oculta su IP real al servidor).
 * 2. Como respaldo, la IP con la que el servidor recibe el request HTTP
 *    (X-Forwarded-For / X-Real-IP reenviados por nginx), que es la fuente más
 *    confiable en la red local ya que no depende de que el navegador logre
 *    exponer la IP LAN vía WebRTC (puede fallar por mDNS, permisos o
 *    políticas de red del equipo).
 *
 * Por eso SIEMPRE se consulta al backend, incluso si WebRTC no devuelve IP.
 */
@Injectable({
  providedIn: 'root'
})
export class IpRoutingService {

  private static readonly TIMEOUT_WEBRTC_MS = 2500;
  private static readonly CACHE_IP_KEY = 'sigre-dispositivo-ip';

  private ipDispositivoCache: string | null = null;
  private ipDetectadaBackend: string | null = null;
  private rutaPorIpCache: RutaMarcajePorIp | null | undefined;

  constructor(
    private http: HttpClient,
    private configService: ConfigService
  ) {}

  async resolverRutaAutomatica(): Promise<RutaMarcajePorIp | null> {
    return this.consultarRutaPorIp();
  }

  /**
   * Indica si la IP del dispositivo coincide con una IP fija de kiosco
   * (garita simplificado o marcación de producción) según el backend.
   */
  async esDispositivoKiosco(): Promise<boolean> {
    const ruta = await this.consultarRutaPorIp();
    return ruta !== null;
  }

  private async consultarRutaPorIp(): Promise<RutaMarcajePorIp | null> {
    if (this.rutaPorIpCache !== undefined) {
      return this.rutaPorIpCache;
    }

    const ipDispositivo = await this.capturarIpDispositivo();
    if (!ipDispositivo) {
      console.warn('⚠️ No se pudo capturar la IP privada vía WebRTC; se intentará con la IP del servidor');
    }

    try {
      const apiUrl = this.configService.getApiUrl() + '/api/asistencia/menu/ruta-por-ip';
      const params = ipDispositivo ? { localIp: ipDispositivo } : undefined;
      const response = await firstValueFrom(
        this.http.get<RutaPorIpResponse>(apiUrl, { params })
      );

      console.log('🧭 Resolución de ruta automática por IP:', {
        ipDispositivoWebRTC: ipDispositivo,
        response
      });

      if (response?.ipDetectada) {
        this.ipDetectadaBackend = response.ipDetectada;
      }

      this.rutaPorIpCache = this.mapearRuta(response);
      return this.rutaPorIpCache;
    } catch (error) {
      console.warn('⚠️ No se pudo resolver la ruta automática por IP, se mostrará el menú por defecto:', error);
      this.rutaPorIpCache = null;
      return null;
    }
  }

  /**
   * IP del dispositivo para mostrar en pantalla. Prioriza la capturada por
   * WebRTC en el navegador; si no está disponible, usa la que detectó el
   * backend a partir del request HTTP (ya consultada por resolverRutaAutomatica).
   */
  async obtenerIpCliente(): Promise<string | null> {
    const ipWebRtc = await this.capturarIpDispositivo();
    if (ipWebRtc) {
      return ipWebRtc;
    }
    if (this.ipDetectadaBackend) {
      return this.ipDetectadaBackend;
    }

    try {
      const apiUrl = this.configService.getApiUrl() + '/api/asistencia/menu/ruta-por-ip';
      const response = await firstValueFrom(
        this.http.get<RutaPorIpResponse>(apiUrl)
      );
      this.ipDetectadaBackend = response?.ipDetectada ?? null;
      return this.ipDetectadaBackend;
    } catch (error) {
      console.warn('⚠️ No se pudo consultar la IP al backend:', error);
      return null;
    }
  }

  /**
   * Captura la IP privada del dispositivo vía WebRTC. Puede devolver null si
   * el navegador la oculta (mDNS) o bloquea WebRTC; en ese caso se usa la IP
   * detectada por el backend a partir del request HTTP como respaldo.
   */
  async capturarIpDispositivo(): Promise<string | null> {
    if (this.ipDispositivoCache) {
      return this.ipDispositivoCache;
    }

    const ipEnSesion = sessionStorage.getItem(IpRoutingService.CACHE_IP_KEY);
    if (ipEnSesion) {
      this.ipDispositivoCache = ipEnSesion;
      return ipEnSesion;
    }

    const ip = await this.capturarIpLocalViaWebRTC();
    if (ip) {
      this.ipDispositivoCache = ip;
      sessionStorage.setItem(IpRoutingService.CACHE_IP_KEY, ip);
    }
    return ip;
  }

  private mapearRuta(response: RutaPorIpResponse | null | undefined): RutaMarcajePorIp | null {
    if (!response?.tipoMarcaje) {
      return null;
    }
    return {
      tipoMarcaje: response.tipoMarcaje,
      modoMarcaje: response.modoMarcaje ?? undefined
    };
  }

  private capturarIpLocalViaWebRTC(): Promise<string | null> {
    return new Promise((resolve) => {
      let resuelto = false;
      const ipsPrivadas: string[] = [];

      const resolverUnaVez = (valor: string | null) => {
        if (resuelto) {
          return;
        }
        resuelto = true;
        resolve(valor);
      };

      let rtc: RTCPeerConnection | null = null;

      const registrarIp = (ip: string) => {
        if (!this.esIpPrivada(ip) || ip === '127.0.0.1') {
          return;
        }
        if (!ipsPrivadas.includes(ip)) {
          ipsPrivadas.push(ip);
        }
        if (ip.startsWith('192.168.')) {
          rtc?.close();
          resolverUnaVez(ip);
        }
      };

      try {
        rtc = new RTCPeerConnection({ iceServers: [] });
        rtc.createDataChannel('');

        rtc.onicecandidate = (ice) => {
          if (!ice?.candidate?.candidate) {
            return;
          }
          const match = ice.candidate.candidate.match(/([0-9]{1,3}(?:\.[0-9]{1,3}){3})/);
          if (match) {
            registrarIp(match[1]);
          }
        };

        rtc.createOffer()
          .then(offer => rtc.setLocalDescription(offer))
          .catch(() => resolverUnaVez(null));

        setTimeout(() => {
          rtc?.close();
          resolverUnaVez(this.seleccionarMejorIpPrivada(ipsPrivadas));
        }, IpRoutingService.TIMEOUT_WEBRTC_MS);
      } catch {
        resolverUnaVez(null);
      }
    });
  }

  private esIpPrivada(ip: string): boolean {
    if (ip.startsWith('192.168.')) {
      return true;
    }
    if (ip.startsWith('10.')) {
      return true;
    }
    return /^172\.(1[6-9]|2[0-9]|3[0-1])\./.test(ip);
  }

  private seleccionarMejorIpPrivada(ips: string[]): string | null {
    if (ips.length === 0) {
      return null;
    }
    const ip192 = ips.find(ip => ip.startsWith('192.168.'));
    if (ip192) {
      return ip192;
    }
    const ip10 = ips.find(ip => ip.startsWith('10.'));
    if (ip10) {
      return ip10;
    }
    return ips[0];
  }
}
