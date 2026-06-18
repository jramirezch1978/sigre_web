import { Injectable, inject } from '@angular/core';
import { Observable, catchError, forkJoin, map, of, switchMap } from 'rxjs';
import { IOrdenServicioRepository } from '../../domain/repositories/iorden-servicio.repository';
import { OrdenServicioEntity } from '../../domain/models/orden-servicio.entity';
import { ApiClientService } from '../../../../core/infrastructure/http/api-client.service';
import { StorageService } from '../../../../core/services/storage.service';

interface OrdenServicioResumenDto {
  id: number;
  nroOs?: string;
  sucursalId?: number;
  proveedorId?: number;
  proveedorRazonSocial?: string;
  fecRegistro?: string;
  fecProyect?: string;
  fecEntrega?: string;
  fechaEntrega?: string;
  monedaId?: number;
  monedaCodigo?: string;
  montoTotal?: number;
  flagEstado?: string;
  formaPagoId?: number;
  compradorNombre?: string;
}

interface OrdenServicioResumenPageDto {
  content?: OrdenServicioResumenDto[];
}

interface OrdenServicioLineaDto {
  id?: number;
  nroItem?: number;
  servicioId?: number;
  servicioCodigo?: string;
  servicioDescripcion?: string;
  descripcion?: string;
  fecProyect?: string;
  importe?: number;
  dsctoPorcentaje?: number;
  decuento?: number;
  tiposImpuestoId?: number | null;
  impuesto?: number;
  tiposImpuesto2Id?: number | null;
  impuesto2?: number;
  subtotal?: number;
  centrosCostoId?: number | null;
  conceptoFinancieroId?: number | null;
  operacionesDetId?: number | null;
  flagEstado?: string;
}

interface OrdenServicioDetalleDto extends OrdenServicioResumenDto {
  codOrigen?: string;
  proveedorRuc?: string;
  nomVendedor?: string;
  docTipoId?: number;
  tipoCambio?: number | string | null;
  flagReqServ?: string;
  flagSolicitaActa?: string;
  ordenTrabajoId?: number | null;
  descripcion?: string;
  compradorId?: number;
  aprobadorId?: number;
  aprobadorNombre?: string | null;
  fechaAprob?: string | null;
  motivoAnulacion?: string | null;
  lineas?: OrdenServicioLineaDto[];
}

interface OrdenServicioLineaRequest {
  servicioId: number;
  descripcion: string;
  fecProyect: string;
  importe: number;
  dsctoPorcentaje?: number;
  tiposImpuestoId?: number | null;
  tiposImpuesto2Id?: number | null;
  centrosCostoId?: number | null;
  conceptoFinancieroId?: number | null;
  operacionesDetId?: number | null;
}

interface OrdenServicioRequestDto {
  sucursalId: number;
  codOrigen: string;
  proveedorId: number;
  nomVendedor?: string | null;
  docTipoId?: number | null;
  fecRegistro: string;
  monedaId: number;
  tipoCambio?: number | null;
  formaPagoId?: number | null;
  flagReqServ?: string;
  flagSolicitaActa?: boolean;
  ordenTrabajoId?: number | null;
  descripcion?: string | null;
  lineas: OrdenServicioLineaRequest[];
}

interface RelacionComercialPageDto {
  content?: Array<{
    id?: number;
    razonSocial?: string;
    nroDocumento?: string;
    flagEstado?: string;
  }>;
}

interface ServicioCatalogoDto {
  id?: number;
  servicio?: string;
  descripcion?: string;
  tarifaEstd?: number;
  flagEstado?: string;
}

interface ServicioCatalogoPageDto {
  content?: ServicioCatalogoDto[];
}

interface MonedaDto {
  id?: number;
  codigo?: string;
  nombre?: string;
  flagEstado?: string;
}

interface SucursalDto {
  id?: number;
  codigo?: string;
  nombre?: string;
  flagEstado?: string;
}

interface SucursalPageDto {
  content?: SucursalDto[];
}

interface SessionUserLike {
  empresaId?: number;
  sucursalId?: number;
  [key: string]: unknown;
}

interface OrdenServicioCatalogosContexto {
  sucursalesMap: Map<number, string>;
}

/**
 * Implementación del repositorio de Órdenes de Servicio (Infrastructure Layer).
 * Consume los endpoints reales del backend ms-compras a través de ApiClientService.
 * Ruta base: /compras/ordenes-servicio
 */
@Injectable()
export class OrdenesServicioRepositoryImpl implements IOrdenServicioRepository {
  private readonly api = inject(ApiClientService);
  private readonly storage = inject(StorageService);

  private static readonly COD_ORIGEN = 'MANUAL';

  obtenerOrdenesServicio(): Observable<OrdenServicioEntity[]> {
    const user = this.storage.getUser<SessionUserLike>();
    const sucursales$ = user?.empresaId
      ? this.api
          .get<SucursalDto[] | SucursalPageDto>(`/core/empresas/${user.empresaId}/sucursales`, {
            page: 0,
            size: 1000,
          })
          .pipe(catchError(() => of([] as SucursalDto[])))
      : of([] as SucursalDto[]);

    return forkJoin({
      resumenes: this.api.get<OrdenServicioResumenDto[] | OrdenServicioResumenPageDto>('/compras/ordenes-servicio', {
        page: 0,
        size: 1000,
        sort: 'id,desc',
      }),
      sucursales: sucursales$,
    }).pipe(
      map(({ resumenes, sucursales }) => {
        const ordenes = this.extraerResumenes(resumenes);
        const contexto: OrdenServicioCatalogosContexto = {
          sucursalesMap: this.crearMapaSucursales(sucursales),
        };
        // La grilla solo necesita el resumen. El detalle (líneas, RUC, etc.) se
        // carga bajo demanda al seleccionar una fila (obtenerOrdenServicioPorId).
        // Antes se hacía un GET de detalle por cada orden (N+1) que saturaba la
        // red/hilo principal y provocaba lag en la pantalla.
        return ordenes.map((resumen) => this.mapOrdenResumen(resumen, contexto));
      })
    );
  }

  obtenerOrdenServicioPorId(id: string): Observable<OrdenServicioEntity | null> {
    const numericId = Number(id);
    if (Number.isFinite(numericId) && numericId > 0) {
      return this.api
        .get<OrdenServicioDetalleDto>(`/compras/ordenes-servicio/${numericId}`)
        .pipe(map((detalle) => this.mapOrdenDetalle(detalle)));
    }

    return this.obtenerOrdenesServicio().pipe(
      map((ordenes) => ordenes.find((orden) => orden.orden_servicio_numero === id) ?? null)
    );
  }

  guardarOrdenServicio(ordenServicio: OrdenServicioEntity): Observable<OrdenServicioEntity> {
    return this.construirRequestDesdeOrden(ordenServicio).pipe(
      switchMap((payload) => this.api.post<OrdenServicioDetalleDto>('/compras/ordenes-servicio', payload)),
      switchMap((response) => this.enviarOrdenAAprobacion(response)),
      map((response) => this.mapOrdenDetalle(response))
    );
  }

  actualizarOrdenServicio(ordenServicio: OrdenServicioEntity): Observable<OrdenServicioEntity> {
    const ordenId = this.parseNumericId(ordenServicio['id']);
    return this.construirRequestDesdeOrden(ordenServicio).pipe(
      switchMap((payload) =>
        this.api.put<OrdenServicioDetalleDto>(`/compras/ordenes-servicio/${ordenId}`, payload)
      ),
      map((response) => this.mapOrdenDetalle(response))
    );
  }

  eliminarOrdenServicio(id: string): Observable<boolean> {
    return this.obtenerOrdenServicioPorId(id).pipe(
      switchMap((orden) => {
        const ordenId = this.parseNumericId(orden?.['id']);
        return this.api.post<{ id?: number }>(`/compras/ordenes-servicio/${ordenId}/anular`, {
          motivo: 'Anulación solicitada desde frontend',
        });
      }),
      map(() => true)
    );
  }

  // ============ Construcción del request ============

  private construirRequestDesdeOrden(orden: OrdenServicioEntity): Observable<OrdenServicioRequestDto> {
    const fecRegistro = this.normalizarFecha(orden.orden_servicio_fecha_registro) || this.fechaHoyIso();
    const fecProyectDefault = this.normalizarFecha(orden.orden_servicio_fecha_entrega) || fecRegistro;
    const proveedorId$ = this.resolverProveedorId(orden);
    const sucursalId$ = this.resolverSucursalId(orden);
    const monedaId$ = this.resolverMonedaId(orden);
    const formaPagoId = this.resolverFormaPagoId(orden);

    const lineasFuente = (orden.orden_servicio_articulos ?? []) as unknown as Array<Record<string, unknown>>;
    const lineas$ = lineasFuente.length
      ? forkJoin(
          lineasFuente.map((linea) =>
            this.resolverServicioId(linea).pipe(
              map((servicioId) => {
                const cantidad = this.parseDecimal(linea['det_orden_servicio_cantidad'] ?? linea['cantidad']) || 1;
                const precio = this.parseDecimal(
                  linea['det_orden_servicio_precio_unitario'] ?? linea['precioUnitario']
                );
                const subtotal =
                  this.parseDecimal(linea['det_orden_servicio_subtotal'] ?? linea['subtotal']) ||
                  cantidad * precio;
                const importe = subtotal > 0 ? subtotal : precio;
                return {
                  servicioId,
                  descripcion: String(
                    linea['det_orden_servicio_descripcion'] ?? linea['descripcion'] ?? ''
                  ),
                  fecProyect: this.normalizarFecha(linea['fecProyect'] as string) || fecProyectDefault,
                  importe,
                  dsctoPorcentaje: this.parseOptionalDecimal(linea['descuentoPorcentaje']) ?? 0,
                  tiposImpuestoId: this.parseOptionalNumericId(linea['tipoImpuestoId']),
                  centrosCostoId: this.parseOptionalNumericId(
                    linea['centrosCostoId'] ?? linea['centrocostos']
                  ),
                } as OrdenServicioLineaRequest;
              })
            )
          )
        )
      : of([] as OrdenServicioLineaRequest[]);

    return forkJoin([proveedorId$, sucursalId$, monedaId$, lineas$]).pipe(
      map(([proveedorId, sucursalId, monedaId, lineas]) => ({
        sucursalId,
        codOrigen: OrdenesServicioRepositoryImpl.COD_ORIGEN,
        proveedorId,
        nomVendedor: orden.orden_servicio_proveedor || undefined,
        fecRegistro,
        monedaId,
        tipoCambio: this.parseOptionalDecimal(orden.orden_servicio_tipo_cambio),
        formaPagoId,
        flagReqServ: '0',
        flagSolicitaActa: false,
        descripcion: (orden['observaciones'] as string) || orden.orden_servicio_direccion_entrega || undefined,
        lineas,
      }))
    );
  }

  private enviarOrdenAAprobacion(detalle: OrdenServicioDetalleDto): Observable<OrdenServicioDetalleDto> {
    const ordenId = this.parseNumericId(detalle.id);
    return this.api
      .post<OrdenServicioDetalleDto>(`/compras/ordenes-servicio/${ordenId}/enviar-aprobacion`, {})
      .pipe(catchError(() => of(detalle)));
  }

  // ============ Resolución de identificadores ============

  private resolverProveedorId(orden: OrdenServicioEntity): Observable<number> {
    if (orden['proveedorId']) {
      return of(this.parseNumericId(orden['proveedorId']));
    }

    return this.api
      .get<RelacionComercialPageDto>('/core/relaciones-comerciales', {
        esProveedor: true,
        nroDocumento: orden.orden_servicio_numero_documento,
        razonSocial: !orden.orden_servicio_numero_documento ? orden.orden_servicio_proveedor : undefined,
        page: 0,
        size: 20,
      })
      .pipe(
        map((response) => response?.content?.find((item) => item.flagEstado === '1')?.id),
        map((id) => this.parseNumericId(id))
      );
  }

  private resolverSucursalId(orden: OrdenServicioEntity): Observable<number> {
    if (orden['sucursalId']) {
      return of(this.parseNumericId(orden['sucursalId']));
    }

    if (this.esNumeroValido(orden.orden_servicio_sucursal)) {
      return of(this.parseNumericId(orden.orden_servicio_sucursal));
    }

    const user = this.storage.getUser<SessionUserLike>();
    if (user?.sucursalId) {
      return of(this.parseNumericId(user.sucursalId));
    }

    if (!user?.empresaId) {
      throw new Error('No se pudo resolver la sucursal para la orden de servicio');
    }

    return this.api
      .get<SucursalDto[] | SucursalPageDto>(`/core/empresas/${user.empresaId}/sucursales`, {
        page: 0,
        size: 100,
      })
      .pipe(
        map((response) =>
          this.extraerSucursales(response).find(
            (item) => item.flagEstado !== '0' && this.coincideTexto(item.nombre, orden.orden_servicio_sucursal)
          )?.id
        ),
        map((id) => this.parseNumericId(id))
      );
  }

  private resolverMonedaId(orden: OrdenServicioEntity): Observable<number> {
    if (orden['monedaId']) {
      return of(this.parseNumericId(orden['monedaId']));
    }

    return this.api.get<MonedaDto[] | { content?: MonedaDto[] }>('/core/monedas').pipe(
      map((response) => {
        const monedas = Array.isArray(response) ? response : (response?.content ?? []);
        return monedas.find(
          (item) =>
            item.flagEstado !== '0' &&
            (this.coincideTexto(item.codigo, orden.orden_servicio_moneda) ||
              this.coincideTexto(item.nombre, orden.orden_servicio_moneda))
        )?.id;
      }),
      map((id) => this.parseNumericId(id ?? this.mapMonedaNombreAId(orden.orden_servicio_moneda)))
    );
  }

  private resolverFormaPagoId(orden: OrdenServicioEntity): number | null {
    const directo = this.parseOptionalNumericId(orden['formaPagoId']);
    if (directo) {
      return directo;
    }

    const texto = String(orden.orden_servicio_condicion_pago ?? '').trim();
    if (!texto) {
      return null;
    }

    const numerico = this.parseOptionalNumericId(texto);
    if (numerico) {
      return numerico;
    }

    const match = texto.match(/(\d+)$/);
    return match ? this.parseOptionalNumericId(match[1]) : null;
  }

  private resolverServicioId(linea: Record<string, unknown>): Observable<number> {
    if (linea['servicioId']) {
      return of(this.parseNumericId(linea['servicioId']));
    }

    const codigo = String(linea['det_orden_servicio_codigo'] ?? linea['codigo'] ?? '').trim();
    const descripcion = String(linea['det_orden_servicio_descripcion'] ?? linea['descripcion'] ?? '').trim();

    return this.api
      .get<ServicioCatalogoPageDto | ServicioCatalogoDto[]>('/compras/maestros/servicios-catalogo', {
        page: 0,
        size: 100,
      })
      .pipe(
        map((response) => {
          const servicios = Array.isArray(response) ? response : (response?.content ?? []);
          const encontrado =
            servicios.find((item) => this.coincideTexto(item.servicio, codigo)) ??
            servicios.find((item) => this.coincideTexto(item.descripcion, descripcion));
          return encontrado?.id;
        }),
        map((id) => this.parseNumericId(id))
      );
  }

  // ============ Mapeo respuesta -> entidad ============

  /**
   * Mapea una fila de la lista a partir del resumen, sin pedir el detalle.
   * Los campos de detalle (líneas, RUC, direcciones, etc.) quedan vacíos y se
   * completan al seleccionar la fila con obtenerOrdenServicioPorId.
   */
  private mapOrdenResumen(
    resumen: OrdenServicioResumenDto,
    contexto: OrdenServicioCatalogosContexto
  ): OrdenServicioEntity {
    const sucursalNombre = resumen.sucursalId
      ? contexto.sucursalesMap.get(Number(resumen.sucursalId)) ?? String(resumen.sucursalId)
      : '';

    return {
      id: resumen.id,
      proveedorId: resumen.proveedorId,
      sucursalId: resumen.sucursalId,
      monedaId: resumen.monedaId,
      formaPagoId: resumen.formaPagoId,
      orden_servicio_numero: resumen.nroOs ?? '',
      orden_servicio_fecha_registro: resumen.fecRegistro ?? '',
      orden_servicio_fecha_entrega: resumen.fecProyect ?? resumen.fecEntrega ?? resumen.fechaEntrega ?? '',
      orden_servicio_proveedor: resumen.proveedorRazonSocial ?? '',
      orden_servicio_tipo_documento: 'RUC',
      orden_servicio_numero_documento: '',
      orden_servicio_direccion_fiscal: '',
      orden_servicio_direccion_entrega: '',
      orden_servicio_almacen: '',
      orden_servicio_sucursal: String(sucursalNombre),
      orden_servicio_centro_costo: '',
      orden_servicio_moneda: this.mapMonedaCodigo(resumen.monedaCodigo),
      orden_servicio_tipo_cambio: '',
      orden_servicio_condicion_pago: resumen.formaPagoId ? String(resumen.formaPagoId) : '',
      orden_servicio_total: resumen.montoTotal ?? 0,
      orden_servicio_estado: this.mapEstado(resumen.flagEstado),
      orden_servicio_articulos: [] as any,
      observaciones: '',
      emitidoPor: resumen.compradorNombre ?? '',
      aprobadorNombre: '',
      flagEstadoCodigo: resumen.flagEstado ?? '',
      fechaAprobacion: '',
      motivoAnulacion: '',
    };
  }

  private mapOrdenDetalle(
    detalle: OrdenServicioDetalleDto,
    contexto?: OrdenServicioCatalogosContexto
  ): OrdenServicioEntity {
    const articulos = (detalle.lineas ?? []).map((linea) => this.mapLinea(linea));
    const sucursalNombre = detalle.sucursalId
      ? contexto?.sucursalesMap.get(Number(detalle.sucursalId)) ?? String(detalle.sucursalId)
      : '';
    const fechaEntrega = detalle.lineas?.[0]?.fecProyect ?? '';

    return {
      id: detalle.id,
      proveedorId: detalle.proveedorId,
      sucursalId: detalle.sucursalId,
      monedaId: detalle.monedaId,
      formaPagoId: detalle.formaPagoId,
      orden_servicio_numero: detalle.nroOs ?? '',
      orden_servicio_fecha_registro: detalle.fecRegistro ?? '',
      orden_servicio_fecha_entrega: fechaEntrega,
      orden_servicio_proveedor: detalle.proveedorRazonSocial ?? '',
      orden_servicio_tipo_documento: 'RUC',
      orden_servicio_numero_documento: detalle.proveedorRuc ?? '',
      orden_servicio_direccion_fiscal: '',
      orden_servicio_direccion_entrega: detalle.descripcion ?? '',
      orden_servicio_almacen: '',
      orden_servicio_sucursal: String(sucursalNombre),
      orden_servicio_centro_costo: detalle.lineas?.[0]?.centrosCostoId
        ? String(detalle.lineas[0].centrosCostoId)
        : '',
      orden_servicio_moneda: this.mapMonedaCodigo(detalle.monedaCodigo),
      orden_servicio_tipo_cambio:
        detalle.tipoCambio === null || detalle.tipoCambio === undefined ? '' : String(detalle.tipoCambio),
      orden_servicio_condicion_pago: detalle.formaPagoId ? String(detalle.formaPagoId) : '',
      orden_servicio_total: detalle.montoTotal ?? 0,
      orden_servicio_estado: this.mapEstado(detalle.flagEstado),
      orden_servicio_articulos: articulos as any,
      observaciones: detalle.descripcion ?? '',
      emitidoPor: detalle.compradorNombre ?? '',
      aprobadorNombre: detalle.aprobadorNombre ?? '',
      flagEstadoCodigo: detalle.flagEstado ?? '',
      fechaAprobacion: detalle.fechaAprob ?? '',
      motivoAnulacion: detalle.motivoAnulacion ?? '',
    };
  }

  private mapLinea(linea: OrdenServicioLineaDto): Record<string, unknown> {
    const importe = Number(linea.importe ?? 0);
    const impuesto = Number(linea.impuesto ?? 0);
    const subtotal = Number(linea.subtotal ?? importe + impuesto);

    return {
      id: linea.id,
      servicioId: linea.servicioId,
      tipoImpuestoId: linea.tiposImpuestoId ?? null,
      centrosCostoId: linea.centrosCostoId ?? null,
      centrocostos: linea.centrosCostoId ? String(linea.centrosCostoId) : '',
      det_orden_servicio_codigo: linea.servicioCodigo ?? '',
      det_orden_servicio_cantidad: 1,
      det_orden_servicio_descripcion: linea.descripcion ?? linea.servicioDescripcion ?? '',
      det_orden_servicio_precio_unitario: importe,
      det_orden_servicio_subtotal: importe,
      det_orden_servicio_impuestos: impuesto,
      det_orden_servicio_total: subtotal,
    };
  }

  // ============ Utilidades ============

  private extraerResumenes(
    response: OrdenServicioResumenDto[] | OrdenServicioResumenPageDto | null | undefined
  ): OrdenServicioResumenDto[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response.content;
    }
    return [];
  }

  private extraerSucursales(response: SucursalDto[] | SucursalPageDto | null | undefined): SucursalDto[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response.content;
    }
    return [];
  }

  private crearMapaSucursales(response: SucursalDto[] | SucursalPageDto | null | undefined): Map<number, string> {
    return new Map(
      this.extraerSucursales(response)
        .filter((item) => item?.id && item.flagEstado !== '0')
        .map((item) => [Number(item.id), item.nombre ?? item.codigo ?? String(item.id)])
    );
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
    const valor = this.normalizarTexto(monedaCodigo);
    return valor.includes('usd') || valor.includes('dolar') ? 'dolares' : 'soles';
  }

  private mapMonedaNombreAId(moneda?: string): number {
    const valor = this.normalizarTexto(moneda);
    if (!valor) {
      return 1;
    }
    return valor.includes('dolar') || valor === 'usd' ? 2 : 1;
  }

  private normalizarFecha(value: string | undefined | null): string {
    if (!value) {
      return '';
    }
    const raw = String(value).trim();
    if (/^\d{4}-\d{2}-\d{2}/.test(raw)) {
      return raw.slice(0, 10);
    }
    const match = raw.match(/^(\d{1,2})\/(\d{1,2})\/(\d{4})$/);
    if (match) {
      const [, dia, mes, anio] = match;
      return `${anio}-${mes.padStart(2, '0')}-${dia.padStart(2, '0')}`;
    }
    return raw;
  }

  private parseNumericId(value: unknown): number {
    const parsed = Number(value);
    if (!Number.isFinite(parsed) || parsed <= 0) {
      throw new Error(`No se pudo resolver un id numérico válido: ${String(value ?? '')}`);
    }
    return parsed;
  }

  private parseOptionalNumericId(value: unknown): number | null {
    if (value === undefined || value === null || value === '') {
      return null;
    }
    const parsed = Number(value);
    return Number.isFinite(parsed) && parsed > 0 ? parsed : null;
  }

  private parseDecimal(value: unknown): number {
    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : 0;
  }

  private parseOptionalDecimal(value: unknown): number | null {
    if (value === undefined || value === null || value === '') {
      return null;
    }
    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : null;
  }

  private fechaHoyIso(): string {
    return new Date().toISOString().slice(0, 10);
  }

  private coincideTexto(source: string | undefined, target: string | undefined): boolean {
    const a = this.normalizarTexto(source);
    const b = this.normalizarTexto(target);
    return !!a && a === b;
  }

  private normalizarTexto(value: string | undefined): string {
    return String(value ?? '')
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .trim()
      .toLowerCase();
  }

  private esNumeroValido(value: unknown): boolean {
    const parsed = Number(value);
    return Number.isFinite(parsed) && parsed > 0;
  }
}
