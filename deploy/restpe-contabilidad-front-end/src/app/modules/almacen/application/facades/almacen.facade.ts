import { Injectable, inject, signal } from '@angular/core';
import { Observable } from 'rxjs';
import { ObtenerTiposAlmacenUseCase } from '../usecases/obtener-tipos-almacen.usecase';
import { TipoAlmacenEntity } from '../../domain/models/tipo-almacen.entity';
import {
  ObtenerAlmacenesUseCase,
  GuardarAlmacenUseCase,
  ActualizarAlmacenUseCase,
  EliminarAlmacenUseCase,
  ObtenerCatalogosUseCase,
  ObtenerTransferenciasUseCase,
  ObtenerComparacionesInventarioUseCase,
  ObtenerReporteTomasUseCase,
  ObtenerReporteValorizacionUseCase,
  ObtenerReporteVendidosUseCase,
  ObtenerReporteStockMinimoUseCase,
  ObtenerReporteStockFechaUseCase,
  ObtenerReporteHistorialVencimientoUseCase,
  ObtenerReporteDiagnosticoAlmacenesUseCase,
  ObtenerConsultaArticulosUseCase,
  ObtenerConsultaOrdenesCompraUseCase,
  ObtenerConsultaDevolucionesUseCase,
  ObtenerConsultaKardexUseCase,
  ObtenerConsultaPrestamosUseCase,
  ObtenerRecepcionesAlmacenamientoUseCase,
  ObtenerDespachosUseCase,
  ObtenerGestionesDevolucionUseCase,
  ObtenerRecepcionesTransferenciaUseCase,
  ObtenerRegistroPerdidasUseCase,
  ObtenerProductosAlmacenUseCase,
  ObtenerReposicionesStockUseCase,
  ObtenerProductosReposicionStockUseCase,
  ObtenerRecalculoPreciosUC,
  ObtenerCuadreStockUC,
  ObtenerMovimientosCuadreStockUC,
  ObtenerActualizacionProductosUC
} from '../usecases';
import { ObtenerClasificacionArticulosUseCase } from '../usecases/obtener-clasificacion-articulos.usecase';
import { ObtenerMaestroProductosUseCase } from '../usecases/obtener-maestro-productos.usecase';
import { ObtenerMovAlmacenesUseCase } from '../usecases/obtener-mov-almacenes.usecase';
import { DescargarMovimientoPdfUseCase } from '../usecases/descargar-movimiento-pdf.usecase';
import { ObtenerReqTrasladosUseCase } from '../usecases/obtener-req-traslados.usecase';
import { AlmacenEntity } from '../../domain/models/almacen.entity';
import { AlmacenStore } from '../../store/almacen.store';

@Injectable()
export class AlmacenFacade {

  private readonly store = inject(AlmacenStore);

  private readonly obtenerUC = inject(ObtenerAlmacenesUseCase);
  private readonly obtenerTiposAlmacenUC = inject(ObtenerTiposAlmacenUseCase);
  private readonly guardarUC = inject(GuardarAlmacenUseCase);
  private readonly actualizarUC = inject(ActualizarAlmacenUseCase);
  private readonly eliminarUC = inject(EliminarAlmacenUseCase);
  private readonly obtenerCatalogosUC = inject(ObtenerCatalogosUseCase);
  private readonly obtenerTransferenciasUC = inject(ObtenerTransferenciasUseCase);
  private readonly obtenerComparacionesUC = inject(ObtenerComparacionesInventarioUseCase);
  private readonly obtenerReporteTomasUC = inject(ObtenerReporteTomasUseCase);
  private readonly obtenerReporteValorizacionUC = inject(ObtenerReporteValorizacionUseCase);
  private readonly obtenerReporteVendidosUC = inject(ObtenerReporteVendidosUseCase);
  private readonly obtenerReporteStockMinimoUC = inject(ObtenerReporteStockMinimoUseCase);
  private readonly obtenerReporteStockFechaUC = inject(ObtenerReporteStockFechaUseCase);
  private readonly obtenerReporteHistorialVencimientoUC = inject(ObtenerReporteHistorialVencimientoUseCase);
  private readonly obtenerReporteDiagnosticoAlmacenesUC = inject(ObtenerReporteDiagnosticoAlmacenesUseCase);
  private readonly obtenerConsultaArticulosUC = inject(ObtenerConsultaArticulosUseCase);
  private readonly obtenerConsultaOrdenesCompraUC = inject(ObtenerConsultaOrdenesCompraUseCase);
  private readonly obtenerConsultaDevolucionesUC = inject(ObtenerConsultaDevolucionesUseCase);
  private readonly obtenerConsultaKardexUC = inject(ObtenerConsultaKardexUseCase);
  private readonly obtenerConsultaPrestamosUC = inject(ObtenerConsultaPrestamosUseCase);
  private readonly obtenerRecepcionesAlmacenamientoUC = inject(ObtenerRecepcionesAlmacenamientoUseCase);
  private readonly obtenerDespachosUC = inject(ObtenerDespachosUseCase);
  private readonly obtenerGestionesDevolucionUC = inject(ObtenerGestionesDevolucionUseCase);
  private readonly obtenerRecepcionesTransferenciaUC = inject(ObtenerRecepcionesTransferenciaUseCase);
  private readonly obtenerRegistroPerdidasUC = inject(ObtenerRegistroPerdidasUseCase);
  private readonly obtenerProductosAlmacenUC = inject(ObtenerProductosAlmacenUseCase);
  private readonly obtenerReposicionesStockUC = inject(ObtenerReposicionesStockUseCase);
  private readonly obtenerProductosReposicionStockUC = inject(ObtenerProductosReposicionStockUseCase);
  private readonly obtenerRecalculoPreciosUC = inject(ObtenerRecalculoPreciosUC);
  private readonly obtenerClasificacionArticulosUC = inject(ObtenerClasificacionArticulosUseCase);
  private readonly obtenerMaestroProductosUC = inject(ObtenerMaestroProductosUseCase);
  private readonly obtenerMovAlmacenesUC = inject(ObtenerMovAlmacenesUseCase);
  private readonly descargarMovimientoPdfUC = inject(DescargarMovimientoPdfUseCase);
  private readonly obtenerReqTrasladosUC = inject(ObtenerReqTrasladosUseCase);
  private readonly obtenerCuadreStockUC = inject(ObtenerCuadreStockUC);
  private readonly obtenerMovimientosCuadreStockUC = inject(ObtenerMovimientosCuadreStockUC);
  private readonly obtenerActualizacionProductosUC = inject(ObtenerActualizacionProductosUC);

  // Selectores de almacenes
  readonly almacenes = this.store.almacenes;

  /** Catálogo real de tipos de almacén (backend `/almacen-tipos`). */
  private readonly _tiposAlmacen = signal<TipoAlmacenEntity[]>([]);
  readonly tiposAlmacen = this._tiposAlmacen.asReadonly();
  readonly almacenSeleccionado = this.store.almacenSeleccionado;

  // Selectores de catálogos y datos
  readonly catalogos = this.store.catalogos;
  readonly transferencias = this.store.transferencias;
  readonly comparacionesInventario = this.store.comparacionesInventario;
  readonly reporteTomas = this.store.reporteTomas;
  readonly reporteValorizacion = this.store.reporteValorizacion;
  readonly reporteVendidos = this.store.reporteVendidos;
  readonly reporteStockMinimo = this.store.reporteStockMinimo;
  readonly reporteStockFecha = this.store.reporteStockFecha;
  readonly reporteHistorialVencimiento = this.store.reporteHistorialVencimiento;
  readonly reporteDiagnosticoAlmacenes = this.store.reporteDiagnosticoAlmacenes;
  readonly recalculoPrecios = this.store.recalculoPrecios;

  // Selectores de tablas
  readonly clasificacionArticulos = this.store.clasificacionArticulos;
  readonly loadingClasificacionArticulos = this.store.loadingClasificacionArticulos;
  readonly maestroProductos = this.store.maestroProductos;
  readonly loadingMaestroProductos = this.store.loadingMaestroProductos;
  readonly movAlmacenes = this.store.movAlmacenes;
  readonly loadingMovAlmacenes = this.store.loadingMovAlmacenes;
  readonly reqTraslados = this.store.reqTraslados;
  readonly loadingReqTraslados = this.store.loadingReqTraslados;
  readonly cuadreStock = this.store.cuadreStock;
  readonly loadingCuadreStock = this.store.loadingCuadreStock;
  readonly movimientosCuadreStock = this.store.movimientosCuadreStock;
  readonly loadingMovimientosCuadreStock = this.store.loadingMovimientosCuadreStock;
  readonly actualizacionProductos = this.store.actualizacionProductos;
  readonly loadingActualizacionProductos = this.store.loadingActualizacionProductos;
  readonly consultaArticulos = this.store.consultaArticulos;
  readonly consultaOrdenesCompra = this.store.consultaOrdenesCompra;
  readonly consultaDevoluciones = this.store.consultaDevoluciones;
  readonly consultaKardex = this.store.consultaKardex;
  readonly consultaPrestamos = this.store.consultaPrestamos;
  readonly recepcionesAlmacenamiento = this.store.recepcionesAlmacenamiento;
  readonly despachos = this.store.despachos;
  readonly gestionesDevoluciones = this.store.gestionesDevoluciones;
  readonly recepcionesTransferencia = this.store.recepcionesTransferencia;
  readonly registroPerdidas = this.store.registroPerdidas;
  readonly productosAlmacen = this.store.productosAlmacen;
  readonly reposicionesStock = this.store.reposicionesStock;
  readonly productosReposicionStock = this.store.productosReposicionStock;

  // Selectores de loading
  readonly loadingObtener = this.store.loadingObtener;
  readonly loadingGuardar = this.store.loadingGuardar;
  readonly loadingEliminar = this.store.loadingEliminar;
  readonly loadingActualizar = this.store.loadingActualizar;
  readonly loadingCatalogos = this.store.loadingCatalogos;
  readonly loadingReporteTomas = this.store.loadingReporteTomas;
  readonly loadingReporteValorizacion = this.store.loadingReporteValorizacion;
  readonly loadingReporteVendidos = this.store.loadingReporteVendidos;
  readonly loadingReporteStockMinimo = this.store.loadingReporteStockMinimo;
  readonly loadingReporteStockFecha = this.store.loadingReporteStockFecha;
  readonly loadingReporteHistorialVencimiento = this.store.loadingReporteHistorialVencimiento;
  readonly loadingReporteDiagnosticoAlmacenes = this.store.loadingReporteDiagnosticoAlmacenes;
  readonly loadingConsultaArticulos = this.store.loadingConsultaArticulos;
  readonly loadingConsultaOrdenesCompra = this.store.loadingConsultaOrdenesCompra;
  readonly loadingConsultaDevoluciones = this.store.loadingConsultaDevoluciones;
  readonly loadingConsultaKardex = this.store.loadingConsultaKardex;
  readonly loadingConsultaPrestamos = this.store.loadingConsultaPrestamos;
  readonly loadingRecepcionesAlmacenamiento = this.store.loadingRecepcionesAlmacenamiento;
  readonly loadingDespachos = this.store.loadingDespachos;
  readonly loadingGestionesDevoluciones = this.store.loadingGestionesDevoluciones;
  readonly loadingRecepcionesTransferencia = this.store.loadingRecepcionesTransferencia;
  readonly loadingRegistroPerdidas = this.store.loadingRegistroPerdidas;
  readonly loadingProductosAlmacen = this.store.loadingProductosAlmacen;
  readonly loadingReposicionesStock = this.store.loadingReposicionesStock;
  readonly loadingProductosReposicionStock = this.store.loadingProductosReposicionStock;
  readonly loadingRecalculoPrecios = this.store.loadingRecalculoPrecios;

  readonly isLoading = this.store.isLoading;
  readonly hasError = this.store.hasError;

  // Selectores de errores
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorEliminar = this.store.errorEliminar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly errorCatalogos = this.store.errorCatalogos;
  readonly errorReporteTomas = this.store.errorReporteTomas;
  readonly errorReporteValorizacion = this.store.errorReporteValorizacion;
  readonly errorReporteVendidos = this.store.errorReporteVendidos;
  readonly errorReporteStockMinimo = this.store.errorReporteStockMinimo;

  // Selectores de resultados
  readonly resultGuardar = this.store.resultGuardar;
  readonly resultEliminar = this.store.resultEliminar;
  readonly resultActualizar = this.store.resultActualizar;

  cargarAlmacenes(): void {
    this.store.setLoadingObtener(true);

    this.obtenerUC.execute().subscribe({
      next: (almacenes) => {
        this.store.setAlmacenes(almacenes);
      },
      error: (err) => {
        this.store.setErrorObtener(err.message || 'Error al cargar almacenes');
      },
      complete: () => {
        this.store.setLoadingObtener(false);
      }
    });
  }

  /** Carga el catálogo real de tipos de almacén para el selector del form. */
  cargarTiposAlmacen(): void {
    this.obtenerTiposAlmacenUC.execute().subscribe({
      next: (tipos) => this._tiposAlmacen.set(tipos),
      error: (err) => console.error('Error al cargar tipos de almacén:', err),
    });
  }

  guardarAlmacen(almacen: AlmacenEntity): void {
    this.store.setLoadingGuardar(true);

    this.guardarUC.execute(almacen).subscribe({
      next: (result) => {
        this.store.setGuardarResultado(result);
      },
      error: (err) => {
        this.store.setErrorGuardar(err.message || 'Error al guardar almacén');
      },
      complete: () => {
        this.store.setLoadingGuardar(false);
      }
    });
  }

  actualizarAlmacen(almacen: AlmacenEntity): void {
    this.store.setLoadingActualizar(true);

    this.actualizarUC.execute(almacen).subscribe({
      next: (result) => {
        this.store.setActualizarResultado(result);
      },
      error: (err) => {
        this.store.setErrorActualizar(err.message || 'Error al actualizar almacén');
      },
      complete: () => {
        this.store.setLoadingActualizar(false);
      }
    });
  }

  eliminarAlmacen(almacen_codigo: string): void {
    this.store.setLoadingEliminar(true);

    this.eliminarUC.execute(almacen_codigo).subscribe({
      next: (result) => {
        this.store.setEliminarResultado(result, almacen_codigo);
      },
      error: (err) => {
        this.store.setErrorEliminar(err.message || 'Error al eliminar almacén');
      },
      complete: () => {
        this.store.setLoadingEliminar(false);
      }
    });
  }

  seleccionarAlmacen(almacen: AlmacenEntity | null): void {
    this.store.setAlmacenSeleccionado(almacen);
  }

  limpiarErrores(): void {
    this.store.clearErrors();
  }

  // Métodos para cargar catálogos y datos
  cargarCatalogos(): void {
    this.store.setLoadingCatalogos(true);

    this.obtenerCatalogosUC.execute().subscribe({
      next: (catalogos) => {
        this.store.setCatalogos(catalogos);
      },
      error: (err) => {
        this.store.setErrorCatalogos(err.message || 'Error al cargar catálogos');
      }
    });
  }

  cargarTransferencias(): void {
    this.store.setLoadingTransferencias(true);

    this.obtenerTransferenciasUC.execute().subscribe({
      next: (transferencias) => {
        this.store.setTransferencias(transferencias);
      },
      error: (err) => {
        console.error('Error al cargar transferencias:', err);
        this.store.setLoadingTransferencias(false);
      }
    });
  }

  cargarComparacionesInventario(): void {
    this.store.setLoadingComparaciones(true);

    this.obtenerComparacionesUC.execute().subscribe({
      next: (comparaciones) => {
        this.store.setComparacionesInventario(comparaciones);
      },
      error: (err) => {
        console.error('Error al cargar comparaciones:', err);
        this.store.setLoadingComparaciones(false);
      }
    });
  }

  actualizarListaComparaciones(data: any[]): void {
    this.store.setComparacionesInventario(data);
  }

  cargarReporteTomas(): void {
    this.store.setLoadingReporteTomas(true);

    this.obtenerReporteTomasUC.execute().subscribe({
      next: (reporte) => {
        this.store.setReporteTomas(reporte);
      },
      error: (err) => {
        console.error('Error al cargar reporte tomas:', err);
        this.store.setErrorReporteTomas(err.message || 'Error al cargar reporte');
      }
    });
  }

  cargarReporteValorizacion(): void {
    this.store.setLoadingReporteValorizacion(true);

    this.obtenerReporteValorizacionUC.execute().subscribe({
      next: (reporte) => {
        this.store.setReporteValorizacion(reporte);
      },
      error: (err) => {
        console.error('Error al cargar reporte valorización:', err);
        this.store.setErrorReporteValorizacion(err.message || 'Error al cargar reporte');
      }
    });
  }

  cargarReporteVendidos(): void {
    this.store.setLoadingReporteVendidos(true);

    this.obtenerReporteVendidosUC.execute().subscribe({
      next: (reporte) => {
        this.store.setReporteVendidos(reporte);
      },
      error: (err) => {
        this.store.setErrorReporteVendidos(err.message || 'Error al cargar reporte');
      }
    });
  }

  cargarReporteStockMinimo(): void {
    this.store.setLoadingReporteStockMinimo(true);

    this.obtenerReporteStockMinimoUC.execute().subscribe({
      next: (reporte) => {
        this.store.setReporteStockMinimo(reporte);
      },
      error: (err) => {
        console.error('Error al cargar reporte stock mínimo:', err);
        this.store.setErrorReporteStockMinimo(err.message || 'Error al cargar reporte');
      }
    });
  }

  cargarReporteStockFecha(): void {
    this.store.setLoadingReporteStockFecha(true);

    this.obtenerReporteStockFechaUC.execute().subscribe({
      next: (reporte) => {
        this.store.setReporteStockFecha(reporte);
      },
      error: (err) => {
        console.error('Error al cargar reporte stock por fecha:', err);
        this.store.setErrorReporteStockFecha(err.message || 'Error al cargar reporte');
      }
    });
  }

  cargarReporteHistorialVencimiento(): void {
    this.store.setLoadingReporteHistorialVencimiento(true);

    this.obtenerReporteHistorialVencimientoUC.execute().subscribe({
      next: (reporte) => {
        this.store.setReporteHistorialVencimiento(reporte);
      },
      error: (err) => {
        console.error('Error al cargar reporte historial de vencimiento:', err);
        this.store.setErrorReporteHistorialVencimiento(err.message || 'Error al cargar reporte');
      }
    });
  }

  cargarReporteDiagnosticoAlmacenes(): void {
    this.store.setLoadingReporteDiagnosticoAlmacenes(true);

    this.obtenerReporteDiagnosticoAlmacenesUC.execute().subscribe({
      next: (reporte) => {
        this.store.setReporteDiagnosticoAlmacenes(reporte);
      },
      error: (err) => {
        console.error('Error al cargar reporte diagnóstico de almacenes:', err);
        this.store.setErrorReporteDiagnosticoAlmacenes(err.message || 'Error al cargar reporte');
      }
    });
  }

  cargarConsultaArticulos(): void {
    this.store.setLoadingConsultaArticulos(true);

    this.obtenerConsultaArticulosUC.execute().subscribe({
      next: (articulos) => {
        this.store.setConsultaArticulos(articulos);
      },
      error: (err) => {
        console.error('Error al cargar consulta de artículos:', err);
        this.store.setErrorConsultaArticulos(err.message || 'Error al cargar artículos');
      }
    });
  }

  cargarConsultaOrdenesCompra(): void {
    this.store.setLoadingConsultaOrdenesCompra(true);

    this.obtenerConsultaOrdenesCompraUC.execute().subscribe({
      next: (ordenes) => {
        this.store.setConsultaOrdenesCompra(ordenes);
      },
      error: (err) => {
        console.error('Error al cargar consulta de órdenes de compra:', err);
        this.store.setErrorConsultaOrdenesCompra(err.message || 'Error al cargar órdenes de compra');
      }
    });
  }

  cargarConsultaDevoluciones(): void {
    this.store.setLoadingConsultaDevoluciones(true);

    this.obtenerConsultaDevolucionesUC.execute().subscribe({
      next: (devoluciones) => {
        this.store.setConsultaDevoluciones(devoluciones);
      },
      error: (err) => {
        console.error('Error al cargar consulta de devoluciones:', err);
        this.store.setErrorConsultaDevoluciones(err.message || 'Error al cargar devoluciones');
      }
    });
  }

  cargarConsultaKardex(): void {
    this.store.setLoadingConsultaKardex(true);

    this.obtenerConsultaKardexUC.execute().subscribe({
      next: (kardex) => {
        this.store.setConsultaKardex(kardex);
      },
      error: (err) => {
        console.error('Error al cargar consulta de kardex:', err);
        this.store.setErrorConsultaKardex(err.message || 'Error al cargar kardex');
      }
    });
  }

  cargarConsultaPrestamos(): void {
    this.store.setLoadingConsultaPrestamos(true);

    this.obtenerConsultaPrestamosUC.execute().subscribe({
      next: (prestamos) => {
        this.store.setConsultaPrestamos(prestamos);
      },
      error: (err) => {
        console.error('Error al cargar consulta de préstamos:', err);
        this.store.setErrorConsultaPrestamos(err.message || 'Error al cargar préstamos');
      }
    });
  }

  cargarRecepcionesAlmacenamiento(): void {
    this.store.setLoadingRecepcionesAlmacenamiento(true);

    this.obtenerRecepcionesAlmacenamientoUC.execute().subscribe({
      next: (recepciones) => {
        this.store.setRecepcionesAlmacenamiento(recepciones);
      },
      error: (err) => {
        console.error('Error al cargar recepciones de almacenamiento:', err);
        this.store.setErrorRecepcionesAlmacenamiento(err.message || 'Error al cargar recepciones');
      }
    });
  }

  cargarDespachos(): void {
    this.store.setLoadingDespachos(true);

    this.obtenerDespachosUC.execute().subscribe({
      next: (despachos) => {
        this.store.setDespachos(despachos);
      },
      error: (err) => {
        console.error('Error al cargar despachos:', err);
        this.store.setErrorDespachos(err.message || 'Error al cargar despachos');
      }
    });
  }

  actualizarListaDespachos(data: any[]): void {
    this.store.setDespachos(data);
  }

  cargarGestionesDevoluciones(): void {
    this.store.setLoadingGestionesDevoluciones(true);

    this.obtenerGestionesDevolucionUC.execute().subscribe({
      next: (gestionesDevoluciones) => {
        this.store.setGestionesDevoluciones(gestionesDevoluciones);
      },
      error: (err) => {
        console.error('Error al cargar gestiones de devoluciones:', err);
        this.store.setErrorGestionesDevoluciones(err.message || 'Error al cargar gestiones de devoluciones');
      }
    });
  }

  cargarRecepcionesTransferencia(): void {
    this.store.setLoadingRecepcionesTransferencia(true);

    this.obtenerRecepcionesTransferenciaUC.execute().subscribe({
      next: (recepcionesTransferencia) => {
        this.store.setRecepcionesTransferencia(recepcionesTransferencia);
      },
      error: (err) => {
        console.error('Error al cargar recepciones de transferencia:', err);
        this.store.setErrorRecepcionesTransferencia(err.message || 'Error al cargar recepciones de transferencia');
      }
    });
  }

  actualizarListaRecepcionesTransferencia(data: any[]): void {
    this.store.setRecepcionesTransferencia(data);
  }

  cargarRegistroPerdidas(): void {
    this.store.setLoadingRegistroPerdidas(true);

    this.obtenerRegistroPerdidasUC.execute().subscribe({
      next: (registroPerdidas) => {
        this.store.setRegistroPerdidas(registroPerdidas);
      },
      error: (err) => {
        console.error('Error al cargar registro de pérdidas:', err);
        this.store.setErrorRegistroPerdidas(err.message || 'Error al cargar registro de pérdidas');
      }
    });
  }

  actualizarListaRegistroPerdidas(data: any[]): void {
    this.store.setRegistroPerdidas(data);
  }

  cargarProductosAlmacen(): void {
    this.store.setLoadingProductosAlmacen(true);

    this.obtenerProductosAlmacenUC.execute().subscribe({
      next: (productos) => {
        this.store.setProductosAlmacen(productos);
      },
      error: (err) => {
        console.error('Error al cargar productos de almacén:', err);
        this.store.setErrorProductosAlmacen(err.message || 'Error al cargar productos de almacén');
      }
    });
  }

  cargarReposicionesStock(): void {
    this.store.setLoadingReposicionesStock(true);

    this.obtenerReposicionesStockUC.execute().subscribe({
      next: (reposiciones) => {
        this.store.setReposicionesStock(reposiciones);
      },
      error: (err) => {
        console.error('Error al cargar reposiciones de stock:', err);
        this.store.setErrorReposicionesStock(err.message || 'Error al cargar reposiciones de stock');
      }
    });
  }

  actualizarListaReposicionesStock(data: any[]): void {
    this.store.setReposicionesStock(data);
  }

  cargarProductosReposicionStock(): void {
    this.store.setLoadingProductosReposicionStock(true);

    this.obtenerProductosReposicionStockUC.execute().subscribe({
      next: (productos) => {
        this.store.setProductosReposicionStock(productos);
      },
      error: (err) => {
        this.store.setErrorProductosReposicionStock(err.message || 'Error al cargar productos de reposición de stock');
      }
    });
  }

  cargarRecalculoPrecios(): void {
    this.store.setLoadingRecalculoPrecios(true);

    this.obtenerRecalculoPreciosUC.execute().subscribe({
      next: (datos: any) => {
        this.store.setRecalculoPrecios(datos);
        this.store.setLoadingRecalculoPrecios(false);
      },
      error: (err: any) => {
        this.store.setErrorRecalculoPrecios(err.message || 'Error al cargar datos de recálculo de precios');
        this.store.setLoadingRecalculoPrecios(false);
      }
    });
  }

  cargarClasificacionArticulos(): void {
    this.store.setLoadingClasificacionArticulos(true);

    this.obtenerClasificacionArticulosUC.execute().subscribe({
      next: (datos) => {
        this.store.setClasificacionArticulos(datos);
      },
      error: (err) => {
        console.error('Error al cargar clasificación de artículos:', err);
        this.store.setErrorClasificacionArticulos(err.message || 'Error al cargar datos');
      }
    });
  }

  cargarMaestroProductos(): void {
    this.store.setLoadingMaestroProductos(true);

    this.obtenerMaestroProductosUC.execute().subscribe({
      next: (datos) => {
        this.store.setMaestroProductos(datos);
      },
      error: (err) => {
        console.error('Error al cargar maestro de productos:', err);
        this.store.setErrorMaestroProductos(err.message || 'Error al cargar datos');
      }
    });
  }

  cargarMovAlmacenes(): void {
    this.store.setLoadingMovAlmacenes(true);

    this.obtenerMovAlmacenesUC.execute().subscribe({
      next: (datos) => {
        this.store.setMovAlmacenes(datos);
      },
      error: (err) => {
        console.error('Error al cargar movimientos de almacén:', err);
        this.store.setErrorMovAlmacenes(err.message || 'Error al cargar datos');
      }
    });
  }

  /** PDF del vale de movimiento (Jasper backend). Devuelve el Blob para descargar. */
  descargarMovimientoPdf(id: number): Observable<Blob> {
    return this.descargarMovimientoPdfUC.execute(id);
  }

  cargarReqTraslados(): void {
    this.store.setLoadingReqTraslados(true);

    this.obtenerReqTrasladosUC.execute().subscribe({
      next: (datos) => {
        this.store.setReqTraslados(datos);
      },
      error: (err) => {
        console.error('Error al cargar requerimientos de traslado:', err);
        this.store.setErrorReqTraslados(err.message || 'Error al cargar datos');
      }
    });
  }

  /**
   * Inicializa todos los datos necesarios para el módulo
   * Llama a todos los métodos de carga de datos
   */
  inicializarDatos(): void {
    this.cargarAlmacenes();
    this.cargarCatalogos();
    this.cargarTransferencias();
    this.cargarComparacionesInventario();
  }

  cargarCuadreStock(): void {
    this.store.setLoadingCuadreStock(true);
    this.obtenerCuadreStockUC.execute().subscribe({
      next: (datos) => {
        this.store.setCuadreStock(datos);
        this.store.setLoadingCuadreStock(false);
      },
      error: (err) => {
        this.store.setErrorCuadreStock(err.message || 'Error al cargar cuadre de stock');
      }
    });
  }

  cargarMovimientosCuadreStock(): void {
    this.store.setLoadingMovimientosCuadreStock(true);
    this.obtenerMovimientosCuadreStockUC.execute().subscribe({
      next: (datos) => {
        this.store.setMovimientosCuadreStock(datos);
        this.store.setLoadingMovimientosCuadreStock(false);
      },
      error: (err) => {
        this.store.setErrorMovimientosCuadreStock(err.message || 'Error al cargar movimientos de cuadre de stock');
      }
    });
  }

  cargarActualizacionProductos(): void {
    this.store.setLoadingActualizacionProductos(true);
    this.obtenerActualizacionProductosUC.execute().subscribe({
      next: (datos) => {
        this.store.setActualizacionProductos(datos);
        this.store.setLoadingActualizacionProductos(false);
      },
      error: (err) => {
        this.store.setErrorActualizacionProductos(err.message || 'Error al cargar actualización de productos');
        this.store.setLoadingActualizacionProductos(false);
      }
    });
  }

  resetState(): void {
    this.store.resetState();
  }
}
