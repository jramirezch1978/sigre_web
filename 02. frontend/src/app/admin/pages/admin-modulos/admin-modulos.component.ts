import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from '@sigre-common';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { ModuloDto } from '../../models/admin.models';
import { TablaColumna } from '../../../erp/shared/models/api-page.model';
import { AdminTablaPageBase } from '../../shared/admin-tabla-page-base';

@Component({
  selector: 'app-admin-modulos',
  templateUrl: './admin-modulos.component.html',
  styleUrls: ['./admin-modulos.component.scss'],
  standalone: false,
})
export class AdminModulosComponent extends AdminTablaPageBase<ModuloDto> implements OnInit {

  private readonly api = inject(AdminSeguridadApiService);
  private readonly fb = inject(FormBuilder);
  private readonly modalCtrl = inject(ModalController);

  modulos: ModuloDto[] = [];
  loading = true;
  filtro = '';

  mostrandoForm = false;
  editandoId: number | null = null;
  form!: FormGroup;

  ngOnInit(): void {
    this.initForm();
    this.cargar();
  }

  private initForm(): void {
    this.form = this.fb.group({
      codigo: ['', [Validators.required, Validators.maxLength(40)]],
      nombre: ['', [Validators.required, Validators.maxLength(120)]],
      activo: [true],
    });
  }

  cargar(): void {
    this.loading = true;
    this.api.listarModulos().subscribe({
      next: res => {
        this.loading = false;
        this.modulos = res.data ?? [];
      },
      error: () => { this.loading = false; },
    });
  }

  protected override get todosLosRegistros(): ModuloDto[] { return this.modulos; }

  get modulosFiltrados(): ModuloDto[] {
    let lista = this.modulos;
    if (this.filtro.trim()) {
      const q = this.filtro.toLowerCase();
      lista = lista.filter(m => m.codigo.toLowerCase().includes(q) || m.nombre.toLowerCase().includes(q));
    }
    return this.filtrarPorEstado(lista);
  }

  readonly columnasTabla: TablaColumna[] = [
    { key: 'id', header: 'ID', width: '70px' },
    { key: 'codigo', header: 'Código', width: '180px' },
    { key: 'nombre', header: 'Nombre', width: '260px' },
    { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
  ];

  protected get registrosTabla(): ModuloDto[] { return this.modulosFiltrados; }
  protected aFila(m: ModuloDto): Record<string, unknown> {
    return { id: m.id, codigo: m.codigo, nombre: m.nombre, flagEstado: m.activo ? '1' : '0' };
  }
  protected override editarRegistro(m: ModuloDto): void { this.abrirEditar(m); }

  abrirCrear(): void {
    this.editandoId = null;
    this.form.reset({ codigo: '', nombre: '', activo: true });
    this.mostrandoForm = true;
  }

  abrirEditar(m: ModuloDto): void {
    this.editandoId = m.id;
    this.form.patchValue({ codigo: m.codigo, nombre: m.nombre, activo: m.activo ?? true });
    this.mostrandoForm = true;
  }

  cancelar(): void {
    this.mostrandoForm = false;
    this.editandoId = null;
  }

  guardar(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    const body = this.form.getRawValue();
    const obs = this.editandoId != null
      ? this.api.actualizarModulo(this.editandoId, body)
      : this.api.crearModulo(body);

    obs.subscribe({
      next: () => {
        this.mostrandoForm = false;
        this.editandoId = null;
        this.cargar();
      },
      error: async (err: any) => {
        const msg = err?.error?.message ?? 'Error al guardar';
        await this.mostrarError(msg);
      },
    });
  }

  private async mostrarError(message: string): Promise<void> {
    const modal = await this.modalCtrl.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: { titlemodal: '', tipemodal: 'error', title: 'Error', message, btnOkTxt: 'Aceptar', mostrarCancelar: false },
    });
    await modal.present();
  }
}
