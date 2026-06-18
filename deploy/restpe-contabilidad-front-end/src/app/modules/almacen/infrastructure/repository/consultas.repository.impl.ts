import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay } from 'rxjs';
import { map } from 'rxjs/operators';
import { IConsultasRepository } from '../../domain/repositories/iconsultas.repository';
import { ArticuloConsultaEntity } from '../../domain/models/articulo-consulta.entity';
import { OrdenCompraConsultaEntity } from '../../domain/models/orden-compra-consulta.entity';
import { DevolucionConsultaEntity } from '../../domain/models/devolucion-consulta.entity';
import { KardexConsultaEntity } from '../../domain/models/kardex-consulta.entity';
import { PrestamoConsultaEntity } from '../../domain/models/prestamo-consulta.entity';
import { AlmacenHttpService } from '../http/almacen-http.service';
import { ALMACEN_ENDPOINTS } from '../http/almacen-api.config';
import { BackendKardexResponse, BackendStockResponse } from '../../application/dto/almacen-backend.types';

/**
 * Consultas de almacén.
 *
 * HÍBRIDO: artículos (stock) y kardex consumen `ms-almacen`; las consultas sin
 * backend en almacén (órdenes de compra y devoluciones → ms-compras; préstamos
 * → no modelado) siguen leyendo su JSON mock para no romper las pantallas.
 */
@Injectable({ providedIn: 'root' })
export class ConsultasRepositoryImpl implements IConsultasRepository {

  private readonly api = inject(AlmacenHttpService);
  private readonly http = inject(HttpClient);

  private readonly JSON_ORDENES_COMPRA = 'assets/data/almacen/consultas/consulta-ordenes-compra.json';
  private readonly JSON_DEVOLUCIONES = 'assets/data/almacen/consultas/consulta-devoluciones.json';
  private readonly JSON_PRESTAMOS = 'assets/data/almacen/consultas/consulta-prestamos.json';

  // ── Conectados al backend ──────────────────────────────────────────────

  obtenerConsultaArticulos(): Observable<ArticuloConsultaEntity[]> {
    return this.api
      .getList<BackendStockResponse>(ALMACEN_ENDPOINTS.stock, { size: 1000 })
      .pipe(map((rows) => rows.map((r) => this.toArticulo(r))));
  }

  obtenerConsultaKardex(): Observable<KardexConsultaEntity[]> {
    return this.api
      .getList<BackendKardexResponse>(ALMACEN_ENDPOINTS.kardex, { size: 1000, sort: 'fecha,desc' })
      .pipe(map((rows) => rows.map((r) => this.toKardex(r))));
  }

  // ── Sin backend en almacén: mock JSON ────────────────────────────────────

  obtenerConsultaOrdenesCompra(): Observable<OrdenCompraConsultaEntity[]> {
    return this.http.get<OrdenCompraConsultaEntity[]>(this.JSON_ORDENES_COMPRA).pipe(delay(300));
  }

  obtenerConsultaDevoluciones(): Observable<DevolucionConsultaEntity[]> {
    return this.http.get<DevolucionConsultaEntity[]>(this.JSON_DEVOLUCIONES).pipe(delay(300));
  }

  obtenerConsultaPrestamos(): Observable<PrestamoConsultaEntity[]> {
    return this.http.get<PrestamoConsultaEntity[]>(this.JSON_PRESTAMOS).pipe(delay(300));
  }

  // ── Mappers ────────────────────────────────────────────────────────────

  private toArticulo(r: BackendStockResponse): ArticuloConsultaEntity {
    const stock = r.cantidadTotal ?? r.cantidadDisponible ?? 0;
    return {
      almacen_codigo: r.almacenId != null ? String(r.almacenId) : '',
      nombre: r.articuloId != null ? String(r.articuloId) : '',
      codBarras: '',
      medida: '',
      categoria: '',
      stockActual: Number(stock),
      precioVenta: 0,
      precioCompra: Number(r.costoPromedio ?? 0),
      estado: '',
      usuarioResponsable: '',
      almacenPrincipal: r.almacenId != null ? String(r.almacenId) : '',
      puntoReposicion: 0,
      proveedorHabitual: '',
      impuestoA: 0,
      naturalezaC: '',
      cuentaCI: '',
      cuentaCV: '',
      unidad: '',
    };
  }

  private toKardex(r: BackendKardexResponse): KardexConsultaEntity {
    const cant = Number(r.cantidad ?? 0);
    return {
      almacen_codigo: r.almacenId != null ? String(r.almacenId) : '',
      kardex_consulta_nombre: r.articuloNombre ?? (r.articuloId != null ? String(r.articuloId) : ''),
      kardex_consulta_categoria: '',
      kardex_consulta_medida: '',
      kardex_consulta_almacen: r.almacenId != null ? String(r.almacenId) : '',
      stkInicial: 0,
      ingresos: cant >= 0 ? cant : 0,
      salidas: cant < 0 ? Math.abs(cant) : 0,
      stkFinal: Number(r.saldoCantidad ?? 0),
      costoProm: Number(r.saldoCostoUnitario ?? r.costoUnitario ?? 0),
      valorTotal: Number(r.saldoCostoTotal ?? 0),
      fMov: r.fecha ?? '',
      tipoMov: r.tipo ?? '',
    };
  }
}
