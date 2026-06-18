import { Injectable, signal, computed } from '@angular/core';
import { AlmacenState, initialAlmacenState } from './almacen.state';
import { AlmacenEntity } from '../domain/models/almacen.entity';
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

@Injectable()
export class AlmacenStore {

  private readonly state = signal<AlmacenState>(initialAlmacenState);

  readonly almacenes = computed(() => this.state().almacenes);
  readonly almacenSeleccionado = computed(() => this.state().almacenSeleccionado);

  // Selectores de catálogos
  readonly catalogos = computed(() => this.state().catalogos);
  readonly transferencias = computed(() => this.state().transferencias);

  readonly comparacionesInventario = computed(() => this.state().comparacionesInventario);
  readonly reporteTomas = computed(() => this.state().reporteTomas);
  readonly reporteValorizacion = computed(() => this.state().reporteValorizacion);
  readonly reporteVendidos = computed(() => this.state().reporteVendidos);
  readonly reporteStockMinimo = computed(() => this.state().reporteStockMinimo);
  readonly reporteStockFecha = computed(() => this.state().reporteStockFecha);
  readonly reporteHistorialVencimiento = computed(() => this.state().reporteHistorialVencimiento);
  readonly reporteDiagnosticoAlmacenes = computed(() => this.state().reporteDiagnosticoAlmacenes);
  readonly consultaArticulos = computed(() => this.state().consultaArticulos);
  readonly consultaOrdenesCompra = computed(() => this.state().consultaOrdenesCompra);
  readonly consultaDevoluciones = computed(() => this.state().consultaDevoluciones);
  readonly consultaKardex = computed(() => this.state().consultaKardex);
  readonly consultaPrestamos = computed(() => this.state().consultaPrestamos);
  readonly recepcionesAlmacenamiento = computed(() => this.state().recepcionesAlmacenamiento);
  readonly despachos = computed(() => this.state().despachos);
  readonly loadingDespachos = computed(() => this.state().loadingDespachos);
  readonly gestionesDevoluciones = computed(() => this.state().gestionesDevoluciones);
  readonly loadingGestionesDevoluciones = computed(() => this.state().loadingGestionesDevoluciones);
  readonly recepcionesTransferencia = computed(() => this.state().recepcionesTransferencia);
  readonly loadingRecepcionesTransferencia = computed(() => this.state().loadingRecepcionesTransferencia);
  readonly registroPerdidas = computed(() => this.state().registroPerdidas);
  readonly loadingRegistroPerdidas = computed(() => this.state().loadingRegistroPerdidas);
  readonly productosAlmacen = computed(() => this.state().productosAlmacen);
  readonly loadingProductosAlmacen = computed(() => this.state().loadingProductosAlmacen);
  readonly reposicionesStock = computed(() => this.state().reposicionesStock);
  readonly loadingReposicionesStock = computed(() => this.state().loadingReposicionesStock);
  readonly productosReposicionStock = computed(() => this.state().productosReposicionStock);
  readonly loadingProductosReposicionStock = computed(() => this.state().loadingProductosReposicionStock);
  readonly recalculoPrecios = computed(() => this.state().recalculoPrecios);
  readonly loadingRecalculoPrecios = computed(() => this.state().loadingRecalculoPrecios);

  readonly clasificacionArticulos = computed(() => this.state().clasificacionArticulos);
  readonly loadingClasificacionArticulos = computed(() => this.state().loadingClasificacionArticulos);
  readonly errorClasificacionArticulos = computed(() => this.state().errorClasificacionArticulos);

  readonly maestroProductos = computed(() => this.state().maestroProductos);
  readonly loadingMaestroProductos = computed(() => this.state().loadingMaestroProductos);
  readonly errorMaestroProductos = computed(() => this.state().errorMaestroProductos);

  readonly movAlmacenes = computed(() => this.state().movAlmacenes);
  readonly loadingMovAlmacenes = computed(() => this.state().loadingMovAlmacenes);
  readonly errorMovAlmacenes = computed(() => this.state().errorMovAlmacenes);

  readonly reqTraslados = computed(() => this.state().reqTraslados);
  readonly loadingReqTraslados = computed(() => this.state().loadingReqTraslados);
  readonly errorReqTraslados = computed(() => this.state().errorReqTraslados);

  readonly cuadreStock = computed(() => this.state().cuadreStock);
  readonly loadingCuadreStock = computed(() => this.state().loadingCuadreStock);
  readonly errorCuadreStock = computed(() => this.state().errorCuadreStock);

  readonly movimientosCuadreStock = computed(() => this.state().movimientosCuadreStock);
  readonly loadingMovimientosCuadreStock = computed(() => this.state().loadingMovimientosCuadreStock);
  readonly errorMovimientosCuadreStock = computed(() => this.state().errorMovimientosCuadreStock);

  readonly actualizacionProductos = computed(() => this.state().actualizacionProductos);
  readonly loadingActualizacionProductos = computed(() => this.state().loadingActualizacionProductos);
  readonly errorActualizacionProductos = computed(() => this.state().errorActualizacionProductos);

  readonly loadingObtener = computed(() => this.state().loadingObtener);
  readonly loadingGuardar = computed(() => this.state().loadingGuardar);
  readonly loadingEliminar = computed(() => this.state().loadingEliminar);
  readonly loadingActualizar = computed(() => this.state().loadingActualizar);
  readonly loadingCatalogos = computed(() => this.state().loadingCatalogos);
  readonly loadingTransferencias = computed(() => this.state().loadingTransferencias);

  readonly loadingComparaciones = computed(() => this.state().loadingComparaciones);
  readonly loadingReporteTomas = computed(() => this.state().loadingReporteTomas);
  readonly loadingReporteValorizacion = computed(() => this.state().loadingReporteValorizacion);
  readonly loadingReporteVendidos = computed(() => this.state().loadingReporteVendidos);
  readonly loadingReporteStockMinimo = computed(() => this.state().loadingReporteStockMinimo);
  readonly loadingReporteStockFecha = computed(() => this.state().loadingReporteStockFecha);
  readonly loadingReporteHistorialVencimiento = computed(() => this.state().loadingReporteHistorialVencimiento);
  readonly loadingReporteDiagnosticoAlmacenes = computed(() => this.state().loadingReporteDiagnosticoAlmacenes);
  readonly loadingConsultaArticulos = computed(() => this.state().loadingConsultaArticulos);
  readonly loadingConsultaOrdenesCompra = computed(() => this.state().loadingConsultaOrdenesCompra);
  readonly loadingConsultaDevoluciones = computed(() => this.state().loadingConsultaDevoluciones);
  readonly loadingConsultaKardex = computed(() => this.state().loadingConsultaKardex);
  readonly loadingConsultaPrestamos = computed(() => this.state().loadingConsultaPrestamos);
  readonly loadingRecepcionesAlmacenamiento = computed(() => this.state().loadingRecepcionesAlmacenamiento);

  readonly errorObtener = computed(() => this.state().errorObtener);
  readonly errorGuardar = computed(() => this.state().errorGuardar);
  readonly errorEliminar = computed(() => this.state().errorEliminar);
  readonly errorActualizar = computed(() => this.state().errorActualizar);

  readonly errorCatalogos = computed(() => this.state().errorCatalogos);
  readonly errorReporteTomas = computed(() => this.state().errorReporteTomas);
  readonly errorReporteValorizacion = computed(() => this.state().errorReporteValorizacion);
  readonly errorReporteVendidos = computed(() => this.state().errorReporteVendidos);
  readonly errorReporteStockMinimo = computed(() => this.state().errorReporteStockMinimo);
  readonly errorReporteStockFecha = computed(() => this.state().errorReporteStockFecha);
  readonly errorReporteHistorialVencimiento = computed(() => this.state().errorReporteHistorialVencimiento);

  readonly resultGuardar = computed(() => this.state().resultGuardar);
  readonly resultEliminar = computed(() => this.state().resultEliminar);
  readonly resultActualizar = computed(() => this.state().resultActualizar);

  readonly isLoading = computed(() =>
    this.state().loadingObtener ||
    this.state().loadingGuardar ||
    this.state().loadingEliminar ||
    this.state().loadingActualizar ||
    this.state().loadingCatalogos ||
    this.state().loadingTransferencias ||
    this.state().loadingComparaciones ||
    this.state().loadingReporteTomas ||
    this.state().loadingReporteValorizacion ||
    this.state().loadingReporteVendidos ||
    this.state().loadingReporteStockMinimo ||
    this.state().loadingReporteStockFecha ||
    this.state().loadingReporteHistorialVencimiento ||
    this.state().loadingReporteDiagnosticoAlmacenes ||
    this.state().loadingConsultaArticulos ||
    this.state().loadingConsultaOrdenesCompra ||
    this.state().loadingConsultaDevoluciones ||
    this.state().loadingConsultaKardex ||
    this.state().loadingConsultaPrestamos ||
    this.state().loadingRecepcionesAlmacenamiento ||
    this.state().loadingDespachos ||
    this.state().loadingGestionesDevoluciones ||
    this.state().loadingRecepcionesTransferencia ||
    this.state().loadingRegistroPerdidas ||
    this.state().loadingProductosAlmacen ||
    this.state().loadingReposicionesStock ||
    this.state().loadingProductosReposicionStock ||
    this.state().loadingClasificacionArticulos ||
    this.state().loadingMaestroProductos ||
    this.state().loadingMovAlmacenes ||
    this.state().loadingReqTraslados
  );

  // Selector de error global
  readonly hasError = computed(() =>
    !!this.state().errorObtener ||
    !!this.state().errorGuardar ||
    !!this.state().errorEliminar ||
    !!this.state().errorActualizar ||
    !!this.state().errorCatalogos ||
    !!this.state().errorReporteTomas ||
    !!this.state().errorReporteValorizacion ||
    !!this.state().errorReporteVendidos ||
    !!this.state().errorReporteStockMinimo ||
    !!this.state().errorReporteStockFecha ||
    !!this.state().errorReporteHistorialVencimiento ||
    !!this.state().errorReporteDiagnosticoAlmacenes
  );

  readonly errorReporteDiagnosticoAlmacenes = computed(() => this.state().errorReporteDiagnosticoAlmacenes);

  setLoadingObtener(value: boolean) {
    this.state.update((s) => ({ ...s, loadingObtener: value }));
  }

  setLoadingGuardar(value: boolean) {
    this.state.update((s) => ({ ...s, loadingGuardar: value }));
  }

  setLoadingEliminar(value: boolean) {
    this.state.update((s) => ({ ...s, loadingEliminar: value }));
  }

  setLoadingActualizar(value: boolean) {
    this.state.update((s) => ({ ...s, loadingActualizar: value }));
  }

  setAlmacenes(almacenes: AlmacenEntity[]) {
    this.state.update((s) => ({
      ...s,
      almacenes,
      errorObtener: null
    }));
  }

  setAlmacenSeleccionado(almacen: AlmacenEntity | null) {
    this.state.update((s) => ({
      ...s,
      almacenSeleccionado: almacen
    }));
  }

  setGuardarResultado(result: ApiResponse<AlmacenEntity> | null) {
    this.state.update((s) => ({
      ...s,
      resultGuardar: result,
      errorGuardar: null
    }));

    if (result?.success && result.data) {
      this.state.update((s) => {
        const almacenExistente = s.almacenes.find((a: AlmacenEntity) => a.almacen_codigo === result.data!.almacen_codigo);
        if (almacenExistente) {
          return {
            ...s,
            almacenes: s.almacenes.map((a: AlmacenEntity) =>
              a.almacen_codigo === result.data!.almacen_codigo ? result.data! : a
            )
          };
        } else {
          return {
            ...s,
            almacenes: [result.data!, ...s.almacenes]
          };
        }
      });
    }
  }

  setEliminarResultado(result: ApiResponse<boolean> | null, almacen_codigo?: string) {
    this.state.update((s) => ({
      ...s,
      resultEliminar: result,
      errorEliminar: null
    }));

    if (result?.success && almacen_codigo) {
      this.state.update((s) => ({
        ...s,
        almacenes: s.almacenes.filter(a => a.almacen_codigo !== almacen_codigo),
        almacenSeleccionado: s.almacenSeleccionado?.almacen_codigo === almacen_codigo ? null : s.almacenSeleccionado
      }));
    }
  }

  setActualizarResultado(result: ApiResponse<AlmacenEntity> | null) {
    this.state.update((s) => ({
      ...s,
      resultActualizar: result,
      errorActualizar: null
    }));

    if (result?.success && result.data) {
      this.state.update((s) => ({
        ...s,
        almacenes: s.almacenes.map(a =>
          a.almacen_codigo === result.data!.almacen_codigo ? result.data! : a
        ),
        almacenSeleccionado: s.almacenSeleccionado?.almacen_codigo === result.data!.almacen_codigo
          ? result.data!
          : s.almacenSeleccionado
      }));
    }
  }

  setErrorObtener(message: string | null) {
    this.state.update((s) => ({
      ...s,
      errorObtener: message,
      loadingObtener: false
    }));
  }

  setErrorGuardar(message: string | null) {
    this.state.update((s) => ({
      ...s,
      errorGuardar: message,
      loadingGuardar: false
    }));
  }

  setErrorEliminar(message: string | null) {
    this.state.update((s) => ({
      ...s,
      errorEliminar: message,
      loadingEliminar: false
    }));
  }

  setErrorActualizar(message: string | null) {
    this.state.update((s) => ({
      ...s,
      errorActualizar: message,
      loadingActualizar: false
    }));
  }

  clearErrors() {
    this.state.update((s) => ({
      ...s,
      errorObtener: null,
      errorGuardar: null,
      errorEliminar: null,
      errorActualizar: null,
      errorCatalogos: null
    }));
  }

  resetState() {
    this.state.set(initialAlmacenState);
  }

  // Mutadores para catálogos
  setLoadingCatalogos(value: boolean) {
    this.state.update((s) => ({ ...s, loadingCatalogos: value }));
  }

  setLoadingTransferencias(value: boolean) {
    this.state.update((s) => ({ ...s, loadingTransferencias: value }));
  }

  setLoadingComparaciones(value: boolean) {
    this.state.update((s) => ({ ...s, loadingComparaciones: value }));
  }

  setCatalogos(catalogos: any) {
    this.state.update((s) => ({
      ...s,
      catalogos,
      loadingCatalogos: false,
      errorCatalogos: null
    }));
  }

  setTransferencias(transferencias: any[]) {
    this.state.update((s) => ({
      ...s,
      transferencias,
      loadingTransferencias: false
    }));
  }

  setComparacionesInventario(comparaciones: any[]) {
    this.state.update((s) => ({
      ...s,
      comparacionesInventario: comparaciones,
      loadingComparaciones: false
    }));
  }

  setErrorCatalogos(error: string) {
    this.state.update((s) => ({
      ...s,
      errorCatalogos: error,
      loadingCatalogos: false
    }));
  }

  setReporteTomas(reporte: TomaInventarioEntity[]) {
    this.state.update((s) => ({
      ...s,
      reporteTomas: reporte,
      loadingReporteTomas: false
    }));
  }

  setLoadingReporteTomas(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingReporteTomas: value
    }));
  }

  setErrorReporteTomas(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorReporteTomas: error,
      loadingReporteTomas: false
    }));
  }

  setReporteValorizacion(reporte: ValorizacionProductoEntity[]) {
    this.state.update((s) => ({
      ...s,
      reporteValorizacion: reporte,
      loadingReporteValorizacion: false
    }));
  }

  setLoadingReporteValorizacion(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingReporteValorizacion: value
    }));
  }

  setErrorReporteValorizacion(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorReporteValorizacion: error,
      loadingReporteValorizacion: false
    }));
  }

  setReporteVendidos(reporte: ProductoVendidoEntity[]) {
    this.state.update((s) => ({
      ...s,
      reporteVendidos: reporte,
      loadingReporteVendidos: false
    }));
  }

  setLoadingReporteVendidos(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingReporteVendidos: value
    }));
  }

  setErrorReporteVendidos(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorReporteVendidos: error,
      loadingReporteVendidos: false
    }));
  }

  setReporteStockMinimo(reporte: StockMinimoEntity[]) {
    this.state.update((s) => ({
      ...s,
      reporteStockMinimo: reporte,
      loadingReporteStockMinimo: false
    }));
  }

  setLoadingReporteStockMinimo(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingReporteStockMinimo: value
    }));
  }

  setErrorReporteStockMinimo(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorReporteStockMinimo: error,
      loadingReporteStockMinimo: false
    }));
  }

  setReporteStockFecha(reporte: StockFechaEntity[]) {
    this.state.update((s) => ({
      ...s,
      reporteStockFecha: reporte,
      loadingReporteStockFecha: false
    }));
  }

  setLoadingReporteStockFecha(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingReporteStockFecha: value
    }));
  }

  setErrorReporteStockFecha(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorReporteStockFecha: error,
      loadingReporteStockFecha: false
    }));
  }

  setReporteHistorialVencimiento(reporte: HistorialVencimientoEntity[]) {
    this.state.update((s) => ({
      ...s,
      reporteHistorialVencimiento: reporte,
      loadingReporteHistorialVencimiento: false
    }));
  }

  setLoadingReporteHistorialVencimiento(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingReporteHistorialVencimiento: value
    }));
  }

  setErrorReporteHistorialVencimiento(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorReporteHistorialVencimiento: error,
      loadingReporteHistorialVencimiento: false
    }));
  }

  setReporteDiagnosticoAlmacenes(reporte: DiagnosticoAlmacenEntity[]) {
    this.state.update((s) => ({
      ...s,
      reporteDiagnosticoAlmacenes: reporte,
      loadingReporteDiagnosticoAlmacenes: false
    }));
  }

  setLoadingReporteDiagnosticoAlmacenes(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingReporteDiagnosticoAlmacenes: value
    }));
  }

  setErrorReporteDiagnosticoAlmacenes(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorReporteDiagnosticoAlmacenes: error,
      loadingReporteDiagnosticoAlmacenes: false
    }));
  }

  setConsultaArticulos(articulos: ArticuloConsultaEntity[]) {
    this.state.update((s) => ({
      ...s,
      consultaArticulos: articulos,
      loadingConsultaArticulos: false
    }));
  }

  setLoadingConsultaArticulos(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingConsultaArticulos: value
    }));
  }

  setErrorConsultaArticulos(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorConsultaArticulos: error,
      loadingConsultaArticulos: false
    }));
  }

  setConsultaOrdenesCompra(ordenes: OrdenCompraConsultaEntity[]) {
    this.state.update((s) => ({
      ...s,
      consultaOrdenesCompra: ordenes,
      loadingConsultaOrdenesCompra: false
    }));
  }

  setLoadingConsultaOrdenesCompra(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingConsultaOrdenesCompra: value
    }));
  }

  setErrorConsultaOrdenesCompra(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorConsultaOrdenesCompra: error,
      loadingConsultaOrdenesCompra: false
    }));
  }

  setConsultaDevoluciones(devoluciones: DevolucionConsultaEntity[]) {
    this.state.update((s) => ({
      ...s,
      consultaDevoluciones: devoluciones,
      loadingConsultaDevoluciones: false
    }));
  }

  setLoadingConsultaDevoluciones(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingConsultaDevoluciones: value
    }));
  }

  setErrorConsultaDevoluciones(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorConsultaDevoluciones: error,
      loadingConsultaDevoluciones: false
    }));
  }

  setConsultaKardex(kardex: KardexConsultaEntity[]) {
    this.state.update((s) => ({
      ...s,
      consultaKardex: kardex,
      loadingConsultaKardex: false
    }));
  }

  setLoadingConsultaKardex(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingConsultaKardex: value
    }));
  }

  setErrorConsultaKardex(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorConsultaKardex: error,
      loadingConsultaKardex: false
    }));
  }

  setConsultaPrestamos(prestamos: PrestamoConsultaEntity[]) {
    this.state.update((s) => ({
      ...s,
      consultaPrestamos: prestamos,
      loadingConsultaPrestamos: false
    }));
  }

  setLoadingConsultaPrestamos(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingConsultaPrestamos: value
    }));
  }

  setErrorConsultaPrestamos(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorConsultaPrestamos: error,
      loadingConsultaPrestamos: false
    }));
  }

  setRecepcionesAlmacenamiento(recepciones: RecepcionAlmacenamientoEntity[]) {
    this.state.update((s) => ({
      ...s,
      recepcionesAlmacenamiento: recepciones,
      loadingRecepcionesAlmacenamiento: false
    }));
  }

  setLoadingRecepcionesAlmacenamiento(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingRecepcionesAlmacenamiento: value
    }));
  }

  setErrorRecepcionesAlmacenamiento(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorRecepcionesAlmacenamiento: error,
      loadingRecepcionesAlmacenamiento: false
    }));
  }

  setDespachos(despachos: DespachoEntity[]) {
    this.state.update((s) => ({
      ...s,
      despachos: despachos,
      loadingDespachos: false
    }));
  }

  setLoadingDespachos(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingDespachos: value
    }));
  }

  setErrorDespachos(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorDespachos: error,
      loadingDespachos: false
    }));
  }

  setGestionesDevoluciones(gestionesDevoluciones: GestionDevolucionEntity[]) {
    this.state.update((s) => ({
      ...s,
      gestionesDevoluciones,
      loadingGestionesDevoluciones: false
    }));
  }

  setLoadingGestionesDevoluciones(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingGestionesDevoluciones: value
    }));
  }

  setErrorGestionesDevoluciones(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorGestionesDevoluciones: error,
      loadingGestionesDevoluciones: false
    }));
  }

  setRecepcionesTransferencia(recepcionesTransferencia: RecepcionTransferenciaEntity[]) {
    this.state.update((s) => ({
      ...s,
      recepcionesTransferencia,
      loadingRecepcionesTransferencia: false
    }));
  }

  setLoadingRecepcionesTransferencia(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingRecepcionesTransferencia: value
    }));
  }

  setErrorRecepcionesTransferencia(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorRecepcionesTransferencia: error,
      loadingRecepcionesTransferencia: false
    }));
  }

  setRegistroPerdidas(registroPerdidas: RegistroPerdidasEntity[]) {
    this.state.update((s) => ({
      ...s,
      registroPerdidas,
      loadingRegistroPerdidas: false
    }));
  }

  setLoadingRegistroPerdidas(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingRegistroPerdidas: value
    }));
  }

  setErrorRegistroPerdidas(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorRegistroPerdidas: error,
      loadingRegistroPerdidas: false
    }));
  }

  setProductosAlmacen(productosAlmacen: ProductoAlmacenEntity[]) {
    this.state.update((s) => ({
      ...s,
      productosAlmacen,
      loadingProductosAlmacen: false
    }));
  }

  setLoadingProductosAlmacen(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingProductosAlmacen: value
    }));
  }

  setErrorProductosAlmacen(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorProductosAlmacen: error,
      loadingProductosAlmacen: false
    }));
  }

  setReposicionesStock(reposicionesStock: ReposicionStockEntity[]) {
    this.state.update((s) => ({
      ...s,
      reposicionesStock,
      loadingReposicionesStock: false
    }));
  }

  setLoadingReposicionesStock(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingReposicionesStock: value
    }));
  }

  setErrorReposicionesStock(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorReposicionesStock: error,
      loadingReposicionesStock: false
    }));
  }

  setProductosReposicionStock(productosReposicionStock: ProductoAlmacenEntity[]) {
    this.state.update((s) => ({
      ...s,
      productosReposicionStock,
      loadingProductosReposicionStock: false
    }));
  }

  setLoadingProductosReposicionStock(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingProductosReposicionStock: value
    }));
  }

  setErrorProductosReposicionStock(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorProductosReposicionStock: error,
      loadingProductosReposicionStock: false
    }));
  }

  setRecalculoPrecios(recalculoPrecios: RecalculoPrecioEntity[]) {
    this.state.update((s) => ({
      ...s,
      recalculoPrecios,
      loadingRecalculoPrecios: false
    }));
  }

  setLoadingRecalculoPrecios(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingRecalculoPrecios: value
    }));
  }

  setErrorRecalculoPrecios(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorRecalculoPrecios: error,
      loadingRecalculoPrecios: false
    }));
  }

  setClasificacionArticulos(clasificacionArticulos: CategoriaArticuloEntity[]) {
    this.state.update((s) => ({
      ...s,
      clasificacionArticulos,
      loadingClasificacionArticulos: false
    }));
  }

  setLoadingClasificacionArticulos(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingClasificacionArticulos: value
    }));
  }

  setErrorClasificacionArticulos(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorClasificacionArticulos: error,
      loadingClasificacionArticulos: false
    }));
  }

  setMaestroProductos(maestroProductos: MaestroProductoEntity[]) {
    this.state.update((s) => ({
      ...s,
      maestroProductos,
      loadingMaestroProductos: false
    }));
  }

  setLoadingMaestroProductos(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingMaestroProductos: value
    }));
  }

  setErrorMaestroProductos(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorMaestroProductos: error,
      loadingMaestroProductos: false
    }));
  }

  setMovAlmacenes(movAlmacenes: MovAlmacenEntity[]) {
    this.state.update((s) => ({
      ...s,
      movAlmacenes,
      loadingMovAlmacenes: false
    }));
  }

  setLoadingMovAlmacenes(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingMovAlmacenes: value
    }));
  }

  setErrorMovAlmacenes(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorMovAlmacenes: error,
      loadingMovAlmacenes: false
    }));
  }

  setReqTraslados(reqTraslados: ReqTrasladoEntity[]) {
    this.state.update((s) => ({
      ...s,
      reqTraslados,
      loadingReqTraslados: false
    }));
  }

  setLoadingReqTraslados(value: boolean) {
    this.state.update((s) => ({
      ...s,
      loadingReqTraslados: value
    }));
  }

  setErrorReqTraslados(error: string | null) {
    this.state.update((s) => ({
      ...s,
      errorReqTraslados: error,
      loadingReqTraslados: false
    }));
  }

  // ── Cuadre de Stock ──────────────────────────────────────────────────────
  setCuadreStock(cuadreStock: CuadreStockEntity[]) {
    this.state.update((s) => ({ ...s, cuadreStock, loadingCuadreStock: false }));
  }

  setLoadingCuadreStock(value: boolean) {
    this.state.update((s) => ({ ...s, loadingCuadreStock: value }));
  }

  setErrorCuadreStock(error: string | null) {
    this.state.update((s) => ({ ...s, errorCuadreStock: error, loadingCuadreStock: false }));
  }

  // ── Movimientos Cuadre de Stock ──────────────────────────────────────────
  setMovimientosCuadreStock(movimientosCuadreStock: MovimientoCuadreStockEntity[]) {
    this.state.update((s) => ({ ...s, movimientosCuadreStock, loadingMovimientosCuadreStock: false }));
  }

  setLoadingMovimientosCuadreStock(value: boolean) {
    this.state.update((s) => ({ ...s, loadingMovimientosCuadreStock: value }));
  }

  setErrorMovimientosCuadreStock(error: string | null) {
    this.state.update((s) => ({ ...s, errorMovimientosCuadreStock: error, loadingMovimientosCuadreStock: false }));
  }

  // ── Actualización de precios de productos ────────────────────────────────
  setActualizacionProductos(actualizacionProductos: ActualizacionProductoEntity[]) {
    this.state.update((s) => ({ ...s, actualizacionProductos, loadingActualizacionProductos: false }));
  }

  setLoadingActualizacionProductos(value: boolean) {
    this.state.update((s) => ({ ...s, loadingActualizacionProductos: value }));
  }

  setErrorActualizacionProductos(error: string | null) {
    this.state.update((s) => ({ ...s, errorActualizacionProductos: error, loadingActualizacionProductos: false }));
  }
}
