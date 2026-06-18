import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { map } from 'rxjs/operators';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { PermisoEntity } from '../../domain/models/permiso.entity';
import { VacacionLicenciaEntity } from '../../domain/models/vacacion-licencia.entity';
import { AsistenciaEntity } from '../../domain/models/asistencia.entity';
import { CalendarioLaboralEntity } from '../../domain/models/calendario-laboral.entity';
import { AnalisisInconsistenciaEntity } from '../../domain/models/analisis-inconsistencia.entity';
import { InasistenciaEntity } from '../../domain/models/inasistencia.entity';
import { ReportePlanillaEntity } from '../../domain/models/reporte-planilla.entity';
import { AfiliacionFondosPensionEntity } from '../../domain/models/afiliacion-fondos-pension.entity';
import { PaisVigenciaEntity } from '../../domain/models/pais-vigencia.entity';
import { TipoContratoEntity } from '../../domain/models/tipo-contrato.entity';
import { PlanillaEntity } from '../../domain/models/planilla.entity';
import { ConceptoEntity } from '../../domain/models/concepto.entity';
import { ProcesosEspecialesEntity } from '../../domain/models/procesos-especiales.entity';
import { ProvisionGastoEntity } from '../../domain/models/provision-gasto.entity';
import { LiquidacionEntity } from '../../domain/models/liquidacion.entity';
import { DashboardRrhhEntity } from '../../domain/models/dashboard-rrhh.entity';
import { DistribucionCostosEntity } from '../../domain/models/distribucion-costos.entity';
import { EmisionBoletasEntity } from '../../domain/models/emision-boletas.entity';
import { GeneracionArchivosEntity } from '../../domain/models/generacion-archivos.entity';
import { IndicadoresRotacionEntity } from '../../domain/models/indicadores-rotacion.entity';

@Injectable()
export class ReportesRepositoryImpl extends IReportesRepository {
  private readonly permisosUrl = 'assets/data/rr-hh/asistencias-jornadas/permisos.json';
  private readonly permisosRegistroUrl = 'assets/data/rr-hh/asistencias-jornadas/permisos.json';
  private readonly vacacionesUrl = 'assets/data/rr-hh/asistencias-jornadas/vacaciones-licencias.json';
  private readonly vacacionesRegistroUrl = 'assets/data/rr-hh/asistencias-jornadas/vacaciones-licencias.json';
  private readonly asistenciasUrl = 'assets/data/rr-hh/asistencias-jornadas/asistencias.json';
  private readonly calendariosUrl = 'assets/data/rr-hh/asistencias-jornadas/calendarios-laborales.json';
  private readonly analisisInconsistenciaNominaUrl = 'assets/data/rr-hh/consultas-validaciones/analisis-inconsistencia-nomina.json';
  private readonly inasistenciasUrl = 'assets/data/rr-hh/consultas-validaciones/inasistencias.json';
  private readonly reportesPlanillaUrl = 'assets/data/rr-hh/consultas-validaciones/reportes-planilla.json';
  private readonly afiliacionFondosPensionUrl = 'assets/data/rr-hh/maestro-de-personal/afiliacion-fondos-pension.json';
  private readonly paisVigenciaUrl = 'assets/data/rr-hh/parametros/pais-vigencia.json';
  private readonly tipoContratoUrl = 'assets/data/rr-hh/parametros/tipo-contrato.json';
  private readonly planillaUrl = 'assets/data/rr-hh/procesos-de-nomina/planilla.json';
  private readonly conceptosUrl = 'assets/data/rr-hh/procesos-de-nomina/conceptos.json';
  private readonly procesosEspecialesUrl = 'assets/data/rr-hh/procesos-de-nomina/procesos-especiales.json';
  private readonly provisionGastoUrl = 'assets/data/rr-hh/procesos-de-nomina/provision-gasto.json';
  private readonly registrarLiquidacionUrl = 'assets/data/rr-hh/procesos-de-nomina/liquidacion.json';
  private readonly dashboardRrhhUrl = 'assets/data/rr-hh/reportes-y-analitica/dashboard-rrhh.json';
  private readonly distribucionCostosUrl = 'assets/data/rr-hh/reportes-y-analitica/distribucion-costos.json';
  private readonly emisionBoletasUrl = 'assets/data/rr-hh/reportes-y-analitica/emision-boletas.json';
  private readonly generacionArchivosUrl = 'assets/data/rr-hh/reportes-y-analitica/generacion-archivos.json';
  private readonly indicadoresRotacionUrl = 'assets/data/rr-hh/reportes-y-analitica/indicadores-rotacion.json';

  constructor(private readonly http: HttpClient) {
    super();
  }

  private mapRawALiquidacion(raw: any): LiquidacionEntity {
    return {
      liquidacion_codigo: raw?.liquidacion_codigo,
      liquidacion_trabajador: raw?.liquidacion_trabajador,
      liquidacion_fecha_inicio: raw?.liquidacion_fecha_inicio,
      liquidacion_estado: raw?.liquidacion_estado,
      liquidacion_sueldo_basico: raw?.liquidacion_sueldo_basico,
      liquidacion_asignacion_familiar: raw?.liquidacion_asignacion_familiar,
      liquidacion_promedio_gratificacion: raw?.liquidacion_promedio_gratificacion,
      liquidacion_fecha_cese: raw?.liquidacion_fecha_cese,
      liquidacion_tipo_cese: raw?.liquidacion_tipo_cese,
      liquidacion_cts_total: raw?.liquidacion_cts_total,
      liquidacion_gratificacion_total: raw?.liquidacion_gratificacion_total,
      liquidacion_otros_beneficios: raw?.liquidacion_otros_beneficios,
      liquidacion_vacaciones_total: raw?.liquidacion_vacaciones_total,
      liquidacion_bonificacion_extraordinaria: raw?.liquidacion_bonificacion_extraordinaria,
      liquidacion_descuento_rr: raw?.liquidacion_descuento_rr,
      liquidacion_total_pagar: raw?.liquidacion_total_pagar,
      liquidacion_observaciones: raw?.liquidacion_observaciones,
      aguinaldo: raw?.aguinaldo,
      bono14: raw?.bono14,
      vacaciones: raw?.vacaciones,
      indemnizacion: raw?.indemnizacion,
      trabajadorSelect: raw?.trabajadorSelect,
    };
  }

  private mapRawAAprobarPlanilla(raw: any): PlanillaEntity {
    return {
      planilla_codigo: raw?.planilla_codigo,
      planilla_periodo: raw?.planilla_periodo,
      planilla_fecha_registro: raw?.planilla_fecha_registro,
      planilla_sucursal: raw?.planilla_sucursal,
      planilla_calculo_desde: raw?.planilla_calculo_desde,
      planilla_calculo_hasta: raw?.planilla_calculo_hasta,
      planilla_estado: raw?.planilla_estado,
      planilla_empleados_codigos: raw?.planilla_empleados_codigos,
    };
  }

  private mapRawACalculoPlanilla(raw: any): PlanillaEntity {
    return {
      planilla_codigo: raw?.planilla_codigo,
      planilla_periodo: raw?.planilla_periodo,
      planilla_tipo_planilla: raw?.planilla_tipo,
      planilla_fecha_registro: raw?.planilla_fecha_registro,
      planilla_sucursal: raw?.planilla_sucursal,
      planilla_calculo_desde: raw?.planilla_calculo_desde,
      planilla_calculo_hasta: raw?.planilla_calculo_hasta,
      planilla_estado: raw?.planilla_estado,
      planilla_periodicidad_pago: raw?.planilla_periodicidad_pago,
      planilla_empleados_codigos: raw?.planilla_empleados_codigos,
    };
  }

  obtenerPermisos(): Observable<PermisoEntity[]> {
    return this.http.get<PermisoEntity[]>(this.permisosUrl).pipe(delay(1000));
  }

  obtenerPermisosRegistro(): Observable<PermisoEntity[]> {
    return this.http.get<PermisoEntity[]>(this.permisosRegistroUrl).pipe(delay(1000));
  }

  obtenerVacacionesLicencias(): Observable<VacacionLicenciaEntity[]> {
    return this.http.get<VacacionLicenciaEntity[]>(this.vacacionesUrl).pipe(delay(1000));
  }

  obtenerVacacionesLicenciasRegistro(): Observable<VacacionLicenciaEntity[]> {
    return this.http.get<VacacionLicenciaEntity[]>(this.vacacionesRegistroUrl).pipe(delay(1000));
  }

  obtenerAsistencias(): Observable<AsistenciaEntity[]> {
    return this.http.get<AsistenciaEntity[]>(this.asistenciasUrl).pipe(delay(1000));
  }

  obtenerCalendariosLaborales(): Observable<CalendarioLaboralEntity[]> {
    return this.http.get<CalendarioLaboralEntity[]>(this.calendariosUrl).pipe(delay(1000));
  }

  obtenerAnalisisInconsistenciaNomina(): Observable<AnalisisInconsistenciaEntity[]> {
    return this.http.get<AnalisisInconsistenciaEntity[]>(this.analisisInconsistenciaNominaUrl).pipe(delay(1000));
  }

  obtenerInasistencias(): Observable<InasistenciaEntity[]> {
    return this.http.get<InasistenciaEntity[]>(this.inasistenciasUrl).pipe(delay(1000));
  }

  obtenerReportesPlanilla(): Observable<ReportePlanillaEntity[]> {
    return this.http.get<ReportePlanillaEntity[]>(this.reportesPlanillaUrl).pipe(delay(1000));
  }

  obtenerAfiliacionFondosPension(): Observable<AfiliacionFondosPensionEntity[]> {
    return this.http.get<AfiliacionFondosPensionEntity[]>(this.afiliacionFondosPensionUrl).pipe(delay(1000));
  }

  obtenerPaisVigencia(): Observable<PaisVigenciaEntity[]> {
    return this.http.get<PaisVigenciaEntity[]>(this.paisVigenciaUrl).pipe(delay(1000));
  }

  obtenerTipoContrato(): Observable<TipoContratoEntity[]> {
    return this.http.get<TipoContratoEntity[]>(this.tipoContratoUrl).pipe(delay(1000));
  }

  obtenerAprobarPlanilla(): Observable<PlanillaEntity[]> {
    return this.http
      .get<any[]>(this.planillaUrl)
      .pipe(map(items => items.map(item => this.mapRawAAprobarPlanilla(item))), delay(1000));
  }

  obtenerCalculoPlanilla(): Observable<PlanillaEntity[]> {
    return this.http
      .get<any[]>(this.planillaUrl)
      .pipe(map(items => items.map(item => this.mapRawACalculoPlanilla(item))), delay(1000));
  }

  obtenerConceptos(): Observable<ConceptoEntity[]> {
    return this.http.get<ConceptoEntity[]>(this.conceptosUrl).pipe(delay(1000));
  }

  obtenerProcesosEspeciales(): Observable<ProcesosEspecialesEntity[]> {
    return this.http.get<ProcesosEspecialesEntity[]>(this.procesosEspecialesUrl).pipe(delay(1000));
  }

  obtenerProvisionGasto(): Observable<ProvisionGastoEntity[]> {
    return this.http.get<ProvisionGastoEntity[]>(this.provisionGastoUrl).pipe(delay(1000));
  }

  obtenerRegistrarLiquidacion(): Observable<LiquidacionEntity[]> {
    return this.http
      .get<any[]>(this.registrarLiquidacionUrl)
      .pipe(map(items => items.map(item => this.mapRawALiquidacion(item))), delay(1000));
  }

  obtenerDashboardRrhh(): Observable<DashboardRrhhEntity> {
    return this.http.get<DashboardRrhhEntity>(this.dashboardRrhhUrl).pipe(delay(1000));
  }

  obtenerDistribucionCostos(): Observable<DistribucionCostosEntity[]> {
    return this.http.get<DistribucionCostosEntity[]>(this.distribucionCostosUrl).pipe(delay(1000));
  }

  obtenerEmisionBoletas(): Observable<EmisionBoletasEntity[]> {
    return this.http.get<EmisionBoletasEntity[]>(this.emisionBoletasUrl).pipe(delay(1000));
  }

  obtenerGeneracionArchivos(): Observable<GeneracionArchivosEntity[]> {
    return this.http.get<GeneracionArchivosEntity[]>(this.generacionArchivosUrl).pipe(delay(1000));
  }

  obtenerIndicadoresRotacion(): Observable<IndicadoresRotacionEntity[]> {
    return this.http.get<IndicadoresRotacionEntity[]>(this.indicadoresRotacionUrl).pipe(delay(1000));
  }
}
