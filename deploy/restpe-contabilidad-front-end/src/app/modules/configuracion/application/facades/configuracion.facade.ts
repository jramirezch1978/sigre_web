import { Injectable, inject } from '@angular/core';
import { 
  ObtenerHistorialDatosGeneralesUseCase, 
  ObtenerPlanesUseCase,
  ObtenerPlantillasNotificacionUseCase,
  ObtenerHistorialPlantillasNotificacionUseCase,
  ObtenerCompaniasUseCase,
  ObtenerCanalesPagoCobroUseCase,
  ObtenerCondicionesPagoCobroUseCase,
  ObtenerCuentasBancariasUseCase,
  ObtenerEjerciciosFiscalesUseCase,
  ObtenerMonedasUseCase,
  ObtenerRetencionesUseCase,
  ObtenerUsuariosUseCase,
  ObtenerSucursalesUseCase
} from '../usecases';
import { ConfiguracionStore } from '../../store/configuracion.store';

@Injectable()
export class ConfiguracionFacade {

  private readonly store = inject(ConfiguracionStore);
  private readonly obtenerHistorialDatosGeneralesUC = inject(ObtenerHistorialDatosGeneralesUseCase);
  private readonly obtenerPlanesUC = inject(ObtenerPlanesUseCase);
  private readonly obtenerPlantillasNotificacionUC = inject(ObtenerPlantillasNotificacionUseCase);
  private readonly obtenerHistorialPlantillasNotificacionUC = inject(ObtenerHistorialPlantillasNotificacionUseCase);
  private readonly obtenerCompaniasUC = inject(ObtenerCompaniasUseCase);
  private readonly obtenerCanalesPagoCobroUC = inject(ObtenerCanalesPagoCobroUseCase);
  private readonly obtenerCondicionesPagoCobroUC = inject(ObtenerCondicionesPagoCobroUseCase);
  private readonly obtenerCuentasBancariasUC = inject(ObtenerCuentasBancariasUseCase);
  private readonly obtenerEjerciciosFiscalesUC = inject(ObtenerEjerciciosFiscalesUseCase);
  private readonly obtenerMonedasUC = inject(ObtenerMonedasUseCase);
  private readonly obtenerRetencionesUC = inject(ObtenerRetencionesUseCase);
  private readonly obtenerUsuariosUC = inject(ObtenerUsuariosUseCase);
  private readonly obtenerSucursalesUC = inject(ObtenerSucursalesUseCase);

  // Selectores
  readonly historialDatosGenerales = this.store.historialDatosGenerales;
  readonly planes = this.store.planes;
  readonly plantillasNotificacion = this.store.plantillasNotificacion;
  readonly historialPlantillasNotificacion = this.store.historialPlantillasNotificacion;
  readonly companias = this.store.companias;
  readonly canalesPagoCobro = this.store.canalesPagoCobro;
  readonly condicionesPagoCobro = this.store.condicionesPagoCobro;
  readonly cuentasBancarias = this.store.cuentasBancarias;
  readonly ejerciciosFiscales = this.store.ejerciciosFiscales;
  readonly monedas = this.store.monedas;
  readonly retenciones = this.store.retenciones;
  readonly usuarios = this.store.usuarios;
  readonly sucursales = this.store.sucursales;
  
  readonly loadingHistorialDatosGenerales = this.store.loadingHistorialDatosGenerales;
  readonly loadingPlanes = this.store.loadingPlanes;
  readonly loadingPlantillasNotificacion = this.store.loadingPlantillasNotificacion;
  readonly loadingHistorialPlantillasNotificacion = this.store.loadingHistorialPlantillasNotificacion;
  readonly loadingCompanias = this.store.loadingCompanias;
  readonly loadingCanalesPagoCobro = this.store.loadingCanalesPagoCobro;
  readonly loadingCondicionesPagoCobro = this.store.loadingCondicionesPagoCobro;
  readonly loadingCuentasBancarias = this.store.loadingCuentasBancarias;
  readonly loadingEjerciciosFiscales = this.store.loadingEjerciciosFiscales;
  readonly loadingMonedas = this.store.loadingMonedas;
  readonly loadingRetenciones = this.store.loadingRetenciones;
  readonly loadingUsuarios = this.store.loadingUsuarios;
  readonly loadingSucursales = this.store.loadingSucursales;
  
  readonly errorHistorialDatosGenerales = this.store.errorHistorialDatosGenerales;
  readonly errorPlanes = this.store.errorPlanes;
  readonly errorPlantillasNotificacion = this.store.errorPlantillasNotificacion;
  readonly errorHistorialPlantillasNotificacion = this.store.errorHistorialPlantillasNotificacion;
  readonly errorCompanias = this.store.errorCompanias;
  readonly errorCanalesPagoCobro = this.store.errorCanalesPagoCobro;
  readonly errorCondicionesPagoCobro = this.store.errorCondicionesPagoCobro;
  readonly errorCuentasBancarias = this.store.errorCuentasBancarias;
  readonly errorEjerciciosFiscales = this.store.errorEjerciciosFiscales;
  readonly errorMonedas = this.store.errorMonedas;
  readonly errorRetenciones = this.store.errorRetenciones;
  readonly errorUsuarios = this.store.errorUsuarios;
  readonly errorSucursales = this.store.errorSucursales;
  
  readonly isLoading = this.store.isLoading;
  readonly hasError = this.store.hasError;

  cargarHistorialDatosGenerales(): void {
    this.store.setLoadingHistorialDatosGenerales(true);

    this.obtenerHistorialDatosGeneralesUC.execute().subscribe({
      next: (historial) => {
        this.store.setHistorialDatosGenerales(historial);
      },
      error: (err) => {
        console.error('Error al cargar historial de datos generales:', err);
        this.store.setErrorHistorialDatosGenerales(err.message || 'Error al cargar historial');
      }
    });
  }

  cargarPlanes(): void {
    this.store.setLoadingPlanes(true);

    this.obtenerPlanesUC.execute().subscribe({
      next: (planes) => {
        this.store.setPlanes(planes);
      },
      error: (err) => {
        console.error('Error al cargar planes:', err);
        this.store.setErrorPlanes(err.message || 'Error al cargar planes');
      }
    });
  }

  cargarPlantillasNotificacion(): void {
    this.store.setLoadingPlantillasNotificacion(true);

    this.obtenerPlantillasNotificacionUC.execute().subscribe({
      next: (plantillas) => {
        this.store.setPlantillasNotificacion(plantillas);
      },
      error: (err) => {
        console.error('Error al cargar plantillas de notificación:', err);
        this.store.setErrorPlantillasNotificacion(err.message || 'Error al cargar plantillas');
      }
    });
  }

  cargarHistorialPlantillasNotificacion(): void {
    this.store.setLoadingHistorialPlantillasNotificacion(true);

    this.obtenerHistorialPlantillasNotificacionUC.execute().subscribe({
      next: (historial) => {
        this.store.setHistorialPlantillasNotificacion(historial);
      },
      error: (err) => {
        console.error('Error al cargar historial de plantillas:', err);
        this.store.setErrorHistorialPlantillasNotificacion(err.message || 'Error al cargar historial');
      }
    });
  }

  cargarCompanias(): void {
    this.store.setLoadingCompanias(true);

    this.obtenerCompaniasUC.execute().subscribe({
      next: (companias) => {
        this.store.setCompanias(companias);
      },
      error: (err) => {
        console.error('Error al cargar compañías:', err);
        this.store.setErrorCompanias(err.message || 'Error al cargar compañías');
      }
    });
  }

  cargarCanalesPagoCobro(): void {
    this.store.setLoadingCanalesPagoCobro(true);

    this.obtenerCanalesPagoCobroUC.execute().subscribe({
      next: (canales) => {
        this.store.setCanalesPagoCobro(canales);
      },
      error: (err) => {
        console.error('Error al cargar canales de pago/cobro:', err);
        this.store.setErrorCanalesPagoCobro(err.message || 'Error al cargar canales');
      }
    });
  }

  clearCanalesPagoCobro(): void {
    this.store.clearCanalesPagoCobro();
  }

  cargarCondicionesPagoCobro(): void {
    this.store.setLoadingCondicionesPagoCobro(true);

    this.obtenerCondicionesPagoCobroUC.execute().subscribe({
      next: (condiciones) => {
        this.store.setCondicionesPagoCobro(condiciones);
      },
      error: (err) => {
        console.error('Error al cargar condiciones de pago/cobro:', err);
        this.store.setErrorCondicionesPagoCobro(err.message || 'Error al cargar condiciones');
      }
    });
  }

  clearCondicionesPagoCobro(): void {
    this.store.clearCondicionesPagoCobro();
  }

  cargarCuentasBancarias(): void {
    this.store.setLoadingCuentasBancarias(true);

    this.obtenerCuentasBancariasUC.execute().subscribe({
      next: (cuentas) => {
        this.store.setCuentasBancarias(cuentas);
      },
      error: (err) => {
        console.error('Error al cargar cuentas bancarias:', err);
        this.store.setErrorCuentasBancarias(err.message || 'Error al cargar cuentas bancarias');
      }
    });
  }

  clearCuentasBancarias(): void {
    this.store.clearCuentasBancarias();
  }

  cargarEjerciciosFiscales(): void {
    this.store.setLoadingEjerciciosFiscales(true);

    this.obtenerEjerciciosFiscalesUC.execute().subscribe({
      next: (ejercicios) => {
        this.store.setEjerciciosFiscales(ejercicios);
      },
      error: (err) => {
        console.error('Error al cargar ejercicios fiscales:', err);
        this.store.setErrorEjerciciosFiscales(err.message || 'Error al cargar ejercicios fiscales');
      }
    });
  }

  clearEjerciciosFiscales(): void {
    this.store.clearEjerciciosFiscales();
  }

  cargarMonedas(): void {
    this.store.setLoadingMonedas(true);

    this.obtenerMonedasUC.execute().subscribe({
      next: (monedas) => {
        this.store.setMonedas(monedas);
      },
      error: (err) => {
        console.error('Error al cargar monedas:', err);
        this.store.setErrorMonedas(err.message || 'Error al cargar monedas');
      }
    });
  }

  clearMonedas(): void {
    this.store.clearMonedas();
  }

  cargarRetenciones(): void {
    this.store.setLoadingRetenciones(true);

    this.obtenerRetencionesUC.execute().subscribe({
      next: (retenciones) => {
        this.store.setRetenciones(retenciones);
      },
      error: (err) => {
        console.error('Error al cargar retenciones:', err);
        this.store.setErrorRetenciones(err.message || 'Error al cargar retenciones');
      }
    });
  }

  clearRetenciones(): void {
    this.store.clearRetenciones();
  }

  cargarUsuarios(): void {
    this.store.setLoadingUsuarios(true);

    this.obtenerUsuariosUC.execute().subscribe({
      next: (usuarios) => {
        this.store.setUsuarios(usuarios);
      },
      error: (err) => {
        console.error('Error al cargar usuarios:', err);
        this.store.setErrorUsuarios(err.message || 'Error al cargar usuarios');
      }
    });
  }

  clearUsuarios(): void {
    this.store.clearUsuarios();
  }

  cargarSucursales(): void {
    this.store.setLoadingSucursales(true);

    this.obtenerSucursalesUC.execute().subscribe({
      next: (sucursales) => {
        this.store.setSucursales(sucursales);
      },
      error: (err) => {
        console.error('Error al cargar sucursales:', err);
        this.store.setErrorSucursales(err.message || 'Error al cargar sucursales');
      }
    });
  }

  clearSucursales(): void {
    this.store.clearSucursales();
  }

  resetState(): void {
    this.store.resetState();
  }
}
