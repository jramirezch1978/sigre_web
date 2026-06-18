import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiClientService } from '../http/api-client.service';
import { CacheService } from '../http/cache.service';

export interface TipoDocumento {
  id: number;
  codigo: string;
  codigoSunat: string;
  nombre: string;
  longitud: number;
  activo: boolean;
}

/**
 * Servicio transversal de tipos de documento de identidad.
 * Usado por RRHH, compras (proveedores), ventas (clientes), facturación.
 */
@Injectable({ providedIn: 'root' })
export class TipoDocumentoService {
  private readonly api = inject(ApiClientService);
  private readonly cache = inject(CacheService);

  getTiposDocumento(): Observable<TipoDocumento[]> {
    return this.cache.getOrFetch(
      'maestros:tipos-documento',
      this.api.get<TipoDocumento[]>('/maestros/tipos-documento'),
      3_600_000,
    );
  }
}
