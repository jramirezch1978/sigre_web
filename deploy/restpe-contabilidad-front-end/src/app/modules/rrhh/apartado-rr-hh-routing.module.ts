import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CanDeactivateGuard } from 'src/app/auth/guards/can-deactivate.guard';
import { CvInasistenciasComponent } from './consultas-validaciones/cv-inasistencias/cv-inasistencias.component';
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
import { PAgrupacionSedeComponent } from './parametros/components/p-agrupacion-sede/p-agrupacion-sede.component';
import { PConfiguracionProvisionesComponent } from './parametros/components/p-configuracion-provisiones/p-configuracion-provisiones.component';
import { PParametrosImpuestosComponent } from './parametros/components/p-parametros-impuestos/p-parametros-impuestos.component';
import { PFrecuenciaCalendariosComponent } from './parametros/components/p-frecuencia-calendarios/p-frecuencia-calendarios.component';
import { PGeneracionNumeracionComponent } from './parametros/components/p-generacion-numeracion/p-generacion-numeracion.component';
import { PPaisVigenciaComponent } from './parametros/components/p-pais-vigencia/p-pais-vigencia.component';
import { PTipoContratoComponent } from './parametros/components/p-tipo-contrato/p-tipo-contrato.component';
import { CvAnalisisInconsistenciaNominaComponent } from './consultas-validaciones/cv-analisis-inconsistencia-nomina/cv-analisis-inconsistencia-nomina.component';
import { PNConceptosComponent } from './procesos-de-nomina/pages/p-n-conceptos/p-n-conceptos.component';
import { AJAprobacionPermisosComponent } from './asistencias-jornadas/pages/a-j-aprobacion-permisos/a-j-aprobacion-permisos.component';

const routes: Routes = [

  {
    path: 'consultas-validaciones/inasistencias', 
    component: CvInasistenciasComponent
  },
  {
    path: 'consultas-validaciones/reportes-de-planilla',
    component: CvReportesdeplanillaComponent,
  },
  {
    path: 'consultas-validaciones/analisis-inconsistencia-nomina',
    component: CvAnalisisInconsistenciaNominaComponent,
  },
  {
    path: 'maestro-personal/datos-contacto',
    component: MPDatosPersonalesComponent,
  },
  {
    path: 'maestro-personal/categorias-laborales',
    component: CategoriasLaboralesComponent,
  },
   {
    path: 'maestro-personal/definicion-cargos',
    component: DefinicionCargosComponent,
  },
  {
    path: 'maestro-personal/definicion-areas-jerarquias',
    component: DefinicionAreasJerarquiasComponent,
  },
  {
    path: 'maestro-personal/configuracion-planilla',
    component: AfiliacionFondosDePensionComponent,
  },
  {
    path: 'asistencias-jornadas/calendarios-laborales',
    component: AJCalendariosLaboralesComponent,
  },
  {
    path: 'asistencias-jornadas/asistencias-HE',
    component: AJAsistenciasComponent,
  },
  {
    path: 'asistencias-jornadas/permisos',
    component: AJPermisosComponent,
  },
  {
    path: 'asistencias-jornadas/aprobacion-permisos',
    component: AJAprobacionPermisosComponent,
  },
  {
    path: 'asistencias-jornadas/vacaciones-licencias',
    component: AJVacacionesLicenciasComponent,
  },
  {
    path: 'asistencias-jornadas/aprobar-vacaciones-licencias',
    component: AJAprobarVacacionesLicenciasComponent,
  },
  {
    path: 'procesos-de-nomina/calculo-planillas',
    component: PNCalculoPlanillaComponent,
  },
  {
    path: 'procesos-de-nomina/aprobar-planilla',
    component: PNAprobarPlanillaComponent,
  },
  {
    path: 'procesos-de-nomina/registrar-liquidacion',
    component: PNRegistrarLiquidacionComponent,
  },
  {
    path: 'procesos-de-nomina/aprobar-liquidacion',
    component: PNAprobarLiquidacionComponent,
  },
  {
    path: 'procesos-de-nomina/provision-gasto',
    component: PNProvisionGastoComponent,
  },
  {
    path: 'procesos-de-nomina/procesos-especiales',
    component: PNProcesosEspecialesComponent,
  },
  {
    path: 'procesos-de-nomina/conceptos',
    component: PNConceptosComponent,
  },
  {
    path: 'reportes-y-analitica/emision-boletas',
    component: RAEmisionBoletasComponent,
  },
  {
    path: 'reportes-y-analitica/distribucion-costos',
    component: RADistribucionCostosComponent,
  },
  {
    path: 'reportes-y-analitica/indicadores-rotacion',
    component: RAIndicadoresRotacionComponent,
  },
  {
    path: 'reportes-y-analitica/generacion-archivos',
    component: RAGeneracionArchivosComponent,
  },
  {
  path: 'reportes-y-analitica/dashboard-rrhh',
    component: RADashboardRrhhComponent,
  },  
  {
    path: 'parametros/agrupacion-sede',
    component: PAgrupacionSedeComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'parametros/configuracion-provisiones',
    component:PConfiguracionProvisionesComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'parametros/parametros-impuestos',
    component:PParametrosImpuestosComponent,
  },
  {
    path: 'parametros/frecuencia-calendarios',
    component:PFrecuenciaCalendariosComponent,
  },
  {
    path: 'parametros/generacion-numeracion',
    component:PGeneracionNumeracionComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'parametros/pais-vigencia',
    component:PPaisVigenciaComponent,
  },
  {
    path: 'parametros/tipo-contrato',
    component:PTipoContratoComponent,
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ApartadoRrHhRoutingModule {}
