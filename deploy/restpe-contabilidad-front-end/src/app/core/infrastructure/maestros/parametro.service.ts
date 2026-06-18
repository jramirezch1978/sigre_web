import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiClientService } from '../http/api-client.service';
import { CacheService } from '../http/cache.service';

export interface Parametro {
  id: number;
  grupo: string;
  codigo: string;
  valor: string;
  descripcion: string;
  orden: number;
  activo: boolean;
}

/**
 * Servicio transversal de parámetros globales del sistema.
 * Consulta ms-core-maestros para obtener parámetros de configuración
 * compartidos por todos los módulos (monedas, tipos, estados, etc.).
 */
@Injectable({ providedIn: 'root' })
export class ParametroService {
  private readonly api = inject(ApiClientService);
  private readonly cache = inject(CacheService);

  private readonly basePath = '/maestros/parametros';
  private readonly TTL = 600_000;

  getByGrupo(grupo: string): Observable<Parametro[]> {
    return this.cache.getOrFetch(
      `parametros:${grupo}`,
      this.api.get<Parametro[]>(`${this.basePath}?grupo=${grupo}`),
      this.TTL,
    );
  }

  getByGrupoYCodigo(grupo: string, codigo: string): Observable<Parametro> {
    return this.api.get<Parametro>(`${this.basePath}/${grupo}/${codigo}`);
  }

  invalidarGrupo(grupo: string): void {
    this.cache.invalidate(`parametros:${grupo}`);
  }

  invalidarTodos(): void {
    this.cache.invalidateByPrefix('parametros:');
  }
}
