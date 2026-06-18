import { Injectable, inject } from '@angular/core';
import { Observable, forkJoin, map, of, switchMap, throwError } from 'rxjs';
import { IFacturaNoCompraRepository } from '../../domain/repositories/ifactura-no-compra.repository';
import { FacturaNoCompraEntity } from '../../domain/models/factura-no-compra.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { ApiClientService } from '../../../../core/infrastructure/http/api-client.service';

interface DocDirectoDetResponseDto {
  id?: number;
  item?: number;
  conceptoFinancieroId?: number;
  descripcion?: string;
  cantidad?: number;
  precioUnitario?: number;
  monto?: number;
  centrosCostoId?: number;
  tiposImpuestoId?: number;
}

interface DocDirectoResponseDto {
  id?: number;
  proveedorId?: number;
  proveedorRazonSocial?: string;
  proveedorRuc?: string;
  docTipoId?: number;
  docTipoCodigo?: string;
  docTipoNombre?: string;
  serie?: string;
  numero?: string;
  fechaEmision?: string;
  fechaVencimiento?: string;
  monedaId?: number;
  monedaCodigo?: string;
  total?: number;
  saldo?: number;
  flagEstado?: string;
  detalles?: DocDirectoDetResponseDto[];
}

interface PageDto<T> {
  content?: T[];
}

interface MonedaDto {
  id?: number;
  codigo?: string;
  nombre?: string;
}

interface DocTipoDto {
  id?: number;
  codigo?: string;
  nombre?: string;
  sunatCodigo?: string;
  flagEstado?: string;
}

interface RelacionComercialDto {
  id?: number;
  razonSocial?: string;
  nroDocumento?: string;
  flagEstado?: string;
}

interface DocDirectoDetRequestDto {
  item: number;
  conceptoFinancieroId: number;
  descripcion: string;
  articuloId?: number | null;
  cantidad: number;
  precioUnitario: number;
  monto: number;
  centrosCostoId: number;
  tiposImpuestoId: number;
  fechaMov: string;
  tipoMov: string;
}

interface DocDirectoRequestDto {
  proveedorId: number;
  docTipoId: number;
  serie?: string;
  numero?: string;
  fechaEmision: string;
  fechaVencimiento?: string;
  monedaId: number;
  total: number;
  detalles: DocDirectoDetRequestDto[];
}

/**
 * Facturas no asociadas a compras.
 * Backend real: /api/finanzas/cuentas-pagar/directos.
 */
@Injectable({ providedIn: 'root' })
export class FacturaNoComprasRepositoryImpl implements IFacturaNoCompraRepository {
  private readonly api = inject(ApiClientService);
  private readonly BASE = '/finanzas/cuentas-pagar/directos';

  obtenerFacturas(): Observable<FacturaNoCompraEntity[]> {
    return this.api
      .get<PageDto<DocDirectoResponseDto> | DocDirectoResponseDto[]>(this.BASE, { page: 0, size: 1000 })
      .pipe(map((response) => this.extraerLista(response).map((item) => this.mapFactura(item))));
  }

  obtenerPorCodigo(codigo: string): Observable<FacturaNoCompraEntity> {
    const id = this.parseId(codigo);
    return this.api.get<DocDirectoResponseDto>(`${this.BASE}/${id}`).pipe(map((dto) => this.mapFactura(dto)));
  }

  guardar(factura: FacturaNoCompraEntity): Observable<ApiResponse<FacturaNoCompraEntity>> {
    return this.construirRequest(factura).pipe(
      switchMap((request) =>
        this.api.postRaw<DocDirectoResponseDto>(this.BASE, request).pipe(
          map((response) => ({
            success: response.success ?? true,
            message: response.message || 'Factura directa registrada correctamente',
            data: response.data ? this.mapFactura(response.data) : { ...factura },
          }))
        )
      )
    );
  }

  actualizar(factura: FacturaNoCompraEntity): Observable<ApiResponse<FacturaNoCompraEntity>> {
    const id = this.parseId(factura['id'] ?? factura.factura_no_compra_codigo);
    return this.construirRequest(factura).pipe(
      switchMap((request) =>
        this.api.put<DocDirectoResponseDto>(`${this.BASE}/${id}`, request).pipe(
          map((response) => ({
            success: true,
            message: 'Factura directa actualizada correctamente',
            data: this.mapFactura(response),
          }))
        )
      )
    );
  }

  eliminar(codigo: string): Observable<ApiResponse<boolean>> {
    const id = this.parseId(codigo);
    return this.api.post<DocDirectoResponseDto>(`${this.BASE}/${id}/anular`, {}).pipe(
      map(() => ({
        success: true,
        message: 'Factura directa anulada correctamente',
        data: true,
      }))
    );
  }

  private construirRequest(factura: FacturaNoCompraEntity): Observable<DocDirectoRequestDto> {
    return forkJoin({
      proveedores: this.api
        .get<PageDto<RelacionComercialDto> | RelacionComercialDto[]>('/core/relaciones-comerciales', {
          esProveedor: true,
          nroDocumento: factura.factura_no_compra_doc_fiscal || undefined,
          page: 0,
          size: 50,
        })
        .pipe(map((r) => this.extraerLista(r))),
      docTipos: this.api.get<PageDto<DocTipoDto> | DocTipoDto[]>('/core/tipos-documento').pipe(map((r) => this.extraerLista(r))),
      monedas: this.api
        .get<PageDto<MonedaDto> | MonedaDto[]>('/core/monedas', { page: 0, size: 100 })
        .pipe(map((r) => this.extraerLista(r))),
    }).pipe(
      switchMap(({ proveedores, docTipos, monedas }) => {
        const proveedorId = this.resolverProveedorId(factura, proveedores);
        if (!proveedorId) {
          return throwError(() => new Error('No se encontro el proveedor. Selecciona un proveedor activo del catalogo.'));
        }

        const docTipoId = this.resolverDocTipoId(docTipos);
        if (!docTipoId) {
          return throwError(() => new Error('No se pudo resolver el tipo de documento factura.'));
        }

        const monedaId = this.resolverMonedaId(factura.factura_no_compra_moneda, monedas);
        const detalles = this.construirDetalles(factura);
        if (!detalles.length) {
          return throwError(() => new Error('Debes agregar al menos una linea de detalle con monto mayor a cero.'));
        }

        const total = detalles.reduce((sum, item) => sum + item.monto, 0);
        const { serie, numero } = this.separarSerieNumero(factura['factura_no_compra_serie_numero'] ?? factura.factura_no_compra_codigo);

        return of({
          proveedorId,
          docTipoId,
          serie,
          numero,
          fechaEmision: this.normalizarFecha(factura['factura_no_compra_fecha_emision'] ?? factura.factura_no_compra_fecha_registro),
          fechaVencimiento: this.normalizarFecha(factura.factura_no_compra_vencimiento),
          monedaId,
          total,
          detalles,
        });
      })
    );
  }

  private construirDetalles(factura: FacturaNoCompraEntity): DocDirectoDetRequestDto[] {
    const lineas = (factura['factura_no_compra_productos'] ?? []) as Array<Record<string, unknown>>;
    const fechaMov = this.normalizarFecha(factura['factura_no_compra_fecha_emision'] ?? factura.factura_no_compra_fecha_registro);
    const conceptoFinancieroId = this.aNumero(factura['factura_no_compra_concepto_financiero_id'] ?? factura.factura_no_compra_cuenta_contable);
    const centrosCostoId = this.aNumero(factura['factura_no_compra_centros_costo_id'] ?? factura.factura_no_compra_centro_costo);
    if (centrosCostoId <= 0) {
      throw new Error('No se pudo resolver el centro de costo requerido por Finanzas.');
    }

    return lineas
      .map((linea, indice) => {
        const cantidad = this.aNumero(linea['cantidad']) || 1;
        const precioUnitario = this.aNumero(linea['precioUni'] ?? linea['precioUnitario']);
        const monto = this.aNumero(linea['total'] ?? linea['monto']) || cantidad * precioUnitario;

        return {
          item: indice + 1,
          conceptoFinancieroId,
          descripcion: String(linea['descripcion'] ?? factura.factura_no_compra_descripcion_detallada ?? 'Factura directa').trim(),
          articuloId: null,
          cantidad,
          precioUnitario,
          monto,
          centrosCostoId,
          tiposImpuestoId: this.aNumero(linea['tiposImpuestoId']) || 1,
          fechaMov,
          tipoMov: 'DIRECTO',
        };
      })
      .filter((detalle) => detalle.conceptoFinancieroId > 0 && detalle.monto > 0);
  }

  private mapFactura(dto: DocDirectoResponseDto): FacturaNoCompraEntity {
    const serieNumero = [dto.serie, dto.numero].filter(Boolean).join('-') || String(dto.id ?? '');
    return {
      id: dto.id,
      factura_no_compra_codigo: String(dto.id ?? serieNumero),
      factura_no_compra_serie_numero: serieNumero,
      factura_no_compra_fecha_registro: dto.fechaEmision ?? '',
      factura_no_compra_fecha_emision: dto.fechaEmision ?? '',
      factura_no_compra_doc_fiscal: dto.proveedorRuc ?? '',
      factura_no_compra_tipo_gasto: dto.docTipoNombre ?? 'Factura directa',
      factura_no_compra_proveedor: dto.proveedorRazonSocial ?? '',
      factura_no_compra_proveedor_id: dto.proveedorId,
      factura_no_compra_vencimiento: dto.fechaVencimiento ?? '',
      factura_no_compra_responsable: '',
      factura_no_compra_monto_total: Number(dto.total ?? 0),
      factura_no_compra_estado: this.mapEstado(dto.flagEstado),
      factura_no_compra_moneda: dto.monedaCodigo ?? '',
      factura_no_compra_productos: (dto.detalles ?? []).map((detalle) => ({
        codigo: String(detalle.id ?? detalle.item ?? ''),
        cantidad: Number(detalle.cantidad ?? 1),
        descripcion: detalle.descripcion ?? '',
        precioUni: Number(detalle.precioUnitario ?? 0),
        subtotal: Number(detalle.monto ?? 0),
        impuestos: 0,
        total: Number(detalle.monto ?? 0),
        conceptoFinancieroId: detalle.conceptoFinancieroId,
        centrosCostoId: detalle.centrosCostoId,
        tiposImpuestoId: detalle.tiposImpuestoId,
      })),
    };
  }

  private resolverProveedorId(factura: FacturaNoCompraEntity, proveedores: RelacionComercialDto[]): number {
    const idDirecto = this.aNumero(factura['factura_no_compra_proveedor_id'] ?? factura.factura_no_compra_proveedor);
    if (idDirecto > 0) {
      return idDirecto;
    }

    const documento = String(factura.factura_no_compra_doc_fiscal ?? '').trim();
    const nombre = this.normalizar(factura.factura_no_compra_proveedor);
    const encontrado =
      proveedores.find((item) => String(item.nroDocumento ?? '').trim() === documento) ??
      proveedores.find((item) => this.normalizar(item.razonSocial) === nombre) ??
      proveedores.find((item) => item.flagEstado !== '0') ??
      proveedores[0];
    return this.aNumero(encontrado?.id);
  }

  private resolverDocTipoId(docTipos: DocTipoDto[]): number {
    const encontrado =
      docTipos.find((item) => item.sunatCodigo === '01' || item.codigo === '01') ??
      docTipos.find((item) => this.normalizar(item.nombre).includes('factura')) ??
      docTipos.find((item) => item.flagEstado !== '0') ??
      docTipos[0];
    return this.aNumero(encontrado?.id);
  }

  private resolverMonedaId(moneda: string | undefined, monedas: MonedaDto[]): number {
    const valor = this.normalizar(moneda);
    const encontrada = monedas.find((item) => {
      const codigo = this.normalizar(item.codigo);
      const nombre = this.normalizar(item.nombre);
      return codigo === valor || nombre === valor;
    });
    return this.aNumero(encontrada?.id) || (valor.includes('usd') || valor.includes('dolar') ? 2 : 1);
  }

  private separarSerieNumero(value: unknown): { serie?: string; numero?: string } {
    const texto = String(value ?? '').trim();
    const [serie, ...numeroParts] = texto.split('-');
    return {
      serie: serie || undefined,
      numero: numeroParts.join('-') || undefined,
    };
  }

  private normalizarFecha(value: unknown): string {
    if (!value) {
      return new Date().toISOString().slice(0, 10);
    }
    if (value instanceof Date) {
      return value.toISOString().slice(0, 10);
    }
    const texto = String(value);
    if (/^\d{4}-\d{2}-\d{2}/.test(texto)) {
      return texto.slice(0, 10);
    }
    const partes = texto.split('/');
    if (partes.length === 3) {
      return `${partes[2]}-${partes[1].padStart(2, '0')}-${partes[0].padStart(2, '0')}`;
    }
    return texto;
  }

  private parseId(value: unknown): number {
    const parsed = this.aNumero(value);
    if (parsed <= 0) {
      throw new Error(`No se pudo resolver el id de la factura directa: ${String(value ?? '')}`);
    }
    return parsed;
  }

  private aNumero(value: unknown): number {
    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : 0;
  }

  private extraerLista<T>(response: T[] | PageDto<T> | null | undefined): T[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response.content;
    }
    return [];
  }

  private mapEstado(flagEstado?: string): string {
    switch (flagEstado) {
      case '0':
        return 'Anulado';
      case '2':
        return 'Aprobada';
      case '1':
      default:
        return 'Pendiente';
    }
  }

  private normalizar(value: unknown): string {
    return String(value ?? '')
      .trim()
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '');
  }
}
