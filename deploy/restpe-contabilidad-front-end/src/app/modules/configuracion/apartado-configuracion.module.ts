import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApartadoConfiguracionRoutingModule } from './apartado-configuracion-routing.module';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { AgGridSharedModule } from 'src/app/shared/ag-grid-shared.module';
import { UiModule } from 'src/app/ui/ui.module';
import { CADatosGeneralesComponent } from './ajustes/c-a-datos-generales/c-a-datos-generales.component';
import { CComCompaniasSucursalesTransaccionesComponent } from './companias/c-com-companias-sucursales-transacciones/c-com-companias-sucursales-transacciones.component';
import { ModalNuevaSucursalComponent } from './companias/c-com-companias-sucursales-transacciones/modal/modal-nueva-sucursal.component';
import { ALCanalPagoCobroComponent } from './localizacion/pages/a-l-canal-pago-cobro/a-l-canal-pago-cobro.component';
import { ALCondicionesPagoCobroComponent } from './localizacion/pages/a-l-condiciones-pago-cobro/a-l-condiciones-pago-cobro.component';
import { ALCuentaBancariaComponent } from './localizacion/pages/a-l-cuenta-bancaria/a-l-cuenta-bancaria.component';
import { ALMonedasComponent } from './localizacion/pages/a-l-monedas/a-l-monedas.component';
import { ALFormasPagoComponent } from './localizacion/pages/a-l-formas-pago/a-l-formas-pago.component';
import { ALMediosPagoComponent } from './localizacion/pages/a-l-medios-pago/a-l-medios-pago.component';
import { ALEjerciciosYPeriodosComponent } from './localizacion/pages/a-l-ejercicios-y-periodos/a-l-ejercicios-y-periodos.component';
import { ALRetencionesComponent } from './localizacion/pages/a-l-retenciones/a-l-retenciones.component';
import { ALUsuariosComponent } from './localizacion/pages/a-l-usuarios/a-l-usuarios.component';
import { ModalEditarPeriodoComponent } from './localizacion/modals/modal-editar-periodo/modal-editar-periodo.component';
import { CANotifiacionAsignacionActivosComponent } from './ajustes/c-a-notifiacion-asignacion-activos/c-a-notifiacion-asignacion-activos.component';

// Repositorios
import { IReportesRepository } from './domain/repositories/ireportes.repository';
import { ReportesRepositoryImpl } from './infrastructure/repository/reportes.repository.impl';

// UseCases
import { 
  ObtenerHistorialDatosGeneralesUseCase, 
  ObtenerPlanesUseCase,
  ObtenerPlantillasNotificacionUseCase,
  ObtenerHistorialPlantillasNotificacionUseCase,
  ObtenerCompaniasUseCase,
  ObtenerCanalesPagoCobroUseCase,
  ObtenerCondicionesPagoCobroUseCase,
  ObtenerCuentasBancariasUseCase,
  ObtenerEjerciciosFiscalesUseCase,
  ObtenerMonedasUseCase,
  ObtenerRetencionesUseCase,
  ObtenerUsuariosUseCase,
  ObtenerSucursalesUseCase,
} from './application/usecases';

// Store y Facade
import { ConfiguracionStore } from './store/configuracion.store';
import { ConfiguracionFacade } from './application/facades/configuracion.facade';

// Effects
import { ConfiguracionGridEffects } from './effects/configuracion-grid.effect';
import { ConfiguracionCompaniasGridEffects } from './effects/configuracion-companias-grid.effect';
import { ConfiguracionCanalesPagoCobroGridEffects } from './effects/configuracion-canales-pago-cobro-grid.effect';
import { ConfiguracionCondicionesPagoCobroGridEffects } from './effects/configuracion-condiciones-pago-cobro-grid.effect';
import { ConfiguracionCuentasBancariasGridEffects } from './effects/configuracion-cuentas-bancarias-grid.effect';
import { ConfiguracionEjerciciosFiscalesGridEffects } from './effects/configuracion-ejercicios-fiscales-grid.effect';
import { ConfiguracionMonedasGridEffects } from './effects/configuracion-monedas-grid.effect';
import { ConfiguracionRetencionesGridEffects } from './effects/configuracion-retenciones-grid.effect';
import { ConfiguracionUsuariosGridEffects } from './effects/configuracion-usuarios-grid.effect';

@NgModule({
  imports: [
    CommonModule,
    ApartadoConfiguracionRoutingModule,
    FormsModule,
    IonicModule,
    ReactiveFormsModule,
    FontAwesomeModule,
    AgGridSharedModule,
    UiModule,
  ],
  declarations: [
    CADatosGeneralesComponent,
    CComCompaniasSucursalesTransaccionesComponent,
    ModalNuevaSucursalComponent,
    CANotifiacionAsignacionActivosComponent,
    ALCanalPagoCobroComponent,
    ALCondicionesPagoCobroComponent,
    ALCuentaBancariaComponent,
    ALRetencionesComponent,
    ALMonedasComponent,
    ALFormasPagoComponent,
    ALMediosPagoComponent,
    ALEjerciciosYPeriodosComponent,
    ALUsuariosComponent,
    ModalEditarPeriodoComponent,

  ],
  providers: [
    // Repositorios
    { provide: IReportesRepository, useClass: ReportesRepositoryImpl },
    
    // UseCases
    ObtenerHistorialDatosGeneralesUseCase,
    ObtenerPlanesUseCase,
    ObtenerPlantillasNotificacionUseCase,
    ObtenerHistorialPlantillasNotificacionUseCase,
    ObtenerCompaniasUseCase,
    ObtenerCanalesPagoCobroUseCase,
    ObtenerCondicionesPagoCobroUseCase,
    ObtenerCuentasBancariasUseCase,
    ObtenerEjerciciosFiscalesUseCase,
    ObtenerMonedasUseCase,
    ObtenerRetencionesUseCase,
    ObtenerUsuariosUseCase,
    ObtenerSucursalesUseCase,
    
    // Store y Facade
    ConfiguracionStore,
    ConfiguracionFacade,
    
    // Effects
    ConfiguracionGridEffects,
    ConfiguracionCompaniasGridEffects,
    ConfiguracionCanalesPagoCobroGridEffects,
    ConfiguracionCondicionesPagoCobroGridEffects,
    ConfiguracionCuentasBancariasGridEffects,
    ConfiguracionEjerciciosFiscalesGridEffects,
    ConfiguracionMonedasGridEffects,
    ConfiguracionRetencionesGridEffects,
    ConfiguracionUsuariosGridEffects,
  ],
})
export class ApartadoConfiguracionModule { }
