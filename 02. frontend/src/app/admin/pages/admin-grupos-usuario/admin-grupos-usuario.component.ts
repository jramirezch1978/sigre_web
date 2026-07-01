import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { forkJoin } from 'rxjs';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from '@sigre-common';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { StorageService } from '../../../core/services/storage.service';
import { JwtClaimsReaderService } from '../../services/jwt-claims-reader.service';
import { GrupoUsuarioDto, GrupoUsuarioMiembroDto, UsuarioAdminDto } from '../../models/admin.models';
import { TablaColumna } from '../../../erp/shared/models/api-page.model';
import { AdminTablaPageBase } from '../../shared/admin-tabla-page-base';

@Component({
  selector: 'app-admin-grupos-usuario',
  templateUrl: './admin-grupos-usuario.component.html',
  styleUrls: ['./admin-grupos-usuario.component.scss'],
  standalone: false,
})
export class AdminGruposUsuarioComponent extends AdminTablaPageBase<GrupoUsuarioDto> implements OnInit {

  private readonly api = inject(AdminSeguridadApiService);
  private readonly fb = inject(FormBuilder);
  private readonly modalCtrl = inject(ModalController);
  private readonly storage = inject(StorageService);
  private readonly claims = inject(JwtClaimsReaderService);

  grupos: GrupoUsuarioDto[] = [];
  usuariosEmpresa: UsuarioAdminDto[] = [];
  miembros: GrupoUsuarioMiembroDto[] = [];
  /** Miembros seleccionados durante la creación, antes de que el grupo exista. */
  miembrosPendientes: UsuarioAdminDto[] = [];
  loading = true;
  loadingMiembros = false;
  filtro = '';
  mostrandoForm = false;
  editandoId: number | null = null;
  /** Selección múltiple del combo "Agregar miembro". */
  usuariosIdsAsignar: number[] = [];
  form!: FormGroup;

  get empresaId(): number {
    const token = this.storage.getToken();
    return token ? (this.claims.getEmpresaId(token) ?? 0) : 0;
  }

  ngOnInit(): void {
    this.form = this.fb.group({
      codigo: ['', [Validators.required, Validators.maxLength(80)]],
      descripcion: ['', [Validators.required, Validators.maxLength(220)]],
      activo: [true],
    });
    this.cargarDatosIniciales();
  }

  private cargarDatosIniciales(): void {
    if (!this.empresaId) { this.loading = false; return; }
    this.loading = true;
    forkJoin({
      grupos: this.api.listarGruposUsuario(this.empresaId),
      usuarios: this.api.listarUsuariosDeEmpresa(this.empresaId),
    }).subscribe({
      next: ({ grupos, usuarios }) => {
        this.loading = false;
        this.grupos = grupos.data ?? [];
        this.usuariosEmpresa = usuarios.data ?? [];
      },
      error: () => { this.loading = false; },
    });
  }

  protected override get todosLosRegistros(): GrupoUsuarioDto[] { return this.grupos; }

  get gruposFiltrados(): GrupoUsuarioDto[] {
    let lista = this.grupos;
    if (this.filtro.trim()) {
      const q = this.filtro.toLowerCase();
      lista = lista.filter(g => g.codigo.toLowerCase().includes(q) || g.descripcion.toLowerCase().includes(q));
    }
    return this.filtrarPorEstado(lista);
  }

  readonly columnasTabla: TablaColumna[] = [
    { key: 'id', header: 'ID', width: '70px' },
    { key: 'codigo', header: 'Código', width: '180px' },
    { key: 'descripcion', header: 'Descripción', width: '300px' },
    { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
  ];

  protected get registrosTabla(): GrupoUsuarioDto[] { return this.gruposFiltrados; }
  protected aFila(g: GrupoUsuarioDto): Record<string, unknown> {
    return { id: g.id, codigo: g.codigo, descripcion: g.descripcion, flagEstado: g.activo ? '1' : '0' };
  }
  protected override editarRegistro(g: GrupoUsuarioDto): void { this.abrirEditar(g); }

  get usuariosDisponibles(): UsuarioAdminDto[] {
    const asignados = new Set<number>(this.miembros.map(m => m.usuarioId));
    for (const p of this.miembrosPendientes) {
      asignados.add(p.id);
    }
    return this.usuariosEmpresa.filter(u => !asignados.has(u.id));
  }

  abrirCrear(): void {
    this.editandoId = null;
    this.form.reset({ codigo: '', descripcion: '', activo: true });
    this.miembros = [];
    this.miembrosPendientes = [];
    this.usuariosIdsAsignar = [];
    this.mostrandoForm = true;
  }

  abrirEditar(g: GrupoUsuarioDto): void {
    this.editandoId = g.id;
    this.form.patchValue(g);
    this.miembrosPendientes = [];
    this.usuariosIdsAsignar = [];
    this.mostrandoForm = true;
    this.cargarMiembros();
  }

  cancelar(): void {
    this.mostrandoForm = false;
    this.editandoId = null;
    this.miembros = [];
    this.miembrosPendientes = [];
    this.usuariosIdsAsignar = [];
  }

  guardar(): void {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    const body = this.form.getRawValue();

    // Edición: solo actualiza la cabecera (los miembros se gestionan en vivo).
    if (this.editandoId != null) {
      this.api.actualizarGrupoUsuario(this.empresaId, this.editandoId, body).subscribe({
        next: () => { this.cargarDatosIniciales(); this.showSuccess('Grupo actualizado'); },
        error: async (err: any) => { await this.showError(err?.error?.message ?? 'Error al guardar'); },
      });
      return;
    }

    // Creación: cabecera + detalle en una sola operación atómica (no se permiten grupos vacíos).
    if (this.miembrosPendientes.length === 0) {
      void this.showError('Debe agregar al menos un miembro al grupo antes de guardar.');
      return;
    }
    const total = this.miembrosPendientes.length;
    const payload = { ...body, miembrosIds: this.miembrosPendientes.map(u => u.id) };
    this.api.crearGrupoUsuario(this.empresaId, payload).subscribe({
      next: () => {
        this.cargarDatosIniciales();
        this.cancelar();
        this.showSuccess(`Grupo creado con ${total} miembro(s)`);
      },
      error: async (err: any) => { await this.showError(err?.error?.message ?? 'Error al guardar'); },
    });
  }

  cargarMiembros(): void {
    if (this.editandoId == null) return;
    this.loadingMiembros = true;
    this.api.listarMiembrosGrupo(this.empresaId, this.editandoId).subscribe({
      next: r => { this.loadingMiembros = false; this.miembros = r.data ?? []; },
      error: () => { this.loadingMiembros = false; },
    });
  }

  asignarMiembro(): void {
    const ids = this.usuariosIdsAsignar ?? [];
    if (ids.length === 0) return;

    // Modo creación: el grupo aún no existe → guardar en pendientes (se persisten al Guardar).
    if (this.editandoId == null) {
      for (const id of ids) {
        const u = this.usuariosEmpresa.find(x => x.id === id);
        if (u && !this.miembrosPendientes.some(p => p.id === u.id)) {
          this.miembrosPendientes = [...this.miembrosPendientes, u];
        }
      }
      this.usuariosIdsAsignar = [];
      return;
    }

    // Modo edición: asigna todos los seleccionados contra el backend.
    const grupoId = this.editandoId;
    const calls = ids.map(id => this.api.asignarMiembroGrupo(this.empresaId, grupoId, { usuarioId: id, activo: true }));
    forkJoin(calls).subscribe({
      next: () => { this.usuariosIdsAsignar = []; this.cargarMiembros(); },
      error: async (err: any) => { this.cargarMiembros(); await this.showError(err?.error?.message ?? 'Error al asignar miembros'); },
    });
  }

  quitarMiembro(usuarioId: number): void {
    if (this.editandoId == null) return;
    if (this.miembros.length <= 1) {
      void this.showError('Un grupo debe tener al menos un miembro. Agregue otro antes de quitar este.');
      return;
    }
    this.api.quitarMiembroGrupo(this.empresaId, this.editandoId, usuarioId).subscribe({
      next: () => this.cargarMiembros(),
      error: async (err: any) => { await this.showError(err?.error?.message ?? 'Error al quitar miembro'); },
    });
  }

  quitarMiembroPendiente(usuarioId: number): void {
    this.miembrosPendientes = this.miembrosPendientes.filter(p => p.id !== usuarioId);
  }

  private async showError(message: string): Promise<void> {
    const modal = await this.modalCtrl.create({
      component: ModalConfirmationComponent, cssClass: 'promo',
      componentProps: { titlemodal: '', tipemodal: 'error', title: 'Error', message, btnOkTxt: 'Aceptar', mostrarCancelar: false },
    });
    await modal.present();
  }

  private async showSuccess(message: string): Promise<void> {
    const modal = await this.modalCtrl.create({
      component: ModalConfirmationComponent, cssClass: 'promo',
      componentProps: { titlemodal: '', tipemodal: 'success', title: 'Éxito', message, btnOkTxt: 'Aceptar', mostrarCancelar: false },
    });
    await modal.present();
  }
}
