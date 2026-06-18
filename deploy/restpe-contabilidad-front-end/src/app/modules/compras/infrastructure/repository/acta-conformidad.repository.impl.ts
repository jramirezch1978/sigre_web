import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map } from 'rxjs';
import { IActaConformidadRepository } from '../../domain/repositories/iacta-conformidad.repository';
import {
  ActaConformidadEntity,
  OrdenServicioPendienteConformidadEntity,
} from '../../domain/models/acta-conformidad.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { ApiClientService } from '../../../../core/infrastructure/http/api-client.service';
import { environment } from '../../../../../environments/environment';

interface PendienteDto {
  ordenServicioId?: number;
  nroOs?: string;
  proveedorId?: number;
  proveedorRazonSocial?: string;
  fecRegistro?: string;
  montoTotal?: number;
  flagEstado?: string;
}

interface ActaDetLineaDto {
  id?: number;
  secuencia?: number;
  descripcion?: string;
  cantidad?: number;
  precioUnitario?: number;
  subtotal?: number;
}

interface ActaDto {
  id?: number;
  ordenServicioId?: number;
  fecha?: string;
  observacion?: string;
  aprobado?: boolean;
  flagEstado?: string;
  lineas?: ActaDetLineaDto[];
}

interface PageDto<T> {
  content?: T[];
}

interface ActaDetRequestDto {
  secuencia: number;
  descripcion?: string;
  cantidad?: number;
  precioUnitario?: number;
}

interface ActaRequestDto {
  ordenServicioId: number;
  fecha: string;
  observacion?: string;
  lineas: ActaDetRequestDto[];
}

/**
 * Implementación del repositorio de Actas de Conformidad de OS.
 * Consume ms-compras (/api/compras/actas-conformidad).
 */
@Injectable({ providedIn: 'root' })
export class ActaConformidadRepositoryImpl implements IActaConformidadRepository {
  private readonly api = inject(ApiClientService);
  private readonly http = inject(HttpClient);
  private readonly BASE = '/compras/actas-conformidad';

  obtenerPendientes(): Observable<OrdenServicioPendienteConformidadEntity[]> {
    return this.api
      .get<PageDto<PendienteDto> | PendienteDto[]>(`${this.BASE}/pendientes`, { page: 0, size: 500 })
      .pipe(map((r) => this.extraerLista(r).map((p) => this.mapPendiente(p))));
  }

  obtenerActas(): Observable<ActaConformidadEntity[]> {
    return this.api
      .get<PageDto<ActaDto> | ActaDto[]>(this.BASE, { page: 0, size: 500 })
      .pipe(map((r) => this.extraerLista(r).map((a) => this.mapActa(a))));
  }

  obtenerPorId(id: string): Observable<ActaConformidadEntity> {
    const idNum = this.parseId(id);
    return this.api.get<ActaDto>(`${this.BASE}/${idNum}`).pipe(map((dto) => this.mapActa(dto)));
  }

  crear(acta: ActaConformidadEntity): Observable<ApiResponse<ActaConformidadEntity>> {
    const request = this.construirRequest(acta);
    return this.api.postRaw<ActaDto>(this.BASE, request).pipe(
      map((response) => ({
        success: response.success ?? true,
        message: response.message || '¡Acta de conformidad registrada correctamente!',
        data: response.data ? this.mapActa(response.data) : { ...acta },
      }))
    );
  }

  aprobar(id: string): Observable<ApiResponse<boolean>> {
    const idNum = this.parseId(id);
    return this.api.post<ActaDto>(`${this.BASE}/${idNum}/aprobar`, {}).pipe(
      map(() => ({ success: true, message: '¡Acta aprobada correctamente!', data: true }))
    );
  }

  anular(id: string): Observable<ApiResponse<boolean>> {
    const idNum = this.parseId(id);
    return this.api.post<ActaDto>(`${this.BASE}/${idNum}/anular`, {}).pipe(
      map(() => ({ success: true, message: '¡Acta anulada correctamente!', data: true }))
    );
  }

  descargarPdf(id: string): Observable<Blob> {
    const idNum = this.parseId(id);
    return this.http.get(`${environment.apiBaseUrl}${this.BASE}/${idNum}/pdf`, {
      responseType: 'blob',
    });
  }

  private construirRequest(acta: ActaConformidadEntity): ActaRequestDto {
    return {
      ordenServicioId: Number(acta.acta_orden_servicio_id),
      fecha: this.normalizarFecha(acta.acta_fecha),
      observacion: acta.acta_observacion?.trim() || undefined,
      lineas: (acta.acta_lineas ?? []).map((l, i) => ({
        secuencia: Number(l.secuencia) || i + 1,
        descripcion: l.descripcion?.trim() || `Línea ${i + 1}`,
        cantidad: Number(l.cantidad) || 0,
        precioUnitario: Number(l.precioUnitario) || 0,
      })),
    };
  }

  private mapPendiente(dto: PendienteDto): OrdenServicioPendienteConformidadEntity {
    return {
      ordenServicioId: Number(dto.ordenServicioId ?? 0),
      nroOs: dto.nroOs ?? '',
      proveedorId: dto.proveedorId,
      proveedorRazonSocial: dto.proveedorRazonSocial ?? '',
      fecRegistro: dto.fecRegistro ?? '',
      montoTotal: Number(dto.montoTotal ?? 0),
      flagEstado: dto.flagEstado ?? '',
    };
  }

  private mapActa(dto: ActaDto): ActaConformidadEntity {
    return {
      id: dto.id,
      acta_orden_servicio_id: Number(dto.ordenServicioId ?? 0),
      acta_fecha: dto.fecha ?? '',
      acta_observacion: dto.observacion ?? '',
      acta_aprobado: !!dto.aprobado,
      acta_estado:
        dto.flagEstado === '0' || dto.flagEstado === '9'
          ? 'Anulada'
          : dto.aprobado
          ? 'Aprobada'
          : 'Registrada',
      acta_monto_total: (dto.lineas ?? []).reduce(
        (acc, l) => acc + (Number(l.subtotal) || (Number(l.cantidad) || 0) * (Number(l.precioUnitario) || 0)),
        0
      ),
      acta_lineas: (dto.lineas ?? []).map((l, i) => ({
        id: l.id,
        secuencia: Number(l.secuencia ?? i + 1),
        descripcion: l.descripcion ?? '',
        cantidad: Number(l.cantidad ?? 0),
        precioUnitario: Number(l.precioUnitario ?? 0),
        subtotal: Number(l.subtotal ?? (Number(l.cantidad) || 0) * (Number(l.precioUnitario) || 0)),
      })),
    };
  }

  private extraerLista<T>(response: PageDto<T> | T[] | null | undefined): T[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response!.content as T[];
    }
    return [];
  }

  private normalizarFecha(valor: string | undefined): string {
    if (!valor) {
      const hoy = new Date();
      return `${hoy.getFullYear()}-${String(hoy.getMonth() + 1).padStart(2, '0')}-${String(hoy.getDate()).padStart(2, '0')}`;
    }
    if (valor.includes('/')) {
      const [d, m, y] = valor.split('/');
      if (y && m && d) {
        return `${y}-${m.padStart(2, '0')}-${d.padStart(2, '0')}`;
      }
    }
    return valor.substring(0, 10);
  }

  private parseId(value: unknown): number {
    const parsed = Number(value);
    if (!Number.isFinite(parsed) || parsed <= 0) {
      throw new Error(`No se pudo resolver el id del acta: ${String(value ?? 'sin valor')}`);
    }
    return parsed;
  }
}
