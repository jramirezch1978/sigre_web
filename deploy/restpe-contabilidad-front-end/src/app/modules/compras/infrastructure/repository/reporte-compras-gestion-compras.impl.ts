import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, catchError, map, of } from 'rxjs';
import { IReporteComprasGestionComprasRepository } from '../../domain/repositories/ireporte-compras-gestion-compras.repository';
import { GestionCompraEntity, GestionCompraDetalleItem } from '../../domain/models/gestion-compra.entity';
import { ApiClientService } from '../../../../core/infrastructure/http/api-client.service';

interface GestionCompraDetalleDto {
  codigo?: string;
  cantidad?: number;
  producto?: string;
  montoAcumulado?: number;
  monto_acumulado?: number;
}

interface GestionCompraDto {
  [key: string]: unknown;
  detalle?: GestionCompraDetalleDto[];
  detalles?: GestionCompraDetalleDto[];
}

interface PageDto<T> {
  content?: T[];
}

/**
 * Repositorio del Reporte de Gestión de Compras al detalle.
 *
 * Contrato esperado del backend (a implementar por el equipo de backend):
 *   GET /api/compras/reportes/gestion-compras
 *   -> ejecuta compras.sp_generar_reporte_compras y devuelve el detalle.
 *
 * Mientras el endpoint no exista, hace fallback al JSON de assets para que la
 * pantalla siga operativa. Cuando el backend esté disponible, se consume solo.
 */
@Injectable({ providedIn: 'root' })
export class ReporteComprasGestionComprasRepositoryImpl implements IReporteComprasGestionComprasRepository {
  private readonly http = inject(HttpClient);
  private readonly api = inject(ApiClientService);
  private readonly ENDPOINT = '/compras/reportes/gestion-compras';
  private readonly JSON_PATH = 'assets/data/compras/reportes/reporte-compras-gestion-compras.json';

  obtenerReporte(): Observable<GestionCompraEntity[]> {
    return this.api.get<PageDto<GestionCompraDto> | GestionCompraDto[]>(this.ENDPOINT, { page: 0, size: 2000 }).pipe(
      map((response) => this.extraerLista(response).map((dto) => this.mapReporte(dto))),
      catchError(() =>
        // Fallback: backend aún no implementado → usar mock de assets.
        this.http.get<GestionCompraEntity[]>(this.JSON_PATH).pipe(catchError(() => of([] as GestionCompraEntity[])))
      )
    );
  }

  private extraerLista(response: PageDto<GestionCompraDto> | GestionCompraDto[] | null | undefined): GestionCompraDto[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response!.content as GestionCompraDto[];
    }
    return [];
  }

  /** Mapeo tolerante: acepta campos ya prefijados (mock) o camelCase del SP. */
  private mapReporte(dto: GestionCompraDto): GestionCompraEntity {
    const get = (...keys: string[]): unknown => {
      for (const k of keys) {
        if (dto[k] !== undefined && dto[k] !== null) {
          return dto[k];
        }
      }
      return undefined;
    };

    const detalleRaw = (dto.detalle ?? dto.detalles ?? []) as GestionCompraDetalleDto[];
    const detalle: GestionCompraDetalleItem[] = (Array.isArray(detalleRaw) ? detalleRaw : []).map((d) => ({
      codigo: String(d.codigo ?? ''),
      cantidad: Number(d.cantidad ?? 0),
      producto: String(d.producto ?? ''),
      montoAcumulado: Number(d.montoAcumulado ?? d.monto_acumulado ?? 0),
    }));

    return {
      gestion_compra_fecha_compra: String(get('gestion_compra_fecha_compra', 'fechaCompra', 'fecha') ?? ''),
      gestion_compra_nro_orden: String(get('gestion_compra_nro_orden', 'nroOrden', 'numeroOrden') ?? ''),
      gestion_compra_doc_fiscal: String(get('gestion_compra_doc_fiscal', 'docFiscal', 'documentoFiscal') ?? ''),
      gestion_compra_razon_social: String(get('gestion_compra_razon_social', 'razonSocial', 'proveedor') ?? ''),
      gestion_compra_producto: String(get('gestion_compra_producto', 'producto') ?? ''),
      gestion_compra_categoria: String(get('gestion_compra_categoria', 'categoria') ?? ''),
      gestion_compra_medida: String(get('gestion_compra_medida', 'unidadMedida', 'medida') ?? ''),
      gestion_compra_cantidad: Number(get('gestion_compra_cantidad', 'cantidad') ?? 0),
      gestion_compra_precio_venta: Number(get('gestion_compra_precio_venta', 'precioVenta', 'precio') ?? 0),
      gestion_compra_condicion: String(get('gestion_compra_condicion', 'condicion') ?? ''),
      gestion_compra_estado: String(get('gestion_compra_estado', 'estado') ?? ''),
      gestion_compra_detalle: detalle,
    } as GestionCompraEntity;
  }
}
