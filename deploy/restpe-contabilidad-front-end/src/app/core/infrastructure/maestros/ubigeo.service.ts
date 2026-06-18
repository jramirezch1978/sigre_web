import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiClientService } from '../http/api-client.service';
import { CacheService } from '../http/cache.service';

export interface Departamento {
  id: string;
  nombre: string;
}

export interface Provincia {
  id: string;
  departamentoId: string;
  nombre: string;
}

export interface Distrito {
  id: string;
  provinciaId: string;
  nombre: string;
  ubigeo: string;
}

/**
 * Servicio transversal de UBIGEO (departamentos, provincias, distritos).
 * Usado por RRHH (dirección empleados), compras (proveedores), ventas (clientes).
 */
@Injectable({ providedIn: 'root' })
export class UbigeoService {
  private readonly api = inject(ApiClientService);
  private readonly cache = inject(CacheService);

  private readonly basePath = '/maestros/ubigeo';
  private readonly TTL = 3_600_000;

  getDepartamentos(): Observable<Departamento[]> {
    return this.cache.getOrFetch(
      'ubigeo:departamentos',
      this.api.get<Departamento[]>(`${this.basePath}/departamentos`),
      this.TTL,
    );
  }

  getProvincias(departamentoId: string): Observable<Provincia[]> {
    return this.cache.getOrFetch(
      `ubigeo:provincias:${departamentoId}`,
      this.api.get<Provincia[]>(`${this.basePath}/departamentos/${departamentoId}/provincias`),
      this.TTL,
    );
  }

  getDistritos(provinciaId: string): Observable<Distrito[]> {
    return this.cache.getOrFetch(
      `ubigeo:distritos:${provinciaId}`,
      this.api.get<Distrito[]>(`${this.basePath}/provincias/${provinciaId}/distritos`),
      this.TTL,
    );
  }
}
