import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { AgGridSharedModule } from 'src/app/shared/ag-grid-shared.module';
import { UiModule } from 'src/app/ui/ui.module';
import { ApartadoProduccionPageRoutingModule } from './apartado-produccion-routing.module';
import { AsignacionGastosIndirectosComponent } from './m-p-procesos/pages/asignacion-gastos-indirectos/asignacion-gastos-indirectos.component';

// Repositorios
import { IReportesRepository } from './domain/repositories/ireportes.repository';
import { ReportesRepositoryImpl } from './infrastructure/repository/reportes.repository.impl';

// UseCases
import { ObtenerReglasAsignacionUseCase } from './application/usecases/obtener-reglas-asignacion.usecase';

// Store y Facade
import { ProduccionStore } from './store/produccion.store';
import { ProduccionFacade } from './application/facades/produccion.facade';

// Effects
import { ProduccionAsignacionGridEffects } from './effects/produccion-asignacion-grid.effect';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    ReactiveFormsModule,
    FontAwesomeModule,
    AgGridSharedModule,
    UiModule,
    ApartadoProduccionPageRoutingModule,
  ],
  declarations: [
    AsignacionGastosIndirectosComponent,
  ],
  providers: [
    // Repositorios
    { provide: IReportesRepository, useClass: ReportesRepositoryImpl },

    // UseCases
    ObtenerReglasAsignacionUseCase,

    // Store y Facade
    ProduccionStore,
    ProduccionFacade,

    // Effects
    ProduccionAsignacionGridEffects,
  ],
})
export class ApartadoProduccionPageModule {}
