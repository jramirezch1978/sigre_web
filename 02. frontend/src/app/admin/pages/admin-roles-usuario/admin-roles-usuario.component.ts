import { Component, OnInit, inject } from '@angular/core';
import { forkJoin } from 'rxjs';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from '@sigre-common';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { StorageService } from '../../../core/services/storage.service';
import { JwtClaimsReaderService } from '../../services/jwt-claims-reader.service';
import { UsuarioAdminDto, RolDto, RolUsuarioDto } from '../../models/admin.models';
import { TablaColumna } from '../../../erp/shared/models/api-page.model';
import { AdminTablaPageBase } from '../../shared/admin-tabla-page-base';

@Component({
  selector: 'app-admin-roles-usuario',
  templateUrl: './admin-roles-usuario.component.html',
  styleUrls: ['./admin-roles-usuario.component.scss'],
  standalone: false,
})
export class AdminRolesUsuarioComponent extends AdminTablaPageBase<UsuarioAdminDto> implements OnInit {
  // Tabla propia (selector de usuario); solo se reusa la paginación de la base.
  columnasTabla: TablaColumna[] = [];
  protected get registrosTabla(): UsuarioAdminDto[] { return this.usuariosFiltrados; }
  protected aFila(u: UsuarioAdminDto): Record<string, unknown> { return { id: u.id }; }

  private readonly api = inject(AdminSeguridadApiService);
  private readonly modalCtrl = inject(ModalController);
  private readonly storage = inject(StorageService);
  private readonly claims = inject(JwtClaimsReaderService);

  usuarios: UsuarioAdminDto[] = [];
  rolesEmpresa: RolDto[] = [];
  rolesUsuario: RolUsuarioDto[] = [];
  usuarioSeleccionado: UsuarioAdminDto | null = null;
  loading = true;
  loadingRoles = false;
  filtro = '';
  rolIdAsignar: number | null = null;

  private get empresaId(): number {
    const token = this.storage.getToken();
    return token ? (this.claims.getEmpresaId(token) ?? 0) : 0;
  }

  ngOnInit(): void {
    if (this.empresaId) {
      forkJoin({
        usuarios: this.api.listarUsuarios(),
        roles: this.api.listarRoles(this.empresaId),
      }).subscribe({
        next: ({ usuarios, roles }) => {
          this.loading = false;
          this.usuarios = usuarios.data ?? [];
          this.rolesEmpresa = roles.data ?? [];
        },
        error: async err => {
          this.loading = false;
          await this.error(err?.error?.message ?? 'No se pudo cargar usuarios y roles de la empresa.');
        },
      });
    } else {
      this.api.listarUsuarios().subscribe({
        next: r => { this.loading = false; this.usuarios = r.data ?? []; },
        error: () => { this.loading = false; },
      });
    }
  }

  get usuariosFiltrados(): UsuarioAdminDto[] {
    if (!this.filtro.trim()) return this.usuarios;
    const q = this.filtro.toLowerCase();
    return this.usuarios.filter(u => u.nombreCompleto.toLowerCase().includes(q) || u.username.toLowerCase().includes(q));
  }

  seleccionarUsuario(u: UsuarioAdminDto): void {
    this.usuarioSeleccionado = u;
    this.cargarRolesUsuario();
  }

  cargarRolesUsuario(): void {
    if (!this.usuarioSeleccionado || !this.empresaId) return;
    this.loadingRoles = true;
    this.api.listarRolesUsuario(this.empresaId, this.usuarioSeleccionado.id).subscribe({
      next: r => { this.loadingRoles = false; this.rolesUsuario = r.data ?? []; },
      error: () => { this.loadingRoles = false; },
    });
  }

  get rolesDisponibles(): RolDto[] {
    const asignados = new Set(this.rolesUsuario.map(ru => ru.rolId));
    return this.rolesEmpresa.filter(r => !asignados.has(r.id));
  }

  asignar(): void {
    if (!this.rolIdAsignar || !this.usuarioSeleccionado) return;
    this.api.asignarRolUsuario(this.empresaId, this.usuarioSeleccionado.id, { rolId: this.rolIdAsignar, activo: true }).subscribe({
      next: () => { this.rolIdAsignar = null; this.cargarRolesUsuario(); },
      error: async (err: any) => { await this.error(err?.error?.message ?? 'Error al asignar rol'); },
    });
  }

  quitar(rolId: number): void {
    if (!this.usuarioSeleccionado) return;
    this.api.quitarRolUsuario(this.empresaId, this.usuarioSeleccionado.id, rolId).subscribe({
      next: () => this.cargarRolesUsuario(),
      error: async (err: any) => { await this.error(err?.error?.message ?? 'Error al quitar rol'); },
    });
  }

  volver(): void { this.usuarioSeleccionado = null; this.rolesUsuario = []; this.paginaActual = 1; }

  private async error(message: string): Promise<void> {
    const modal = await this.modalCtrl.create({ component: ModalConfirmationComponent, cssClass: 'promo',
      componentProps: { titlemodal: '', tipemodal: 'error', title: 'Error', message, btnOkTxt: 'Aceptar', mostrarCancelar: false } });
    await modal.present();
  }
}
