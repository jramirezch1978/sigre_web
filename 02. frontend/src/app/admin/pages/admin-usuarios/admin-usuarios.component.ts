import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from '@sigre-common';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { UsuarioAdminDto } from '../../models/admin.models';
import { TablaColumna } from '../../../erp/shared/models/api-page.model';
import { AdminTablaPageBase } from '../../shared/admin-tabla-page-base';

@Component({
  selector: 'app-admin-usuarios',
  templateUrl: './admin-usuarios.component.html',
  styleUrls: ['./admin-usuarios.component.scss'],
  standalone: false,
})
export class AdminUsuariosComponent extends AdminTablaPageBase<UsuarioAdminDto> implements OnInit {

  private readonly api = inject(AdminSeguridadApiService);
  private readonly fb = inject(FormBuilder);
  private readonly modalCtrl = inject(ModalController);

  usuarios: UsuarioAdminDto[] = [];
  loading = true;
  filtro = '';
  mostrandoForm = false;
  editandoId: number | null = null;
  formCrear!: FormGroup;
  formEditar!: FormGroup;

  ngOnInit(): void {
    this.formCrear = this.fb.group({
      email: ['', [Validators.required, Validators.email, Validators.maxLength(150)]],
      username: ['', [Validators.required, Validators.maxLength(50)]],
      password: ['', [Validators.required, Validators.minLength(6)]],
      nombres: ['', [Validators.required, Validators.maxLength(100)]],
      apellidos: ['', [Validators.required, Validators.maxLength(100)]],
      flagAdminSistema: [false],
      tipoSales: [''],
    });
    this.formEditar = this.fb.group({
      email: ['', [Validators.required, Validators.email, Validators.maxLength(150)]],
      username: ['', [Validators.required, Validators.maxLength(50)]],
      nombres: ['', [Validators.required, Validators.maxLength(100)]],
      apellidos: ['', [Validators.required, Validators.maxLength(100)]],
      activo: [true],
      bloqueado: [false],
      flagAdminSistema: [false],
      tipoSales: [''],
    });
    this.cargar();
  }

  cargar(): void {
    this.loading = true;
    this.api.listarUsuarios().subscribe({
      next: r => { this.loading = false; this.usuarios = r.data ?? []; },
      error: () => { this.loading = false; },
    });
  }

  get usuariosFiltrados(): UsuarioAdminDto[] {
    if (!this.filtro.trim()) return this.usuarios;
    const q = this.filtro.toLowerCase();
    return this.usuarios.filter(u =>
      u.username.toLowerCase().includes(q) ||
      u.email.toLowerCase().includes(q) ||
      u.nombreCompleto.toLowerCase().includes(q)
    );
  }

  readonly columnasTabla: TablaColumna[] = [
    { key: 'id', header: 'ID', width: '70px' },
    { key: 'nombreCompleto', header: 'Nombre completo', width: '220px' },
    { key: 'username', header: 'Username', width: '150px' },
    { key: 'email', header: 'Email', width: '220px' },
    { key: 'flagAdminSistema', header: 'Admin Sistema', width: '120px', format: 'flag' },
    { key: 'bloqueado', header: 'Bloqueado', width: '110px', format: 'flag' },
    { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
  ];

  protected get registrosTabla(): UsuarioAdminDto[] { return this.usuariosFiltrados; }
  protected aFila(u: UsuarioAdminDto): Record<string, unknown> {
    return {
      id: u.id, nombreCompleto: u.nombreCompleto, username: u.username, email: u.email,
      flagAdminSistema: u.flagAdminSistema ? '1' : '0',
      bloqueado: u.bloqueado ? '1' : '0',
      flagEstado: u.activo ? '1' : '0',
    };
  }
  protected override editarRegistro(u: UsuarioAdminDto): void { this.abrirEditar(u); }

  get formActivo(): FormGroup { return this.editandoId != null ? this.formEditar : this.formCrear; }
  get esCreacion(): boolean { return this.editandoId == null; }

  abrirCrear(): void {
    this.editandoId = null;
    this.formCrear.reset({ email: '', username: '', password: '', nombres: '', apellidos: '', flagAdminSistema: false, tipoSales: '' });
    this.mostrandoForm = true;
  }

  abrirEditar(u: UsuarioAdminDto): void {
    this.editandoId = u.id;
    this.formEditar.patchValue({
      email: u.email, username: u.username,
      nombres: u.nombres, apellidos: u.apellidos,
      activo: u.activo ?? true, bloqueado: u.bloqueado ?? false,
      flagAdminSistema: u.flagAdminSistema ?? false,
      tipoSales: u.tipoSales ?? '',
    });
    this.mostrandoForm = true;
  }

  cancelar(): void { this.mostrandoForm = false; this.editandoId = null; }

  campoInvalido(control: string): boolean {
    const campo = this.formActivo.get(control);
    return !!campo && campo.invalid && (campo.dirty || campo.touched);
  }

  guardar(): void {
    const form = this.formActivo;
    if (form.invalid) { 
      form.markAllAsTouched(); 
      return; 
    }
    const body = form.getRawValue();
    const obs = this.editandoId != null
      ? this.api.actualizarUsuario(this.editandoId, body)
      : this.api.crearUsuario(body);
    obs.subscribe({
      next: () => { this.mostrandoForm = false; this.editandoId = null; this.cargar(); },
      error: async (err: any) => {
        const modal = await this.modalCtrl.create({ component: ModalConfirmationComponent, cssClass: 'promo',
          componentProps: { titlemodal: '', tipemodal: 'error', title: 'Error', message: err?.error?.message ?? 'Error al guardar', btnOkTxt: 'Aceptar', mostrarCancelar: false } });
        await modal.present();
      },
    });
  }
}
