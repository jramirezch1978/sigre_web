import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { FTGestionGruposComponent } from '../finanzas/m-f-tabla/components/f-t-gestion-grupos/f-t-gestion-grupos.component';
import { CanDeactivateGuard } from 'src/app/auth/guards/can-deactivate.guard';
import { CADatosGeneralesComponent } from './ajustes/c-a-datos-generales/c-a-datos-generales.component';
import { CComCompaniasSucursalesTransaccionesComponent } from './companias/c-com-companias-sucursales-transacciones/c-com-companias-sucursales-transacciones.component';
import { ALCuentaBancariaComponent } from './localizacion/pages/a-l-cuenta-bancaria/a-l-cuenta-bancaria.component';
import { ALCanalPagoCobroComponent } from './localizacion/pages/a-l-canal-pago-cobro/a-l-canal-pago-cobro.component';
import { ALCondicionesPagoCobroComponent } from './localizacion/pages/a-l-condiciones-pago-cobro/a-l-condiciones-pago-cobro.component';
import { ALMonedasComponent } from './localizacion/pages/a-l-monedas/a-l-monedas.component';
import { ALFormasPagoComponent } from './localizacion/pages/a-l-formas-pago/a-l-formas-pago.component';
import { ALMediosPagoComponent } from './localizacion/pages/a-l-medios-pago/a-l-medios-pago.component';
import { ALEjerciciosYPeriodosComponent } from './localizacion/pages/a-l-ejercicios-y-periodos/a-l-ejercicios-y-periodos.component';
import { ALRetencionesComponent } from './localizacion/pages/a-l-retenciones/a-l-retenciones.component';
import { ALUsuariosComponent } from './localizacion/pages/a-l-usuarios/a-l-usuarios.component';
import { CANotifiacionAsignacionActivosComponent } from './ajustes/c-a-notifiacion-asignacion-activos/c-a-notifiacion-asignacion-activos.component';

const routes: Routes = [
  {
    path: 'localizacion/retenciones',
    component: ALRetencionesComponent,
  },
  {
    path: 'localizacion/monedas',
    component: ALMonedasComponent,
  },
  {
    path: 'localizacion/ejercicios-periodos',
    component: ALEjerciciosYPeriodosComponent,
  },
  {
    path: 'localizacion/cuenta-bancaria',
    component: ALCuentaBancariaComponent,
  },
  {
    path: 'localizacion/gestion-grupos',
    component: FTGestionGruposComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'localizacion/canal-pago-cobro',
    component: ALCanalPagoCobroComponent,
  },
  {
    path: 'localizacion/condiciones-pago-cobro',
    component: ALCondicionesPagoCobroComponent,
  },
  {
    path: 'localizacion/formas-pago',
    component: ALFormasPagoComponent,
  },
  {
    path: 'localizacion/medios-pago',
    component: ALMediosPagoComponent,
  },
  {
    path: 'localizacion/usuarios',
    component: ALUsuariosComponent,
  },
  {
    path: 'ajustes/datos-generales',
    component: CADatosGeneralesComponent,
  },
  {
    path: 'ajustes/notificacion-asignacion-activos',
    component: CANotifiacionAsignacionActivosComponent,
  },
  {
    path: 'companias/sucursales-transacciones',
    component: CComCompaniasSucursalesTransaccionesComponent,
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ApartadoConfiguracionRoutingModule { }
