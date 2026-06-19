import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from '@sigre-common';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { ModuloDto } from '../../models/admin.models';

@Component({
  selector: 'app-admin-modulos',
  templateUrl: './admin-modulos.component.html',
  styleUrls: ['./admin-modulos.component.scss'],
  standalone: false,
})
export class AdminModulosComponent implements OnInit {

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

  get modulosFiltrados(): ModuloDto[] {
    if (!this.filtro.trim()) return this.modulos;
    const q = this.filtro.toLowerCase();
    return this.modulos.filter(m =>
      m.codigo.toLowerCase().includes(q) || m.nombre.toLowerCase().includes(q)
    );
  }

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
