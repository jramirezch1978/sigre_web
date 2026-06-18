import { Injectable, computed, signal } from '@angular/core';
import { RrHhState, initialRrHhState } from './rr-hh.state';
import { PermisoEntity } from '../domain/models/permiso.entity';
import { VacacionLicenciaEntity } from '../domain/models/vacacion-licencia.entity';
import { AsistenciaEntity } from '../domain/models/asistencia.entity';
import { CalendarioLaboralEntity } from '../domain/models/calendario-laboral.entity';
import { AnalisisInconsistenciaEntity } from '../domain/models/analisis-inconsistencia.entity';
import { InasistenciaEntity } from '../domain/models/inasistencia.entity';
import { ReportePlanillaEntity } from '../domain/models/reporte-planilla.entity';
import { AfiliacionFondosPensionEntity } from '../domain/models/afiliacion-fondos-pension.entity';
import { CategoriaLaboralEntity } from '../domain/models/categoria-laboral.entity';
import { DefinicionAreasJerarquiasEntity } from '../domain/models/definicion-areas-jerarquias.entity';
import { DefinicionCargosEntity } from '../domain/models/definicion-cargos.entity';
import { DatosPersonalesEntity } from '../domain/models/datos-personales.entity';
import { AgrupacionSedeEntity } from '../domain/models/agrupacion-sede.entity';
import { ConfiguracionProvisionesEntity } from '../domain/models/configuracion-provisiones.entity';
import { FrecuenciaCalendariosEntity } from '../domain/models/frecuencia-calendarios.entity';
import { GeneracionNumeracionEntity } from '../domain/models/generacion-numeracion.entity';
import { PaisVigenciaEntity } from '../domain/models/pais-vigencia.entity';
import { TipoContratoEntity } from '../domain/models/tipo-contrato.entity';
import { PlanillaEntity } from '../domain/models/planilla.entity';
import { ConceptoEntity } from '../domain/models/concepto.entity';
import { ProcesosEspecialesEntity } from '../domain/models/procesos-especiales.entity';
import { ProvisionGastoEntity } from '../domain/models/provision-gasto.entity';
import { LiquidacionEntity } from '../domain/models/liquidacion.entity';
import { DashboardRrhhEntity } from '../domain/models/dashboard-rrhh.entity';
import { DistribucionCostosEntity } from '../domain/models/distribucion-costos.entity';
import { EmisionBoletasEntity } from '../domain/models/emision-boletas.entity';
import { GeneracionArchivosEntity } from '../domain/models/generacion-archivos.entity';
import { IndicadoresRotacionEntity } from '../domain/models/indicadores-rotacion.entity';

@Injectable()
export class RrHhStore {
  private readonly state = signal<RrHhState>(initialRrHhState);

  // Selectores
  readonly permisos = computed(() => this.state().permisos);
  readonly loadingPermisos = computed(() => this.state().loadingPermisos);
  readonly errorPermisos = computed(() => this.state().errorPermisos);

  readonly permisosRegistro = computed(() => this.state().permisosRegistro);
  readonly loadingPermisosRegistro = computed(() => this.state().loadingPermisosRegistro);
  readonly errorPermisosRegistro = computed(() => this.state().errorPermisosRegistro);

  readonly vacacionesLicencias = computed(() => this.state().vacacionesLicencias);
  readonly loadingVacacionesLicencias = computed(() => this.state().loadingVacacionesLicencias);
  readonly errorVacacionesLicencias = computed(() => this.state().errorVacacionesLicencias);

  readonly vacacionesLicenciasRegistro = computed(() => this.state().vacacionesLicenciasRegistro);
  readonly loadingVacacionesLicenciasRegistro = computed(() => this.state().loadingVacacionesLicenciasRegistro);
  readonly errorVacacionesLicenciasRegistro = computed(() => this.state().errorVacacionesLicenciasRegistro);

  readonly asistencias = computed(() => this.state().asistencias);
  readonly loadingAsistencias = computed(() => this.state().loadingAsistencias);
  readonly errorAsistencias = computed(() => this.state().errorAsistencias);

  readonly calendariosLaborales = computed(() => this.state().calendariosLaborales);
  readonly loadingCalendariosLaborales = computed(() => this.state().loadingCalendariosLaborales);
  readonly errorCalendariosLaborales = computed(() => this.state().errorCalendariosLaborales);

  readonly analisisInconsistenciaNomina = computed(() => this.state().analisisInconsistenciaNomina);
  readonly loadingAnalisisInconsistenciaNomina = computed(() => this.state().loadingAnalisisInconsistenciaNomina);
  readonly errorAnalisisInconsistenciaNomina = computed(() => this.state().errorAnalisisInconsistenciaNomina);

  readonly inasistencias = computed(() => this.state().inasistencias);
  readonly loadingInasistencias = computed(() => this.state().loadingInasistencias);
  readonly errorInasistencias = computed(() => this.state().errorInasistencias);

  readonly reportesPlanilla = computed(() => this.state().reportesPlanilla);
  readonly loadingReportesPlanilla = computed(() => this.state().loadingReportesPlanilla);
  readonly errorReportesPlanilla = computed(() => this.state().errorReportesPlanilla);

  readonly afiliacionFondosPension = computed(() => this.state().afiliacionFondosPension);
  readonly loadingAfiliacionFondosPension = computed(() => this.state().loadingAfiliacionFondosPension);
  readonly errorAfiliacionFondosPension = computed(() => this.state().errorAfiliacionFondosPension);

  readonly categoriasLaborales = computed(() => this.state().categoriasLaborales);
  readonly loadingCategoriasLaborales = computed(() => this.state().loadingCategoriasLaborales);
  readonly errorCategoriasLaborales = computed(() => this.state().errorCategoriasLaborales);

  readonly definicionAreasJerarquias = computed(() => this.state().definicionAreasJerarquias);
  readonly loadingDefinicionAreasJerarquias = computed(() => this.state().loadingDefinicionAreasJerarquias);
  readonly errorDefinicionAreasJerarquias = computed(() => this.state().errorDefinicionAreasJerarquias);

  readonly definicionCargos = computed(() => this.state().definicionCargos);
  readonly loadingDefinicionCargos = computed(() => this.state().loadingDefinicionCargos);
  readonly errorDefinicionCargos = computed(() => this.state().errorDefinicionCargos);

  readonly datosPersonales = computed(() => this.state().datosPersonales);
  readonly loadingDatosPersonales = computed(() => this.state().loadingDatosPersonales);
  readonly errorDatosPersonales = computed(() => this.state().errorDatosPersonales);

  readonly agrupacionSede = computed(() => this.state().agrupacionSede);
  readonly loadingAgrupacionSede = computed(() => this.state().loadingAgrupacionSede);
  readonly errorAgrupacionSede = computed(() => this.state().errorAgrupacionSede);

  readonly configuracionProvisiones = computed(() => this.state().configuracionProvisiones);
  readonly loadingConfiguracionProvisiones = computed(() => this.state().loadingConfiguracionProvisiones);
  readonly errorConfiguracionProvisiones = computed(() => this.state().errorConfiguracionProvisiones);

  readonly frecuenciaCalendarios = computed(() => this.state().frecuenciaCalendarios);
  readonly loadingFrecuenciaCalendarios = computed(() => this.state().loadingFrecuenciaCalendarios);
  readonly errorFrecuenciaCalendarios = computed(() => this.state().errorFrecuenciaCalendarios);

  readonly generacionNumeracion = computed(() => this.state().generacionNumeracion);
  readonly loadingGeneracionNumeracion = computed(() => this.state().loadingGeneracionNumeracion);
  readonly errorGeneracionNumeracion = computed(() => this.state().errorGeneracionNumeracion);

  readonly paisVigencia = computed(() => this.state().paisVigencia);
  readonly loadingPaisVigencia = computed(() => this.state().loadingPaisVigencia);
  readonly errorPaisVigencia = computed(() => this.state().errorPaisVigencia);

  readonly tipoContrato = computed(() => this.state().tipoContrato);
  readonly loadingTipoContrato = computed(() => this.state().loadingTipoContrato);
  readonly errorTipoContrato = computed(() => this.state().errorTipoContrato);

  readonly aprobarPlanilla = computed(() => this.state().aprobarPlanilla);
  readonly loadingAprobarPlanilla = computed(() => this.state().loadingAprobarPlanilla);
  readonly errorAprobarPlanilla = computed(() => this.state().errorAprobarPlanilla);

  readonly calculoPlanilla = computed(() => this.state().calculoPlanilla);
  readonly loadingCalculoPlanilla = computed(() => this.state().loadingCalculoPlanilla);
  readonly errorCalculoPlanilla = computed(() => this.state().errorCalculoPlanilla);

  readonly conceptos = computed(() => this.state().conceptos);
  readonly loadingConceptos = computed(() => this.state().loadingConceptos);
  readonly errorConceptos = computed(() => this.state().errorConceptos);

  readonly procesosEspeciales = computed(() => this.state().procesosEspeciales);
  readonly loadingProcesosEspeciales = computed(() => this.state().loadingProcesosEspeciales);
  readonly errorProcesosEspeciales = computed(() => this.state().errorProcesosEspeciales);

  readonly provisionGasto = computed(() => this.state().provisionGasto);
  readonly loadingProvisionGasto = computed(() => this.state().loadingProvisionGasto);
  readonly errorProvisionGasto = computed(() => this.state().errorProvisionGasto);

  readonly registrarLiquidacion = computed(() => this.state().registrarLiquidacion);
  readonly loadingRegistrarLiquidacion = computed(() => this.state().loadingRegistrarLiquidacion);
  readonly errorRegistrarLiquidacion = computed(() => this.state().errorRegistrarLiquidacion);

  readonly dashboardRrhh = computed(() => this.state().dashboardRrhh);
  readonly loadingDashboardRrhh = computed(() => this.state().loadingDashboardRrhh);
  readonly errorDashboardRrhh = computed(() => this.state().errorDashboardRrhh);

  readonly distribucionCostos = computed(() => this.state().distribucionCostos);
  readonly loadingDistribucionCostos = computed(() => this.state().loadingDistribucionCostos);
  readonly errorDistribucionCostos = computed(() => this.state().errorDistribucionCostos);

  readonly emisionBoletas = computed(() => this.state().emisionBoletas);
  readonly loadingEmisionBoletas = computed(() => this.state().loadingEmisionBoletas);
  readonly errorEmisionBoletas = computed(() => this.state().errorEmisionBoletas);

  readonly generacionArchivos = computed(() => this.state().generacionArchivos);
  readonly loadingGeneracionArchivos = computed(() => this.state().loadingGeneracionArchivos);
  readonly errorGeneracionArchivos = computed(() => this.state().errorGeneracionArchivos);

  readonly indicadoresRotacion = computed(() => this.state().indicadoresRotacion);
  readonly loadingIndicadoresRotacion = computed(() => this.state().loadingIndicadoresRotacion);
  readonly errorIndicadoresRotacion = computed(() => this.state().errorIndicadoresRotacion);

  readonly isLoading = computed(() => this.state().loadingPermisos || this.state().loadingPermisosRegistro || this.state().loadingVacacionesLicencias || this.state().loadingVacacionesLicenciasRegistro || this.state().loadingAsistencias || this.state().loadingCalendariosLaborales || this.state().loadingAnalisisInconsistenciaNomina || this.state().loadingInasistencias || this.state().loadingReportesPlanilla || this.state().loadingAfiliacionFondosPension || this.state().loadingCategoriasLaborales || this.state().loadingDefinicionAreasJerarquias || this.state().loadingDefinicionCargos || this.state().loadingDatosPersonales || this.state().loadingAgrupacionSede || this.state().loadingConfiguracionProvisiones || this.state().loadingFrecuenciaCalendarios || this.state().loadingGeneracionNumeracion || this.state().loadingPaisVigencia || this.state().loadingTipoContrato || this.state().loadingAprobarPlanilla || this.state().loadingCalculoPlanilla || this.state().loadingConceptos || this.state().loadingProcesosEspeciales || this.state().loadingProvisionGasto || this.state().loadingRegistrarLiquidacion || this.state().loadingDashboardRrhh || this.state().loadingDistribucionCostos || this.state().loadingEmisionBoletas || this.state().loadingGeneracionArchivos || this.state().loadingIndicadoresRotacion);
  readonly hasError = computed(() => this.state().errorPermisos !== null || this.state().errorVacacionesLicencias !== null || this.state().errorAsistencias !== null || this.state().errorCalendariosLaborales !== null || this.state().errorAnalisisInconsistenciaNomina !== null || this.state().errorInasistencias !== null);

  // Mutaciones
  setLoadingPermisos(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingPermisos: loading }));
  }

  setPermisos(permisos: PermisoEntity[]): void {
    this.state.update(s => ({ ...s, permisos, loadingPermisos: false, errorPermisos: null }));
  }

  clearPermisos(): void {
    this.state.update(s => ({ ...s, permisos: [], errorPermisos: null }));
  }

  setErrorPermisos(error: string): void {
    this.state.update(s => ({ ...s, errorPermisos: error, loadingPermisos: false }));
  }

  setLoadingPermisosRegistro(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingPermisosRegistro: loading }));
  }

  setPermisosRegistro(permisosRegistro: PermisoEntity[]): void {
    this.state.update(s => ({ ...s, permisosRegistro, loadingPermisosRegistro: false, errorPermisosRegistro: null }));
  }

  clearPermisosRegistro(): void {
    this.state.update(s => ({ ...s, permisosRegistro: [], errorPermisosRegistro: null }));
  }

  setErrorPermisosRegistro(error: string): void {
    this.state.update(s => ({ ...s, errorPermisosRegistro: error, loadingPermisosRegistro: false }));
  }

  setLoadingVacacionesLicencias(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingVacacionesLicencias: loading }));
  }

  setVacacionesLicencias(vacacionesLicencias: VacacionLicenciaEntity[]): void {
    this.state.update(s => ({ ...s, vacacionesLicencias, loadingVacacionesLicencias: false, errorVacacionesLicencias: null }));
  }

  clearVacacionesLicencias(): void {
    this.state.update(s => ({ ...s, vacacionesLicencias: [], errorVacacionesLicencias: null }));
  }

  setErrorVacacionesLicencias(error: string): void {
    this.state.update(s => ({ ...s, errorVacacionesLicencias: error, loadingVacacionesLicencias: false }));
  }

  setLoadingVacacionesLicenciasRegistro(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingVacacionesLicenciasRegistro: loading }));
  }

  setVacacionesLicenciasRegistro(vacacionesLicenciasRegistro: VacacionLicenciaEntity[]): void {
    this.state.update(s => ({ ...s, vacacionesLicenciasRegistro, loadingVacacionesLicenciasRegistro: false, errorVacacionesLicenciasRegistro: null }));
  }

  clearVacacionesLicenciasRegistro(): void {
    this.state.update(s => ({ ...s, vacacionesLicenciasRegistro: [], errorVacacionesLicenciasRegistro: null }));
  }

  setErrorVacacionesLicenciasRegistro(error: string): void {
    this.state.update(s => ({ ...s, errorVacacionesLicenciasRegistro: error, loadingVacacionesLicenciasRegistro: false }));
  }

  setLoadingAsistencias(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingAsistencias: loading }));
  }

  setAsistencias(asistencias: AsistenciaEntity[]): void {
    this.state.update(s => ({ ...s, asistencias, loadingAsistencias: false, errorAsistencias: null }));
  }

  clearAsistencias(): void {
    this.state.update(s => ({ ...s, asistencias: [], errorAsistencias: null }));
  }

  setErrorAsistencias(error: string): void {
    this.state.update(s => ({ ...s, errorAsistencias: error, loadingAsistencias: false }));
  }

  setLoadingCalendariosLaborales(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingCalendariosLaborales: loading }));
  }

  setCalendariosLaborales(calendariosLaborales: CalendarioLaboralEntity[]): void {
    this.state.update(s => ({ ...s, calendariosLaborales, loadingCalendariosLaborales: false, errorCalendariosLaborales: null }));
  }

  clearCalendariosLaborales(): void {
    this.state.update(s => ({ ...s, calendariosLaborales: [], errorCalendariosLaborales: null }));
  }

  setErrorCalendariosLaborales(error: string): void {
    this.state.update(s => ({ ...s, errorCalendariosLaborales: error, loadingCalendariosLaborales: false }));
  }

  setLoadingAnalisisInconsistenciaNomina(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingAnalisisInconsistenciaNomina: loading }));
  }

  setAnalisisInconsistenciaNomina(analisisInconsistenciaNomina: AnalisisInconsistenciaEntity[]): void {
    this.state.update(s => ({ ...s, analisisInconsistenciaNomina, loadingAnalisisInconsistenciaNomina: false, errorAnalisisInconsistenciaNomina: null }));
  }

  clearAnalisisInconsistenciaNomina(): void {
    this.state.update(s => ({ ...s, analisisInconsistenciaNomina: [], errorAnalisisInconsistenciaNomina: null }));
  }

  setErrorAnalisisInconsistenciaNomina(error: string): void {
    this.state.update(s => ({ ...s, errorAnalisisInconsistenciaNomina: error, loadingAnalisisInconsistenciaNomina: false }));
  }

  setLoadingInasistencias(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingInasistencias: loading }));
  }

  setInasistencias(inasistencias: InasistenciaEntity[]): void {
    this.state.update(s => ({ ...s, inasistencias, loadingInasistencias: false, errorInasistencias: null }));
  }

  clearInasistencias(): void {
    this.state.update(s => ({ ...s, inasistencias: [], errorInasistencias: null }));
  }

  setErrorInasistencias(error: string): void {
    this.state.update(s => ({ ...s, errorInasistencias: error, loadingInasistencias: false }));
  }

  setLoadingReportesPlanilla(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingReportesPlanilla: loading }));
  }

  setReportesPlanilla(reportesPlanilla: ReportePlanillaEntity[]): void {
    this.state.update(s => ({ ...s, reportesPlanilla, loadingReportesPlanilla: false, errorReportesPlanilla: null }));
  }

  clearReportesPlanilla(): void {
    this.state.update(s => ({ ...s, reportesPlanilla: [], errorReportesPlanilla: null }));
  }

  setErrorReportesPlanilla(error: string): void {
    this.state.update(s => ({ ...s, errorReportesPlanilla: error, loadingReportesPlanilla: false }));
  }

  setLoadingAfiliacionFondosPension(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingAfiliacionFondosPension: loading }));
  }

  setAfiliacionFondosPension(afiliacionFondosPension: AfiliacionFondosPensionEntity[]): void {
    this.state.update(s => ({ ...s, afiliacionFondosPension, loadingAfiliacionFondosPension: false, errorAfiliacionFondosPension: null }));
  }

  clearAfiliacionFondosPension(): void {
    this.state.update(s => ({ ...s, afiliacionFondosPension: [], errorAfiliacionFondosPension: null }));
  }

  setErrorAfiliacionFondosPension(error: string): void {
    this.state.update(s => ({ ...s, errorAfiliacionFondosPension: error, loadingAfiliacionFondosPension: false }));
  }

  setLoadingCategoriasLaborales(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingCategoriasLaborales: loading }));
  }

  setCategoriasLaborales(categoriasLaborales: CategoriaLaboralEntity[]): void {
    this.state.update(s => ({ ...s, categoriasLaborales, loadingCategoriasLaborales: false, errorCategoriasLaborales: null }));
  }

  clearCategoriasLaborales(): void {
    this.state.update(s => ({ ...s, categoriasLaborales: [], errorCategoriasLaborales: null }));
  }

  setErrorCategoriasLaborales(error: string): void {
    this.state.update(s => ({ ...s, errorCategoriasLaborales: error, loadingCategoriasLaborales: false }));
  }

  setLoadingDefinicionAreasJerarquias(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingDefinicionAreasJerarquias: loading }));
  }

  setDefinicionAreasJerarquias(definicionAreasJerarquias: DefinicionAreasJerarquiasEntity[]): void {
    this.state.update(s => ({ ...s, definicionAreasJerarquias, loadingDefinicionAreasJerarquias: false, errorDefinicionAreasJerarquias: null }));
  }

  clearDefinicionAreasJerarquias(): void {
    this.state.update(s => ({ ...s, definicionAreasJerarquias: [], errorDefinicionAreasJerarquias: null }));
  }

  setErrorDefinicionAreasJerarquias(error: string): void {
    this.state.update(s => ({ ...s, errorDefinicionAreasJerarquias: error, loadingDefinicionAreasJerarquias: false }));
  }

  setLoadingDefinicionCargos(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingDefinicionCargos: loading }));
  }

  setDefinicionCargos(definicionCargos: DefinicionCargosEntity[]): void {
    this.state.update(s => ({ ...s, definicionCargos, loadingDefinicionCargos: false, errorDefinicionCargos: null }));
  }

  clearDefinicionCargos(): void {
    this.state.update(s => ({ ...s, definicionCargos: [], errorDefinicionCargos: null }));
  }

  setErrorDefinicionCargos(error: string): void {
    this.state.update(s => ({ ...s, errorDefinicionCargos: error, loadingDefinicionCargos: false }));
  }

  setLoadingDatosPersonales(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingDatosPersonales: loading }));
  }

  setDatosPersonales(datosPersonales: DatosPersonalesEntity[]): void {
    this.state.update(s => ({ ...s, datosPersonales, loadingDatosPersonales: false, errorDatosPersonales: null }));
  }

  clearDatosPersonales(): void {
    this.state.update(s => ({ ...s, datosPersonales: [], errorDatosPersonales: null }));
  }

  setErrorDatosPersonales(error: string): void {
    this.state.update(s => ({ ...s, errorDatosPersonales: error, loadingDatosPersonales: false }));
  }

  setLoadingAgrupacionSede(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingAgrupacionSede: loading }));
  }

  setAgrupacionSede(agrupacionSede: AgrupacionSedeEntity[]): void {
    this.state.update(s => ({ ...s, agrupacionSede, loadingAgrupacionSede: false, errorAgrupacionSede: null }));
  }

  clearAgrupacionSede(): void {
    this.state.update(s => ({ ...s, agrupacionSede: [], errorAgrupacionSede: null }));
  }

  setErrorAgrupacionSede(error: string): void {
    this.state.update(s => ({ ...s, errorAgrupacionSede: error, loadingAgrupacionSede: false }));
  }

  setLoadingConfiguracionProvisiones(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingConfiguracionProvisiones: loading }));
  }

  setConfiguracionProvisiones(configuracionProvisiones: ConfiguracionProvisionesEntity[]): void {
    this.state.update(s => ({ ...s, configuracionProvisiones, loadingConfiguracionProvisiones: false, errorConfiguracionProvisiones: null }));
  }

  clearConfiguracionProvisiones(): void {
    this.state.update(s => ({ ...s, configuracionProvisiones: [], errorConfiguracionProvisiones: null }));
  }

  setErrorConfiguracionProvisiones(error: string): void {
    this.state.update(s => ({ ...s, errorConfiguracionProvisiones: error, loadingConfiguracionProvisiones: false }));
  }

  setLoadingFrecuenciaCalendarios(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingFrecuenciaCalendarios: loading }));
  }

  setFrecuenciaCalendarios(frecuenciaCalendarios: FrecuenciaCalendariosEntity[]): void {
    this.state.update(s => ({ ...s, frecuenciaCalendarios, loadingFrecuenciaCalendarios: false, errorFrecuenciaCalendarios: null }));
  }

  clearFrecuenciaCalendarios(): void {
    this.state.update(s => ({ ...s, frecuenciaCalendarios: [], errorFrecuenciaCalendarios: null }));
  }

  setErrorFrecuenciaCalendarios(error: string): void {
    this.state.update(s => ({ ...s, errorFrecuenciaCalendarios: error, loadingFrecuenciaCalendarios: false }));
  }

  setLoadingGeneracionNumeracion(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingGeneracionNumeracion: loading }));
  }

  setGeneracionNumeracion(generacionNumeracion: GeneracionNumeracionEntity[]): void {
    this.state.update(s => ({ ...s, generacionNumeracion, loadingGeneracionNumeracion: false, errorGeneracionNumeracion: null }));
  }

  clearGeneracionNumeracion(): void {
    this.state.update(s => ({ ...s, generacionNumeracion: [], errorGeneracionNumeracion: null }));
  }

  setErrorGeneracionNumeracion(error: string): void {
    this.state.update(s => ({ ...s, errorGeneracionNumeracion: error, loadingGeneracionNumeracion: false }));
  }

  setLoadingPaisVigencia(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingPaisVigencia: loading }));
  }

  setPaisVigencia(paisVigencia: PaisVigenciaEntity[]): void {
    this.state.update(s => ({ ...s, paisVigencia, loadingPaisVigencia: false, errorPaisVigencia: null }));
  }

  clearPaisVigencia(): void {
    this.state.update(s => ({ ...s, paisVigencia: [], errorPaisVigencia: null }));
  }

  setErrorPaisVigencia(error: string): void {
    this.state.update(s => ({ ...s, errorPaisVigencia: error, loadingPaisVigencia: false }));
  }

  setLoadingTipoContrato(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingTipoContrato: loading }));
  }

  setTipoContrato(tipoContrato: TipoContratoEntity[]): void {
    this.state.update(s => ({ ...s, tipoContrato, loadingTipoContrato: false, errorTipoContrato: null }));
  }

  clearTipoContrato(): void {
    this.state.update(s => ({ ...s, tipoContrato: [], errorTipoContrato: null }));
  }

  setErrorTipoContrato(error: string): void {
    this.state.update(s => ({ ...s, errorTipoContrato: error, loadingTipoContrato: false }));
  }

  setLoadingAprobarPlanilla(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingAprobarPlanilla: loading }));
  }

  setAprobarPlanilla(aprobarPlanilla: PlanillaEntity[]): void {
    this.state.update(s => ({ ...s, aprobarPlanilla, loadingAprobarPlanilla: false, errorAprobarPlanilla: null }));
  }

  clearAprobarPlanilla(): void {
    this.state.update(s => ({ ...s, aprobarPlanilla: [], errorAprobarPlanilla: null }));
  }

  setErrorAprobarPlanilla(error: string): void {
    this.state.update(s => ({ ...s, errorAprobarPlanilla: error, loadingAprobarPlanilla: false }));
  }

  setLoadingCalculoPlanilla(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingCalculoPlanilla: loading }));
  }

  setCalculoPlanilla(calculoPlanilla: PlanillaEntity[]): void {
    this.state.update(s => ({ ...s, calculoPlanilla, loadingCalculoPlanilla: false, errorCalculoPlanilla: null }));
  }

  clearCalculoPlanilla(): void {
    this.state.update(s => ({ ...s, calculoPlanilla: [], errorCalculoPlanilla: null }));
  }

  setErrorCalculoPlanilla(error: string): void {
    this.state.update(s => ({ ...s, errorCalculoPlanilla: error, loadingCalculoPlanilla: false }));
  }

  setLoadingConceptos(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingConceptos: loading }));
  }

  setConceptos(conceptos: ConceptoEntity[]): void {
    this.state.update(s => ({ ...s, conceptos, loadingConceptos: false, errorConceptos: null }));
  }

  clearConceptos(): void {
    this.state.update(s => ({ ...s, conceptos: [], errorConceptos: null }));
  }

  setErrorConceptos(error: string): void {
    this.state.update(s => ({ ...s, errorConceptos: error, loadingConceptos: false }));
  }

  setLoadingProcesosEspeciales(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingProcesosEspeciales: loading }));
  }

  setProcesosEspeciales(procesosEspeciales: ProcesosEspecialesEntity[]): void {
    this.state.update(s => ({ ...s, procesosEspeciales, loadingProcesosEspeciales: false, errorProcesosEspeciales: null }));
  }

  clearProcesosEspeciales(): void {
    this.state.update(s => ({ ...s, procesosEspeciales: [], errorProcesosEspeciales: null }));
  }

  setErrorProcesosEspeciales(error: string): void {
    this.state.update(s => ({ ...s, errorProcesosEspeciales: error, loadingProcesosEspeciales: false }));
  }

  setLoadingProvisionGasto(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingProvisionGasto: loading }));
  }

  setProvisionGasto(provisionGasto: ProvisionGastoEntity[]): void {
    this.state.update(s => ({ ...s, provisionGasto, loadingProvisionGasto: false, errorProvisionGasto: null }));
  }

  clearProvisionGasto(): void {
    this.state.update(s => ({ ...s, provisionGasto: [], errorProvisionGasto: null }));
  }

  setErrorProvisionGasto(error: string): void {
    this.state.update(s => ({ ...s, errorProvisionGasto: error, loadingProvisionGasto: false }));
  }

  setLoadingRegistrarLiquidacion(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingRegistrarLiquidacion: loading }));
  }

  setRegistrarLiquidacion(registrarLiquidacion: LiquidacionEntity[]): void {
    this.state.update(s => ({ ...s, registrarLiquidacion, loadingRegistrarLiquidacion: false, errorRegistrarLiquidacion: null }));
  }

  clearRegistrarLiquidacion(): void {
    this.state.update(s => ({ ...s, registrarLiquidacion: [], errorRegistrarLiquidacion: null }));
  }

  setErrorRegistrarLiquidacion(error: string): void {
    this.state.update(s => ({ ...s, errorRegistrarLiquidacion: error, loadingRegistrarLiquidacion: false }));
  }

  setLoadingDashboardRrhh(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingDashboardRrhh: loading }));
  }

  setDashboardRrhh(dashboardRrhh: DashboardRrhhEntity): void {
    this.state.update(s => ({ ...s, dashboardRrhh, loadingDashboardRrhh: false, errorDashboardRrhh: null }));
  }

  clearDashboardRrhh(): void {
    this.state.update(s => ({ ...s, dashboardRrhh: null, errorDashboardRrhh: null }));
  }

  setErrorDashboardRrhh(error: string): void {
    this.state.update(s => ({ ...s, errorDashboardRrhh: error, loadingDashboardRrhh: false }));
  }

  setLoadingDistribucionCostos(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingDistribucionCostos: loading }));
  }

  setDistribucionCostos(distribucionCostos: DistribucionCostosEntity[]): void {
    this.state.update(s => ({ ...s, distribucionCostos, loadingDistribucionCostos: false, errorDistribucionCostos: null }));
  }

  clearDistribucionCostos(): void {
    this.state.update(s => ({ ...s, distribucionCostos: [], errorDistribucionCostos: null }));
  }

  setErrorDistribucionCostos(error: string): void {
    this.state.update(s => ({ ...s, errorDistribucionCostos: error, loadingDistribucionCostos: false }));
  }

  setLoadingEmisionBoletas(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingEmisionBoletas: loading }));
  }

  setEmisionBoletas(emisionBoletas: EmisionBoletasEntity[]): void {
    this.state.update(s => ({ ...s, emisionBoletas, loadingEmisionBoletas: false, errorEmisionBoletas: null }));
  }

  clearEmisionBoletas(): void {
    this.state.update(s => ({ ...s, emisionBoletas: [], errorEmisionBoletas: null }));
  }

  setErrorEmisionBoletas(error: string): void {
    this.state.update(s => ({ ...s, errorEmisionBoletas: error, loadingEmisionBoletas: false }));
  }

  setLoadingGeneracionArchivos(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingGeneracionArchivos: loading }));
  }

  setGeneracionArchivos(generacionArchivos: GeneracionArchivosEntity[]): void {
    this.state.update(s => ({ ...s, generacionArchivos, loadingGeneracionArchivos: false, errorGeneracionArchivos: null }));
  }

  clearGeneracionArchivos(): void {
    this.state.update(s => ({ ...s, generacionArchivos: [], errorGeneracionArchivos: null }));
  }

  setErrorGeneracionArchivos(error: string): void {
    this.state.update(s => ({ ...s, errorGeneracionArchivos: error, loadingGeneracionArchivos: false }));
  }

  setLoadingIndicadoresRotacion(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingIndicadoresRotacion: loading }));
  }

  setIndicadoresRotacion(indicadoresRotacion: IndicadoresRotacionEntity[]): void {
    this.state.update(s => ({ ...s, indicadoresRotacion, loadingIndicadoresRotacion: false, errorIndicadoresRotacion: null }));
  }

  clearIndicadoresRotacion(): void {
    this.state.update(s => ({ ...s, indicadoresRotacion: [], errorIndicadoresRotacion: null }));
  }

  setErrorIndicadoresRotacion(error: string): void {
    this.state.update(s => ({ ...s, errorIndicadoresRotacion: error, loadingIndicadoresRotacion: false }));
  }

  resetState(): void {
    this.state.set(initialRrHhState);
  }
}
