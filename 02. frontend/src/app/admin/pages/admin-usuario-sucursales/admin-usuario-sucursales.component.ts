import { Component, OnInit, inject } from '@angular/core';
import { finalize, switchMap, tap } from 'rxjs/operators';
import { forkJoin, of } from 'rxjs';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from '@sigre-common';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { AdminCoreMaestrosApiService } from '../../services/admin-core-maestros-api.service';
import { EmpresaAdminDto, UsuarioAdminDto } from '../../models/admin.models';
import { SucursalCatalogoDto } from '../../models/admin-core-maestros.models';

@Component({
  selector: 'app-admin-usuario-sucursales',
  templateUrl: './admin-usuario-sucursales.component.html',
  styleUrls: ['./admin-usuario-sucursales.component.scss'],
  standalone: false,
})
export class AdminUsuarioSucursalesComponent implements OnInit {

  private readonly seguridadApi = inject(AdminSeguridadApiService);
  private readonly coreApi = inject(AdminCoreMaestrosApiService);
  private readonly modalCtrl = inject(ModalController);

  empresas: EmpresaAdminDto[] = [];
  loadingEmpresas = true;
  filtroEmpresa = '';

  empresaSeleccionada: EmpresaAdminDto | null = null;
  usuarios: UsuarioAdminDto[] = [];
  catalogo: SucursalCatalogoDto[] = [];
  loadingUsuarios = false;
  filtroUsuario = '';

  usuarioSeleccionado: UsuarioAdminDto | null = null;
  asignadas: SucursalCatalogoDto[] = [];
  loadingSucursales = false;
  sucursalIdAsignar: number | null = null;

  ngOnInit(): void {
    this.cargarEmpresas();
  }

  // ── Paso 1: empresas ──

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

  seleccionarEmpresa(e: EmpresaAdminDto): void {
    this.empresaSeleccionada = e;
    this.filtroUsuario = '';
    this.usuarioSeleccionado = null;
    this.asignadas = [];
    this.cargarUsuariosYCatalogo();
  }

  volverAEmpresas(): void {
    this.empresaSeleccionada = null;
    this.usuarios = [];
    this.catalogo = [];
    this.usuarioSeleccionado = null;
    this.asignadas = [];
  }

  // ── Paso 2: usuarios de la empresa ──

  cargarUsuariosYCatalogo(): void {
    if (!this.empresaSeleccionada) return;
    const eid = this.empresaSeleccionada.id;
    this.loadingUsuarios = true;
    forkJoin({
      usuarios: this.seguridadApi.listarUsuariosDeEmpresa(eid),
      catalogo: this.coreApi.listarSucursalesEmpresa(eid),
    }).subscribe({
      next: ({ usuarios, catalogo }) => {
        this.loadingUsuarios = false;
        this.usuarios = usuarios.data ?? [];
        this.catalogo = catalogo.data ?? [];
      },
      error: async err => {
        this.loadingUsuarios = false;
        await this.mostrarError(err?.error?.message ?? 'No se pudieron cargar usuarios o catálogo.');
      },
    });
  }

  get usuariosFiltrados(): UsuarioAdminDto[] {
    if (!this.filtroUsuario.trim()) return this.usuarios;
    const q = this.filtroUsuario.toLowerCase();
    return this.usuarios.filter(u =>
      u.nombreCompleto.toLowerCase().includes(q)
      || u.username.toLowerCase().includes(q)
    );
  }

  seleccionarUsuario(u: UsuarioAdminDto): void {
    this.usuarioSeleccionado = u;
    this.cargarAsignadas();
  }

  volverAUsuarios(): void {
    this.usuarioSeleccionado = null;
    this.asignadas = [];
  }

  // ── Paso 3: sucursales del usuario ──

  cargarAsignadas(): void {
    if (!this.usuarioSeleccionado || !this.empresaSeleccionada) return;
    const eid = this.empresaSeleccionada.id;
    this.loadingSucursales = true;
    this.coreApi
      .listarSucursalesAsignadasUsuario(eid, this.usuarioSeleccionado.id)
      .pipe(finalize(() => { this.loadingSucursales = false; }))
      .subscribe({
        next: r => { this.asignadas = r.data ?? []; },
        error: async err => {
          await this.mostrarError(err?.error?.message ?? 'Error al cargar sucursales asignadas.');
        },
      });
  }

  get sucursalesDisponibles(): SucursalCatalogoDto[] {
    const ids = new Set(this.asignadas.map(s => s.id));
    return this.catalogo.filter(s => !ids.has(s.id));
  }

  asignar(): void {
    if (!this.sucursalIdAsignar || !this.usuarioSeleccionado || !this.empresaSeleccionada) return;
    const eid = this.empresaSeleccionada.id;
    const uid = this.usuarioSeleccionado.id;
    this.coreApi
      .asignarUsuarioSucursal(eid, uid, this.sucursalIdAsignar)
      .pipe(
        tap(() => { this.sucursalIdAsignar = null; }),
        switchMap(() => this.coreApi.listarSucursalesAsignadasUsuario(eid, uid))
      )
      .subscribe({
        next: r => { this.asignadas = r.data ?? []; },
        error: async err => {
          await this.mostrarError(err?.error?.message ?? 'Error al asignar sucursal.');
        },
      });
  }

  retirar(sucursalId: number): void {
    if (!this.usuarioSeleccionado || !this.empresaSeleccionada) return;
    const eid = this.empresaSeleccionada.id;
    const uid = this.usuarioSeleccionado.id;
    this.coreApi
      .retirarUsuarioSucursal(eid, uid, sucursalId)
      .pipe(switchMap(() => this.coreApi.listarSucursalesAsignadasUsuario(eid, uid)))
      .subscribe({
        next: r => { this.asignadas = r.data ?? []; },
        error: async err => {
          await this.mostrarError(err?.error?.message ?? 'Error al retirar sucursal.');
        },
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
