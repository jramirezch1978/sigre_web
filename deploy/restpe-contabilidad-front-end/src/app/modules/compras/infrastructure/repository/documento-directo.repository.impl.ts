import { Injectable, inject } from '@angular/core';
import { Observable, forkJoin, map, of, switchMap, throwError } from 'rxjs';
import { IDocumentoDirectoRepository } from '../../domain/repositories/idocumento-directo.repository';
import { DocumentoDirectoEntity } from '../../domain/models/documento-directo.entity';
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

interface DocDirectoPageDto {
  content?: DocDirectoResponseDto[];
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
 * Implementación del repositorio de Documentos por Pagar Directo (DPD).
 * Consume ms-finanzas (/api/finanzas/cuentas-pagar/directos).
 * Resuelve actores secundarios (proveedor, tipo de documento, moneda) contra ms-core-maestros.
 */
@Injectable({ providedIn: 'root' })
export class DocumentoDirectoRepositoryImpl implements IDocumentoDirectoRepository {
  private readonly api = inject(ApiClientService);
  private readonly BASE = '/finanzas/cuentas-pagar/directos';

  obtenerDocumentos(): Observable<DocumentoDirectoEntity[]> {
    return this.api
      .get<DocDirectoPageDto | DocDirectoResponseDto[]>(this.BASE, { page: 0, size: 1000 })
      .pipe(map((response) => this.extraerLista(response).map((item) => this.mapDocumento(item))));
  }

  obtenerPorCodigo(codigo: string): Observable<DocumentoDirectoEntity> {
    const id = this.parseId(codigo);
    return this.api
      .get<DocDirectoResponseDto>(`${this.BASE}/${id}`)
      .pipe(map((dto) => this.mapDocumento(dto)));
  }

  guardar(documento: DocumentoDirectoEntity): Observable<ApiResponse<DocumentoDirectoEntity>> {
    return this.construirRequest(documento).pipe(
      switchMap((request) =>
        this.api.postRaw<DocDirectoResponseDto>(this.BASE, request).pipe(
          map((response) => ({
            success: response.success ?? true,
            message: response.message || '¡Documento directo registrado correctamente!',
            data: response.data ? this.mapDocumento(response.data) : { ...documento },
          }))
        )
      )
    );
  }

  actualizar(documento: DocumentoDirectoEntity): Observable<ApiResponse<DocumentoDirectoEntity>> {
    const id = this.parseId(documento['id'] ?? documento.dpd_codigo);
    return this.construirRequest(documento).pipe(
      switchMap((request) =>
        this.api.put<DocDirectoResponseDto>(`${this.BASE}/${id}`, request).pipe(
          map((data) => ({
            success: true,
            message: '¡Documento directo actualizado correctamente!',
            data: data ? this.mapDocumento(data) : { ...documento },
          }))
        )
      )
    );
  }

  anular(codigo: string): Observable<ApiResponse<boolean>> {
    const id = this.parseId(codigo);
    return this.api.post<DocDirectoResponseDto>(`${this.BASE}/${id}/anular`, {}).pipe(
      map(() => ({
        success: true,
        message: '¡Documento directo anulado correctamente!',
        data: true,
      }))
    );
  }

  private construirRequest(documento: DocumentoDirectoEntity): Observable<DocDirectoRequestDto> {
    const nroDocumento = String(documento.dpd_nro_documento ?? '').trim();

    return forkJoin({
      proveedores: this.api
        .get<{ content?: RelacionComercialDto[] } | RelacionComercialDto[]>('/core/relaciones-comerciales', {
          nroDocumento: nroDocumento || undefined,
          page: 0,
          size: 20,
        })
        .pipe(map((r) => this.extraerListaGenerica<RelacionComercialDto>(r))),
      docTipos: this.api.get<DocTipoDto[]>('/core/tipos-documento'),
      monedas: this.api.get<MonedaDto[]>('/core/monedas'),
    }).pipe(
      switchMap(({ proveedores, docTipos, monedas }) => {
        const proveedorId = this.resolverProveedorId(documento, proveedores);
        if (!proveedorId) {
          return throwError(
            () => new Error('No se encontró el proveedor. Usa "Buscar" para seleccionar un proveedor válido.')
          );
        }

        const docTipoId = this.resolverDocTipoId(documento, docTipos);
        if (!docTipoId) {
          return throwError(() => new Error('No se pudo resolver el tipo de comprobante.'));
        }

        const monedaId = this.resolverMonedaId(documento.dpd_moneda, monedas);
        const detalles = this.construirDetalles(documento);
        if (!detalles.length) {
          return throwError(() => new Error('Debes agregar al menos una línea de detalle.'));
        }

        const total = this.resolverTotal(documento, detalles);
        if (total <= 0) {
          return throwError(() => new Error('El total debe ser mayor a cero.'));
        }

        const request: DocDirectoRequestDto = {
          proveedorId,
          docTipoId,
          serie: this.valorOpcional(documento.dpd_serie),
          numero: this.valorOpcional(documento.dpd_numero),
          fechaEmision: this.normalizarFecha(documento.dpd_fecha_emision),
          fechaVencimiento: documento.dpd_fecha_vencimiento
            ? this.normalizarFecha(documento.dpd_fecha_vencimiento)
            : undefined,
          monedaId,
          total,
          detalles,
        };
        return of(request);
      })
    );
  }

  private construirDetalles(documento: DocumentoDirectoEntity): DocDirectoDetRequestDto[] {
    const lineas = (documento.dpd_detalle ?? []) as unknown as Array<Record<string, unknown>>;
    const fechaMov = this.normalizarFecha(documento.dpd_fecha_emision);

    return lineas
      .map((linea, indice) => {
        const cantidad = this.aNumero(linea['cantidad']) || 1;
        const precioUnitario = this.aNumero(linea['precioUnitario'] ?? linea['precioUni']);
        const montoCalculado = this.aNumero(linea['monto'] ?? linea['subtotal'] ?? linea['total']);
        const monto = montoCalculado || cantidad * precioUnitario;

        const detalle: DocDirectoDetRequestDto = {
          item: indice + 1,
          conceptoFinancieroId: this.aNumero(linea['conceptoFinancieroId'] ?? linea['concepto_financiero_id']),
          descripcion: String(linea['descripcion'] ?? '').trim() || 'Detalle directo',
          articuloId: this.aNumero(linea['articuloId']) || null,
          cantidad,
          precioUnitario,
          monto,
          centrosCostoId: this.aNumero(linea['centrosCostoId'] ?? linea['centros_costo_id']) || 1,
          tiposImpuestoId: this.aNumero(linea['tiposImpuestoId'] ?? linea['tipos_impuesto_id']) || 1,
          fechaMov,
          tipoMov: 'DIRECTO',
        };
        return detalle;
      })
      .filter((detalle) => detalle.conceptoFinancieroId > 0 && detalle.monto > 0);
  }

  private resolverProveedorId(documento: DocumentoDirectoEntity, proveedores: RelacionComercialDto[]): number {
    const idDirecto = this.aNumero(documento.dpd_proveedor_id);
    if (idDirecto > 0) {
      return idDirecto;
    }
    const nro = String(documento.dpd_nro_documento ?? '').trim();
    const encontrado = proveedores.find((p) => String(p.nroDocumento ?? '').trim() === nro) ?? proveedores[0];
    return this.aNumero(encontrado?.id);
  }

  private resolverDocTipoId(documento: DocumentoDirectoEntity, docTipos: DocTipoDto[]): number {
    const idDirecto = this.aNumero(documento.dpd_doc_tipo_id);
    if (idDirecto > 0) {
      return idDirecto;
    }
    const tipo = this.normalizar(documento.dpd_tipo_documento);
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
    const encontrada = monedas.find((m) => this.normalizar(m.codigo) === valor || this.normalizar(m.nombre) === valor);
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

  private resolverTotal(documento: DocumentoDirectoEntity, detalles: DocDirectoDetRequestDto[]): number {
    const totalForm = this.aNumero(documento.dpd_total);
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

  private mapDocumento(dto: DocDirectoResponseDto): DocumentoDirectoEntity {
    const nroComprobante = [dto.serie, dto.numero].filter((v) => !!v).join('-');
    const entity: DocumentoDirectoEntity = {
      id: dto.id,
      dpd_codigo: dto.id ? String(dto.id) : '',
      dpd_tipo_documento: dto.docTipoNombre ?? '',
      dpd_doc_tipo_id: dto.docTipoId,
      dpd_serie: dto.serie ?? '',
      dpd_numero: dto.numero ?? '',
      dpd_proveedor: dto.proveedorRazonSocial ?? '',
      dpd_proveedor_id: dto.proveedorId,
      dpd_nro_documento: nroComprobante,
      dpd_fecha_emision: dto.fechaEmision ?? '',
      dpd_fecha_vencimiento: dto.fechaVencimiento ?? '',
      dpd_moneda: dto.monedaCodigo ?? '',
      dpd_total: Number(dto.total ?? 0),
      dpd_estado: dto.flagEstado === '0' || dto.flagEstado === '9' ? 'Anulado' : 'Registrado',
      dpd_detalle: (dto.detalles ?? []).map((det) => ({
        item: det.item,
        descripcion: det.descripcion ?? '',
        cantidad: Number(det.cantidad ?? 0),
        precioUni: Number(det.precioUnitario ?? 0),
        subtotal: Number(det.monto ?? 0),
        monto: Number(det.monto ?? 0),
        conceptoFinancieroId: det.conceptoFinancieroId,
        centros_costo_id: det.centrosCostoId,
        tiposImpuestoId: det.tiposImpuestoId,
        impuestos: '',
      })),
    };
    return entity;
  }

  private extraerLista(
    response: DocDirectoPageDto | DocDirectoResponseDto[] | null | undefined
  ): DocDirectoResponseDto[] {
    return this.extraerListaGenerica<DocDirectoResponseDto>(response);
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
      throw new Error(`No se pudo resolver el id del documento directo: ${String(value ?? 'sin valor')}`);
    }
    return parsed;
  }
}
