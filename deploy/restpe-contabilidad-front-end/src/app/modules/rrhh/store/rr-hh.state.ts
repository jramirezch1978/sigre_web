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

export interface RrHhState {
  permisos: PermisoEntity[];
  loadingPermisos: boolean;
  errorPermisos: string | null;
  permisosRegistro: PermisoEntity[];
  loadingPermisosRegistro: boolean;
  errorPermisosRegistro: string | null;
  vacacionesLicencias: VacacionLicenciaEntity[];
  loadingVacacionesLicencias: boolean;
  errorVacacionesLicencias: string | null;
  vacacionesLicenciasRegistro: VacacionLicenciaEntity[];
  loadingVacacionesLicenciasRegistro: boolean;
  errorVacacionesLicenciasRegistro: string | null;
  asistencias: AsistenciaEntity[];
  loadingAsistencias: boolean;
  errorAsistencias: string | null;
  calendariosLaborales: CalendarioLaboralEntity[];
  loadingCalendariosLaborales: boolean;
  errorCalendariosLaborales: string | null;
  analisisInconsistenciaNomina: AnalisisInconsistenciaEntity[];
  loadingAnalisisInconsistenciaNomina: boolean;
  errorAnalisisInconsistenciaNomina: string | null;
  inasistencias: InasistenciaEntity[];
  loadingInasistencias: boolean;
  errorInasistencias: string | null;
  reportesPlanilla: ReportePlanillaEntity[];
  loadingReportesPlanilla: boolean;
  errorReportesPlanilla: string | null;
  afiliacionFondosPension: AfiliacionFondosPensionEntity[];
  loadingAfiliacionFondosPension: boolean;
  errorAfiliacionFondosPension: string | null;
  categoriasLaborales: CategoriaLaboralEntity[];
  loadingCategoriasLaborales: boolean;
  errorCategoriasLaborales: string | null;
  definicionAreasJerarquias: DefinicionAreasJerarquiasEntity[];
  loadingDefinicionAreasJerarquias: boolean;
  errorDefinicionAreasJerarquias: string | null;
  definicionCargos: DefinicionCargosEntity[];
  loadingDefinicionCargos: boolean;
  errorDefinicionCargos: string | null;
  datosPersonales: DatosPersonalesEntity[];
  loadingDatosPersonales: boolean;
  errorDatosPersonales: string | null;
  agrupacionSede: AgrupacionSedeEntity[];
  loadingAgrupacionSede: boolean;
  errorAgrupacionSede: string | null;
  configuracionProvisiones: ConfiguracionProvisionesEntity[];
  loadingConfiguracionProvisiones: boolean;
  errorConfiguracionProvisiones: string | null;
  frecuenciaCalendarios: FrecuenciaCalendariosEntity[];
  loadingFrecuenciaCalendarios: boolean;
  errorFrecuenciaCalendarios: string | null;
  generacionNumeracion: GeneracionNumeracionEntity[];
  loadingGeneracionNumeracion: boolean;
  errorGeneracionNumeracion: string | null;
  paisVigencia: PaisVigenciaEntity[];
  loadingPaisVigencia: boolean;
  errorPaisVigencia: string | null;
  tipoContrato: TipoContratoEntity[];
  loadingTipoContrato: boolean;
  errorTipoContrato: string | null;
  aprobarPlanilla: PlanillaEntity[];
  loadingAprobarPlanilla: boolean;
  errorAprobarPlanilla: string | null;
  calculoPlanilla: PlanillaEntity[];
  loadingCalculoPlanilla: boolean;
  errorCalculoPlanilla: string | null;
  conceptos: ConceptoEntity[];
  loadingConceptos: boolean;
  errorConceptos: string | null;
  procesosEspeciales: ProcesosEspecialesEntity[];
  loadingProcesosEspeciales: boolean;
  errorProcesosEspeciales: string | null;
  provisionGasto: ProvisionGastoEntity[];
  loadingProvisionGasto: boolean;
  errorProvisionGasto: string | null;
  registrarLiquidacion: LiquidacionEntity[];
  loadingRegistrarLiquidacion: boolean;
  errorRegistrarLiquidacion: string | null;
  dashboardRrhh: DashboardRrhhEntity | null;
  loadingDashboardRrhh: boolean;
  errorDashboardRrhh: string | null;
  distribucionCostos: DistribucionCostosEntity[];
  loadingDistribucionCostos: boolean;
  errorDistribucionCostos: string | null;
  emisionBoletas: EmisionBoletasEntity[];
  loadingEmisionBoletas: boolean;
  errorEmisionBoletas: string | null;
  generacionArchivos: GeneracionArchivosEntity[];
  loadingGeneracionArchivos: boolean;
  errorGeneracionArchivos: string | null;
  indicadoresRotacion: IndicadoresRotacionEntity[];
  loadingIndicadoresRotacion: boolean;
  errorIndicadoresRotacion: string | null;
}

export const initialRrHhState: RrHhState = {
  permisos: [],
  loadingPermisos: false,
  errorPermisos: null,
  permisosRegistro: [],
  loadingPermisosRegistro: false,
  errorPermisosRegistro: null,
  vacacionesLicencias: [],
  loadingVacacionesLicencias: false,
  errorVacacionesLicencias: null,
  vacacionesLicenciasRegistro: [],
  loadingVacacionesLicenciasRegistro: false,
  errorVacacionesLicenciasRegistro: null,
  asistencias: [],
  loadingAsistencias: false,
  errorAsistencias: null,
  calendariosLaborales: [],
  loadingCalendariosLaborales: false,
  errorCalendariosLaborales: null,
  analisisInconsistenciaNomina: [],
  loadingAnalisisInconsistenciaNomina: false,
  errorAnalisisInconsistenciaNomina: null,
  inasistencias: [],
  loadingInasistencias: false,
  errorInasistencias: null,
  reportesPlanilla: [],
  loadingReportesPlanilla: false,
  errorReportesPlanilla: null,
  afiliacionFondosPension: [],
  loadingAfiliacionFondosPension: false,
  errorAfiliacionFondosPension: null,
  categoriasLaborales: [],
  loadingCategoriasLaborales: false,
  errorCategoriasLaborales: null,
  definicionAreasJerarquias: [],
  loadingDefinicionAreasJerarquias: false,
  errorDefinicionAreasJerarquias: null,
  definicionCargos: [],
  loadingDefinicionCargos: false,
  errorDefinicionCargos: null,
  datosPersonales: [],
  loadingDatosPersonales: false,
  errorDatosPersonales: null,
  agrupacionSede: [],
  loadingAgrupacionSede: false,
  errorAgrupacionSede: null,
  configuracionProvisiones: [],
  loadingConfiguracionProvisiones: false,
  errorConfiguracionProvisiones: null,
  frecuenciaCalendarios: [],
  loadingFrecuenciaCalendarios: false,
  errorFrecuenciaCalendarios: null,
  generacionNumeracion: [],
  loadingGeneracionNumeracion: false,
  errorGeneracionNumeracion: null,
  paisVigencia: [],
  loadingPaisVigencia: false,
  errorPaisVigencia: null,
  tipoContrato: [],
  loadingTipoContrato: false,
  errorTipoContrato: null,
  aprobarPlanilla: [],
  loadingAprobarPlanilla: false,
  errorAprobarPlanilla: null,
  calculoPlanilla: [],
  loadingCalculoPlanilla: false,
  errorCalculoPlanilla: null,
  conceptos: [],
  loadingConceptos: false,
  errorConceptos: null,
  procesosEspeciales: [],
  loadingProcesosEspeciales: false,
  errorProcesosEspeciales: null,
  provisionGasto: [],
  loadingProvisionGasto: false,
  errorProvisionGasto: null,
  registrarLiquidacion: [],
  loadingRegistrarLiquidacion: false,
  errorRegistrarLiquidacion: null,
  dashboardRrhh: null,
  loadingDashboardRrhh: false,
  errorDashboardRrhh: null,
  distribucionCostos: [],
  loadingDistribucionCostos: false,
  errorDistribucionCostos: null,
  emisionBoletas: [],
  loadingEmisionBoletas: false,
  errorEmisionBoletas: null,
  generacionArchivos: [],
  loadingGeneracionArchivos: false,
  errorGeneracionArchivos: null,
  indicadoresRotacion: [],
  loadingIndicadoresRotacion: false,
  errorIndicadoresRotacion: null,
};
