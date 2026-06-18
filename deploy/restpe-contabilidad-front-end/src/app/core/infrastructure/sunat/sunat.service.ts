import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiClientService } from '../http/api-client.service';
import { CacheService } from '../http/cache.service';

export interface ConsultaRucResult {
  ruc: string;
  razonSocial: string;
  estado: string;
  condicion: string;
  direccion: string;
  ubigeo: string;
  tipoContribuyente: string;
}

export interface ConsultaDniResult {
  dni: string;
  nombres: string;
  apellidoPaterno: string;
  apellidoMaterno: string;
  nombreCompleto: string;
}

/**
 * Servicio transversal de consultas SUNAT / RENIEC.
 * Las consultas se hacen a través del backend (ms-core-maestros)
 * que actúa como proxy hacia las APIs de SUNAT/RENIEC.
 */
@Injectable({ providedIn: 'root' })
export class SunatService {
  private readonly api = inject(ApiClientService);
  private readonly cache = inject(CacheService);

  private readonly basePath = '/maestros/sunat';

  consultarRuc(ruc: string): Observable<ConsultaRucResult> {
    return this.cache.getOrFetch(
      `sunat:ruc:${ruc}`,
      this.api.get<ConsultaRucResult>(`${this.basePath}/ruc/${ruc}`),
      1_800_000,
    );
  }

  consultarDni(dni: string): Observable<ConsultaDniResult> {
    return this.cache.getOrFetch(
      `sunat:dni:${dni}`,
      this.api.get<ConsultaDniResult>(`${this.basePath}/dni/${dni}`),
      1_800_000,
    );
  }

  invalidarConsulta(tipo: 'ruc' | 'dni', numero: string): void {
    this.cache.invalidate(`sunat:${tipo}:${numero}`);
  }
}
