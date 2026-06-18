import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { ContabilidadTablaPlancontableComponent } from './m-c-tabla/components/c-t-plancontable/contabilidad-tabla-plancontable.component';
import { ContabilidadTablaPlancentrocostoComponent } from './m-c-tabla/components/c-t-plancentrocosto/contabilidad-tabla-plancentrocosto.component';
import { ContabilidadTablaContabilidadComponent } from './m-c-tabla/components/c-t-contabilidad/contabilidad-tabla-contabilidad.component';
import { ContabilidadTablaDetraccionesComponent } from './m-c-tabla/components/c-t-detracciones/contabilidad-tabla-detracciones.component';
import { ContabilidadTablaImpuestosComponent } from './m-c-tabla/components/c-t-impuestos/contabilidad-tabla-impuestos.component';
import { ContabilidadTablaCuentasvssubcategoriasComponent } from './m-c-tabla/components/c-t-cuentasvssubcategorias/contabilidad-tabla-cuentasvssubcategorias.component';
import { ContabilidadReporteMaestrocontableComponent } from './m-c-reporte/components/c-r-maestrocontable/contabilidad-reporte-maestrocontable.component';
import { ContabilidadReporteValidacionComponent } from './m-c-reporte/components/c-r-validacion/contabilidad-reporte-validacion.component';
import { ContabilidadReporteLibrosyasientosComponent } from './m-c-reporte/components/c-r-librosyasientos/contabilidad-reporte-librosyasientos.component';
import { ContabilidadReporteReportefinancieroComponent } from './m-c-reporte/components/c-r-reportefinanciero/contabilidad-reporte-reportefinanciero.component';
import { ContabilidadReporteAnalisiscuentacontableComponent } from './m-c-reporte/components/c-r-analisiscuentacontable/contabilidad-reporte-analisiscuentacontable.component';
import { SaldosCuentasCorrienteComponent } from './m-c-operaciones/components/saldos-cuentas-corriente/saldos-cuentas-corriente.component';
import { CentroCostosTrabajComponent } from './m-c-consultas/components/centro-costos-trabaj/centro-costos-trabaj.component';
import { GestionAsientosManualComponent } from './m-c-operaciones/components/gestion-asientos-manual/gestion-asientos-manual.component';
import { GestionAsientosAutomaticoComponent } from './m-c-operaciones/components/gestion-asientos-automatico/gestion-asientos-automatico.component';
import { AjustesReclasificacionComponent } from './m-c-operaciones/components/ajustes-reclasificacion/ajustes-reclasificacion.component';
import { ContabilidadTablaTipodecambioComponent } from './m-c-tabla/components/c-t-tipodecambio/contabilidad-tabla-tipodecambio.component';
import { CPGenerarlibrosComponent } from './m-c-procesos/pages/c-p-generarlibros/c-p-generarlibros.component';
import { CPConsistenciaasientosComponent } from './m-c-procesos/pages/c-p-consistenciaasientos/c-p-consistenciaasientos.component';
import { CPClonacionasientosComponent } from './m-c-procesos/pages/c-p-clonacionasientos/c-p-clonacionasientos.component';
import { CPProcesosajustesComponent } from './m-c-procesos/pages/c-p-procesosajustes/c-p-procesosajustes.component';
import { CPCierreContableComponent } from './m-c-procesos/pages/c-p-cierre-contable/c-p-cierre-contable.component';
import { CanDeactivateGuard } from 'src/app/auth/guards/can-deactivate.guard';
import { CTRegistroUitComponent } from './m-c-tabla/components/c-t-registro-uit/c-t-registro-uit.component';

const routes: Routes = [
  {
    path: '',
    component: ContabilidadTablaPlancontableComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tabla/plan-contable',
    component: ContabilidadTablaPlancontableComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tabla/plan-centro-costo',
    component: ContabilidadTablaPlancentrocostoComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tabla/contabilidad',
    component: ContabilidadTablaContabilidadComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tabla/detracciones',
    component: ContabilidadTablaDetraccionesComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tabla/impuestos',
    component: ContabilidadTablaImpuestosComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tabla/cuentas-vs-subcategorias',
    component: ContabilidadTablaCuentasvssubcategoriasComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tabla/tipo-de-cambio',
    component: ContabilidadTablaTipodecambioComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tabla/registro-uit',
    component: CTRegistroUitComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'operaciones/gestion-asientos-manual',
    component: GestionAsientosManualComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'operaciones/ajustes-reclasificacion',
    component: AjustesReclasificacionComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'operaciones/gestion-asientos-automatico',
    component: GestionAsientosAutomaticoComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'operaciones/saldos-cuentas-corriente',
    component: SaldosCuentasCorrienteComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'operaciones/consulta-centro-costos',
    component: CentroCostosTrabajComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'reportes/maestro-contable',
    component: ContabilidadReporteMaestrocontableComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'reportes/reportes-analisis-cuenta-contable',
    component: ContabilidadReporteAnalisiscuentacontableComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'reportes/validacion',
    component: ContabilidadReporteValidacionComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'reportes/libros-y-asientos',
    component: ContabilidadReporteLibrosyasientosComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'reportes/reportes-financieros',
    component: ContabilidadReporteReportefinancieroComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'procesos/generar-libros',
    component: CPGenerarlibrosComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'procesos/consistencia-asientos',
    component: CPConsistenciaasientosComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'procesos/procesos-ajustes',
    component: CPProcesosajustesComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'procesos/clonacion-asientos',
    component: CPClonacionasientosComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'procesos/procesos-cierre-contable',
    component: CPCierreContableComponent,
    canDeactivate: [CanDeactivateGuard],
  },

];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ApartadoContabilidadPageRoutingModule {}
