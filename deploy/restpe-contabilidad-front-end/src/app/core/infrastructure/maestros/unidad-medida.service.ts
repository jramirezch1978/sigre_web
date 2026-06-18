import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiClientService } from '../http/api-client.service';
import { CacheService } from '../http/cache.service';

export interface UnidadMedida {
  id: number;
  codigo: string;
  codigoSunat: string;
  nombre: string;
  abreviatura: string;
  activa: boolean;
}

/**
 * Servicio transversal de unidades de medida.
 * Usado por almacén, compras, ventas, facturación, producción.
 */
@Injectable({ providedIn: 'root' })
export class UnidadMedidaService {
  private readonly api = inject(ApiClientService);
  private readonly cache = inject(CacheService);

  getUnidadesMedida(): Observable<UnidadMedida[]> {
    return this.cache.getOrFetch(
      'maestros:unidades-medida',
      this.api.get<UnidadMedida[]>('/maestros/unidades-medida'),
      3_600_000,
    );
  }
}
