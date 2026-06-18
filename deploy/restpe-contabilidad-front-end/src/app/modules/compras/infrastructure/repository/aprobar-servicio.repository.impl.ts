import { Injectable, inject } from '@angular/core';
import { Observable, catchError, forkJoin, map, of, switchMap } from 'rxjs';
import { IAprobarServicioRepository } from '../../domain/repositories/iaprobar-servicio.repository';
import { OrdenServicioEntity } from '../../domain/models/orden-servicio.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { ApiClientService } from '../../../../core/infrastructure/http/api-client.service';
import { StorageService } from '../../../../core/services/storage.service';

interface OrdenServicioResumenDto {
  id?: number;
  nroOs?: string;
  sucursalId?: number;
  sucursalNombre?: string;
  sucursalRazonSocial?: string;
  proveedorId?: number;
  proveedorRazonSocial?: string;
  fecRegistro?: string;
  monedaId?: number;
  monedaCodigo?: string;
  montoTotal?: number;
  flagEstado?: string;
  compradorNombre?: string;
}

interface SucursalResumenDto {
  id?: number;
  nombre?: string;
  codigo?: string;
}

interface PageDto<T> {
  content?: T[];
}

/**
 * Implementación del repositorio de Aprobación de Servicios - Infrastructure Layer.
 * Consume los endpoints reales de ms-compras (/compras/ordenes-servicio).
 * Las acciones de aprobación/rechazo/retorno resuelven el id numérico a partir del nro de OS.
 */
@Injectable({ providedIn: 'root' })
export class AprobarServicioRepositoryImpl implements IAprobarServicioRepository {
  private readonly api = inject(ApiClientService);
  private readonly storage = inject(StorageService);

  obtenerOrdenesPendientes(): Observable<OrdenServicioEntity[]> {
    return forkJoin({
      resumenes: this.api.get<PageDto<OrdenServicioResumenDto> | OrdenServicioResumenDto[]>(
        '/compras/ordenes-servicio/pendientes-aprobacion',
        { page: 0, size: 1000 }
      ),
      sucursales: this.obtenerSucursales(),
    }).pipe(
      map(({ resumenes, sucursales }) => {
        const sucursalesMap = this.crearMapaSucursales(sucursales);
        return this.extraerLista(resumenes).map((o) => this.mapResumen(o, sucursalesMap));
      })
    );
  }

  /** Carga las sucursales de la empresa para resolver el nombre en la lista. */
  private obtenerSucursales(): Observable<PageDto<SucursalResumenDto> | SucursalResumenDto[]> {
    const empresaId = this.storage.getUser<{ empresaId?: number }>()?.empresaId;
    if (!empresaId) {
      return of([] as SucursalResumenDto[]);
    }
    return this.api
      .get<PageDto<SucursalResumenDto> | SucursalResumenDto[]>(`/core/empresas/${empresaId}/sucursales`, {
        page: 0,
        size: 1000,
      })
      .pipe(catchError(() => of([] as SucursalResumenDto[])));
  }

  private crearMapaSucursales(
    sucursales: PageDto<SucursalResumenDto> | SucursalResumenDto[] | null | undefined
  ): Map<number, string> {
    const mapa = new Map<number, string>();
    this.extraerLista(sucursales).forEach((s) => {
      if (s?.id !== undefined && s?.id !== null) {
        mapa.set(Number(s.id), s.nombre ?? s.codigo ?? String(s.id));
      }
    });
    return mapa;
  }

  obtenerTodasLasOrdenes(): Observable<OrdenServicioEntity[]> {
    return this.api
      .get<PageDto<OrdenServicioResumenDto> | OrdenServicioResumenDto[]>('/compras/ordenes-servicio', {
        page: 0,
        size: 1000,
      })
      .pipe(map((response) => this.extraerLista(response).map((o) => this.mapResumen(o))));
  }

  obtenerPorNumero(numeroOrden: string): Observable<OrdenServicioEntity> {
    return this.obtenerTodasLasOrdenes().pipe(
      map((ordenes) => {
        const orden = ordenes.find((o) => o.orden_servicio_numero === numeroOrden);
        if (!orden) {
          throw new Error(`Orden de servicio ${numeroOrden} no encontrada`);
        }
        return orden;
      })
    );
  }

  aprobarOrden(numeroOrden: string): Observable<ApiResponse<OrdenServicioEntity>> {
    return this.ejecutarAccion(numeroOrden, 'aprobar', {}, `Orden de servicio ${numeroOrden} aprobada exitosamente`);
  }

  rechazarOrden(numeroOrden: string, motivo: string): Observable<ApiResponse<OrdenServicioEntity>> {
    return this.ejecutarAccion(
      numeroOrden,
      'rechazar',
      { motivo },
      `Orden de servicio ${numeroOrden} rechazada. Motivo: ${motivo}`
    );
  }

  retornarOrden(numeroOrden: string, motivo: string): Observable<ApiResponse<OrdenServicioEntity>> {
    return this.ejecutarAccion(
      numeroOrden,
      'devolver',
      { motivo },
      `Orden de servicio ${numeroOrden} retornada. Motivo: ${motivo}`
    );
  }

  aprobarOrdenesMasivo(numerosOrden: string[]): Observable<ApiResponse<OrdenServicioEntity[]>> {
    if (!numerosOrden?.length) {
      return of({ success: true, message: 'Sin órdenes a aprobar', data: [] } as ApiResponse<OrdenServicioEntity[]>);
    }

    return forkJoin(numerosOrden.map((numero) => this.aprobarOrden(numero))).pipe(
      map((respuestas) => {
        const aprobadas = respuestas.filter((r) => r.success).map((r) => r.data);
        return {
          success: true,
          message: `${aprobadas.length} orden(es) de servicio aprobada(s) exitosamente`,
          data: aprobadas,
        } as ApiResponse<OrdenServicioEntity[]>;
      })
    );
  }

  // ============ Helpers ============

  private ejecutarAccion(
    numeroOrden: string,
    accion: 'aprobar' | 'rechazar' | 'devolver',
    body: Record<string, unknown>,
    mensajeOk: string
  ): Observable<ApiResponse<OrdenServicioEntity>> {
    return this.resolverIdPorNumero(numeroOrden).pipe(
      switchMap((id) => this.api.post<OrdenServicioResumenDto>(`/compras/ordenes-servicio/${id}/${accion}`, body)),
      map(
        (detalle) =>
          ({
            success: true,
            message: mensajeOk,
            data: this.mapResumen(detalle),
          }) as ApiResponse<OrdenServicioEntity>
      )
    );
  }

  private resolverIdPorNumero(numeroOrden: string): Observable<number> {
    const numericId = Number(numeroOrden);
    if (Number.isFinite(numericId) && numericId > 0 && !/[^0-9]/.test(numeroOrden)) {
      return of(numericId);
    }

    return this.api
      .get<PageDto<OrdenServicioResumenDto> | OrdenServicioResumenDto[]>('/compras/ordenes-servicio', {
        numero: numeroOrden,
        page: 0,
        size: 50,
      })
      .pipe(
        map((response) => {
          const orden = this.extraerLista(response).find((o) => o.nroOs === numeroOrden);
          if (!orden?.id) {
            throw new Error(`Orden de servicio ${numeroOrden} no encontrada`);
          }
          return Number(orden.id);
        })
      );
  }

  private mapResumen(dto: OrdenServicioResumenDto, sucursalesMap?: Map<number, string>): OrdenServicioEntity {
    const sucursalNombre =
      dto.sucursalNombre ??
      dto.sucursalRazonSocial ??
      (dto.sucursalId !== undefined && dto.sucursalId !== null
        ? sucursalesMap?.get(Number(dto.sucursalId)) ?? String(dto.sucursalId)
        : '');

    return {
      id: dto.id,
      proveedorId: dto.proveedorId,
      sucursalId: dto.sucursalId,
      monedaId: dto.monedaId,
      orden_servicio_numero: dto.nroOs ?? '',
      orden_servicio_fecha_registro: dto.fecRegistro ?? '',
      orden_servicio_fecha_entrega: '',
      orden_servicio_proveedor: dto.proveedorRazonSocial ?? '',
      orden_servicio_almacen: '',
      orden_servicio_sucursal: String(sucursalNombre ?? ''),
      orden_servicio_moneda: this.mapMonedaCodigo(dto.monedaCodigo),
      orden_servicio_total: dto.montoTotal ?? 0,
      orden_servicio_estado: this.mapEstado(dto.flagEstado),
      emitidoPor: dto.compradorNombre ?? '',
      flagEstadoCodigo: dto.flagEstado ?? '',
    } as OrdenServicioEntity;
  }

  private extraerLista<T>(response: PageDto<T> | T[] | null | undefined): T[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response.content as T[];
    }
    return [];
  }

  private mapEstado(flagEstado?: string): string {
    switch (flagEstado) {
      case '3':
        return 'Pendiente';
      case '2':
        return 'Cerrada';
      case '0':
        return 'Rechazada';
      case '1':
      default:
        return 'Aprobada';
    }
  }

  private mapMonedaCodigo(monedaCodigo?: string): string {
    const valor = String(monedaCodigo ?? '').toLowerCase();
    return valor.includes('usd') || valor.includes('dolar') ? 'dolares' : 'soles';
  }
}
