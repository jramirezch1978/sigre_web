import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiClientService } from '../http/api-client.service';
import { CacheService } from '../http/cache.service';

export interface Moneda {
  id: number;
  codigo: string;
  nombre: string;
  simbolo: string;
  activa: boolean;
}

export interface TipoCambio {
  monedaOrigenId: number;
  monedaDestinoId: number;
  fecha: string;
  compra: number;
  venta: number;
}

/**
 * Servicio transversal de monedas y tipos de cambio.
 * Consumido por contabilidad, compras, ventas, facturación, caja, etc.
 */
@Injectable({ providedIn: 'root' })
export class MonedaService {
  private readonly api = inject(ApiClientService);
  private readonly cache = inject(CacheService);

  private readonly basePath = '/maestros/monedas';

  getMonedas(): Observable<Moneda[]> {
    return this.cache.getOrFetch(
      'maestros:monedas',
      this.api.get<Moneda[]>(this.basePath),
      600_000,
    );
  }

  getTipoCambio(fecha: string): Observable<TipoCambio[]> {
    return this.cache.getOrFetch(
      `maestros:tipo-cambio:${fecha}`,
      this.api.get<TipoCambio[]>(`${this.basePath}/tipo-cambio`, { fecha }),
      300_000,
    );
  }
}
