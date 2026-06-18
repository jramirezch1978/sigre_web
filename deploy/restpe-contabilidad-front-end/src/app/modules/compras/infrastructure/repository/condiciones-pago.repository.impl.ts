import { Injectable, inject } from '@angular/core';
import { Observable, map, of, switchMap, throwError } from 'rxjs';
import { ICondicionPagoRepository } from '../../domain/repositories/icondicion-pago.repository';
import { CondicionPagoEntity } from '../../domain/models/condicion-pago.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { ApiClientService } from '../../../../core/infrastructure/http/api-client.service';

interface CondicionPagoDto {
  id?: number;
  codigo?: string;
  nombre?: string;
  diasPlazo?: number;
  flagEstado?: string;
}

interface CondicionPagoPageDto {
  content?: CondicionPagoDto[];
}

interface CondicionPagoRequestDto {
  codigo: string;
  nombre: string;
  diasPlazo: number;
  flagEstado: string;
}

/**
 * Implementación del repositorio de Condiciones de Pago - Infrastructure Layer.
 * Consume el microservicio ms-core-maestros (/api/core/condiciones-pago).
 */
@Injectable({ providedIn: 'root' })
export class CondicionPagoRepositoryImpl implements ICondicionPagoRepository {
  private readonly api = inject(ApiClientService);
  private readonly BASE = '/core/condiciones-pago';

  obtenerTodos(): Observable<CondicionPagoEntity[]> {
    return this.api
      .get<CondicionPagoPageDto | CondicionPagoDto[]>(this.BASE, { page: 0, size: 1000 })
      .pipe(map((response) => this.extraerLista(response).map((item) => this.mapCondicion(item))));
  }

  obtenerPorCodigo(codigo: string): Observable<CondicionPagoEntity> {
    return this.obtenerTodos().pipe(
      map((condiciones) => {
        const condicion = condiciones.find((c) => c.condicion_pago_codigo === codigo);
        if (!condicion) {
          throw new Error(`Condición de pago con código ${codigo} no encontrada`);
        }
        return condicion;
      })
    );
  }

  guardar(condicion: CondicionPagoEntity): Observable<ApiResponse<CondicionPagoEntity>> {
    return this.api.postRaw<CondicionPagoDto>(this.BASE, this.toRequest(condicion)).pipe(
      map((response) => ({
        success: response.success ?? true,
        message: response.message || '¡Condición de pago registrada correctamente!',
        data: response.data ? this.mapCondicion(response.data) : { ...condicion },
      }))
    );
  }

  actualizar(condicion: CondicionPagoEntity): Observable<ApiResponse<CondicionPagoEntity>> {
    return this.resolverId(condicion.condicion_pago_codigo).pipe(
      switchMap((id) =>
        this.api.put<CondicionPagoDto>(`${this.BASE}/${id}`, this.toRequest(condicion)).pipe(
          map((data) => ({
            success: true,
            message: '¡Condición de pago actualizada correctamente!',
            data: data ? this.mapCondicion(data) : { ...condicion },
          }))
        )
      )
    );
  }

  eliminar(codigo: string): Observable<ApiResponse<boolean>> {
    return this.resolverId(codigo).pipe(
      switchMap((id) =>
        this.api.delete<boolean>(`${this.BASE}/${id}`).pipe(
          map((result) => ({
            success: true,
            message: '¡Condición de pago eliminada correctamente!',
            data: result ?? true,
          }))
        )
      )
    );
  }

  private resolverId(codigo: string): Observable<number> {
    return this.api
      .get<CondicionPagoPageDto | CondicionPagoDto[]>(this.BASE, { page: 0, size: 1000 })
      .pipe(
        switchMap((response) => {
          const item = this.extraerLista(response).find((c) => (c.codigo ?? '') === codigo);
          if (!item?.id) {
            return throwError(() => new Error(`No se pudo resolver el id de la condición de pago: ${codigo}`));
          }
          return of(item.id);
        })
      );
  }

  private extraerLista(
    response: CondicionPagoPageDto | CondicionPagoDto[] | null | undefined
  ): CondicionPagoDto[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response.content;
    }
    return [];
  }

  private mapCondicion(item: CondicionPagoDto): CondicionPagoEntity {
    const dias = Number(item.diasPlazo ?? 0);
    const entity: CondicionPagoEntity = {
      condicion_pago_codigo: item.codigo ?? (item.id ? String(item.id) : ''),
      condicion_pago_nombre: item.nombre ?? '',
      condicion_pago_tipo: dias > 0 ? 'Crédito' : 'Contado',
      condicion_pago_plazo: String(dias),
      condicion_pago_estado: item.flagEstado === '0' ? 'Inactivo' : 'Activo',
    };
    // Se adjunta el id numérico para operaciones de actualización/eliminación.
    (entity as unknown as Record<string, unknown>)['id'] = item.id;
    return entity;
  }

  private toRequest(condicion: CondicionPagoEntity): CondicionPagoRequestDto {
    const dias = Number(condicion.condicion_pago_plazo);
    return {
      codigo: condicion.condicion_pago_codigo?.trim() || this.generarCodigo(),
      nombre: condicion.condicion_pago_nombre,
      diasPlazo: Number.isFinite(dias) ? dias : 0,
      flagEstado: condicion.condicion_pago_estado?.toLowerCase() === 'inactivo' ? '0' : '1',
    };
  }

  private generarCodigo(): string {
    return `CP-${String(Date.now()).slice(-6)}`;
  }
}
