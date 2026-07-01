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

/**
 * Asignación de roles por usuario: acordeón agrupado por usuario (igual que
 * "Movimientos por almacén" del ERP) — cada usuario es un grupo colapsable;
 * al expandirlo se cargan (bajo demanda) sus roles asignados y el control
 * para agregar/quitar, sin salir de la lista.
 */
@Component({
  selector: 'app-admin-roles-usuario',
  templateUrl: './admin-roles-usuario.component.html',
  styleUrls: ['./admin-roles-usuario.component.scss'],
  standalone: false,
})
export class AdminRolesUsuarioComponent extends AdminTablaPageBase<UsuarioAdminDto> implements OnInit {
  // Tabla propia (acordeón); solo se reusa la paginación de la base.
  columnasTabla: TablaColumna[] = [];
  protected get registrosTabla(): UsuarioAdminDto[] { return this.usuariosFiltrados; }
  protected aFila(u: UsuarioAdminDto): Record<string, unknown> { return { id: u.id }; }

  private readonly api = inject(AdminSeguridadApiService);
  private readonly modalCtrl = inject(ModalController);
  private readonly storage = inject(StorageService);
  private readonly claims = inject(JwtClaimsReaderService);

  usuarios: UsuarioAdminDto[] = [];
  rolesEmpresa: RolDto[] = [];
  loading = true;
  filtro = '';

  /** Usuarios expandidos y sus roles, cargados bajo demanda al expandir. */
  abiertos = new Set<number>();
  rolesPorUsuario: Record<number, RolUsuarioDto[]> = {};
  loadingRolesPorUsuario: Record<number, boolean> = {};
  rolIdAsignarPorUsuario: Record<number, number | null> = {};

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

  toggle(usuario: UsuarioAdminDto): void {
    if (this.abiertos.has(usuario.id)) {
      this.abiertos.delete(usuario.id);
      return;
    }
    this.abiertos.add(usuario.id);
    if (!this.rolesPorUsuario[usuario.id]) {
      this.cargarRolesUsuario(usuario);
    }
  }

  estaAbierto(usuarioId: number): boolean {
    return this.abiertos.has(usuarioId);
  }

  cargarRolesUsuario(usuario: UsuarioAdminDto): void {
    if (!this.empresaId) return;
    this.loadingRolesPorUsuario[usuario.id] = true;
    this.api.listarRolesUsuario(this.empresaId, usuario.id).subscribe({
      next: r => {
        this.loadingRolesPorUsuario[usuario.id] = false;
        this.rolesPorUsuario[usuario.id] = r.data ?? [];
      },
      error: () => { this.loadingRolesPorUsuario[usuario.id] = false; },
    });
  }

  rolesDe(usuarioId: number): RolUsuarioDto[] {
    return this.rolesPorUsuario[usuarioId] ?? [];
  }

  rolesDisponiblesDe(usuarioId: number): RolDto[] {
    const asignados = new Set(this.rolesDe(usuarioId).map(ru => ru.rolId));
    return this.rolesEmpresa.filter(r => !asignados.has(r.id));
  }

  asignar(usuario: UsuarioAdminDto): void {
    const rolId = this.rolIdAsignarPorUsuario[usuario.id];
    if (!rolId) return;
    this.api.asignarRolUsuario(this.empresaId, usuario.id, { rolId, activo: true }).subscribe({
      next: () => {
        this.rolIdAsignarPorUsuario[usuario.id] = null;
        this.cargarRolesUsuario(usuario);
      },
      error: async (err: any) => { await this.error(err?.error?.message ?? 'Error al asignar rol'); },
    });
  }

  quitar(usuario: UsuarioAdminDto, rolId: number): void {
    this.api.quitarRolUsuario(this.empresaId, usuario.id, rolId).subscribe({
      next: () => this.cargarRolesUsuario(usuario),
      error: async (err: any) => { await this.error(err?.error?.message ?? 'Error al quitar rol'); },
    });
  }

  private async error(message: string): Promise<void> {
    const modal = await this.modalCtrl.create({ component: ModalConfirmationComponent, cssClass: 'promo',
      componentProps: { titlemodal: '', tipemodal: 'error', title: 'Error', message, btnOkTxt: 'Aceptar', mostrarCancelar: false } });
    await modal.present();
  }
}
