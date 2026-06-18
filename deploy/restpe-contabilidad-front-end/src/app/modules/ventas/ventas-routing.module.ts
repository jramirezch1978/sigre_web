import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CanDeactivateGuard } from 'src/app/auth/guards/can-deactivate.guard';
import { VOFacturacionDeRegaliasComponent } from './m-v-operaciones/v-o-facturacion-de-regalias/v-o-facturacion-de-regalias.component';
import { VRReporteTributarioPorPeriodoComponent } from './m-v-reportes/v-r-reporte-tributario-por-periodo/v-r-reporte-tributario-por-periodo.component';
import { VRReporteVentasComponent } from './m-v-reportes/v-r-reporte-ventas/v-r-reporte-ventas.component';
import { VRPanelReenvioComponent } from './m-v-reportes/v-r-panel-reenvio/v-r-panel-reenvio.component';
import { VRPanelEstadosDocComponent } from './m-v-reportes/v-r-panel-estados-doc/v-r-panel-estados-doc.component';

const routes: Routes = [
  {
    path: 'facturacion-de-regalias',
    component: VOFacturacionDeRegaliasComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'reportes/reporte-tributario-por-periodo',
    component: VRReporteTributarioPorPeriodoComponent,
  },
  {
    path: 'reportes/reporte-de-ventas',
    component: VRReporteVentasComponent,
  },
  {
    path: 'reportes/panel-reenvio',
    component: VRPanelReenvioComponent,
  },
  {
    path: 'reportes/panel-estados-doc',
    component: VRPanelEstadosDocComponent,

  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class VentasRoutingModule {}
