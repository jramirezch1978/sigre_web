import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay } from 'rxjs';
import { map } from 'rxjs/operators';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { TomaInventarioEntity } from '../../domain/models/toma-inventario.entity';
import { ValorizacionProductoEntity } from '../../domain/models/valorizacion-producto.entity';
import { ProductoVendidoEntity } from '../../domain/models/producto-vendido.entity';
import { StockMinimoEntity } from '../../domain/models/stock-minimo.entity';
import { StockFechaEntity } from '../../domain/models/stock-fecha.entity';
import { HistorialVencimientoEntity } from '../../domain/models/historial-vencimiento.entity';
import { DiagnosticoAlmacenEntity } from '../../domain/models/diagnostico-almacen.entity';
import { ComparacionInventarioEntity } from '../../domain/models/catalogo.entity';
import { DespachoEntity } from '../../domain/models/despacho.entity';
import { GestionDevolucionEntity } from '../../domain/models/gestion-devolucion.entity';
import { RecepcionTransferenciaEntity } from '../../domain/models/recepcion-transferencia.entity';
import { RegistroPerdidasEntity } from '../../domain/models/registro-perdidas.entity';
import { ProductoAlmacenEntity } from '../../domain/models/producto-almacen.entity';
import { ReposicionStockEntity } from '../../domain/models/reposicion-stock.entity';
import { RecalculoPrecioEntity } from '../../domain/models/recalculo-precio.entity';
import { CategoriaArticuloEntity } from '../../domain/models/categoria-articulo.entity';
import { MaestroProductoEntity } from '../../domain/models/maestro-producto.entity';
import { MovAlmacenEntity } from '../../domain/models/mov-almacen.entity';
import { ReqTrasladoEntity } from '../../domain/models/req-traslado.entity';
import { CuadreStockEntity } from '../../domain/models/cuadre-stock.entity';
import { MovimientoCuadreStockEntity } from '../../domain/models/movimiento-cuadre-stock.entity';
import { ActualizacionProductoEntity } from '../../domain/models/actualizacion-producto.entity';
import { AlmacenHttpService } from '../http/almacen-http.service';
import { ALMACEN_ENDPOINTS } from '../http/almacen-api.config';
import {
  BackendComparacionInventarioResponse,
  BackendDiagnosticoResponse,
  BackendInventarioConteoResponse,
  BackendLoteVencimientoResponse,
  BackendMovimientoListItem,
  BackendOrdenTrasladoResponse,
  BackendPerdidaResponse,
  BackendStockAFechaResponse,
  BackendStockResponse,
  BackendValorizacionResponse,
} from '../../application/dto/almacen-backend.types';

/**
 * Reportes de almacén.
 *
 * HÍBRIDO: los reportes con endpoint en `ms-almacen` consumen el backend real;
 * los que aún no tienen backend (o son de otro microservicio: ms-ventas,
 * ms-core-maestros) siguen leyendo su JSON mock en `assets/data/...` para no
 * romper las pantallas que dependen de esos datos. Migrar a HTTP a medida que
 * existan los endpoints (ver PENDIENTES_FRONT_ALMACEN.md).
 */
@Injectable({ providedIn: 'root' })
export class ReportesRepositoryImpl implements IReportesRepository {

  private readonly api = inject(AlmacenHttpService);
  private readonly http = inject(HttpClient);

  // Rutas de mock para reportes/pantallas sin backend propio todavía.
  private readonly JSON_VENDIDOS = 'assets/data/almacen/reportes/reporte-vendidos.json';
  private readonly JSON_STOCK_MINIMO = 'assets/data/almacen/reportes/reporte-stock-minimo.json';
  private readonly JSON_GESTION_DEV = 'assets/data/almacen/operaciones/gestion-devolucion.json';
  private readonly JSON_REPOSICIONES = 'assets/data/almacen/operaciones/reposicion-stock.json';
  private readonly JSON_RECALCULO = 'assets/data/almacen/procesos/recalculo-precios.json';
  private readonly JSON_CLASIFICACION = 'assets/data/apartado-almacen/modulo-almacen-tablas/clasificacion-articulos.json';
  private readonly JSON_MAESTRO_PRODUCTOS = 'assets/data/apartado-almacen/modulo-almacen-tablas/maestro-productos.json';
  private readonly JSON_CUADRE = 'assets/data/almacen/procesos/cuadre-stock.json';
  private readonly JSON_MOV_CUADRE = 'assets/data/almacen/procesos/cuadre-stock-movimientos.json';
  private readonly JSON_ACTUALIZACION = 'assets/data/almacen/procesos/actualizacion-producto.json';

  // ── Conectados al backend ──────────────────────────────────────────────

  obtenerReporteTomas(): Observable<TomaInventarioEntity[]> {
    return this.api
      .getList<BackendInventarioConteoResponse>(ALMACEN_ENDPOINTS.tomasInventario, { size: 1000 })
      .pipe(map((rows) => rows.map((r) => this.toToma(r))));
  }

  obtenerReporteValorizacion(): Observable<ValorizacionProductoEntity[]> {
    return this.api
      .getList<BackendValorizacionResponse>(ALMACEN_ENDPOINTS.reportes.valorizacion, { size: 1000 })
      .pipe(map((rows) => rows.map((r) => this.toValorizacion(r))));
  }

  obtenerReporteHistorialVencimiento(): Observable<HistorialVencimientoEntity[]> {
    return this.api
      .getList<BackendLoteVencimientoResponse>(ALMACEN_ENDPOINTS.reportes.lotesPorVencer, { dias: 3650, size: 1000 })
      .pipe(map((rows) => rows.map((r) => this.toVencimiento(r))));
  }

  obtenerProductosAlmacen(): Observable<ProductoAlmacenEntity[]> {
    return this.api
      .getList<BackendStockResponse>(ALMACEN_ENDPOINTS.stock, { size: 1000 })
      .pipe(map((rows) => rows.map((r) => this.toProductoAlmacen(r))));
  }

  obtenerProductosReposicionStock(): Observable<ProductoAlmacenEntity[]> {
    return this.obtenerProductosAlmacen();
  }

  obtenerMovAlmacenes(): Observable<MovAlmacenEntity[]> {
    return this.api
      .getList<BackendMovimientoListItem>(ALMACEN_ENDPOINTS.movimientos, { size: 1000, sort: 'fechaMov,desc' })
      .pipe(map((rows) => rows.map((r) => this.toMovAlmacen(r))));
  }

  /** PDF (vale de movimiento, Jasper) — `GET /api/almacen/movimientos/pdf/{id}`. HU §18.9. */
  descargarMovimientoPdf(id: number): Observable<Blob> {
    return this.api.getBlob(`${ALMACEN_ENDPOINTS.movimientos}/pdf/${id}`);
  }

  obtenerRecepcionesTransferencia(): Observable<RecepcionTransferenciaEntity[]> {
    return this.api
      .getList<BackendOrdenTrasladoResponse>(ALMACEN_ENDPOINTS.ordenesTraslado, { size: 1000, sort: 'id,desc' })
      .pipe(map((rows) => rows.map((r) => this.toRecepcionTransferencia(r))));
  }

  obtenerReqTraslados(): Observable<ReqTrasladoEntity[]> {
    return this.api
      .getList<BackendOrdenTrasladoResponse>(ALMACEN_ENDPOINTS.ordenesTraslado, { size: 1000, sort: 'id,desc' })
      .pipe(map((rows) => rows.map((r) => this.toReqTraslado(r))));
  }

  obtenerDespachos(): Observable<DespachoEntity[]> {
    return this.api
      .getList<BackendMovimientoListItem>(ALMACEN_ENDPOINTS.movimientos, {
        tipoReferenciaOrigen: 'OV',
        size: 1000,
        sort: 'fechaMov,desc',
      })
      .pipe(map((rows) => rows.map((r) => this.toDespacho(r))));
  }

  // ── Sin backend aún: mock JSON (no romper pantallas existentes) ──────────

  obtenerReporteVendidos(): Observable<ProductoVendidoEntity[]> {
    return this.http.get<ProductoVendidoEntity[]>(this.JSON_VENDIDOS).pipe(delay(300));
  }
  obtenerReporteStockMinimo(): Observable<StockMinimoEntity[]> {
    return this.http.get<StockMinimoEntity[]>(this.JSON_STOCK_MINIMO).pipe(delay(300));
  }
  obtenerReporteStockFecha(): Observable<StockFechaEntity[]> {
    return this.api
      .getList<BackendStockAFechaResponse>(ALMACEN_ENDPOINTS.reportes.stockAFecha, { size: 1000 })
      .pipe(map((rows) => rows.map((r) => this.toStockFecha(r))));
  }
  obtenerReporteDiagnosticoAlmacenes(): Observable<DiagnosticoAlmacenEntity[]> {
    return this.api
      .get<BackendDiagnosticoResponse[]>(ALMACEN_ENDPOINTS.reportes.diagnostico)
      .pipe(map((rows) => (rows ?? []).map((r) => this.toDiagnostico(r))));
  }
  obtenerComparacionesInventario(): Observable<ComparacionInventarioEntity[]> {
    return this.api
      .getList<BackendComparacionInventarioResponse>(ALMACEN_ENDPOINTS.reportes.comparacionInventario, { size: 1000 })
      .pipe(map((rows) => rows.map((r) => this.toComparacion(r))));
  }
  obtenerGestionesDevoluciones(): Observable<GestionDevolucionEntity[]> {
    return this.http.get<GestionDevolucionEntity[]>(this.JSON_GESTION_DEV).pipe(delay(300));
  }
  obtenerRegistroPerdidas(): Observable<RegistroPerdidasEntity[]> {
    return this.api
      .getList<BackendPerdidaResponse>(ALMACEN_ENDPOINTS.reportes.perdidas, { size: 1000, sort: 'id,desc' })
      .pipe(map((rows) => rows.map((r) => this.toRegistroPerdidas(r))));
  }
  obtenerReposicionesStock(): Observable<ReposicionStockEntity[]> {
    return this.http.get<ReposicionStockEntity[]>(this.JSON_REPOSICIONES).pipe(delay(300));
  }
  obtenerRecalculoPrecios(): Observable<RecalculoPrecioEntity[]> {
    return this.http.get<RecalculoPrecioEntity[]>(this.JSON_RECALCULO).pipe(delay(300));
  }
  obtenerClasificacionArticulos(): Observable<CategoriaArticuloEntity[]> {
    return this.http.get<CategoriaArticuloEntity[]>(this.JSON_CLASIFICACION).pipe(delay(300));
  }
  obtenerMaestroProductos(): Observable<MaestroProductoEntity[]> {
    return this.http.get<MaestroProductoEntity[]>(this.JSON_MAESTRO_PRODUCTOS).pipe(delay(300));
  }
  obtenerCuadreStock(): Observable<CuadreStockEntity[]> {
    return this.http.get<CuadreStockEntity[]>(this.JSON_CUADRE).pipe(delay(300));
  }
  obtenerMovimientosCuadreStock(): Observable<MovimientoCuadreStockEntity[]> {
    return this.http.get<MovimientoCuadreStockEntity[]>(this.JSON_MOV_CUADRE).pipe(delay(300));
  }
  obtenerActualizacionProductos(): Observable<ActualizacionProductoEntity[]> {
    return this.http.get<ActualizacionProductoEntity[]>(this.JSON_ACTUALIZACION).pipe(delay(300));
  }

  // ── Mappers backend → entidad ──────────────────────────────────────────

  private toToma(r: BackendInventarioConteoResponse): TomaInventarioEntity {
    return {
      toma_inventario_codigo: r.id != null ? String(r.id) : '',
      toma_inventario_producto: r.articuloId != null ? String(r.articuloId) : '',
      toma_inventario_observacion: '',
      toma_inventario_categoria: '',
      toma_inventario_medida: '',
      toma_inventario_stock_fisico: Number(r.cantidadConteo1 ?? 0),
      toma_inventario_stock_sistema: Number(r.saldoSistema ?? 0),
      toma_inventario_diferencia: Number(r.diferencia ?? 0),
      toma_inventario_diferencia_valor: Number(r.diferencia ?? 0) * Number(r.costoUnitario ?? 0),
      toma_inventario_tipo_diferencia: '',
      toma_inventario_almacen: r.almacenId != null ? String(r.almacenId) : '',
      toma_inventario_persona_responsable: '',
      toma_inventario_ultimo_cambio: r.fechaConteo ?? '',
      toma_inventario_condicion: r.flagEstado ?? '',
    };
  }

  private toValorizacion(r: BackendValorizacionResponse): ValorizacionProductoEntity {
    const cant = Number(r.cantidadDisponible ?? 0);
    const costo = Number(r.costoPromedio ?? 0);
    const total = Number(r.valorTotal ?? cant * costo);
    return {
      valorizacion_producto_codigo: r.articuloCodigo ?? (r.articuloId != null ? String(r.articuloId) : ''),
      valorizacion_producto_producto: r.articuloNombre ?? '',
      valorizacion_producto_categoria: '',
      valorizacion_producto_medida: '',
      valorizacion_producto_ultimo_cambio: r.ultimaActualizacion ?? '',
      valorizacion_producto_almacen: r.almacenId != null ? String(r.almacenId) : '',
      valorizacion_producto_cantidad_stock: cant,
      valorizacion_producto_metodo_valorizacion: 'PROMEDIO',
      valorizacion_producto_estado: '',
      valorizacion_producto_costo_unitario: costo,
      valorizacion_producto_valor_total_stock: total,
    };
  }

  private toVencimiento(r: BackendLoteVencimientoResponse): HistorialVencimientoEntity {
    return new HistorialVencimientoEntity({
      historial_vencimiento_fecha_registro: r.fechaVencimiento ?? '',
      historial_vencimiento_codigo: r.articuloCodigo ?? (r.articuloId != null ? String(r.articuloId) : ''),
      historial_vencimiento_producto: r.articuloNombre ?? '',
      historial_vencimiento_almacen: r.almacenId != null ? String(r.almacenId) : '',
      historial_vencimiento_documento_origen: r.nroLote ?? '',
    });
  }

  private toProductoAlmacen(r: BackendStockResponse): ProductoAlmacenEntity {
    return {
      producto_id: r.articuloId != null ? String(r.articuloId) : '',
      producto_nombre: r.articuloId != null ? String(r.articuloId) : '',
      producto_medida: '',
      producto_stock_actual: Number(r.cantidadTotal ?? r.cantidadDisponible ?? 0),
      producto_stock_minimo: 0,
      producto_valor_unitario: Number(r.costoPromedio ?? 0),
    };
  }

  private toMovAlmacen(r: BackendMovimientoListItem): MovAlmacenEntity {
    return {
      mov_almacen_id: r.id ?? null,
      mov_almacen_codigo: r.nroVale ?? (r.id != null ? String(r.id) : ''),
      mov_almacen_fecha_registro: r.fechaMov ?? '',
      mov_almacen_tipo: r.articuloMovTipoId != null ? String(r.articuloMovTipoId) : '',
      mov_almacen_almacen_asociado: r.almacenId != null ? String(r.almacenId) : '',
      mov_almacen_afecta_inventario: '',
      mov_almacen_motivo: r.tipoReferenciaOrigen ?? '',
      mov_almacen_afecta_valor: '',
      mov_almacen_estado: r.flagEstado ?? '',
    };
  }

  private toRecepcionTransferencia(r: BackendOrdenTrasladoResponse): RecepcionTransferenciaEntity {
    return {
      nroTransferencia: r.numero ?? String(r.id),
      fechaEnvio: r.fecha ?? '',
      fechaRecepcion: '',
      cantidadEnviada: 0,
      cantidadRecibida: 0,
      diferencia: 0,
      origen: r.almacenOrigenId != null ? String(r.almacenOrigenId) : '',
      destino: r.almacenDestinoId != null ? String(r.almacenDestinoId) : '',
      recepcion_transferencia_estado: r.flagEstado ?? '',
    };
  }

  private toReqTraslado(r: BackendOrdenTrasladoResponse): ReqTrasladoEntity {
    return {
      req_traslado_id: String(r.id),
      req_traslado_nro: r.numero ?? String(r.id),
      req_traslado_fecha_registro: r.fecha ?? '',
      req_traslado_origen: r.almacenOrigenId != null ? String(r.almacenOrigenId) : '',
      req_traslado_destino: r.almacenDestinoId != null ? String(r.almacenDestinoId) : '',
      req_traslado_prioridad: '',
      req_traslado_centro_costo: '',
      req_traslado_motivo: r.observacion ?? '',
      req_traslado_estado: r.flagEstado ?? '',
    };
  }

  private toStockFecha(r: BackendStockAFechaResponse): StockFechaEntity {
    return new StockFechaEntity({
      stock_fecha_codigo: r.articuloCodigo ?? (r.articuloId != null ? String(r.articuloId) : ''),
      stock_fecha_producto: r.articuloNombre ?? '',
      stock_fecha_categoria: '',
      stock_fecha_medida: '',
      stock_fecha_ultimo_movimiento: r.ultimoMovimiento ?? '',
      stock_fecha_almacen: r.almacenId != null ? String(r.almacenId) : '',
      stock_fecha_stock_actual: Number(r.cantidad ?? 0),
      stock_fecha_estado: '',
      stock_fecha_valor_unitario: Number(r.costoUnitario ?? 0),
      stock_fecha_valor_total: Number(r.valorTotal ?? 0),
    });
  }

  private toDiagnostico(r: BackendDiagnosticoResponse): DiagnosticoAlmacenEntity {
    return {
      diagnostico_codigo: r.almacenCodigo ?? (r.almacenId != null ? String(r.almacenId) : ''),
      diagnostico_almacen: r.almacenNombre ?? (r.almacenId != null ? String(r.almacenId) : ''),
      diagnostico_ubicacion: '',
      diagnostico_responsable: '',
      diagnostico_valor_inventario: Number(r.valorInventario ?? 0),
      diagnostico_ocupacion: 0,
      diagnostico_rotacion_inventario: 0,
      diagnostico_dias_promedio_inventario: 0,
      diagnostico_baja_rotacion: 0,
      diagnostico_costo_almacenamiento: 0,
      diagnostico_ultimo_cambio: '',
      diagnostico_condicion: `${r.totalArticulos ?? 0} art. / ${r.totalUnidades ?? 0} und.`,
    };
  }

  private toComparacion(r: BackendComparacionInventarioResponse): ComparacionInventarioEntity {
    return {
      comparacion_inventario_codigo: r.id != null ? String(r.id) : '',
      comparacion_inventario_fecha_creacion: r.fechaConteo ?? '',
      comparacion_inventario_producto: r.articuloNombre ?? (r.articuloId != null ? String(r.articuloId) : ''),
      comparacion_inventario_almacen: r.almacenId != null ? String(r.almacenId) : '',
      comparacion_inventario_responsable: '',
      comparacion_inventario_observaciones:
        `Sistema: ${r.saldoSistema ?? 0} · Conteo: ${r.cantidadConteo ?? 0} · Dif: ${r.diferencia ?? 0}`,
      comparacion_inventario_estado: r.flagEstado ?? '',
      comparacion_inventario_observacion: '',
    };
  }

  private toRegistroPerdidas(r: BackendPerdidaResponse): RegistroPerdidasEntity {
    return {
      almacen_codigo: r.almacenId != null ? String(r.almacenId) : '',
      fechaR: r.fecha ?? '',
      codproducto: r.articuloCodigo ?? (r.articuloId != null ? String(r.articuloId) : ''),
      registro_perdidas_producto: r.articuloNombre ?? '',
      registro_perdidas_almacen: r.almacenId != null ? String(r.almacenId) : '',
      tipo: r.descTipoMov ?? r.tipoMov ?? '',
      cantidadP: Number(r.cantidadPerdida ?? 0),
      registro_perdidas_medida: '',
      valorU: String(r.costoUnitario ?? 0),
      valorT: String(r.valorPerdida ?? 0),
      registro_perdidas_responsable: '',
      registro_perdidas_estado: '',
    };
  }

  private toDespacho(r: BackendMovimientoListItem): DespachoEntity {
    return {
      despacho_codigo: r.nroVale ?? (r.id != null ? String(r.id) : ''),
      despacho_fecha: r.fechaMov ?? '',
      despacho_tipo: r.tipoReferenciaOrigen ?? '',
      despacho_destino: r.ordenVentaId != null ? String(r.ordenVentaId) : '',
      despacho_cantidad_solicitada: 0,
      despacho_cantidad_despachada: 0,
      despacho_diferencia: 0,
      despacho_almacen_origen: r.almacenId != null ? String(r.almacenId) : '',
      despacho_usuario: '',
      despacho_estado: r.flagEstado ?? '',
    };
  }
}
