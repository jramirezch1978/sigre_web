import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';

import { ApartadoRrHhRoutingModule } from './apartado-rr-hh-routing.module';
import { CENTRO_COSTO_PROVIDERS } from '../contabilidad/infrastructure/providers/centro-costo.providers';
import { IReportesRepository } from './domain/repositories/ireportes.repository';
import { ReportesRepositoryImpl } from './infrastructure/repository/reportes.repository.impl';
import { ObtenerPermisosUseCase } from './application/usecases/obtener-permisos.usecase';
import { ObtenerPermisosRegistroUseCase } from './application/usecases/obtener-permisos-registro.usecase';
import { RrHhStore } from './store/rr-hh.store';
import { RrHhFacade } from './application/facades/rr-hh.facade';
import { RrHhAprobacionPermisosGridEffects } from './effects/rr-hh-aprobacion-permisos-grid.effect';
import { RrHhPermisosRegistroGridEffects } from './effects/rr-hh-permisos-registro-grid.effect';
import { RrHhVacacionesLicenciasRegistroGridEffects } from './effects/rr-hh-vacaciones-licencias-registro-grid.effect';
import { ObtenerVacacionesLicenciasUseCase } from './application/usecases/obtener-vacaciones-licencias.usecase';
import { ObtenerVacacionesLicenciasRegistroUseCase } from './application/usecases/obtener-vacaciones-licencias-registro.usecase';
import { RrHhAprobarVacacionesGridEffects } from './effects/rr-hh-aprobar-vacaciones-grid.effect';
import { ObtenerAsistenciasUseCase } from './application/usecases/obtener-asistencias.usecase';
import { RrHhAsistenciasGridEffects } from './effects/rr-hh-asistencias-grid.effect';
import { ObtenerCalendariosLaboralesUseCase } from './application/usecases/obtener-calendarios-laborales.usecase';
import { RrHhCalendariosLaboralesGridEffects } from './effects/rr-hh-calendarios-laborales-grid.effect';
import { ObtenerAnalisisInconsistenciaNominaUseCase } from './application/usecases/obtener-analisis-inconsistencia-nomina.usecase';
import { ObtenerInasistenciasUseCase } from './application/usecases/obtener-inasistencias.usecase';
import { ObtenerReportesPlanillaUseCase } from './application/usecases/obtener-reportes-planilla.usecase';
import { ObtenerAfiliacionFondosPensionUseCase } from './application/usecases/obtener-afiliacion-fondos-pension.usecase';
import { IMaestroPersonalRepository } from './domain/repositories/imaestro-personal.repository';
import { MaestroPersonalRepositoryImpl } from './infrastructure/repository/maestro-personal.repository.impl';
import { IParametrosRepository } from './domain/repositories/iparametros.repository';
import { ParametrosRepositoryImpl } from './infrastructure/repository/parametros.repository.impl';
import { ObtenerAgrupacionSedeUseCase } from './application/usecases/obtener-agrupacion-sede.usecase';
import { ObtenerConfiguracionProvisionesUseCase } from './application/usecases/obtener-configuracion-provisiones.usecase';
import { ObtenerFrecuenciaCalendariosUseCase } from './application/usecases/obtener-frecuencia-calendarios.usecase';
import { ObtenerGeneracionNumeracionUseCase } from './application/usecases/obtener-generacion-numeracion.usecase';
import { ObtenerPaisVigenciaUseCase } from './application/usecases/obtener-pais-vigencia.usecase';
import { ObtenerTipoContratoUseCase } from './application/usecases/obtener-tipo-contrato.usecase';
import { ObtenerAprobarPlanillaUseCase } from './application/usecases/obtener-aprobar-planilla.usecase';
import { ObtenerCalculoPlanillaUseCase } from './application/usecases/obtener-calculo-planilla.usecase';
import { ObtenerConceptosUseCase } from './application/usecases/obtener-conceptos.usecase';
import { ObtenerProcesosEspecialesUseCase } from './application/usecases/obtener-procesos-especiales.usecase';
import { ObtenerProvisionGastoUseCase } from './application/usecases/obtener-provision-gasto.usecase';
import { ObtenerRegistrarLiquidacionUseCase } from './application/usecases/obtener-registrar-liquidacion.usecase';
import { ObtenerDashboardRrhhUseCase } from './application/usecases/obtener-dashboard-rrhh.usecase';
import { ObtenerDistribucionCostosUseCase } from './application/usecases/obtener-distribucion-costos.usecase';
import { ObtenerEmisionBoletasUseCase } from './application/usecases/obtener-emision-boletas.usecase';
import { ObtenerGeneracionArchivosUseCase } from './application/usecases/obtener-generacion-archivos.usecase';
import { ObtenerIndicadoresRotacionUseCase } from './application/usecases/obtener-indicadores-rotacion.usecase';
import { ObtenerCategoriasLaboralesUseCase } from './application/usecases/obtener-categorias-laborales.usecase';
import { ObtenerDefinicionAreasJerarquiasUseCase } from './application/usecases/obtener-definicion-areas-jerarquias.usecase';
import { ObtenerDefinicionCargosUseCase } from './application/usecases/obtener-definicion-cargos.usecase';
import { ObtenerDatosPersonalesUseCase } from './application/usecases/obtener-datos-personales.usecase';
import { CvInasistenciasComponent } from './consultas-validaciones/cv-inasistencias/cv-inasistencias.component';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { AgGridSharedModule } from 'src/app/shared/ag-grid-shared.module';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { UiModule } from 'src/app/ui/ui.module';
import { CvReportesdeplanillaComponent } from './consultas-validaciones/cv-reportesdeplanilla/cv-reportesdeplanilla.component';
import { MPDatosPersonalesComponent } from './maestro-de-personal/pages/m-p-datos-personales/m-p-datos-personales.component';
import { AJCalendariosLaboralesComponent } from './asistencias-jornadas/pages/a-j-calendarios-laborales/a-j-calendarios-laborales.component';
import { AJAsistenciasComponent } from './asistencias-jornadas/pages/a-j-asistencias/a-j-asistencias.component';
import { AJPermisosComponent } from './asistencias-jornadas/pages/a-j-permisos/a-j-permisos.component';
import { AJVacacionesLicenciasComponent } from './asistencias-jornadas/pages/a-j-vacaciones-licencias/a-j-vacaciones-licencias.component';
import { AJAprobarVacacionesLicenciasComponent } from './asistencias-jornadas/pages/a-j-aprobar-vacaciones-licencias/a-j-aprobar-vacaciones-licencias.component';
import { CategoriasLaboralesComponent } from './maestro-de-personal/pages/categorias-laborales/categorias-laborales.component';
import { DefinicionCargosComponent } from './maestro-de-personal/pages/definicion-cargos/definicion-cargos.component';
import { DefinicionAreasJerarquiasComponent } from './maestro-de-personal/pages/definicion-areas-jerarquias/definicion-areas-jerarquias.component';
import { AfiliacionFondosDePensionComponent } from './maestro-de-personal/pages/afiliacion-fondos-de-pension/afiliacion-fondos-de-pension.component';
import { ModalCuentaBancariaComponent } from './maestro-de-personal/modals/modal-cuenta-bancaria/modal-cuenta-bancaria.component';
import { ModalSancionComponent } from './maestro-de-personal/modals/modal-sancion/modal-sancion.component';
import { ModalRenovarContratoComponent } from './maestro-de-personal/modals/modal-renovar-contrato/modal-renovar-contrato.component';
import { ModalAgregarEquipamientoComponent } from './maestro-de-personal/modals/modal-agregar-equipamiento/modal-agregar-equipamiento.component';
import { ModalCambiarPuestoComponent } from './maestro-de-personal/modals/modal-cambiar-puesto/modal-cambiar-puesto.component';
import { RAEmisionBoletasComponent } from './reportes-y-analitica/pages/r-a-emision-boletas/r-a-emision-boletas.component';
import { RADistribucionCostosComponent } from './reportes-y-analitica/pages/r-a-distribucion-costos/r-a-distribucion-costos.component';
import { RAIndicadoresRotacionComponent } from './reportes-y-analitica/pages/r-a-indicadores-rotacion/r-a-indicadores-rotacion.component';
import { RAGeneracionArchivosComponent } from './reportes-y-analitica/pages/r-a-generacion-archivos/r-a-generacion-archivos.component';
import { PNCalculoPlanillaComponent } from './procesos-de-nomina/pages/p-n-calculo-planilla/p-n-calculo-planilla.component';
import { PNAprobarPlanillaComponent } from './procesos-de-nomina/pages/p-n-aprobar-planilla/p-n-aprobar-planilla.component';
import { RADashboardRrhhComponent } from './reportes-y-analitica/pages/r-a-dashboard-rrhh/r-a-dashboard-rrhh.component';
import { PNRegistrarLiquidacionComponent } from './procesos-de-nomina/pages/p-n-registrar-liquidacion/p-n-registrar-liquidacion.component';
import { PNAprobarLiquidacionComponent } from './procesos-de-nomina/pages/p-n-aprobar-liquidacion/p-n-aprobar-liquidacion.component';
import { PNProvisionGastoComponent } from './procesos-de-nomina/pages/p-n-provision-gasto/p-n-provision-gasto.component';
import { PNProcesosEspecialesComponent } from './procesos-de-nomina/pages/p-n-procesos-especiales/p-n-procesos-especiales.component';
import { CalcularConceptoComponent } from './procesos-de-nomina/modals/calcular-concepto/calcular-concepto.component';
import { PFrecuenciaCalendariosComponent } from './parametros/components/p-frecuencia-calendarios/p-frecuencia-calendarios.component';
import { PPaisVigenciaComponent } from './parametros/components/p-pais-vigencia/p-pais-vigencia.component';
import { PParametrosImpuestosComponent } from './parametros/components/p-parametros-impuestos/p-parametros-impuestos.component';
import { PAgrupacionSedeComponent } from './parametros/components/p-agrupacion-sede/p-agrupacion-sede.component';
import { PGeneracionNumeracionComponent } from './parametros/components/p-generacion-numeracion/p-generacion-numeracion.component';
import { PConfiguracionProvisionesComponent } from './parametros/components/p-configuracion-provisiones/p-configuracion-provisiones.component';
import { PTipoContratoComponent } from './parametros/components/p-tipo-contrato/p-tipo-contrato.component';
import { ModalDetalleCalculoComponent } from './procesos-de-nomina/modals/modal-detalle-calculo/modal-detalle-calculo.component';
import { CvAnalisisInconsistenciaNominaComponent } from './consultas-validaciones/cv-analisis-inconsistencia-nomina/cv-analisis-inconsistencia-nomina.component';
import { ModalAsignacionDistribucionComponent } from './reportes-y-analitica/modals/modal-asignacion-distribucion/modal-asignacion-distribucion.component';
import { AgregarCuentaComponent } from './maestro-de-personal/components/agregar-cuenta/agregar-cuenta.component';
import { ModalVerDocumentoComponent } from './maestro-de-personal/modals/modal-ver-documento/modal-ver-documento.component';
import { PNConceptosComponent } from './procesos-de-nomina/pages/p-n-conceptos/p-n-conceptos.component';
import { AJAprobacionPermisosComponent } from './asistencias-jornadas/pages/a-j-aprobacion-permisos/a-j-aprobacion-permisos.component';



@NgModule({
  imports: [
    CommonModule,
    HttpClientModule,
    ApartadoRrHhRoutingModule,
    FontAwesomeModule,
    AgGridSharedModule,
    FormsModule,
    IonicModule,
    UiModule,
    ReactiveFormsModule,
  ],

  providers: [
    { provide: IReportesRepository, useClass: ReportesRepositoryImpl },
    { provide: IMaestroPersonalRepository, useClass: MaestroPersonalRepositoryImpl },
    { provide: IParametrosRepository, useClass: ParametrosRepositoryImpl },
    ObtenerAgrupacionSedeUseCase,
    ObtenerConfiguracionProvisionesUseCase,
    ObtenerFrecuenciaCalendariosUseCase,
    ObtenerGeneracionNumeracionUseCase,
    ObtenerPaisVigenciaUseCase,
    ObtenerTipoContratoUseCase,
    ObtenerAprobarPlanillaUseCase,
    ObtenerCalculoPlanillaUseCase,
    ObtenerConceptosUseCase,
    ObtenerProcesosEspecialesUseCase,
    ObtenerProvisionGastoUseCase,
    ObtenerRegistrarLiquidacionUseCase,
    ObtenerDashboardRrhhUseCase,
    ObtenerDistribucionCostosUseCase,
    ObtenerEmisionBoletasUseCase,
    ObtenerGeneracionArchivosUseCase,
    ObtenerIndicadoresRotacionUseCase,
    ObtenerPermisosUseCase,
    ObtenerPermisosRegistroUseCase,
    ObtenerVacacionesLicenciasUseCase,
    ObtenerVacacionesLicenciasRegistroUseCase,
    ObtenerAsistenciasUseCase,
    ObtenerCalendariosLaboralesUseCase,
    ObtenerAnalisisInconsistenciaNominaUseCase,
    ObtenerInasistenciasUseCase,
    ObtenerReportesPlanillaUseCase,
    ObtenerAfiliacionFondosPensionUseCase,
    ObtenerCategoriasLaboralesUseCase,
    ObtenerDefinicionAreasJerarquiasUseCase,
    ObtenerDefinicionCargosUseCase,
    ObtenerDatosPersonalesUseCase,
    RrHhStore,
    RrHhFacade,
    RrHhAprobacionPermisosGridEffects,
    RrHhPermisosRegistroGridEffects,
    RrHhVacacionesLicenciasRegistroGridEffects,
    RrHhAprobarVacacionesGridEffects,
    RrHhAsistenciasGridEffects,
    RrHhCalendariosLaboralesGridEffects,
    ...CENTRO_COSTO_PROVIDERS,
  ],

  declarations: [
    CvAnalisisInconsistenciaNominaComponent,
    PFrecuenciaCalendariosComponent,
    PPaisVigenciaComponent,
    PParametrosImpuestosComponent,
    PGeneracionNumeracionComponent,
    PAgrupacionSedeComponent,
    PConfiguracionProvisionesComponent,
    PTipoContratoComponent,
    CvInasistenciasComponent, 
    CvReportesdeplanillaComponent,
    MPDatosPersonalesComponent,
    AJCalendariosLaboralesComponent,
    AJAsistenciasComponent,
    AJPermisosComponent,
    AJVacacionesLicenciasComponent,
    AJAprobarVacacionesLicenciasComponent,
    CategoriasLaboralesComponent,
    DefinicionCargosComponent,
    DefinicionAreasJerarquiasComponent,
    AfiliacionFondosDePensionComponent,
    ModalCuentaBancariaComponent,
    ModalSancionComponent,
    ModalRenovarContratoComponent,
    ModalAgregarEquipamientoComponent,
    ModalCambiarPuestoComponent,
    ModalDetalleCalculoComponent,
    RAEmisionBoletasComponent,
    RADistribucionCostosComponent,
    RAIndicadoresRotacionComponent,
    RAGeneracionArchivosComponent,
    PNCalculoPlanillaComponent,
    PNAprobarPlanillaComponent,
    RADashboardRrhhComponent,
    PNRegistrarLiquidacionComponent,
    PNAprobarLiquidacionComponent,
    PNProvisionGastoComponent,
    PNProcesosEspecialesComponent,
    CalcularConceptoComponent,
    ModalAsignacionDistribucionComponent,
    AgregarCuentaComponent,
    ModalVerDocumentoComponent,    
    PNConceptosComponent,
    AJAprobacionPermisosComponent,
  ],

})
export class ApartadoRrHhModule { }
