import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { BaseChartDirective } from 'ng2-charts';

import { AdminRoutingModule } from './admin-routing.module';
import { AdminUiModule } from '../ui/admin-ui.module';

import { AdminShellComponent } from './components/admin-shell/admin-shell.component';
import { AdminDashboardComponent } from './pages/admin-dashboard/admin-dashboard.component';
import { AdminEmpresasComponent } from './pages/admin-empresas/admin-empresas.component';
import { AdminEmpresaProvisionComponent } from './pages/admin-empresa-provision/admin-empresa-provision.component';
import { AdminModulosComponent } from './pages/admin-modulos/admin-modulos.component';
import { AdminOpcionesMenuComponent } from './pages/admin-opciones-menu/admin-opciones-menu.component';
import { AdminAccionesComponent } from './pages/admin-acciones/admin-acciones.component';
import { AdminRolesComponent } from './pages/admin-roles/admin-roles.component';
import { AdminUsuariosComponent } from './pages/admin-usuarios/admin-usuarios.component';
import { AdminRolesUsuarioComponent } from './pages/admin-roles-usuario/admin-roles-usuario.component';
import { AdminSucursalesComponent } from './pages/admin-sucursales/admin-sucursales.component';
import { AdminUsuarioSucursalesComponent } from './pages/admin-usuario-sucursales/admin-usuario-sucursales.component';

@NgModule({
  declarations: [
    AdminShellComponent,
    AdminDashboardComponent,
    AdminEmpresasComponent,
    AdminEmpresaProvisionComponent,
    AdminModulosComponent,
    AdminOpcionesMenuComponent,
    AdminAccionesComponent,
    AdminRolesComponent,
    AdminUsuariosComponent,
    AdminRolesUsuarioComponent,
    AdminSucursalesComponent,
    AdminUsuarioSucursalesComponent,
  ],
  imports: [
    CommonModule,
    IonicModule,
    RouterModule,
    FormsModule,
    ReactiveFormsModule,
    AdminRoutingModule,
    AdminUiModule,
    BaseChartDirective,
  ],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
})
export class AdminModule {}
