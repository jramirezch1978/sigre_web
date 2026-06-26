import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { BaseChartDirective } from 'ng2-charts';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatIconModule } from '@angular/material/icon';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';

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
import { AdminGruposUsuarioComponent } from './pages/admin-grupos-usuario/admin-grupos-usuario.component';
import { AdminVersionesComponent } from './pages/admin-versiones/admin-versiones.component';
import { AdminSucursalesComponent } from './pages/admin-sucursales/admin-sucursales.component';
import { AdminUsuarioSucursalesComponent } from './pages/admin-usuario-sucursales/admin-usuario-sucursales.component';
import { AdminLoginComponent } from './pages/admin-login/admin-login.component';
import { AdminPasswordRecoveryComponent } from './pages/admin-password-recovery/admin-password-recovery.component';
import { AdminCuentaComponent } from './pages/admin-cuenta/admin-cuenta.component';

@NgModule({
  declarations: [
    AdminLoginComponent,
    AdminPasswordRecoveryComponent,
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
    AdminGruposUsuarioComponent,
    AdminVersionesComponent,
    AdminSucursalesComponent,
    AdminUsuarioSucursalesComponent,
    AdminCuentaComponent,
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
    MatButtonModule,
    MatFormFieldModule,
    MatInputModule,
    MatIconModule,
    MatCheckboxModule,
    MatProgressSpinnerModule,
  ],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
})
export class AdminModule {}
