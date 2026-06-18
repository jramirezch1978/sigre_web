import { AlmacenEntity } from '../domain/models/almacen.entity';
import { CatalogosEntity, TransferenciaEntity, ComparacionInventarioEntity } from '../domain/models/catalogo.entity';
import { TomaInventarioEntity } from '../domain/models/toma-inventario.entity';
import { ValorizacionProductoEntity } from '../domain/models/valorizacion-producto.entity';
import { ProductoVendidoEntity } from '../domain/models/producto-vendido.entity';
import { StockMinimoEntity } from '../domain/models/stock-minimo.entity';
import { StockFechaEntity } from '../domain/models/stock-fecha.entity';
import { HistorialVencimientoEntity } from '../domain/models/historial-vencimiento.entity';
import { DiagnosticoAlmacenEntity } from '../domain/models/diagnostico-almacen.entity';
import { ArticuloConsultaEntity } from '../domain/models/articulo-consulta.entity';
import { OrdenCompraConsultaEntity } from '../domain/models/orden-compra-consulta.entity';
import { DevolucionConsultaEntity } from '../domain/models/devolucion-consulta.entity';
import { KardexConsultaEntity } from '../domain/models/kardex-consulta.entity';
import { PrestamoConsultaEntity } from '../domain/models/prestamo-consulta.entity';
import { RecepcionAlmacenamientoEntity } from '../domain/models/recepcion-almacenamiento.entity';
import { DespachoEntity } from '../domain/models/despacho.entity';
import { GestionDevolucionEntity } from '../domain/models/gestion-devolucion.entity';
import { RecepcionTransferenciaEntity } from '../domain/models/recepcion-transferencia.entity';
import { RegistroPerdidasEntity } from '../domain/models/registro-perdidas.entity';
import { ProductoAlmacenEntity } from '../domain/models/producto-almacen.entity';
import { ReposicionStockEntity } from '../domain/models/reposicion-stock.entity';
import { RecalculoPrecioEntity } from '../domain/models/recalculo-precio.entity';
import { CategoriaArticuloEntity } from '../domain/models/categoria-articulo.entity';
import { MaestroProductoEntity } from '../domain/models/maestro-producto.entity';
import { MovAlmacenEntity } from '../domain/models/mov-almacen.entity';
import { ReqTrasladoEntity } from '../domain/models/req-traslado.entity';
import { CuadreStockEntity } from '../domain/models/cuadre-stock.entity';
import { MovimientoCuadreStockEntity } from '../domain/models/movimiento-cuadre-stock.entity';
import { ActualizacionProductoEntity } from '../domain/models/actualizacion-producto.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface AlmacenState {
  almacenes: AlmacenEntity[];
  almacenSeleccionado: AlmacenEntity | null;

  // Datos de catálogos
  catalogos: CatalogosEntity | null;
  transferencias: TransferenciaEntity[];
  comparacionesInventario: ComparacionInventarioEntity[];

  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingEliminar: boolean;
  loadingActualizar: boolean;
  loadingCatalogos: boolean;
  loadingTransferencias: boolean;
  loadingComparaciones: boolean;

  errorObtener: string | null;
  errorGuardar: string | null;
  errorEliminar: string | null;
  errorActualizar: string | null;
  errorCatalogos: string | null;

  resultGuardar: ApiResponse<AlmacenEntity> | null;
  resultEliminar: ApiResponse<boolean> | null;
  resultActualizar: ApiResponse<AlmacenEntity> | null;

  // Reportes
  reporteTomas: TomaInventarioEntity[];
  loadingReporteTomas: boolean;
  errorReporteTomas: string | null;

  reporteValorizacion: ValorizacionProductoEntity[];
  loadingReporteValorizacion: boolean;
  errorReporteValorizacion: string | null;

  reporteVendidos: ProductoVendidoEntity[];
  loadingReporteVendidos: boolean;
  errorReporteVendidos: string | null;

  reporteStockMinimo: StockMinimoEntity[];
  loadingReporteStockMinimo: boolean;
  errorReporteStockMinimo: string | null;

  reporteStockFecha: StockFechaEntity[];
  loadingReporteStockFecha: boolean;
  errorReporteStockFecha: string | null;

  reporteHistorialVencimiento: HistorialVencimientoEntity[];
  loadingReporteHistorialVencimiento: boolean;
  errorReporteHistorialVencimiento: string | null;

  reporteDiagnosticoAlmacenes: DiagnosticoAlmacenEntity[];
  loadingReporteDiagnosticoAlmacenes: boolean;
  errorReporteDiagnosticoAlmacenes: string | null;

  // Consultas
  consultaArticulos: ArticuloConsultaEntity[];
  loadingConsultaArticulos: boolean;
  errorConsultaArticulos: string | null;

  consultaOrdenesCompra: OrdenCompraConsultaEntity[];
  loadingConsultaOrdenesCompra: boolean;
  errorConsultaOrdenesCompra: string | null;

  consultaDevoluciones: DevolucionConsultaEntity[];
  loadingConsultaDevoluciones: boolean;
  errorConsultaDevoluciones: string | null;

  consultaKardex: KardexConsultaEntity[];
  loadingConsultaKardex: boolean;
  errorConsultaKardex: string | null;

  consultaPrestamos: PrestamoConsultaEntity[];
  loadingConsultaPrestamos: boolean;
  errorConsultaPrestamos: string | null;

  // Operaciones
  recepcionesAlmacenamiento: RecepcionAlmacenamientoEntity[];
  loadingRecepcionesAlmacenamiento: boolean;
  errorRecepcionesAlmacenamiento: string | null;

  despachos: DespachoEntity[];
  loadingDespachos: boolean;
  errorDespachos: string | null;

  gestionesDevoluciones: GestionDevolucionEntity[];
  loadingGestionesDevoluciones: boolean;
  errorGestionesDevoluciones: string | null;

  recepcionesTransferencia: RecepcionTransferenciaEntity[];
  loadingRecepcionesTransferencia: boolean;
  errorRecepcionesTransferencia: string | null;

  registroPerdidas: RegistroPerdidasEntity[];
  loadingRegistroPerdidas: boolean;
  errorRegistroPerdidas: string | null;

  productosAlmacen: ProductoAlmacenEntity[];
  loadingProductosAlmacen: boolean;
  errorProductosAlmacen: string | null;

  reposicionesStock: ReposicionStockEntity[];
  loadingReposicionesStock: boolean;
  errorReposicionesStock: string | null;

  productosReposicionStock: ProductoAlmacenEntity[];
  loadingProductosReposicionStock: boolean;
  errorProductosReposicionStock: string | null;

  recalculoPrecios: RecalculoPrecioEntity[];
  loadingRecalculoPrecios: boolean;
  errorRecalculoPrecios: string | null;

  // Tablas - Clasificación de artículos
  clasificacionArticulos: CategoriaArticuloEntity[];
  loadingClasificacionArticulos: boolean;
  errorClasificacionArticulos: string | null;

  // Tablas - Maestro de productos
  maestroProductos: MaestroProductoEntity[];
  loadingMaestroProductos: boolean;
  errorMaestroProductos: string | null;

  // Tablas - Movimientos de almacén
  movAlmacenes: MovAlmacenEntity[];
  loadingMovAlmacenes: boolean;
  errorMovAlmacenes: string | null;

  // Operaciones - Requerimientos de traslado
  reqTraslados: ReqTrasladoEntity[];
  loadingReqTraslados: boolean;
  errorReqTraslados: string | null;

  // Procesos - Cuadre de stock
  cuadreStock: CuadreStockEntity[];
  loadingCuadreStock: boolean;
  errorCuadreStock: string | null;

  movimientosCuadreStock: MovimientoCuadreStockEntity[];
  loadingMovimientosCuadreStock: boolean;
  errorMovimientosCuadreStock: string | null;

  // Procesos - Actualización de precios de productos
  actualizacionProductos: ActualizacionProductoEntity[];
  loadingActualizacionProductos: boolean;
  errorActualizacionProductos: string | null;
}

export const initialAlmacenState: AlmacenState = {
  almacenes: [],
  almacenSeleccionado: null,

  catalogos: null,
  transferencias: [],
  comparacionesInventario: [],

  loadingObtener: false,
  loadingGuardar: false,
  loadingEliminar: false,
  loadingActualizar: false,
  loadingCatalogos: false,
  loadingTransferencias: false,
  loadingComparaciones: false,

  errorObtener: null,
  errorGuardar: null,
  errorEliminar: null,
  errorActualizar: null,
  errorCatalogos: null,

  resultGuardar: null,
  resultEliminar: null,
  resultActualizar: null,

  reporteTomas: [],
  loadingReporteTomas: false,
  errorReporteTomas: null,

  reporteValorizacion: [],
  loadingReporteValorizacion: false,
  errorReporteValorizacion: null,

  reporteVendidos: [],
  loadingReporteVendidos: false,
  errorReporteVendidos: null,

  reporteStockMinimo: [],
  loadingReporteStockMinimo: false,
  errorReporteStockMinimo: null,

  reporteStockFecha: [],
  loadingReporteStockFecha: false,
  errorReporteStockFecha: null,

  reporteHistorialVencimiento: [],
  loadingReporteHistorialVencimiento: false,
  errorReporteHistorialVencimiento: null,

  reporteDiagnosticoAlmacenes: [],
  loadingReporteDiagnosticoAlmacenes: false,
  errorReporteDiagnosticoAlmacenes: null,

  consultaArticulos: [],
  loadingConsultaArticulos: false,
  errorConsultaArticulos: null,

  consultaOrdenesCompra: [],
  loadingConsultaOrdenesCompra: false,
  errorConsultaOrdenesCompra: null,

  consultaDevoluciones: [],
  loadingConsultaDevoluciones: false,
  errorConsultaDevoluciones: null,

  consultaKardex: [],
  loadingConsultaKardex: false,
  errorConsultaKardex: null,

  consultaPrestamos: [],
  loadingConsultaPrestamos: false,
  errorConsultaPrestamos: null,

  recepcionesAlmacenamiento: [],
  loadingRecepcionesAlmacenamiento: false,
  errorRecepcionesAlmacenamiento: null,

  despachos: [],
  loadingDespachos: false,
  errorDespachos: null,

  gestionesDevoluciones: [],
  loadingGestionesDevoluciones: false,
  errorGestionesDevoluciones: null,

  recepcionesTransferencia: [],
  loadingRecepcionesTransferencia: false,
  errorRecepcionesTransferencia: null,

  registroPerdidas: [],
  loadingRegistroPerdidas: false,
  errorRegistroPerdidas: null,

  productosAlmacen: [],
  loadingProductosAlmacen: false,
  errorProductosAlmacen: null,

  reposicionesStock: [],
  loadingReposicionesStock: false,
  errorReposicionesStock: null,

  productosReposicionStock: [],
  loadingProductosReposicionStock: false,
  errorProductosReposicionStock: null,

  recalculoPrecios: [],
  loadingRecalculoPrecios: false,
  errorRecalculoPrecios: null,

  clasificacionArticulos: [],
  loadingClasificacionArticulos: false,
  errorClasificacionArticulos: null,

  maestroProductos: [],
  loadingMaestroProductos: false,
  errorMaestroProductos: null,

  movAlmacenes: [],
  loadingMovAlmacenes: false,
  errorMovAlmacenes: null,

  reqTraslados: [],
  loadingReqTraslados: false,
  errorReqTraslados: null,

  cuadreStock: [],
  loadingCuadreStock: false,
  errorCuadreStock: null,

  movimientosCuadreStock: [],
  loadingMovimientosCuadreStock: false,
  errorMovimientosCuadreStock: null,

  actualizacionProductos: [],
  loadingActualizacionProductos: false,
  errorActualizacionProductos: null,
};
