import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
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
import { AdminLoginComponent } from './pages/admin-login/admin-login.component';
import { AdminCuentaComponent } from './pages/admin-cuenta/admin-cuenta.component';
import { adminZoneGuard } from './guards/admin-zone.guard';
import { adminLoginGuard } from './guards/admin-login.guard';
import { adminOperativeSessionGuard } from './guards/admin-operative-session.guard';
import { adminProvisioningSessionGuard } from './guards/admin-provisioning-session.guard';

const routes: Routes = [
  {
    path: 'login',
    component: AdminLoginComponent,
    canActivate: [adminLoginGuard],
  },
  {
    path: '',
    component: AdminShellComponent,
    canActivate: [adminZoneGuard],
    children: [
      { path: '', pathMatch: 'full', redirectTo: 'inicio' },
      { path: 'inicio', component: AdminDashboardComponent, canActivate: [adminOperativeSessionGuard] },
      { path: 'empresas', component: AdminEmpresasComponent, canActivate: [adminZoneGuard] },
      { path: 'empresas/nueva', component: AdminEmpresaProvisionComponent, canActivate: [adminProvisioningSessionGuard] },
      { path: 'modulos', component: AdminModulosComponent, canActivate: [adminOperativeSessionGuard] },
      { path: 'opciones-menu', component: AdminOpcionesMenuComponent, canActivate: [adminOperativeSessionGuard] },
      { path: 'acciones', component: AdminAccionesComponent, canActivate: [adminOperativeSessionGuard] },
      { path: 'roles', component: AdminRolesComponent, canActivate: [adminOperativeSessionGuard] },
      { path: 'asignar-acciones-rol', redirectTo: 'roles', pathMatch: 'full' },
      { path: 'usuarios', component: AdminUsuariosComponent, canActivate: [adminOperativeSessionGuard] },
      { path: 'roles-usuario', component: AdminRolesUsuarioComponent, canActivate: [adminOperativeSessionGuard] },
      { path: 'sucursales', component: AdminSucursalesComponent, canActivate: [adminZoneGuard] },
      { path: 'usuarios-sucursales', component: AdminUsuarioSucursalesComponent, canActivate: [adminZoneGuard] },
      {
        path: 'perfil',
        component: AdminCuentaComponent,
        canActivate: [adminOperativeSessionGuard],
        data: {
          titulo: 'Mi perfil',
          descripcion: 'Consulta y edición de datos personales. Disponible en una próxima versión.',
        },
      },
      {
        path: 'preferencias',
        component: AdminCuentaComponent,
        canActivate: [adminOperativeSessionGuard],
        data: {
          titulo: 'Preferencias',
          descripcion: 'Configuración de idioma, notificaciones y apariencia. Disponible en una próxima versión.',
        },
      },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class AdminRoutingModule {}
