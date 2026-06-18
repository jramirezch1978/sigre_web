import { Injectable, inject } from '@angular/core';
import { Observable, catchError, forkJoin, map, of, switchMap, throwError, timeout } from 'rxjs';
import { IFacturaProveedorRepository } from '../../domain/repositories/ifactura-proveedor.repository';
import { FacturaProveedorEntity } from '../../domain/models/factura-proveedor.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { ApiClientService } from '../../../../core/infrastructure/http/api-client.service';

interface CntasPagarDetResponseDto {
  id?: number;
  item?: number;
  conceptoFinancieroId?: number;
  descripcion?: string;
  articuloId?: number | null;
  cantidad?: number;
  precioUnitario?: number;
  monto?: number;
  centrosCostoId?: number;
  tiposImpuestoId?: number;
}

interface CntasPagarResponseDto {
  id?: number;
  proveedorId?: number;
  proveedorRazonSocial?: string;
  docTipoId?: number;
  docTipoNombre?: string;
  serie?: string;
  numero?: string;
  fechaEmision?: string;
  fechaVencimiento?: string;
  monedaId?: number;
  monedaCodigo?: string;
  monedaSimbolo?: string;
  total?: number;
  flagEstado?: string;
  detalles?: CntasPagarDetResponseDto[];
}

interface CntasPagarPageDto {
  content?: CntasPagarResponseDto[];
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

interface CntasPagarDetRequestDto {
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

interface CntasPagarRequestDto {
  proveedorId: number;
  docTipoId: number;
  serie?: string;
  numero?: string;
  fechaEmision: string;
  fechaVencimiento?: string;
  monedaId: number;
  total: number;
  detalles: CntasPagarDetRequestDto[];
}

/**
 * Implementación del repositorio de Facturas de Proveedor (Cuentas por Pagar).
 * Consume el microservicio ms-finanzas (/api/finanzas/cuentas-pagar).
 * Resuelve los actores secundarios (proveedor, tipo de documento, moneda) contra ms-core-maestros.
 */
@Injectable({ providedIn: 'root' })
export class FacturaProveedorRepositoryImpl implements IFacturaProveedorRepository {
  private readonly api = inject(ApiClientService);
  private readonly BASE = '/finanzas/cuentas-pagar';

  obtenerFacturas(): Observable<FacturaProveedorEntity[]> {
    // El listado de facturas manda: si los catálogos fallan o tardan, NO debe bloquear la tabla.
    return this.api
      .get<CntasPagarPageDto | CntasPagarResponseDto[]>(this.BASE, { page: 0, size: 1000 })
      .pipe(
        map((response) => this.extraerLista(response)),
        switchMap((facturas) => {
          if (!facturas.length) {
            return of([] as FacturaProveedorEntity[]);
          }

          const catalogos$ = forkJoin({
            docTipos: this.api
              .get<{ content?: DocTipoDto[] } | DocTipoDto[]>('/core/tipos-documento')
              .pipe(
                map((r) => this.extraerListaGenerica<DocTipoDto>(r)),
                timeout(6000),
                catchError(() => of([] as DocTipoDto[]))
              ),
            monedas: this.api
              .get<{ content?: MonedaDto[] } | MonedaDto[]>('/core/monedas', { page: 0, size: 100 })
              .pipe(
                map((r) => this.extraerListaGenerica<MonedaDto>(r)),
                timeout(6000),
                catchError(() => of([] as MonedaDto[]))
              ),
            proveedores: this.api
              .get<{ content?: RelacionComercialDto[] } | RelacionComercialDto[]>('/core/relaciones-comerciales', {
                page: 0,
                size: 1000,
              })
              .pipe(
                map((r) => this.extraerListaGenerica<RelacionComercialDto>(r)),
                timeout(6000),
                catchError(() => of([] as RelacionComercialDto[]))
              ),
          });

          return catalogos$.pipe(
            map((catalogos) => facturas.map((item) => this.mapFactura(item, catalogos))),
            // Si la resolución de nombres falla, mostramos las facturas igual (sin nombres resueltos).
            catchError(() => of(facturas.map((item) => this.mapFactura(item))))
          );
        })
      );
  }

  obtenerPorCodigo(codigo: string): Observable<FacturaProveedorEntity> {
    const id = this.parseId(codigo);
    return this.api
      .get<CntasPagarResponseDto>(`${this.BASE}/${id}`)
      .pipe(map((dto) => this.mapFactura(dto)));
  }

  guardar(factura: FacturaProveedorEntity): Observable<ApiResponse<FacturaProveedorEntity>> {
    return this.construirRequest(factura).pipe(
      switchMap((request) =>
        this.api.postRaw<CntasPagarResponseDto>(this.BASE, request).pipe(
          map((response) => ({
            success: response.success ?? true,
            message: response.message || '¡Cuenta por pagar registrada correctamente!',
            data: response.data ? this.mapFactura(response.data) : { ...factura },
          }))
        )
      )
    );
  }

  actualizar(factura: FacturaProveedorEntity): Observable<ApiResponse<FacturaProveedorEntity>> {
    const id = this.parseId(factura['id'] ?? factura.factura_proveedor_codigo);
    return this.construirRequest(factura).pipe(
      switchMap((request) =>
        this.api.put<CntasPagarResponseDto>(`${this.BASE}/${id}`, request).pipe(
          map((data) => ({
            success: true,
            message: '¡Cuenta por pagar actualizada correctamente!',
            data: data ? this.mapFactura(data) : { ...factura },
          }))
        )
      )
    );
  }

  eliminar(codigo: string): Observable<ApiResponse<boolean>> {
    const id = this.parseId(codigo);
    return this.api.post<CntasPagarResponseDto>(`${this.BASE}/${id}/anular`, {}).pipe(
      map(() => ({
        success: true,
        message: '¡Cuenta por pagar anulada correctamente!',
        data: true,
      }))
    );
  }

  /** Resuelve los IDs de cabecera y arma el request para el backend. */
  private construirRequest(factura: FacturaProveedorEntity): Observable<CntasPagarRequestDto> {
    const nroDocumento = String(factura.factura_proveedor_nro_documento ?? '').trim();

    return forkJoin({
      proveedores: this.api
        .get<{ content?: RelacionComercialDto[] } | RelacionComercialDto[]>('/core/relaciones-comerciales', {
          nroDocumento: nroDocumento || undefined,
          page: 0,
          size: 20,
        })
        .pipe(map((r) => this.extraerListaGenerica<RelacionComercialDto>(r))),
      docTipos: this.api
        .get<{ content?: DocTipoDto[] } | DocTipoDto[]>('/core/tipos-documento')
        .pipe(map((r) => this.extraerListaGenerica<DocTipoDto>(r))),
      monedas: this.api
        .get<{ content?: MonedaDto[] } | MonedaDto[]>('/core/monedas', { page: 0, size: 100 })
        .pipe(map((r) => this.extraerListaGenerica<MonedaDto>(r))),
    }).pipe(
      switchMap(({ proveedores, docTipos, monedas }) => {
        const proveedorId = this.resolverProveedorId(factura, proveedores);
        if (!proveedorId) {
          return throwError(
            () => new Error('No se encontró el proveedor. Usa "Buscar" para seleccionar un proveedor válido.')
          );
        }

        const docTipoId = this.resolverDocTipoId(factura, docTipos);
        if (!docTipoId) {
          return throwError(() => new Error('No se pudo resolver el tipo de comprobante.'));
        }

        const monedaId = this.resolverMonedaId(factura.factura_proveedor_moneda, monedas);
        const detalles = this.construirDetalles(factura);
        if (!detalles.length) {
          return throwError(() => new Error('Debes agregar al menos una línea de detalle.'));
        }

        const total = this.resolverTotal(factura, detalles);
        if (total <= 0) {
          return throwError(() => new Error('El total debe ser mayor a cero.'));
        }

        const request: CntasPagarRequestDto = {
          proveedorId,
          docTipoId,
          serie: this.valorOpcional(factura['factura_proveedor_serie']),
          numero: this.valorOpcional(factura['factura_proveedor_numero']),
          fechaEmision: this.normalizarFecha(factura.factura_proveedor_fecha_emision),
          fechaVencimiento: factura.factura_proveedor_vencimiento
            ? this.normalizarFecha(factura.factura_proveedor_vencimiento)
            : undefined,
          monedaId,
          total,
          detalles,
        };
        return of(request);
      })
    );
  }

  private construirDetalles(factura: FacturaProveedorEntity): CntasPagarDetRequestDto[] {
    const lineas = (factura.factura_proveedor_detalle ?? []) as unknown as Array<Record<string, unknown>>;
    const fechaMov = this.normalizarFecha(factura.factura_proveedor_fecha_emision);

    return lineas
      .map((linea, indice) => {
        const cantidad = this.aNumero(linea['cantidad']) || 1;
        const precioUnitario = this.aNumero(linea['precioUnitario'] ?? linea['precioUni']);
        const montoCalculado = this.aNumero(linea['monto'] ?? linea['subtotal'] ?? linea['total']);
        const monto = montoCalculado || cantidad * precioUnitario;

        const detalle: CntasPagarDetRequestDto = {
          item: indice + 1,
          conceptoFinancieroId: this.aNumero(linea['conceptoFinancieroId'] ?? linea['concepto_financiero_id']),
          descripcion: String(linea['descripcion'] ?? '').trim() || 'Detalle de compra',
          articuloId: this.aNumero(linea['articuloId']) || null,
          cantidad,
          precioUnitario,
          monto,
          centrosCostoId: this.aNumero(linea['centrosCostoId'] ?? linea['centros_costo_id']) || 1,
          tiposImpuestoId: this.aNumero(linea['tiposImpuestoId'] ?? linea['tipos_impuesto_id']) || 1,
          fechaMov,
          tipoMov: 'COMPRA',
        };
        return detalle;
      })
      .filter((detalle) => detalle.conceptoFinancieroId > 0 && detalle.monto > 0);
  }

  private resolverProveedorId(
    factura: FacturaProveedorEntity,
    proveedores: RelacionComercialDto[]
  ): number {
    const idDirecto = this.aNumero(factura['factura_proveedor_proveedor_id']);
    if (idDirecto > 0) {
      return idDirecto;
    }

    const documento = String(factura.factura_proveedor_nro_documento ?? '').trim();
    const encontrado =
      proveedores.find((p) => String(p.nroDocumento ?? '').trim() === documento) ?? proveedores[0];
    return this.aNumero(encontrado?.id);
  }

  private resolverDocTipoId(factura: FacturaProveedorEntity, docTipos: DocTipoDto[]): number {
    const idDirecto = this.aNumero(factura['factura_proveedor_doc_tipo_id']);
    if (idDirecto > 0) {
      return idDirecto;
    }

    const tipo = this.normalizar(factura.factura_proveedor_tipo);
    const codigoSunat = this.mapComprobanteACodigo(tipo);

    const encontrado =
      docTipos.find((d) => d.sunatCodigo === codigoSunat || d.codigo === codigoSunat) ??
      docTipos.find((d) => this.normalizar(d.nombre).includes(tipo) && tipo.length > 0) ??
      docTipos.find((d) => d.flagEstado !== '0') ??
      docTipos[0];

    return this.aNumero(encontrado?.id);
  }

  private resolverMonedaId(moneda: string | undefined, monedas: MonedaDto[]): number {
    const valor = this.normalizar(moneda);
    const encontrada = monedas.find((m) => {
      const codigo = this.normalizar(m.codigo);
      const nombre = this.normalizar(m.nombre);
      return codigo === valor || nombre === valor;
    });

    if (encontrada?.id) {
      return Number(encontrada.id);
    }
    if (valor.includes('dolar') || valor === 'usd') {
      return 2;
    }
    if (valor.includes('euro') || valor === 'eur') {
      return 3;
    }
    return 1;
  }

  private resolverTotal(factura: FacturaProveedorEntity, detalles: CntasPagarDetRequestDto[]): number {
    const totalForm = this.aNumero(factura.factura_proveedor_monto_total);
    if (totalForm > 0) {
      return totalForm;
    }
    return detalles.reduce((acc, d) => acc + d.monto, 0);
  }

  private mapComprobanteACodigo(tipo: string): string {
    const mapa: Record<string, string> = {
      factura: '01',
      boleta: '03',
      'nota de credito': '07',
      'nota de debito': '08',
      'guia de remision': '09',
      recibo: '14',
      especiales: '01',
    };
    return mapa[tipo] ?? '';
  }

  private mapFactura(
    dto: CntasPagarResponseDto,
    catalogos?: { docTipos: DocTipoDto[]; monedas: MonedaDto[]; proveedores: RelacionComercialDto[] }
  ): FacturaProveedorEntity {
    const nroComprobante = [dto.serie, dto.numero].filter((v) => !!v).join('-');

    const docTipoNombre =
      dto.docTipoNombre ||
      catalogos?.docTipos.find((d) => this.aNumero(d.id) === this.aNumero(dto.docTipoId))?.nombre ||
      '';
    const proveedorCatalogo = catalogos?.proveedores.find(
      (p) => this.aNumero(p.id) === this.aNumero(dto.proveedorId)
    );
    const proveedorRazonSocial = dto.proveedorRazonSocial || proveedorCatalogo?.razonSocial || '';
    const proveedorNroDocumento = proveedorCatalogo?.nroDocumento || '';
    const monedaCatalogo = catalogos?.monedas.find((m) => this.aNumero(m.id) === this.aNumero(dto.monedaId));
    const monedaTexto =
      dto.monedaCodigo || dto.monedaSimbolo || monedaCatalogo?.codigo || monedaCatalogo?.nombre || '';

    const entity: FacturaProveedorEntity = {
      factura_proveedor_codigo: dto.id ? String(dto.id) : '',
      factura_proveedor_nro_comprobante: nroComprobante,
      factura_proveedor_tipo: docTipoNombre,
      factura_proveedor_proveedor: proveedorRazonSocial,
      factura_proveedor_fecha_emision: dto.fechaEmision ?? '',
      factura_proveedor_fecha_registro: dto.fechaEmision ?? '',
      factura_proveedor_vencimiento: dto.fechaVencimiento ?? '',
      factura_proveedor_monto_total: Number(dto.total ?? 0),
      factura_proveedor_moneda: monedaTexto,
      factura_proveedor_responsable: '',
      factura_proveedor_orden_asociada: '',
      factura_proveedor_estado: dto.flagEstado === '0' || dto.flagEstado === '9' ? 'Anulada' : 'Registrada',
      factura_proveedor_detalle: (dto.detalles ?? []).map((det) => ({
        factura_proveedor_codigo: det.id ? String(det.id) : '',
        articuloId: det.articuloId ?? null,
        cantidad: Number(det.cantidad ?? 0),
        descripcion: det.descripcion ?? '',
        conceptoFinancieroId: det.conceptoFinancieroId ?? null,
        centros_costo_id: det.centrosCostoId ?? null,
        tiposImpuestoId: det.tiposImpuestoId ?? null,
        precioUni: Number(det.precioUnitario ?? 0),
        subtotal: Number(det.monto ?? 0),
        impuestos: '',
        montoImpuesto: 0,
        total: Number(det.monto ?? 0),
      })),
    };

    entity['id'] = dto.id;
    entity['factura_proveedor_proveedor_id'] = dto.proveedorId;
    entity['factura_proveedor_doc_tipo_id'] = dto.docTipoId;
    entity['factura_proveedor_nro_documento'] = proveedorNroDocumento;
    entity['factura_proveedor_tipo_documento'] = 'RUC';
    return entity;
  }

  private extraerLista(
    response: CntasPagarPageDto | CntasPagarResponseDto[] | null | undefined
  ): CntasPagarResponseDto[] {
    return this.extraerListaGenerica<CntasPagarResponseDto>(response);
  }

  private extraerListaGenerica<T>(response: { content?: T[] } | T[] | null | undefined): T[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response.content as T[];
    }
    return [];
  }

  private normalizar(valor: string | undefined): string {
    return String(valor ?? '')
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .trim()
      .toLowerCase();
  }

  private aNumero(valor: unknown): number {
    const parsed = Number(valor);
    return Number.isFinite(parsed) ? parsed : 0;
  }

  private valorOpcional(valor: unknown): string | undefined {
    const texto = String(valor ?? '').trim();
    return texto || undefined;
  }

  private normalizarFecha(valor: string | undefined): string {
    if (!valor) {
      const hoy = new Date();
      return `${hoy.getFullYear()}-${String(hoy.getMonth() + 1).padStart(2, '0')}-${String(hoy.getDate()).padStart(2, '0')}`;
    }
    // Si viene en formato dd/mm/yyyy lo convertimos a ISO.
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
      throw new Error(`No se pudo resolver el id de la cuenta por pagar: ${String(value ?? 'sin valor')}`);
    }
    return parsed;
  }
}
