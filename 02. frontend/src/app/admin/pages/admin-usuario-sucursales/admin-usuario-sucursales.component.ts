import { Component, OnInit, inject } from '@angular/core';
import { switchMap, tap } from 'rxjs/operators';
import { forkJoin } from 'rxjs';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from '@sigre-common';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { AdminCoreMaestrosApiService } from '../../services/admin-core-maestros-api.service';
import { EmpresaAdminDto, UsuarioAdminDto } from '../../models/admin.models';
import { SucursalCatalogoDto } from '../../models/admin-core-maestros.models';
import { TablaColumna } from '../../../erp/shared/models/api-page.model';
import { AdminTablaPageBase } from '../../shared/admin-tabla-page-base';

/**
 * Usuarios y sucursales: acordeón anidado (mismo patrón que "Movimientos
 * por almacén" del ERP) — empresa (nivel 1) → usuario (nivel 2), y dentro
 * del usuario expandido se asignan/retiran sucursales, todo cargado bajo
 * demanda y sin salir de la lista.
 */
@Component({
  selector: 'app-admin-usuario-sucursales',
  templateUrl: './admin-usuario-sucursales.component.html',
  styleUrls: ['./admin-usuario-sucursales.component.scss'],
  standalone: false,
})
export class AdminUsuarioSucursalesComponent extends AdminTablaPageBase<EmpresaAdminDto> implements OnInit {
  // Tabla propia (acordeón); solo se reusa la paginación de la base.
  columnasTabla: TablaColumna[] = [];
  protected get registrosTabla(): EmpresaAdminDto[] { return this.empresasFiltradas; }
  protected aFila(e: EmpresaAdminDto): Record<string, unknown> { return { id: e.id }; }

  private readonly seguridadApi = inject(AdminSeguridadApiService);
  private readonly coreApi = inject(AdminCoreMaestrosApiService);
  private readonly modalCtrl = inject(ModalController);

  empresas: EmpresaAdminDto[] = [];
  loadingEmpresas = true;
  filtroEmpresa = '';

  // ── Nivel 1: empresas expandidas ──
  abiertosEmpresa = new Set<number>();
  usuariosPorEmpresa: Record<number, UsuarioAdminDto[]> = {};
  catalogoPorEmpresa: Record<number, SucursalCatalogoDto[]> = {};
  loadingUsuariosPorEmpresa: Record<number, boolean> = {};
  filtroUsuarioPorEmpresa: Record<number, string> = {};

  // ── Nivel 2: usuarios expandidos ──
  abiertosUsuario = new Set<number>();
  asignadasPorUsuario: Record<number, SucursalCatalogoDto[]> = {};
  loadingAsignadasPorUsuario: Record<number, boolean> = {};
  sucursalIdAsignarPorUsuario: Record<number, number | null> = {};

  ngOnInit(): void {
    this.cargarEmpresas();
  }

  cargarEmpresas(): void {
    this.loadingEmpresas = true;
    this.seguridadApi.listarEmpresas().subscribe({
      next: res => {
        this.loadingEmpresas = false;
        this.empresas = (res.data ?? []).filter(e => e.activo);
      },
      error: () => { this.loadingEmpresas = false; },
    });
  }

  get empresasFiltradas(): EmpresaAdminDto[] {
    if (!this.filtroEmpresa.trim()) return this.empresas;
    const q = this.filtroEmpresa.toLowerCase();
    return this.empresas.filter(e =>
      e.razonSocial?.toLowerCase().includes(q)
      || e.ruc?.toLowerCase().includes(q)
      || e.codigo?.toLowerCase().includes(q)
    );
  }

  toggleEmpresa(empresa: EmpresaAdminDto): void {
    if (this.abiertosEmpresa.has(empresa.id)) {
      this.abiertosEmpresa.delete(empresa.id);
      return;
    }
    this.abiertosEmpresa.add(empresa.id);
    if (!this.usuariosPorEmpresa[empresa.id]) {
      this.cargarUsuariosYCatalogo(empresa);
    }
  }

  empresaAbierta(empresaId: number): boolean {
    return this.abiertosEmpresa.has(empresaId);
  }

  cargarUsuariosYCatalogo(empresa: EmpresaAdminDto): void {
    this.loadingUsuariosPorEmpresa[empresa.id] = true;
    forkJoin({
      usuarios: this.seguridadApi.listarUsuariosDeEmpresa(empresa.id),
      catalogo: this.coreApi.listarSucursalesEmpresa(empresa.id),
    }).subscribe({
      next: ({ usuarios, catalogo }) => {
        this.loadingUsuariosPorEmpresa[empresa.id] = false;
        this.usuariosPorEmpresa[empresa.id] = usuarios.data ?? [];
        this.catalogoPorEmpresa[empresa.id] = catalogo.data ?? [];
      },
      error: async err => {
        this.loadingUsuariosPorEmpresa[empresa.id] = false;
        await this.mostrarError(err?.error?.message ?? 'No se pudieron cargar usuarios o catálogo.');
      },
    });
  }

  usuariosFiltradosDe(empresaId: number): UsuarioAdminDto[] {
    const lista = this.usuariosPorEmpresa[empresaId] ?? [];
    const filtro = (this.filtroUsuarioPorEmpresa[empresaId] ?? '').trim().toLowerCase();
    if (!filtro) return lista;
    return lista.filter(u =>
      u.nombreCompleto.toLowerCase().includes(filtro) || u.username.toLowerCase().includes(filtro));
  }

  toggleUsuario(empresa: EmpresaAdminDto, usuario: UsuarioAdminDto): void {
    if (this.abiertosUsuario.has(usuario.id)) {
      this.abiertosUsuario.delete(usuario.id);
      return;
    }
    this.abiertosUsuario.add(usuario.id);
    if (!this.asignadasPorUsuario[usuario.id]) {
      this.cargarAsignadas(empresa, usuario);
    }
  }

  usuarioAbierto(usuarioId: number): boolean {
    return this.abiertosUsuario.has(usuarioId);
  }

  cargarAsignadas(empresa: EmpresaAdminDto, usuario: UsuarioAdminDto): void {
    this.loadingAsignadasPorUsuario[usuario.id] = true;
    this.coreApi.listarSucursalesAsignadasUsuario(empresa.id, usuario.id).subscribe({
      next: r => {
        this.loadingAsignadasPorUsuario[usuario.id] = false;
        this.asignadasPorUsuario[usuario.id] = r.data ?? [];
      },
      error: async err => {
        this.loadingAsignadasPorUsuario[usuario.id] = false;
        await this.mostrarError(err?.error?.message ?? 'Error al cargar sucursales asignadas.');
      },
    });
  }

  asignadasDe(usuarioId: number): SucursalCatalogoDto[] {
    return this.asignadasPorUsuario[usuarioId] ?? [];
  }

  sucursalesDisponiblesDe(empresaId: number, usuarioId: number): SucursalCatalogoDto[] {
    const ids = new Set(this.asignadasDe(usuarioId).map(s => s.id));
    return (this.catalogoPorEmpresa[empresaId] ?? []).filter(s => !ids.has(s.id));
  }

  asignar(empresa: EmpresaAdminDto, usuario: UsuarioAdminDto): void {
    const sucursalId = this.sucursalIdAsignarPorUsuario[usuario.id];
    if (!sucursalId) return;
    this.coreApi
      .asignarUsuarioSucursal(empresa.id, usuario.id, sucursalId)
      .pipe(
        tap(() => { this.sucursalIdAsignarPorUsuario[usuario.id] = null; }),
        switchMap(() => this.coreApi.listarSucursalesAsignadasUsuario(empresa.id, usuario.id)),
      )
      .subscribe({
        next: r => { this.asignadasPorUsuario[usuario.id] = r.data ?? []; },
        error: async err => { await this.mostrarError(err?.error?.message ?? 'Error al asignar sucursal.'); },
      });
  }

  retirar(empresa: EmpresaAdminDto, usuario: UsuarioAdminDto, sucursalId: number): void {
    this.coreApi
      .retirarUsuarioSucursal(empresa.id, usuario.id, sucursalId)
      .pipe(switchMap(() => this.coreApi.listarSucursalesAsignadasUsuario(empresa.id, usuario.id)))
      .subscribe({
        next: r => { this.asignadasPorUsuario[usuario.id] = r.data ?? []; },
        error: async err => { await this.mostrarError(err?.error?.message ?? 'Error al retirar sucursal.'); },
      });
  }

  private async mostrarError(message: string): Promise<void> {
    const modal = await this.modalCtrl.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: '', tipemodal: 'error', title: 'Error',
        message, btnOkTxt: 'Aceptar', mostrarCancelar: false,
      },
    });
    await modal.present();
  }
}
