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
 * producción) según su IP, o si debe mostrarse el menú manual de siempre.
 *
 * La fuente de verdad principal es la IP con la que el backend recibe la
 * petición (más confiable en la red local). La IP local capturada vía WebRTC
 * en el navegador se envía únicamente como respaldo, ya que los navegadores
 * modernos pueden ofuscarla (mDNS) y no garantizan devolver la IP real.
 */
@Injectable({
  providedIn: 'root'
})
export class IpRoutingService {

  private static readonly TIMEOUT_WEBRTC_MS = 800;

  constructor(
    private http: HttpClient,
    private configService: ConfigService
  ) {}

  async resolverRutaAutomatica(): Promise<RutaMarcajePorIp | null> {
    const localIp = await this.capturarIpLocalViaWebRTC();

    try {
      const apiUrl = this.configService.getApiUrl() + '/api/asistencia/menu/ruta-por-ip';
      const params = localIp ? { localIp } : undefined;

      const response = await firstValueFrom(
        this.http.get<RutaPorIpResponse>(apiUrl, { params })
      );

      console.log('🧭 Resolución de ruta automática por IP:', response);

      if (response?.tipoMarcaje) {
        return {
          tipoMarcaje: response.tipoMarcaje,
          modoMarcaje: response.modoMarcaje ?? undefined
        };
      }
      return null;
    } catch (error) {
      console.warn('⚠️ No se pudo resolver la ruta automática por IP, se mostrará el menú por defecto:', error);
      return null;
    }
  }

  /**
   * IP con la que el backend identifica al cliente en la red local.
   * Usa la misma consulta que el enrutamiento automático del menú inicial.
   */
  async obtenerIpCliente(): Promise<string | null> {
    const localIp = await this.capturarIpLocalViaWebRTC();

    try {
      const apiUrl = this.configService.getApiUrl() + '/api/asistencia/menu/ruta-por-ip';
      const params = localIp ? { localIp } : undefined;
      const response = await firstValueFrom(
        this.http.get<RutaPorIpResponse>(apiUrl, { params })
      );

      if (response?.ipDetectada) {
        return response.ipDetectada;
      }
      return localIp;
    } catch (error) {
      console.warn('⚠️ No se pudo consultar la IP al backend:', error);
      return localIp;
    }
  }

  /**
   * Intenta obtener la IP local del equipo (no la pública) usando WebRTC.
   * Devuelve null si no se logra en el tiempo límite o el navegador lo bloquea.
   */
  private capturarIpLocalViaWebRTC(): Promise<string | null> {
    return new Promise((resolve) => {
      let resuelto = false;
      const resolverUnaVez = (valor: string | null) => {
        if (resuelto) {
          return;
        }
        resuelto = true;
        resolve(valor);
      };

      try {
        const rtc = new RTCPeerConnection({ iceServers: [] });
        rtc.createDataChannel('');

        rtc.onicecandidate = (ice) => {
          if (!ice?.candidate?.candidate) {
            return;
          }
          const match = ice.candidate.candidate.match(/([0-9]{1,3}(\.[0-9]{1,3}){3})/);
          if (match && match[1] !== '127.0.0.1') {
            rtc.close();
            resolverUnaVez(match[1]);
          }
        };

        rtc.createOffer()
          .then(offer => rtc.setLocalDescription(offer))
          .catch(() => resolverUnaVez(null));

        setTimeout(() => {
          rtc.close();
          resolverUnaVez(null);
        }, IpRoutingService.TIMEOUT_WEBRTC_MS);
      } catch (error) {
        resolverUnaVez(null);
      }
    });
  }
}
