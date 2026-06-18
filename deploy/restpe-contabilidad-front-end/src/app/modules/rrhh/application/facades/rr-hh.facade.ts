import { Injectable, inject } from '@angular/core';
import { RrHhStore } from '../../store/rr-hh.store';
import { ObtenerPermisosUseCase } from '../usecases/obtener-permisos.usecase';
import { ObtenerPermisosRegistroUseCase } from '../usecases/obtener-permisos-registro.usecase';
import { ObtenerVacacionesLicenciasUseCase } from '../usecases/obtener-vacaciones-licencias.usecase';
import { ObtenerVacacionesLicenciasRegistroUseCase } from '../usecases/obtener-vacaciones-licencias-registro.usecase';
import { ObtenerAsistenciasUseCase } from '../usecases/obtener-asistencias.usecase';
import { ObtenerCalendariosLaboralesUseCase } from '../usecases/obtener-calendarios-laborales.usecase';
import { ObtenerAnalisisInconsistenciaNominaUseCase } from '../usecases/obtener-analisis-inconsistencia-nomina.usecase';
import { ObtenerInasistenciasUseCase } from '../usecases/obtener-inasistencias.usecase';
import { ObtenerReportesPlanillaUseCase } from '../usecases/obtener-reportes-planilla.usecase';
import { ObtenerAfiliacionFondosPensionUseCase } from '../usecases/obtener-afiliacion-fondos-pension.usecase';
import { ObtenerCategoriasLaboralesUseCase } from '../usecases/obtener-categorias-laborales.usecase';
import { ObtenerDefinicionAreasJerarquiasUseCase } from '../usecases/obtener-definicion-areas-jerarquias.usecase';
import { ObtenerDefinicionCargosUseCase } from '../usecases/obtener-definicion-cargos.usecase';
import { ObtenerDatosPersonalesUseCase } from '../usecases/obtener-datos-personales.usecase';
import { ObtenerAgrupacionSedeUseCase } from '../usecases/obtener-agrupacion-sede.usecase';
import { ObtenerConfiguracionProvisionesUseCase } from '../usecases/obtener-configuracion-provisiones.usecase';
import { ObtenerFrecuenciaCalendariosUseCase } from '../usecases/obtener-frecuencia-calendarios.usecase';
import { ObtenerGeneracionNumeracionUseCase } from '../usecases/obtener-generacion-numeracion.usecase';
import { ObtenerPaisVigenciaUseCase } from '../usecases/obtener-pais-vigencia.usecase';
import { ObtenerTipoContratoUseCase } from '../usecases/obtener-tipo-contrato.usecase';
import { ObtenerAprobarPlanillaUseCase } from '../usecases/obtener-aprobar-planilla.usecase';
import { ObtenerCalculoPlanillaUseCase } from '../usecases/obtener-calculo-planilla.usecase';
import { ObtenerConceptosUseCase } from '../usecases/obtener-conceptos.usecase';
import { ObtenerProcesosEspecialesUseCase } from '../usecases/obtener-procesos-especiales.usecase';
import { ObtenerProvisionGastoUseCase } from '../usecases/obtener-provision-gasto.usecase';
import { ObtenerRegistrarLiquidacionUseCase } from '../usecases/obtener-registrar-liquidacion.usecase';
import { ObtenerDashboardRrhhUseCase } from '../usecases/obtener-dashboard-rrhh.usecase';
import { ObtenerDistribucionCostosUseCase } from '../usecases/obtener-distribucion-costos.usecase';
import { ObtenerEmisionBoletasUseCase } from '../usecases/obtener-emision-boletas.usecase';
import { ObtenerGeneracionArchivosUseCase } from '../usecases/obtener-generacion-archivos.usecase';
import { ObtenerIndicadoresRotacionUseCase } from '../usecases/obtener-indicadores-rotacion.usecase';
import { PlanillaEntity } from '@modules/rrhh/domain/models/planilla.entity';
import { LiquidacionEntity } from '@modules/rrhh/domain/models/liquidacion.entity';

@Injectable()
export class RrHhFacade {
  private readonly store = inject(RrHhStore);
  private readonly obtenerPermisosUseCase = inject(ObtenerPermisosUseCase);
  private readonly obtenerPermisosRegistroUseCase = inject(ObtenerPermisosRegistroUseCase);
  private readonly obtenerVacacionesLicenciasUseCase = inject(ObtenerVacacionesLicenciasUseCase);
  private readonly obtenerVacacionesLicenciasRegistroUseCase = inject(ObtenerVacacionesLicenciasRegistroUseCase);
  private readonly obtenerAsistenciasUseCase = inject(ObtenerAsistenciasUseCase);
  private readonly obtenerCalendariosLaboralesUseCase = inject(ObtenerCalendariosLaboralesUseCase);
  private readonly obtenerAnalisisInconsistenciaNominaUseCase = inject(ObtenerAnalisisInconsistenciaNominaUseCase);
  private readonly obtenerInasistenciasUseCase = inject(ObtenerInasistenciasUseCase);
  private readonly obtenerReportesPlanillaUseCase = inject(ObtenerReportesPlanillaUseCase);
  private readonly obtenerAfiliacionFondosPensionUseCase = inject(ObtenerAfiliacionFondosPensionUseCase);
  private readonly obtenerCategoriasLaboralesUseCase = inject(ObtenerCategoriasLaboralesUseCase);
  private readonly obtenerDefinicionAreasJerarquiasUseCase = inject(ObtenerDefinicionAreasJerarquiasUseCase);
  private readonly obtenerDefinicionCargosUseCase = inject(ObtenerDefinicionCargosUseCase);
  private readonly obtenerDatosPersonalesUseCase = inject(ObtenerDatosPersonalesUseCase);
  private readonly obtenerAgrupacionSedeUseCase = inject(ObtenerAgrupacionSedeUseCase);
  private readonly obtenerConfiguracionProvisionesUseCase = inject(ObtenerConfiguracionProvisionesUseCase);
  private readonly obtenerFrecuenciaCalendariosUseCase = inject(ObtenerFrecuenciaCalendariosUseCase);
  private readonly obtenerGeneracionNumeracionUseCase = inject(ObtenerGeneracionNumeracionUseCase);
  private readonly obtenerPaisVigenciaUseCase = inject(ObtenerPaisVigenciaUseCase);
  private readonly obtenerTipoContratoUseCase = inject(ObtenerTipoContratoUseCase);
  private readonly obtenerAprobarPlanillaUseCase = inject(ObtenerAprobarPlanillaUseCase);
  private readonly obtenerCalculoPlanillaUseCase = inject(ObtenerCalculoPlanillaUseCase);
  private readonly obtenerConceptosUseCase = inject(ObtenerConceptosUseCase);
  private readonly obtenerProcesosEspecialesUseCase = inject(ObtenerProcesosEspecialesUseCase);
  private readonly obtenerProvisionGastoUseCase = inject(ObtenerProvisionGastoUseCase);
  private readonly obtenerRegistrarLiquidacionUseCase = inject(ObtenerRegistrarLiquidacionUseCase);
  private readonly obtenerDashboardRrhhUseCase = inject(ObtenerDashboardRrhhUseCase);
  private readonly obtenerDistribucionCostosUseCase = inject(ObtenerDistribucionCostosUseCase);
  private readonly obtenerEmisionBoletasUseCase = inject(ObtenerEmisionBoletasUseCase);
  private readonly obtenerGeneracionArchivosUseCase = inject(ObtenerGeneracionArchivosUseCase);
  private readonly obtenerIndicadoresRotacionUseCase = inject(ObtenerIndicadoresRotacionUseCase);

  // Selectores expuestos al exterior
  readonly permisos = this.store.permisos;
  readonly loadingPermisos = this.store.loadingPermisos;
  readonly errorPermisos = this.store.errorPermisos;
  readonly permisosRegistro = this.store.permisosRegistro;
  readonly loadingPermisosRegistro = this.store.loadingPermisosRegistro;
  readonly vacacionesLicencias = this.store.vacacionesLicencias;
  readonly loadingVacacionesLicencias = this.store.loadingVacacionesLicencias;
  readonly vacacionesLicenciasRegistro = this.store.vacacionesLicenciasRegistro;
  readonly loadingVacacionesLicenciasRegistro = this.store.loadingVacacionesLicenciasRegistro;
  readonly asistencias = this.store.asistencias;
  readonly loadingAsistencias = this.store.loadingAsistencias;
  readonly calendariosLaborales = this.store.calendariosLaborales;
  readonly loadingCalendariosLaborales = this.store.loadingCalendariosLaborales;
  readonly analisisInconsistenciaNomina = this.store.analisisInconsistenciaNomina;
  readonly loadingAnalisisInconsistenciaNomina = this.store.loadingAnalisisInconsistenciaNomina;
  readonly errorAnalisisInconsistenciaNomina = this.store.errorAnalisisInconsistenciaNomina;
  readonly inasistencias = this.store.inasistencias;
  readonly loadingInasistencias = this.store.loadingInasistencias;
  readonly errorInasistencias = this.store.errorInasistencias;
  readonly reportesPlanilla = this.store.reportesPlanilla;
  readonly loadingReportesPlanilla = this.store.loadingReportesPlanilla;
  readonly errorReportesPlanilla = this.store.errorReportesPlanilla;
  readonly afiliacionFondosPension = this.store.afiliacionFondosPension;
  readonly loadingAfiliacionFondosPension = this.store.loadingAfiliacionFondosPension;
  readonly errorAfiliacionFondosPension = this.store.errorAfiliacionFondosPension;
  readonly categoriasLaborales = this.store.categoriasLaborales;
  readonly loadingCategoriasLaborales = this.store.loadingCategoriasLaborales;
  readonly errorCategoriasLaborales = this.store.errorCategoriasLaborales;
  readonly definicionAreasJerarquias = this.store.definicionAreasJerarquias;
  readonly loadingDefinicionAreasJerarquias = this.store.loadingDefinicionAreasJerarquias;
  readonly errorDefinicionAreasJerarquias = this.store.errorDefinicionAreasJerarquias;
  readonly definicionCargos = this.store.definicionCargos;
  readonly loadingDefinicionCargos = this.store.loadingDefinicionCargos;
  readonly errorDefinicionCargos = this.store.errorDefinicionCargos;
  readonly datosPersonales = this.store.datosPersonales;
  readonly loadingDatosPersonales = this.store.loadingDatosPersonales;
  readonly errorDatosPersonales = this.store.errorDatosPersonales;
  readonly agrupacionSede = this.store.agrupacionSede;
  readonly loadingAgrupacionSede = this.store.loadingAgrupacionSede;
  readonly errorAgrupacionSede = this.store.errorAgrupacionSede;
  readonly configuracionProvisiones = this.store.configuracionProvisiones;
  readonly loadingConfiguracionProvisiones = this.store.loadingConfiguracionProvisiones;
  readonly errorConfiguracionProvisiones = this.store.errorConfiguracionProvisiones;

  readonly frecuenciaCalendarios = this.store.frecuenciaCalendarios;
  readonly loadingFrecuenciaCalendarios = this.store.loadingFrecuenciaCalendarios;
  readonly errorFrecuenciaCalendarios = this.store.errorFrecuenciaCalendarios;

  readonly generacionNumeracion = this.store.generacionNumeracion;
  readonly loadingGeneracionNumeracion = this.store.loadingGeneracionNumeracion;
  readonly errorGeneracionNumeracion = this.store.errorGeneracionNumeracion;
  readonly isLoading = this.store.isLoading;

  readonly paisVigencia = this.store.paisVigencia;
  readonly loadingPaisVigencia = this.store.loadingPaisVigencia;
  readonly errorPaisVigencia = this.store.errorPaisVigencia;

  readonly tipoContrato = this.store.tipoContrato;
  readonly loadingTipoContrato = this.store.loadingTipoContrato;
  readonly errorTipoContrato = this.store.errorTipoContrato;

  readonly aprobarPlanilla = this.store.aprobarPlanilla;
  readonly loadingAprobarPlanilla = this.store.loadingAprobarPlanilla;
  readonly errorAprobarPlanilla = this.store.errorAprobarPlanilla;

  readonly calculoPlanilla = this.store.calculoPlanilla;
  readonly loadingCalculoPlanilla = this.store.loadingCalculoPlanilla;
  readonly errorCalculoPlanilla = this.store.errorCalculoPlanilla;

  readonly conceptos = this.store.conceptos;
  readonly loadingConceptos = this.store.loadingConceptos;
  readonly errorConceptos = this.store.errorConceptos;

  readonly procesosEspeciales = this.store.procesosEspeciales;
  readonly loadingProcesosEspeciales = this.store.loadingProcesosEspeciales;
  readonly errorProcesosEspeciales = this.store.errorProcesosEspeciales;
  readonly provisionGasto = this.store.provisionGasto;
  readonly loadingProvisionGasto = this.store.loadingProvisionGasto;
  readonly errorProvisionGasto = this.store.errorProvisionGasto;
  readonly registrarLiquidacion = this.store.registrarLiquidacion;
  readonly loadingRegistrarLiquidacion = this.store.loadingRegistrarLiquidacion;
  readonly errorRegistrarLiquidacion = this.store.errorRegistrarLiquidacion;
  readonly dashboardRrhh = this.store.dashboardRrhh;
  readonly loadingDashboardRrhh = this.store.loadingDashboardRrhh;
  readonly errorDashboardRrhh = this.store.errorDashboardRrhh;
  readonly distribucionCostos = this.store.distribucionCostos;
  readonly loadingDistribucionCostos = this.store.loadingDistribucionCostos;
  readonly errorDistribucionCostos = this.store.errorDistribucionCostos;
  readonly emisionBoletas = this.store.emisionBoletas;
  readonly loadingEmisionBoletas = this.store.loadingEmisionBoletas;
  readonly errorEmisionBoletas = this.store.errorEmisionBoletas;

  readonly generacionArchivos = this.store.generacionArchivos;
  readonly loadingGeneracionArchivos = this.store.loadingGeneracionArchivos;
  readonly errorGeneracionArchivos = this.store.errorGeneracionArchivos;

  readonly indicadoresRotacion = this.store.indicadoresRotacion;
  readonly loadingIndicadoresRotacion = this.store.loadingIndicadoresRotacion;
  readonly errorIndicadoresRotacion = this.store.errorIndicadoresRotacion;

  constructor() {}

  cargarPermisos(): void {
    this.store.setLoadingPermisos(true);
    this.obtenerPermisosUseCase.execute().subscribe({
      next: (permisos) => this.store.setPermisos(permisos),
      error: (err) => this.store.setErrorPermisos(err?.message ?? 'Error al cargar los permisos'),
    });
  }

  clearPermisos(): void {
    this.store.clearPermisos();
  }

  cargarPermisosRegistro(): void {
    this.store.setLoadingPermisosRegistro(true);
    this.obtenerPermisosRegistroUseCase.execute().subscribe({
      next: (data) => this.store.setPermisosRegistro(data),
      error: (err) => this.store.setErrorPermisosRegistro(err?.message ?? 'Error al cargar los permisos'),
    });
  }

  clearPermisosRegistro(): void {
    this.store.clearPermisosRegistro();
  }

  cargarVacacionesLicencias(): void {
    this.store.setLoadingVacacionesLicencias(true);
    this.obtenerVacacionesLicenciasUseCase.execute().subscribe({
      next: (data) => this.store.setVacacionesLicencias(data),
      error: (err) => this.store.setErrorVacacionesLicencias(err?.message ?? 'Error al cargar vacaciones y licencias'),
    });
  }

  clearVacacionesLicencias(): void {
    this.store.clearVacacionesLicencias();
  }

  cargarVacacionesLicenciasRegistro(): void {
    this.store.setLoadingVacacionesLicenciasRegistro(true);
    this.obtenerVacacionesLicenciasRegistroUseCase.execute().subscribe({
      next: (data) => this.store.setVacacionesLicenciasRegistro(data),
      error: (err) => this.store.setErrorVacacionesLicenciasRegistro(err?.message ?? 'Error al cargar vacaciones y licencias registro'),
    });
  }

  clearVacacionesLicenciasRegistro(): void {
    this.store.clearVacacionesLicenciasRegistro();
  }

  cargarAsistencias(): void {
    this.store.setLoadingAsistencias(true);
    this.obtenerAsistenciasUseCase.execute().subscribe({
      next: (data) => this.store.setAsistencias(data),
      error: (err) => this.store.setErrorAsistencias(err?.message ?? 'Error al cargar las asistencias'),
    });
  }

  clearAsistencias(): void {
    this.store.clearAsistencias();
  }

  cargarCalendariosLaborales(): void {
    this.store.setLoadingCalendariosLaborales(true);
    this.obtenerCalendariosLaboralesUseCase.execute().subscribe({
      next: (data) => this.store.setCalendariosLaborales(data),
      error: (err) => this.store.setErrorCalendariosLaborales(err?.message ?? 'Error al cargar los calendarios laborales'),
    });
  }

  clearCalendariosLaborales(): void {
    this.store.clearCalendariosLaborales();
  }

  cargarAnalisisInconsistenciaNomina(): void {
    this.store.setLoadingAnalisisInconsistenciaNomina(true);
    this.obtenerAnalisisInconsistenciaNominaUseCase.execute().subscribe({
      next: (data) => this.store.setAnalisisInconsistenciaNomina(data),
      error: (err) => this.store.setErrorAnalisisInconsistenciaNomina(err?.message ?? 'Error al cargar el análisis de inconsistencias de nómina'),
    });
  }

  clearAnalisisInconsistenciaNomina(): void {
    this.store.clearAnalisisInconsistenciaNomina();
  }

  cargarInasistencias(): void {
    this.store.setLoadingInasistencias(true);
    this.obtenerInasistenciasUseCase.execute().subscribe({
      next: (data) => this.store.setInasistencias(data),
      error: (err) => this.store.setErrorInasistencias(err?.message ?? 'Error al cargar las inasistencias'),
    });
  }

  clearInasistencias(): void {
    this.store.clearInasistencias();
  }

  cargarReportesPlanilla(): void {
    this.store.setLoadingReportesPlanilla(true);
    this.obtenerReportesPlanillaUseCase.execute().subscribe({
      next: (data) => this.store.setReportesPlanilla(data),
      error: (err) => this.store.setErrorReportesPlanilla(err?.message ?? 'Error al cargar los reportes de planilla'),
    });
  }

  clearReportesPlanilla(): void {
    this.store.clearReportesPlanilla();
  }

  cargarAfiliacionFondosPension(): void {
    this.store.setLoadingAfiliacionFondosPension(true);
    this.obtenerAfiliacionFondosPensionUseCase.execute().subscribe({
      next: (data) => this.store.setAfiliacionFondosPension(data),
      error: (err) => this.store.setErrorAfiliacionFondosPension(err?.message ?? 'Error al cargar la afiliación a fondos de pensión'),
    });
  }

  clearAfiliacionFondosPension(): void {
    this.store.clearAfiliacionFondosPension();
  }

  cargarCategoriasLaborales(): void {
    this.store.setLoadingCategoriasLaborales(true);
    this.obtenerCategoriasLaboralesUseCase.execute().subscribe({
      next: (data) => this.store.setCategoriasLaborales(data),
      error: (err) => this.store.setErrorCategoriasLaborales(err?.message ?? 'Error al cargar las categorías laborales'),
    });
  }

  clearCategoriasLaborales(): void {
    this.store.clearCategoriasLaborales();
  }

  cargarDefinicionAreasJerarquias(): void {
    this.store.setLoadingDefinicionAreasJerarquias(true);
    this.obtenerDefinicionAreasJerarquiasUseCase.execute().subscribe({
      next: (data) => this.store.setDefinicionAreasJerarquias(data),
      error: (err) => this.store.setErrorDefinicionAreasJerarquias(err?.message ?? 'Error al cargar la definición de áreas y jerarquías'),
    });
  }

  clearDefinicionAreasJerarquias(): void {
    this.store.clearDefinicionAreasJerarquias();
  }

  cargarDefinicionCargos(): void {
    this.store.setLoadingDefinicionCargos(true);
    this.obtenerDefinicionCargosUseCase.execute().subscribe({
      next: (data) => this.store.setDefinicionCargos(data),
      error: (err) => this.store.setErrorDefinicionCargos(err?.message ?? 'Error al cargar la definición de cargos'),
    });
  }

  clearDefinicionCargos(): void {
    this.store.clearDefinicionCargos();
  }

  cargarDatosPersonales(): void {
    this.store.setLoadingDatosPersonales(true);
    this.obtenerDatosPersonalesUseCase.execute().subscribe({
      next: (data) => this.store.setDatosPersonales(data),
      error: (err) => this.store.setErrorDatosPersonales(err?.message ?? 'Error al cargar los datos personales'),
    });
  }

  clearDatosPersonales(): void {
    this.store.clearDatosPersonales();
  }

  cargarAgrupacionSede(): void {
    this.store.setLoadingAgrupacionSede(true);
    this.obtenerAgrupacionSedeUseCase.execute().subscribe({
      next: (data) => this.store.setAgrupacionSede(data),
      error: (err) => this.store.setErrorAgrupacionSede(err?.message ?? 'Error al cargar la agrupación por sede'),
    });
  }

  clearAgrupacionSede(): void {
    this.store.clearAgrupacionSede();
  }

  cargarConfiguracionProvisiones(): void {
    this.store.setLoadingConfiguracionProvisiones(true);
    this.obtenerConfiguracionProvisionesUseCase.execute().subscribe({
      next: (data) => this.store.setConfiguracionProvisiones(data),
      error: (err) => this.store.setErrorConfiguracionProvisiones(err?.message ?? 'Error al cargar la configuración de provisiones'),
    });
  }

  clearConfiguracionProvisiones(): void {
    this.store.clearConfiguracionProvisiones();
  }

  cargarFrecuenciaCalendarios(): void {
    this.store.setLoadingFrecuenciaCalendarios(true);
    this.obtenerFrecuenciaCalendariosUseCase.execute().subscribe({
      next: (data) => this.store.setFrecuenciaCalendarios(data),
      error: (err) => this.store.setErrorFrecuenciaCalendarios(err?.message ?? 'Error al cargar la frecuencia y calendarios'),
    });
  }

  clearFrecuenciaCalendarios(): void {
    this.store.clearFrecuenciaCalendarios();
  }

  cargarGeneracionNumeracion(): void {
    this.store.setLoadingGeneracionNumeracion(true);
    this.obtenerGeneracionNumeracionUseCase.execute().subscribe({
      next: (data) => this.store.setGeneracionNumeracion(data),
      error: (err) => this.store.setErrorGeneracionNumeracion(err?.message ?? 'Error al cargar la generación de numeración'),
    });
  }

  clearGeneracionNumeracion(): void {
    this.store.clearGeneracionNumeracion();
  }

  cargarPaisVigencia(): void {
    this.store.setLoadingPaisVigencia(true);
    this.obtenerPaisVigenciaUseCase.execute().subscribe({
      next: (data) => this.store.setPaisVigencia(data),
      error: (err) => this.store.setErrorPaisVigencia(err?.message ?? 'Error al cargar país y vigencia'),
    });
  }

  clearPaisVigencia(): void {
    this.store.clearPaisVigencia();
  }

  cargarTipoContrato(): void {
    this.store.setLoadingTipoContrato(true);
    this.obtenerTipoContratoUseCase.execute().subscribe({
      next: (data) => this.store.setTipoContrato(data),
      error: (err) => this.store.setErrorTipoContrato(err?.message ?? 'Error al cargar tipo de contrato'),
    });
  }

  clearTipoContrato(): void {
    this.store.clearTipoContrato();
  }

  cargarAprobarPlanilla(): void {
    this.store.setLoadingAprobarPlanilla(true);
    this.obtenerAprobarPlanillaUseCase.execute().subscribe({
      next: (data) => this.store.setAprobarPlanilla(data),
      error: (err) => this.store.setErrorAprobarPlanilla(err?.message ?? 'Error al cargar aprobar planilla'),
    });
  }

  clearAprobarPlanilla(): void {
    this.store.clearAprobarPlanilla();
  }

  cargarCalculoPlanilla(): void {
    this.store.setLoadingCalculoPlanilla(true);
    this.obtenerCalculoPlanillaUseCase.execute().subscribe({
      next: (data) => this.store.setCalculoPlanilla(data),
      error: (err) => this.store.setErrorCalculoPlanilla(err?.message ?? 'Error al cargar cálculo de planilla'),
    });
  }

  actualizarCalculoPlanilla(calculoPlanilla: PlanillaEntity[]): void {
    this.store.setCalculoPlanilla(calculoPlanilla);
  }

  clearCalculoPlanilla(): void {
    this.store.clearCalculoPlanilla();
  }

  cargarConceptos(): void {
    this.store.setLoadingConceptos(true);
    this.obtenerConceptosUseCase.execute().subscribe({
      next: (data) => this.store.setConceptos(data),
      error: (err) => this.store.setErrorConceptos(err?.message ?? 'Error al cargar conceptos'),
    });
  }

  clearConceptos(): void {
    this.store.clearConceptos();
  }

  cargarProcesosEspeciales(): void {
    this.store.setLoadingProcesosEspeciales(true);
    this.obtenerProcesosEspecialesUseCase.execute().subscribe({
      next: (data) => this.store.setProcesosEspeciales(data),
      error: (err) => this.store.setErrorProcesosEspeciales(err?.message ?? 'Error al cargar procesos especiales'),
    });
  }

  clearProcesosEspeciales(): void {
    this.store.clearProcesosEspeciales();
  }

  cargarProvisionGasto(): void {
    this.store.setLoadingProvisionGasto(true);
    this.obtenerProvisionGastoUseCase.execute().subscribe({
      next: (data) => this.store.setProvisionGasto(data),
      error: (err) => this.store.setErrorProvisionGasto(err?.message ?? 'Error al cargar provisión de gasto'),
    });
  }

  clearProvisionGasto(): void {
    this.store.clearProvisionGasto();
  }

  cargarRegistrarLiquidacion(): void {
    this.store.setLoadingRegistrarLiquidacion(true);
    this.obtenerRegistrarLiquidacionUseCase.execute().subscribe({
      next: (data) => this.store.setRegistrarLiquidacion(data),
      error: (err) => this.store.setErrorRegistrarLiquidacion(err?.message ?? 'Error al cargar registrar liquidación'),
    });
  }

  actualizarRegistrarLiquidacion(registrarLiquidacion: LiquidacionEntity[]): void {
    this.store.setRegistrarLiquidacion(registrarLiquidacion);
  }

  clearRegistrarLiquidacion(): void {
    this.store.clearRegistrarLiquidacion();
  }

  cargarDashboardRrhh(): void {
    this.store.setLoadingDashboardRrhh(true);
    this.obtenerDashboardRrhhUseCase.execute().subscribe({
      next: (data) => this.store.setDashboardRrhh(data),
      error: (err) => this.store.setErrorDashboardRrhh(err?.message ?? 'Error al cargar el dashboard de RR.HH'),
    });
  }

  clearDashboardRrhh(): void {
    this.store.clearDashboardRrhh();
  }

  cargarDistribucionCostos(): void {
    this.store.setLoadingDistribucionCostos(true);
    this.obtenerDistribucionCostosUseCase.execute().subscribe({
      next: (data) => this.store.setDistribucionCostos(data),
      error: (err) => this.store.setErrorDistribucionCostos(err?.message ?? 'Error al cargar la distribución de costos'),
    });
  }

  clearDistribucionCostos(): void {
    this.store.clearDistribucionCostos();
  }

  cargarEmisionBoletas(): void {
    this.store.setLoadingEmisionBoletas(true);
    this.obtenerEmisionBoletasUseCase.execute().subscribe({
      next: (data) => this.store.setEmisionBoletas(data),
      error: (err) => this.store.setErrorEmisionBoletas(err?.message ?? 'Error al cargar la emisión de boletas'),
    });
  }

  clearEmisionBoletas(): void {
    this.store.clearEmisionBoletas();
  }

  cargarGeneracionArchivos(): void {
    this.store.setLoadingGeneracionArchivos(true);
    this.obtenerGeneracionArchivosUseCase.execute().subscribe({
      next: (data) => this.store.setGeneracionArchivos(data),
      error: (err) => this.store.setErrorGeneracionArchivos(err?.message ?? 'Error al cargar la generación de archivos'),
    });
  }

  clearGeneracionArchivos(): void {
    this.store.clearGeneracionArchivos();
  }

  cargarIndicadoresRotacion(): void {
    this.store.setLoadingIndicadoresRotacion(true);
    this.obtenerIndicadoresRotacionUseCase.execute().subscribe({
      next: (data) => this.store.setIndicadoresRotacion(data),
      error: (err) => this.store.setErrorIndicadoresRotacion(err?.message ?? 'Error al cargar los indicadores de rotación'),
    });
  }

  clearIndicadoresRotacion(): void {
    this.store.clearIndicadoresRotacion();
  }

  resetState(): void {
    this.store.resetState();
  }
}
