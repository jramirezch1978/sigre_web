import { Injectable, inject } from '@angular/core';
import { Observable, catchError, forkJoin, map, of, switchMap, throwError } from 'rxjs';
import { IOrdenCompraRepository } from '../../domain/repositories/iorden-compra.repository';
import { ArticuloEntity, OrdenCompraEntity } from '../../domain/models/orden-compra.entity';
import { ApiClientService } from '../../../../core/infrastructure/http/api-client.service';
import { StorageService } from '../../../../core/services/storage.service';

interface OrdenCompraResumenDto {
  id: number;
  nroOrdenCompra?: string;
  fechaEmision?: string;
  total?: number;
  flagEstado?: string;
}

interface OrdenCompraResumenPageDto {
  content?: OrdenCompraResumenDto[];
}

interface OrdenCompraDetalleDto extends OrdenCompraResumenDto {
  sucursalId?: number;
  proveedorId?: number;
  proveedorRazonSocial?: string;
  proveedorRuc?: string;
  fechaEntrega?: string;
  monedaId?: number;
  monedaCodigo?: string;
  formaPagoId?: number;
  entidadBancoCntaId?: number;
  lugarEntrega?: string;
  observaciones?: string;
  tipoCambio?: number | string | null;
  subtotal?: number;
  igvTotal?: number;
  percepcionTotal?: number;
  total?: number;
  flagEstado?: string;
  lineas?: OrdenCompraLineaDto[];
  compradorNombre?: string;
  aprobadorNombre?: string | null;
  fechaAprobacion?: string | null;
  motivoAnulacion?: string | null;
}

interface OrdenCompraLineaDto {
  id?: number;
  articuloId?: number;
  articuloCodigo?: string;
  articuloDescripcion?: string;
  unidadMedidaId?: number | null;
  unidadMedidaCodigo?: string;
  cantProyectada?: number;
  valorUnitario?: number;
  valorImpuesto?: number;
  subtotal?: number;
  tipoImpuestoId?: number | null;
  tipoImpuestoDescripcion?: string;
  descuentoPorcentaje?: number;
  centrosCostoId?: number | null;
  almacenId?: number | null;
  fechaEntrega?: string;
}

interface OrdenCompraRequestDto {
  sucursalId: number;
  proveedorId: number;
  fechaEmision: string;
  monedaId: number;
  lineas: Array<{
    articuloId: number;
    cantProyectada: number;
    valorUnitario: number;
    tipoImpuestoId?: number | null;
    descuentoPorcentaje: number;
    fechaEntrega: string;
    unidadMedidaId?: number | null;
    almacenId?: number | null;
    centrosCostoId?: number | null;
  }>;
  fechaEntrega?: string;
  formaPagoId?: number | null;
  lugarEntrega?: string;
  observaciones?: string | null;
  flagImportacion?: boolean;
  flagSolicitaDua?: boolean;
  tipoCambio?: number | null;
}

interface RelacionComercialPageDto {
  content?: Array<{
    id?: number;
    razonSocial?: string;
    nroDocumento?: string;
    flagEstado?: string;
  }>;
}

interface ArticuloPageDto {
  content?: Array<{
    id?: number;
    codigo?: string;
    nombre?: string;
    flagEstado?: string;
  }>;
}

interface MonedaDto {
  id?: number;
  codigo?: string;
  nombre?: string;
  activa?: boolean;
  flagEstado?: string;
}

interface FormaPagoDto {
  id?: number;
  codigo?: string;
  nombre?: string;
  tipo?: string;
  flagEstado?: string;
}

interface FormaPagoPageDto {
  content?: FormaPagoDto[];
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

interface AlmacenDto {
  id?: number;
  nombre?: string;
  codigo?: string;
  flagEstado?: string;
}

interface DatosArticuloDto {
  precioPactado?: number;
  almacenTacitoId?: number;
  saldoActual?: number;
  unidadMedidaId?: number;
  unidadMedidaDescripcion?: string;
}

interface SessionUserLike {
  empresaId?: number;
  sucursalId?: number;
  [key: string]: unknown;
}

interface OrdenCompraCatalogosContexto {
  almacenesMap: Map<number, string>;
  sucursalesMap: Map<number, string>;
  formasPagoMap: Map<number, string>;
}

@Injectable()
export class OrdenesCompraRepositoryImpl implements IOrdenCompraRepository {
  protected readonly api = inject(ApiClientService);
  private readonly storage = inject(StorageService);

  obtenerOrdenesCompra(): Observable<OrdenCompraEntity[]> {
    return this.obtenerDetallesDesdeRuta('/compras/ordenes-compra');
  }

  obtenerOrdenCompraPorId(id: string): Observable<OrdenCompraEntity | null> {
    return this.resolverOrdenPorIdentificador(id);
  }

  guardarOrdenCompra(ordenCompra: OrdenCompraEntity): Observable<OrdenCompraEntity> {
    return this.construirRequestDesdeOrden(ordenCompra).pipe(
      switchMap((payload) => this.api.post<OrdenCompraDetalleDto>('/compras/ordenes-compra', payload)),
      switchMap((response) => this.enviarOrdenAAprobacion(response)),
      map((response) => this.mapOrdenDetalle(response))
    );
  }

  actualizarOrdenCompra(ordenCompra: OrdenCompraEntity): Observable<OrdenCompraEntity> {
    const ordenId = this.parseNumericId(ordenCompra['id']);
    return this.construirRequestDesdeOrden(ordenCompra).pipe(
      switchMap((payload) =>
        this.api.put<OrdenCompraDetalleDto>(`/compras/ordenes-compra/${ordenId}`, payload)
      ),
      map((response) => this.mapOrdenDetalle(response))
    );
  }

  eliminarOrdenCompra(id: string): Observable<boolean> {
    return this.resolverOrdenPorIdentificador(id).pipe(
      switchMap((orden) => {
        const ordenId = this.parseNumericId(orden?.['id']);
        return this.api.post<{ id?: number }>(`/compras/ordenes-compra/${ordenId}/anular`, {
          motivo: 'Anulación solicitada desde frontend',
        });
      }),
      map(() => true)
    );
  }

  protected obtenerDetallesDesdeRuta(path: string): Observable<OrdenCompraEntity[]> {
    const user = this.storage.getUser<SessionUserLike>();
    const sucursales$ = user?.empresaId
      ? this.api.get<SucursalDto[] | SucursalPageDto>(`/core/empresas/${user.empresaId}/sucursales`, {
          page: 0,
          size: 1000,
        }).pipe(catchError(() => of([] as SucursalDto[])))
      : of([] as SucursalDto[]);

    return forkJoin({
      // Se piden suficientes registros y orden por id desc (más recientes primero);
      // sin esto el backend pagina a 20 sin orden y la OC recién creada podía no
      // aparecer en la lista tras refrescar.
      resumenes: this.api.get<OrdenCompraResumenDto[] | OrdenCompraResumenPageDto>(path, {
        page: 0,
        size: 1000,
        sort: 'id,desc',
      }),
      almacenes: this.api
        .get<AlmacenDto[] | { content?: AlmacenDto[] }>('/almacen/almacenes', { page: 0, size: 1000 })
        .pipe(catchError(() => of([] as AlmacenDto[]))),
      sucursales: sucursales$,
      formasPago: this.api
        .get<FormaPagoDto[] | FormaPagoPageDto>('/core/formas-pago', { page: 0, size: 1000 })
        .pipe(catchError(() => of([] as FormaPagoDto[]))),
    }).pipe(
      switchMap(({ resumenes, almacenes, sucursales, formasPago }) => {
        const ordenes = this.extraerResumenes(resumenes);
        const contexto: OrdenCompraCatalogosContexto = {
          almacenesMap: this.crearMapaAlmacenes(almacenes),
          sucursalesMap: this.crearMapaSucursales(sucursales),
          formasPagoMap: this.crearMapaFormasPago(formasPago),
        };

        if (!ordenes?.length) {
          return of([]);
        }

        return forkJoin(
          ordenes.map((orden) =>
            this.api.get<OrdenCompraDetalleDto>(`/compras/ordenes-compra/${orden.id}`).pipe(
              map((detalle) => this.mapOrdenDetalle(detalle, contexto)),
              catchError(() => of(null))
            )
          )
        ).pipe(
          map((detalles) => detalles.filter((orden): orden is OrdenCompraEntity => !!orden))
        );
      })
    );
  }

  protected resolverOrdenPorIdentificador(identificador: string): Observable<OrdenCompraEntity | null> {
    const numericId = Number(identificador);

    if (Number.isFinite(numericId) && numericId > 0) {
      return this.api
        .get<OrdenCompraDetalleDto>(`/compras/ordenes-compra/${numericId}`)
        .pipe(map((detalle) => this.mapOrdenDetalle(detalle)));
    }

    return this.obtenerOrdenesCompra().pipe(
      map((ordenes) =>
        ordenes.find((orden) => orden.orden_compra_numero === identificador) ?? null
      )
    );
  }

  protected mapOrdenDetalle(
    detalle: OrdenCompraDetalleDto,
    contexto?: OrdenCompraCatalogosContexto
  ): OrdenCompraEntity {
    const articulos = (detalle.lineas ?? []).map((linea) => this.mapLinea(linea, contexto?.almacenesMap));
    const almacenNombre = articulos[0]?.['almacen_nombre'] ?? '';
    const sucursalNombre = detalle.sucursalId
      ? (contexto?.sucursalesMap.get(Number(detalle.sucursalId)) ?? String(detalle.sucursalId))
      : '';

    return {
      id: detalle.id,
      proveedorId: detalle.proveedorId,
      sucursalId: detalle.sucursalId,
      monedaId: detalle.monedaId,
      formaPagoId: detalle.formaPagoId,
      entidadBancoCntaId: detalle.entidadBancoCntaId,
      orden_compra_numero: detalle.nroOrdenCompra ?? '',
      orden_compra_fecha_registro: detalle.fechaEmision ?? '',
      orden_compra_fecha_entrega: detalle.fechaEntrega ?? '',
      orden_compra_proveedor: detalle.proveedorRazonSocial ?? '',
      documentoproveedor: 'RUC',
      documentoproveedorinput: detalle.proveedorRuc ?? '',
      direccionFiscal: '',
      direccionEntrega: detalle.lugarEntrega ?? '',
      orden_compra_almacen: String(almacenNombre),
      orden_compra_sucursal: String(sucursalNombre),
      orden_compra_centro_costo: String(articulos[0]?.['centrocostos'] ?? ''),
      orden_compra_moneda: this.mapMonedaCodigo(detalle.monedaCodigo),
      orden_compra_tipo_cambio:
        detalle.tipoCambio === null || detalle.tipoCambio === undefined
          ? ''
          : String(detalle.tipoCambio),
      orden_compra_condicion_pago: detalle.formaPagoId ? String(detalle.formaPagoId) : '',
      observaciones: detalle.observaciones ?? '',
      orden_compra_total: detalle.total ?? 0,
      orden_compra_estado: this.mapEstado(detalle.flagEstado),
      orden_compra_articulos: articulos,
      subtotalGeneral: detalle.subtotal ?? 0,
      impuestosGenerales: detalle.igvTotal ?? 0,
      percepcionGeneral: detalle.percepcionTotal ?? 0,
      totalGeneral: detalle.total ?? 0,
      emitidoPor: detalle.compradorNombre ?? '',
      aprobadorNombre: detalle.aprobadorNombre ?? '',
      flagEstadoCodigo: detalle.flagEstado ?? '',
      fechaAprobacion: detalle.fechaAprobacion ?? '',
      motivoAnulacion: detalle.motivoAnulacion ?? '',
    };
  }

  protected mapLinea(linea: OrdenCompraLineaDto, almacenesMap?: Map<number, string>): Record<string, unknown> & ArticuloEntity {
    const subtotalBase = linea.subtotal ?? (linea.cantProyectada ?? 0) * (linea.valorUnitario ?? 0);
    const impuesto = linea.valorImpuesto ?? 0;
    const subtotalSinImpuesto = Math.max(subtotalBase - impuesto, 0);
    const almacenNombre = linea.almacenId ? (almacenesMap?.get(Number(linea.almacenId)) ?? String(linea.almacenId)) : '';

    return {
      id: linea.id,
      articuloId: linea.articuloId,
      unidadMedidaId: linea.unidadMedidaId ?? null,
      almacenId: linea.almacenId,
      centrosCostoId: linea.centrosCostoId,
      fechaEntrega: linea.fechaEntrega ?? '',
      tipoImpuesto: linea.tipoImpuestoDescripcion ?? null,
      tipoImpuestoId: linea.tipoImpuestoId,
      igvTasa: 0,
      percepcionTasa: 0,
      descuentoPorcentaje: Number(linea.descuentoPorcentaje ?? 0),
      det_orden_compra_codigo: linea.articuloCodigo ?? '',
      det_orden_compra_cantidad: Number(linea.cantProyectada ?? 0),
      det_orden_compra_unidad: linea.unidadMedidaCodigo ?? 'UND',
      det_orden_compra_descripcion: linea.articuloDescripcion ?? '',
      det_orden_compra_precio_unitario: Number(linea.valorUnitario ?? 0),
      det_orden_compra_subtotal: Number(subtotalSinImpuesto),
      det_orden_compra_impuestos: Number(impuesto),
      det_orden_compra_total: Number(subtotalBase),
      almacen_nombre: almacenNombre,
      centrocostos: linea.centrosCostoId ? String(linea.centrosCostoId) : '',
    };
  }

  private construirRequestDesdeOrden(ordenCompra: OrdenCompraEntity): Observable<OrdenCompraRequestDto> {
    const fechaEmision = ordenCompra.orden_compra_fecha_registro || this.fechaHoyIso();
    const fechaEntrega = ordenCompra.orden_compra_fecha_entrega || fechaEmision;
    const proveedorId$ = this.resolverProveedorId(ordenCompra);
    const sucursalId$ = this.resolverSucursalId(ordenCompra);
    const monedaId$ = this.resolverMonedaId(ordenCompra);
    const formaPagoId = this.resolverFormaPagoId(ordenCompra);
    const lineas$ = (ordenCompra.orden_compra_articulos ?? []).length
      ? forkJoin(
          ((ordenCompra.orden_compra_articulos ?? []) as Array<ArticuloEntity & Record<string, unknown>>).map((linea) =>
            forkJoin({
              articuloId: this.resolverArticuloId(linea),
              proveedorId: proveedorId$,
              sucursalId: sucursalId$,
              monedaId: monedaId$,
            }).pipe(
              switchMap(({ articuloId, proveedorId, sucursalId, monedaId }) =>
                this.resolverDatosArticulo(articuloId, proveedorId, monedaId, sucursalId, fechaEmision).pipe(
                  map((datosArticulo) => ({
                    articuloId,
                    cantProyectada: Number(linea.det_orden_compra_cantidad ?? 0),
                    valorUnitario: Number(
                      linea.det_orden_compra_precio_unitario ?? datosArticulo?.precioPactado ?? 0
                    ),
                    tipoImpuestoId: this.parseOptionalNumericId(linea['tipoImpuestoId']),
                    descuentoPorcentaje: this.parseOptionalDecimal(linea['descuentoPorcentaje']) ?? 0,
                    fechaEntrega: (linea['fechaEntrega'] as string) || fechaEntrega,
                    unidadMedidaId:
                      this.parseOptionalNumericId(linea['unidadMedidaId']) ??
                      datosArticulo?.unidadMedidaId ??
                      undefined,
                    almacenId:
                      this.parseOptionalNumericId(linea['almacenId'] ?? linea['almacen_nombre']) ??
                      datosArticulo?.almacenTacitoId ??
                      undefined,
                    centrosCostoId:
                      this.parseOptionalNumericId(linea['centrosCostoId'] ?? linea['centrocostos']) ?? 1,
                  }))
                )
              )
            )
          )
        )
      : of([]);

    return forkJoin([proveedorId$, sucursalId$, monedaId$, lineas$]).pipe(
      map(([proveedorId, sucursalId, monedaId, lineas]) => ({
        sucursalId,
        proveedorId,
        fechaEmision,
        fechaEntrega,
        monedaId,
        formaPagoId,
        lugarEntrega: ordenCompra.direccionEntrega ?? '',
        observaciones: ordenCompra.observaciones || undefined,
        flagImportacion: Boolean(ordenCompra.flagImportacion),
        flagSolicitaDua: Boolean(ordenCompra.flagSolicitaDua),
        tipoCambio: this.parseOptionalDecimal(ordenCompra.orden_compra_tipo_cambio),
        lineas,
      }))
    );
  }

  private resolverFormaPagoId(ordenCompra: OrdenCompraEntity): number | null {
    const directo = this.parseOptionalNumericId(ordenCompra['formaPagoId']);
    if (directo) {
      return directo;
    }

    const texto = String(ordenCompra.orden_compra_condicion_pago ?? '').trim();
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

  private resolverProveedorId(ordenCompra: OrdenCompraEntity): Observable<number> {
    if (ordenCompra['proveedorId']) {
      return of(this.parseNumericId(ordenCompra['proveedorId']));
    }

    return this.api
      .get<RelacionComercialPageDto>('/core/relaciones-comerciales', {
        esProveedor: true,
        nroDocumento: ordenCompra.documentoproveedorinput,
        razonSocial: !ordenCompra.documentoproveedorinput ? ordenCompra.orden_compra_proveedor : undefined,
        page: 0,
        size: 20,
      })
      .pipe(
        map((response) => response?.content?.find((item) => item.flagEstado === '1')?.id),
        map((id) => this.parseNumericId(id))
      );
  }

  private resolverSucursalId(ordenCompra: OrdenCompraEntity): Observable<number> {
    if (ordenCompra['sucursalId']) {
      return of(this.parseNumericId(ordenCompra['sucursalId']));
    }

    const user = this.storage.getUser<SessionUserLike>();
    if (user?.sucursalId) {
      return of(this.parseNumericId(user.sucursalId));
    }

    if (this.esNumeroValido(ordenCompra.orden_compra_sucursal)) {
      return of(this.parseNumericId(ordenCompra.orden_compra_sucursal));
    }

    if (!user?.empresaId) {
      throw new Error('No se pudo resolver la sucursal para la orden de compra');
    }

    return this.api
      .get<SucursalDto[]>(`/core/empresas/${user.empresaId}/sucursales`, { page: 0, size: 100 })
      .pipe(
        map((sucursales) =>
          sucursales.find(
            (item) =>
              item.flagEstado !== '0' &&
              this.coincideTexto(item.nombre, ordenCompra.orden_compra_sucursal)
          )?.id
        ),
        map((id) => this.parseNumericId(id))
      );
  }

  private resolverMonedaId(ordenCompra: OrdenCompraEntity): Observable<number> {
    if (ordenCompra['monedaId']) {
      return of(this.parseNumericId(ordenCompra['monedaId']));
    }

    return this.api.get<MonedaDto[]>('/core/monedas').pipe(
      map((monedas) =>
        monedas.find(
          (item) =>
            item.flagEstado !== '0' &&
            (this.coincideTexto(item.codigo, ordenCompra.orden_compra_moneda) ||
              this.coincideTexto(item.nombre, ordenCompra.orden_compra_moneda))
        )?.id
      ),
      map((id) => this.parseNumericId(id ?? this.mapMonedaNombreAId(ordenCompra.orden_compra_moneda)))
    );
  }

  private resolverArticuloId(linea: ArticuloEntity & Record<string, unknown>): Observable<number> {
    if (linea['articuloId']) {
      return of(this.parseNumericId(linea['articuloId']));
    }

    return this.api
      .get<ArticuloPageDto>('/core/articulos', {
        codigo: linea.det_orden_compra_codigo,
        nombre: !linea.det_orden_compra_codigo ? linea.det_orden_compra_descripcion : undefined,
        page: 0,
        size: 20,
      })
      .pipe(
        map((response) => response?.content?.find((item) => item.flagEstado !== '0')?.id),
        map((id) => this.parseNumericId(id))
      );
  }

  private resolverDatosArticulo(
    articuloId: number,
    proveedorId: number,
    monedaId: number,
    sucursalId: number,
    fechaEmision: string
  ): Observable<DatosArticuloDto | null> {
    return this.api
      .get<DatosArticuloDto>('/compras/ordenes-compra/datos-articulo', {
        articuloId,
        proveedorId,
        monedaId,
        sucursalId,
        fechaEmision,
      })
      .pipe(
        map((data) => data ?? null),
        catchError(() => of(null))
      );
  }

  private enviarOrdenAAprobacion(detalle: OrdenCompraDetalleDto): Observable<OrdenCompraDetalleDto> {
    const ordenId = this.parseNumericId(detalle.id);
    return this.api.post<OrdenCompraDetalleDto>(`/compras/ordenes-compra/${ordenId}/enviar-aprobacion`, {}).pipe(
      // Si el tenant tiene el flujo de aprobación desactivado (COMPRA_APROBACION_OC=0),
      // el backend responde COM-035. En ese caso la OC ya quedó creada y activa, así que
      // no es un error: se devuelve la orden creada para que el guardado sea exitoso.
      catchError((error: any) => {
        const code = error?.error?.errorCode ?? '';
        const msg = String(error?.error?.message ?? '');
        if (code === 'COM-035' || msg.includes('COMPRA_APROBACION_OC')) {
          return of(detalle);
        }
        return throwError(() => error);
      })
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
    if ((monedaCodigo ?? '').toUpperCase() === 'USD') {
      return 'Dólares';
    }
    return 'Soles';
  }

  private mapMonedaNombreAId(moneda?: string): number {
    const valor = this.normalizarTexto(moneda);
    if (!valor) {
      return 1;
    }
    return valor.includes('dolar') || valor === 'usd' ? 2 : 1;
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

  private parseOptionalDecimal(value: unknown): number | null {
    if (value === undefined || value === null || value === '') {
      return null;
    }

    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : null;
  }

  private extraerResumenes(response: OrdenCompraResumenDto[] | OrdenCompraResumenPageDto | null | undefined): OrdenCompraResumenDto[] {
    if (Array.isArray(response)) {
      return response;
    }

    if (Array.isArray(response?.content)) {
      return response.content;
    }

    return [];
  }

  private crearMapaAlmacenes(response: AlmacenDto[] | { content?: AlmacenDto[] } | null | undefined): Map<number, string> {
    const almacenes = Array.isArray(response)
      ? response
      : Array.isArray(response?.content)
        ? response.content
        : [];

    return new Map(
      almacenes
        .filter((item) => item?.id && item.flagEstado !== '0')
        .map((item) => [Number(item.id), item.nombre ?? item.codigo ?? String(item.id)])
    );
  }

  private crearMapaSucursales(response: SucursalDto[] | SucursalPageDto | null | undefined): Map<number, string> {
    const sucursales = Array.isArray(response)
      ? response
      : Array.isArray(response?.content)
        ? response.content
        : [];

    return new Map(
      sucursales
        .filter((item) => item?.id && item.flagEstado !== '0')
        .map((item) => [Number(item.id), item.nombre ?? item.codigo ?? String(item.id)])
    );
  }

  private crearMapaFormasPago(response: FormaPagoDto[] | FormaPagoPageDto | null | undefined): Map<number, string> {
    const formasPago = Array.isArray(response)
      ? response
      : Array.isArray(response?.content)
        ? response.content
        : [];

    return new Map(
      formasPago
        .filter((item) => item?.id && item.flagEstado !== '0')
        .map((item) => [Number(item.id), item.nombre ?? item.codigo ?? String(item.id)])
    );
  }

  private fechaHoyIso(): string {
    return new Date().toISOString().slice(0, 10);
  }

  private coincideTexto(source: string | undefined, target: string | undefined): boolean {
    return this.normalizarTexto(source) === this.normalizarTexto(target);
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

