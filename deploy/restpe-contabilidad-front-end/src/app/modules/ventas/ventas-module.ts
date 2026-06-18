import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { VentasRoutingModule } from './ventas-routing.module';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { AgGridSharedModule } from 'src/app/shared/ag-grid-shared.module';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { UiModule } from 'src/app/ui/ui.module';
import { VOFacturacionDeRegaliasComponent } from './m-v-operaciones/v-o-facturacion-de-regalias/v-o-facturacion-de-regalias.component';
import { VRReporteTributarioPorPeriodoComponent } from './m-v-reportes/v-r-reporte-tributario-por-periodo/v-r-reporte-tributario-por-periodo.component';
import { VRReporteVentasComponent } from './m-v-reportes/v-r-reporte-ventas/v-r-reporte-ventas.component';
import { VENTAS_PROVIDERS } from './infrastructure/providers/ventas.providers';
import { VRPanelReenvioComponent } from './m-v-reportes/v-r-panel-reenvio/v-r-panel-reenvio.component';
import { VRPanelEstadosDocComponent } from './m-v-reportes/v-r-panel-estados-doc/v-r-panel-estados-doc.component';


@NgModule({

  imports: [
    CommonModule,
    VentasRoutingModule,
    FontAwesomeModule,
    AgGridSharedModule,
    FormsModule,
    IonicModule,
    UiModule,
    ReactiveFormsModule,
  ],
  declarations: [
    VOFacturacionDeRegaliasComponent,
    VRReporteTributarioPorPeriodoComponent,
    VRReporteVentasComponent,
    VRPanelReenvioComponent,
    VRPanelEstadosDocComponent,
  ],
  providers: [
    ...VENTAS_PROVIDERS,
  ],
})
export class VentasModule { }
