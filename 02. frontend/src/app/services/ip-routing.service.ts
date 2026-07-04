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
 * producción) según la IP privada del dispositivo.
 *
 * La IP se captura SIEMPRE en el frontend (WebRTC): el servidor ve su propia IP
 * o la del proxy, no la del tablet/móvil/kiosco donde corre el navegador.
 */
@Injectable({
  providedIn: 'root'
})
export class IpRoutingService {

  private static readonly TIMEOUT_WEBRTC_MS = 2500;
  private static readonly CACHE_IP_KEY = 'sigre-dispositivo-ip';

  private ipDispositivoCache: string | null = null;

  constructor(
    private http: HttpClient,
    private configService: ConfigService
  ) {}

  async resolverRutaAutomatica(): Promise<RutaMarcajePorIp | null> {
    const ipDispositivo = await this.capturarIpDispositivo();
    if (!ipDispositivo) {
      console.warn('⚠️ No se pudo capturar la IP privada del dispositivo; se mostrará el menú manual');
      return null;
    }

    try {
      const apiUrl = this.configService.getApiUrl() + '/api/asistencia/menu/ruta-por-ip';
      const response = await firstValueFrom(
        this.http.get<RutaPorIpResponse>(apiUrl, { params: { localIp: ipDispositivo } })
      );

      console.log('🧭 Resolución de ruta automática por IP del dispositivo:', {
        ipDispositivo,
        response
      });

      return this.mapearRuta(response);
    } catch (error) {
      console.warn('⚠️ No se pudo resolver la ruta automática por IP, se mostrará el menú por defecto:', error);
      return null;
    }
  }

  /**
   * IP privada del tablet/móvil/kiosco donde corre la aplicación web.
   * Solo se obtiene en el navegador; no se consulta al backend.
   */
  async obtenerIpCliente(): Promise<string | null> {
    return this.capturarIpDispositivo();
  }

  /**
   * Captura la IP privada del dispositivo vía WebRTC (única fuente válida para
   * identificar el kiosco en la red local del cliente).
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
