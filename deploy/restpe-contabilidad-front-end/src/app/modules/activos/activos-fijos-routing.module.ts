import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { CanDeactivateGuard } from 'src/app/auth/guards/can-deactivate.guard';
import { ActivofijoProcesosCalculodepreciacionComponent } from './m-af-procesos/pages/af-p-calculodepreciacion/activofijo-procesos-calculodepreciacion.component';
import { ActivofijoTablaOperacionesComponent } from './m-af-tabla/pages/af-t-operaciones/activofijo-tabla-operaciones.component';
import { ActivofijoTablaIncidenciasComponent } from './m-af-tabla/pages/af-t-incidencias/activofijo-tabla-incidencias.component';
import { ActivofijoReporteResumenactivofijoComponent } from './m-af-reporte/pages/af-r-resumenactivofijo/activofijo-reporte-resumenactivofijo.component';
import { ActivofijoReporteDepreciacionanualComponent } from './m-af-reporte/pages/af-r-depreciacionanual/activofijo-reporte-depreciacionanual.component';
import { ActivofijoReporteResumenrangosComponent } from './m-af-reporte/pages/af-r-resumenrangos/activofijo-reporte-resumenrangos.component';
import { ActivofijoProcesosGeneracionasientosdepreciacionComponent } from './m-af-procesos/pages/af-p-generacionasientosdepreciacion/activofijo-procesos-generacionasientosdepreciacion.component';
import { ActivofijoProcesosGeneracionasientosindexacionComponent } from './m-af-procesos/pages/af-p-generacionasientosindexacion/activofijo-procesos-generacionasientosindexacion.component';
import { ActivofijoProcesosGeneracionasientosrevaluacionComponent } from './m-af-procesos/pages/af-p-generacionasientosrevaluacion/activofijo-procesos-generacionasientosrevaluacion.component';
import { ActivofijoProcesosGeneracionasientossiniestroComponent } from './m-af-procesos/pages/af-p-generacionasientossiniestro/activofijo-procesos-generacionasientossiniestro.component';
import { ActivofijoProcesosGeneraciondevengoaseguradoresComponent } from './m-af-procesos/pages/af-p-generaciondevengoaseguradores/activofijo-procesos-generaciondevengoaseguradores.component';
import { ActivofijoTablaAseguradoresComponent } from './m-af-tabla/pages/af-t-aseguradores/activofijo-tabla-aseguradores.component';
import { ActivofijoTablaSegurosComponent } from './m-af-tabla/pages/af-t-seguros/activofijo-tabla-seguros.component';
import { ActivofijoTablaClasifactivosComponent } from './m-af-tabla/pages/af-t-clasifactivos/activofijo-tabla-clasifactivos.component';
import { ActivofijoTablaMatrizcontableComponent } from './m-af-tabla/pages/af-t-matrizcontable/activofijo-tabla-matrizcontable.component';
import { ActivofijoTablaUbicacionactivosComponent } from './m-af-tabla/pages/af-t-ubicacionactivos/activofijo-tabla-ubicacionactivos.component';
import { ActivofijoTablaParamoperacionesComponent } from './m-af-tabla/pages/af-t-paramoperaciones/activofijo-tabla-paramoperaciones.component';
import { ActivofijoTablaNumactivosComponent } from './m-af-tabla/pages/af-t-numactivos/activofijo-tabla-numactivos.component';
import { ActivofijoTablaNumtrasladosComponent } from './m-af-tabla/pages/af-t-numtraslados/activofijo-tabla-numtraslados.component';
import { ActivosfijosOperacionesRegistroactivosComponent } from './m-af-tabla/pages/af-o-registroactivos/activosfijos-operaciones-registroactivos.component';
import { ActivosfijosOperacionesRegistrotrasladoComponent } from './m-af-operaciones/pages/af-o-registrotraslado/activosfijos-operaciones-registrotraslado.component';
import { ActivosfijosOperacionesAprobaciontrasladoComponent } from './m-af-operaciones/pages/af-o-aprobaciontraslado/activosfijos-operaciones-aprobaciontraslado.component';
import { ActivosfijosOperacionesPolizasseguroComponent } from './m-af-operaciones/pages/af-o-polizasseguro/activosfijos-operaciones-polizasseguro.component';
import { ActivosfijosOperacionesRevaluacionesComponent } from './m-af-operaciones/pages/af-o-revaluaciones/activosfijos-operaciones-revaluaciones.component';
import { ActivosfijosOperacionesAsignacionratiosComponent } from './m-af-operaciones/pages/af-o-asignacionratios/activosfijos-operaciones-asignacionratios.component';
import { ActivosfijosOperacionesOperacionesactivosComponent } from './m-af-operaciones/pages/af-o-operacionesactivos/activosfijos-operaciones-operacionesactivos.component';
import { AfOVentasActivosComponent } from './m-af-operaciones/pages/af-o-ventas-activos/af-o-ventas-activos.component';
import { AfOReceptTrasladosAfComponent } from './m-af-operaciones/pages/af-o-recept-traslados-af/af-o-recept-traslados-af.component';

const routes: Routes = [
  {
    path: '',
    redirectTo: 'tabla/operaciones',
    pathMatch: 'full'
  },
  // Rutas de componentes tablas
  {
    path: 'tabla/operaciones',
    component: ActivofijoTablaOperacionesComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'tabla/incidencias',
    component: ActivofijoTablaIncidenciasComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'tabla/aseguradores',
    component: ActivofijoTablaAseguradoresComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'tabla/seguros',
    component: ActivofijoTablaSegurosComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'tabla/clasifactivos',
    component: ActivofijoTablaClasifactivosComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'tabla/matrizcontable',
    component: ActivofijoTablaMatrizcontableComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'tabla/ubicacionactivos',
    component: ActivofijoTablaUbicacionactivosComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'tabla/paramoperaciones',
    component: ActivofijoTablaParamoperacionesComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'tabla/numactivos',
    component: ActivofijoTablaNumactivosComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'tabla/numtraslados',
    component: ActivofijoTablaNumtrasladosComponent,
    canDeactivate: [CanDeactivateGuard]
  },

  // Rutas de compoentes Operaciones 

   {
    path: 'operaciones/registroactivos',
    component: ActivosfijosOperacionesRegistroactivosComponent,
    canDeactivate: [CanDeactivateGuard]
   },
   {
    path: 'operaciones/registrotraslado',
    component: ActivosfijosOperacionesRegistrotrasladoComponent,
    canDeactivate: [CanDeactivateGuard]
   },
   {
    path: 'operaciones/aprobaciontraslado',
    component: ActivosfijosOperacionesAprobaciontrasladoComponent,
    canDeactivate: [CanDeactivateGuard]
   },
   {
    path: 'operaciones/recep-traslados',
    component: AfOReceptTrasladosAfComponent,
    canDeactivate: [CanDeactivateGuard]
   },
   {
    path: 'operaciones/operacionesactivos', // Modulo operaciones Especiales
    component: ActivosfijosOperacionesOperacionesactivosComponent,
    canDeactivate: [CanDeactivateGuard]
    
   },
   {
    path: 'operaciones/polizasseguro',
    component: ActivosfijosOperacionesPolizasseguroComponent,
    canDeactivate: [CanDeactivateGuard]
   },
   {
    path: 'operaciones/revaluaciones',
    component: ActivosfijosOperacionesRevaluacionesComponent,
    canDeactivate: [CanDeactivateGuard]
   },
   {
    path: 'operaciones/asignacionratios',
    component: ActivosfijosOperacionesAsignacionratiosComponent,
    canDeactivate: [CanDeactivateGuard]
   },
   {
    path: 'operaciones/venta-activos',
    component: AfOVentasActivosComponent,
    canDeactivate: [CanDeactivateGuard]
   },

    //Rutas de Activos Fijos (Reportes)
  {
    path: 'reporte/resumen-activofijo',
    component: ActivofijoReporteResumenactivofijoComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'reporte/depreciacion-anual',
    component: ActivofijoReporteDepreciacionanualComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'reporte/resumen-rangos',
    component: ActivofijoReporteResumenrangosComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  //Rutas de Activos Fijos (Procesos)
  {
    path: 'procesos/calculo-depreciacion',
    component: ActivofijoProcesosCalculodepreciacionComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'procesos/generacion-asientos-depreciacion',
    component: ActivofijoProcesosGeneracionasientosdepreciacionComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'procesos/generacion-asientos-indexacion',
    component: ActivofijoProcesosGeneracionasientosindexacionComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'procesos/generacion-asientos-revaluacion',
    component: ActivofijoProcesosGeneracionasientosrevaluacionComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'procesos/generacion-asientos-siniestro',
    component: ActivofijoProcesosGeneracionasientossiniestroComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'procesos/generacion-devengo-aseguradores',
    component: ActivofijoProcesosGeneraciondevengoaseguradoresComponent,
    canDeactivate: [CanDeactivateGuard]
  }
  


  

];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ActivosFijosPageRoutingModule {}
