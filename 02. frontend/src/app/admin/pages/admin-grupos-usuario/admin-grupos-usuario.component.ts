import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { forkJoin } from 'rxjs';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from '@sigre-common';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { StorageService } from '../../../core/services/storage.service';
import { JwtClaimsReaderService } from '../../services/jwt-claims-reader.service';
import { GrupoUsuarioDto, GrupoUsuarioMiembroDto, UsuarioAdminDto } from '../../models/admin.models';

@Component({
  selector: 'app-admin-grupos-usuario',
  templateUrl: './admin-grupos-usuario.component.html',
  styleUrls: ['./admin-grupos-usuario.component.scss'],
  standalone: false,
})
export class AdminGruposUsuarioComponent implements OnInit {

  private readonly api = inject(AdminSeguridadApiService);
  private readonly fb = inject(FormBuilder);
  private readonly modalCtrl = inject(ModalController);
  private readonly storage = inject(StorageService);
  private readonly claims = inject(JwtClaimsReaderService);

  grupos: GrupoUsuarioDto[] = [];
  usuariosEmpresa: UsuarioAdminDto[] = [];
  miembros: GrupoUsuarioMiembroDto[] = [];
  loading = true;
  loadingMiembros = false;
  filtro = '';
  mostrandoForm = false;
  editandoId: number | null = null;
  usuarioIdAsignar: number | null = null;
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

  get gruposFiltrados(): GrupoUsuarioDto[] {
    if (!this.filtro.trim()) return this.grupos;
    const q = this.filtro.toLowerCase();
    return this.grupos.filter(g => g.codigo.toLowerCase().includes(q) || g.descripcion.toLowerCase().includes(q));
  }

  get usuariosDisponibles(): UsuarioAdminDto[] {
    const asignados = new Set(this.miembros.map(m => m.usuarioId));
    return this.usuariosEmpresa.filter(u => !asignados.has(u.id));
  }

  abrirCrear(): void {
    this.editandoId = null;
    this.form.reset({ codigo: '', descripcion: '', activo: true });
    this.miembros = [];
    this.usuarioIdAsignar = null;
    this.mostrandoForm = true;
  }

  abrirEditar(g: GrupoUsuarioDto): void {
    this.editandoId = g.id;
    this.form.patchValue(g);
    this.mostrandoForm = true;
    this.cargarMiembros();
  }

  cancelar(): void {
    this.mostrandoForm = false;
    this.editandoId = null;
    this.miembros = [];
    this.usuarioIdAsignar = null;
  }

  guardar(): void {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    const body = this.form.getRawValue();
    const obs = this.editandoId != null
      ? this.api.actualizarGrupoUsuario(this.empresaId, this.editandoId, body)
      : this.api.crearGrupoUsuario(this.empresaId, body);
    obs.subscribe({
      next: (resp) => {
        const guardado = resp.data;
        if (this.editandoId == null && guardado) {
          this.editandoId = guardado.id;
          this.form.patchValue(guardado);
          this.cargarMiembros();
        }
        this.cargarDatosIniciales();
        this.showSuccess(this.editandoId != null ? 'Grupo actualizado' : 'Grupo creado exitosamente');
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
    if (this.editandoId == null || !this.usuarioIdAsignar) return;
    this.api.asignarMiembroGrupo(this.empresaId, this.editandoId, { usuarioId: this.usuarioIdAsignar, activo: true }).subscribe({
      next: () => { this.usuarioIdAsignar = null; this.cargarMiembros(); },
      error: async (err: any) => { await this.showError(err?.error?.message ?? 'Error al asignar miembro'); },
    });
  }

  quitarMiembro(usuarioId: number): void {
    if (this.editandoId == null) return;
    this.api.quitarMiembroGrupo(this.empresaId, this.editandoId, usuarioId).subscribe({
      next: () => this.cargarMiembros(),
      error: async (err: any) => { await this.showError(err?.error?.message ?? 'Error al quitar miembro'); },
    });
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
