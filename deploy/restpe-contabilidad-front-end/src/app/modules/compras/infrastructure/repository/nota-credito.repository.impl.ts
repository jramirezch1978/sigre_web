import { Injectable, inject } from '@angular/core';
import { Observable, forkJoin, map, of, switchMap, throwError } from 'rxjs';
import { INotaCreditoRepository } from '../../domain/repositories/inota-credito.repository';
import { NotaCreditoEntity } from '../../domain/models/nota-credito.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { ApiClientService } from '../../../../core/infrastructure/http/api-client.service';

interface NotaDetResponseDto {
  id?: number;
  descripcion?: string;
  cantidad?: number;
  precioUnitario?: number;
  monto?: number;
}

interface NotaResponseDto {
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
  flagEstado?: string;
  detalles?: NotaDetResponseDto[];
}

interface NotaPageDto {
  content?: NotaResponseDto[];
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
}

interface ConceptoFinancieroDto {
  id?: number;
  nombre?: string;
  flagEstado?: string;
}

interface NotaDetRequestDto {
  item: number;
  conceptoFinancieroId: number;
  descripcion: string;
  articuloId?: number | null;
  cantidad: number;
  precioUnitario: number;
  fechaMov: string;
  tipoMov: string;
  monto: number;
  centrosCostoId: number;
  tiposImpuestoId: number;
  sucursalRefId?: number | null;
  docTipoRefId?: number | null;
  nroRef?: string | null;
  itemRef?: number | null;
  trabajadorId?: number | null;
  referencia?: string | null;
}

interface NotaRequestDto {
  tipoNota: 'CREDITO' | 'DEBITO';
  proveedorId: number;
  docTipoId: number;
  serie?: string;
  numero?: string;
  fechaEmision: string;
  fechaVencimiento?: string;
  monedaId: number;
  total: number;
  detalles: NotaDetRequestDto[];
}

/**
 * Implementación del repositorio de Notas de Crédito/Débito por pagar.
 * Consume el microservicio ms-finanzas (/api/finanzas/cuentas-pagar/notas).
 * Resuelve actores secundarios (proveedor, tipo de documento, moneda, concepto financiero).
 */
@Injectable({ providedIn: 'root' })
export class NotaCreditoRepositoryImpl implements INotaCreditoRepository {
  private readonly api = inject(ApiClientService);
  private readonly BASE = '/finanzas/cuentas-pagar/notas';

  obtenerNotas(): Observable<NotaCreditoEntity[]> {
    return this.api
      .get<NotaPageDto | NotaResponseDto[]>(this.BASE, { page: 0, size: 1000 })
      .pipe(map((response) => this.extraerLista(response).map((item) => this.mapNota(item))));
  }

  obtenerPorCodigo(codigo: string): Observable<NotaCreditoEntity> {
    const id = this.parseId(codigo);
    return this.api.get<NotaResponseDto>(`${this.BASE}/${id}`).pipe(map((dto) => this.mapNota(dto)));
  }

  guardar(nota: NotaCreditoEntity): Observable<ApiResponse<NotaCreditoEntity>> {
    return this.construirRequest(nota).pipe(
      switchMap((request) =>
        this.api.postRaw<NotaResponseDto>(this.BASE, request).pipe(
          map((response) => ({
            success: response.success ?? true,
            message: response.message || '¡Nota registrada correctamente!',
            data: response.data ? this.mapNota(response.data) : { ...nota },
          }))
        )
      )
    );
  }

  actualizar(_nota: NotaCreditoEntity): Observable<ApiResponse<NotaCreditoEntity>> {
    // El backend de notas no soporta edición: solo creación y anulación.
    return throwError(
      () => new Error('Las notas no se pueden editar. Anula la nota y registra una nueva.')
    );
  }

  eliminar(codigo: string): Observable<ApiResponse<boolean>> {
    const id = this.parseId(codigo);
    return this.api.post<NotaResponseDto>(`${this.BASE}/${id}/anular`, {}).pipe(
      map(() => ({
        success: true,
        message: '¡Nota anulada correctamente!',
        data: true,
      }))
    );
  }

  private construirRequest(nota: NotaCreditoEntity): Observable<NotaRequestDto> {
    const nroDocumento = String(nota.nota_credito_nro_documento ?? '').trim();
    const tipoNota: 'CREDITO' | 'DEBITO' = this.normalizar(nota.nota_credito_tipo).includes('deb')
      ? 'DEBITO'
      : 'CREDITO';

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
      conceptos: this.api
        .get<{ content?: ConceptoFinancieroDto[] } | ConceptoFinancieroDto[]>('/finanzas/conceptos-financieros', {
          page: 0,
          size: 50,
        })
        .pipe(map((r) => this.extraerListaGenerica<ConceptoFinancieroDto>(r))),
    }).pipe(
      switchMap(({ proveedores, docTipos, monedas, conceptos }) => {
        const proveedorId = this.resolverProveedorId(nota, proveedores);
        if (!proveedorId) {
          return throwError(
            () => new Error('No se encontró el proveedor de la nota. Verifica el documento.')
          );
        }

        const docTipoId = this.resolverDocTipoId(tipoNota, docTipos);
        if (!docTipoId) {
          return throwError(() => new Error('No se pudo resolver el tipo de documento de la nota.'));
        }

        const monedaId = this.resolverMonedaId(nota.nota_credito_moneda, monedas);
        const conceptoDefault = this.aNumero(conceptos.find((c) => c.flagEstado !== '0')?.id ?? conceptos[0]?.id);
        const detalles = this.construirDetalles(nota, conceptoDefault, tipoNota);
        if (!detalles.length) {
          return throwError(() => new Error('La nota debe tener al menos una línea de detalle.'));
        }

        const total = this.resolverTotal(nota, detalles);
        if (total <= 0) {
          return throwError(() => new Error('El total de la nota debe ser mayor a cero.'));
        }

        const request: NotaRequestDto = {
          tipoNota,
          proveedorId,
          docTipoId,
          serie: this.valorOpcional(nota.nota_credito_serie),
          numero: this.valorOpcional(nota.nota_credito_numero),
          fechaEmision: this.normalizarFecha(nota.nota_credito_fecha_emision),
          fechaVencimiento: nota['nota_credito_vencimiento']
            ? this.normalizarFecha(nota['nota_credito_vencimiento'])
            : this.normalizarFecha(nota.nota_credito_fecha_emision),
          monedaId,
          total,
          detalles,
        };
        return of(request);
      })
    );
  }

  private construirDetalles(
    nota: NotaCreditoEntity,
    conceptoDefault: number,
    tipoNota: 'CREDITO' | 'DEBITO'
  ): NotaDetRequestDto[] {
    const lineas = (nota.nota_credito_detalle ?? []) as unknown as Array<Record<string, unknown>>;
    const fechaMov = this.normalizarFecha(nota.nota_credito_fecha_emision);
    const tipoMov = tipoNota === 'DEBITO' ? 'NOTA_DEBITO' : 'NOTA_CREDITO';

    // Referencia al documento afectado (factura) tomada de la cabecera de la nota.
    const docTipoRefId = this.aNumero(nota['nota_credito_doc_tipo_ref_id']) || undefined;
    const nroRefCab = this.valorOpcional(nota['nota_credito_factura_afectada']);
    const referenciaCab = this.valorOpcional(
      nota['nota_credito_descripcion_detallada'] ?? nota['nota_credito_motivo_ajuste']
    );

    return lineas
      .map((linea, indice) => {
        const cantidad =
          this.aNumero(linea['cantidad'] ?? linea['cantAjustada'] ?? linea['cantEntregada']) || 1;
        const precioUnitario = this.aNumero(
          linea['precioUnitario'] ?? linea['costoValor']
        );
        const montoCalculado = this.aNumero(linea['monto'] ?? linea['subtotal']);
        const monto = montoCalculado || cantidad * precioUnitario;

        const detalle: NotaDetRequestDto = {
          item: this.aNumero(linea['item']) || indice + 1,
          conceptoFinancieroId:
            this.aNumero(linea['conceptoFinancieroId'] ?? linea['concepto_financiero_id']) || conceptoDefault,
          descripcion:
            String(linea['descripcion'] ?? linea['nombreProducto'] ?? '').trim() || 'Ajuste de nota',
          articuloId: this.aNumero(linea['articuloId']) || null,
          cantidad,
          precioUnitario,
          fechaMov,
          tipoMov,
          monto,
          centrosCostoId: this.aNumero(linea['centrosCostoId'] ?? linea['centros_costo_id']) || 1,
          tiposImpuestoId: this.aNumero(linea['tiposImpuestoId'] ?? linea['tipos_impuesto_id']) || 1,
          docTipoRefId: this.aNumero(linea['docTipoRefId']) || docTipoRefId || null,
          nroRef: this.valorOpcional(linea['nroRef']) ?? nroRefCab ?? null,
          itemRef: this.aNumero(linea['itemRef']) || null,
          trabajadorId: this.aNumero(linea['trabajadorId']) || null,
          referencia: this.valorOpcional(linea['referencia']) ?? referenciaCab ?? null,
        };
        return detalle;
      })
      .filter((detalle) => detalle.conceptoFinancieroId > 0 && detalle.monto > 0);
  }

  private resolverProveedorId(nota: NotaCreditoEntity, proveedores: RelacionComercialDto[]): number {
    const idDirecto = this.aNumero(nota['nota_credito_proveedor_id']);
    if (idDirecto > 0) {
      return idDirecto;
    }
    const documento = String(nota.nota_credito_nro_documento ?? '').trim();
    const encontrado =
      proveedores.find((p) => String(p.nroDocumento ?? '').trim() === documento) ?? proveedores[0];
    return this.aNumero(encontrado?.id);
  }

  private resolverDocTipoId(tipoNota: 'CREDITO' | 'DEBITO', docTipos: DocTipoDto[]): number {
    const codigoSunat = tipoNota === 'CREDITO' ? '07' : '08';
    const encontrado =
      docTipos.find((d) => d.sunatCodigo === codigoSunat || d.codigo === codigoSunat) ??
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

  private resolverTotal(nota: NotaCreditoEntity, detalles: NotaDetRequestDto[]): number {
    const totalForm = this.aNumero(nota.nota_credito_total_ajuste);
    if (totalForm > 0) {
      return totalForm;
    }
    return detalles.reduce((acc, d) => acc + d.monto, 0);
  }

  private mapNota(dto: NotaResponseDto): NotaCreditoEntity {
    const entity: NotaCreditoEntity = {
      nota_credito_codigo: dto.id ? String(dto.id) : '',
      nota_credito_tipo: dto.docTipoCodigo === '08' ? 'Débito' : 'Crédito',
      nota_credito_serie: dto.serie ?? '',
      nota_credito_numero: dto.numero ?? '',
      nota_credito_responsable: '',
      nota_credito_fecha_emision: this.soloFecha(dto.fechaEmision),
      nota_credito_fecha_registro: this.soloFecha(dto.fechaEmision),
      nota_credito_proveedor: dto.proveedorRazonSocial ?? '',
      nota_credito_factura_afectada: '',
      nota_credito_cuenta_contable: '',
      nota_credito_estado: dto.flagEstado === '0' || dto.flagEstado === '9' ? 'Anulada' : 'Registrada',
      nota_credito_moneda: dto.monedaCodigo ?? '',
      nota_credito_total_ajuste: Number(dto.total ?? 0),
      nota_credito_detalle: (dto.detalles ?? []).map((det) => ({
        conceptoFinancieroNombre: '',
        descripcion: det.descripcion ?? '',
        cantidad: Number(det.cantidad ?? 0),
        precioUnitario: Number(det.precioUnitario ?? 0),
        centros_costo_id: 1,
        impuestos: '',
        monto: Number(det.monto ?? (det.cantidad ?? 0) * (det.precioUnitario ?? 0)),
      })) as any,
    };

    entity['id'] = dto.id;
    entity['nota_credito_proveedor_id'] = dto.proveedorId;
    return entity;
  }

  private extraerLista(response: NotaPageDto | NotaResponseDto[] | null | undefined): NotaResponseDto[] {
    return this.extraerListaGenerica<NotaResponseDto>(response);
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

  private soloFecha(valor: string | undefined): string {
    return valor ? valor.substring(0, 10) : '';
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
      throw new Error(`No se pudo resolver el id de la nota: ${String(value ?? 'sin valor')}`);
    }
    return parsed;
  }
}
