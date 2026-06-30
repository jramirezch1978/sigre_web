import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from '@sigre-common';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { AccionDto } from '../../models/admin.models';
import { TablaColumna } from '../../../erp/shared/models/api-page.model';
import { AdminTablaPageBase } from '../../shared/admin-tabla-page-base';

@Component({
  selector: 'app-admin-acciones',
  templateUrl: './admin-acciones.component.html',
  styleUrls: ['./admin-acciones.component.scss'],
  standalone: false,
})
export class AdminAccionesComponent extends AdminTablaPageBase<AccionDto> implements OnInit {

  private readonly api = inject(AdminSeguridadApiService);
  private readonly fb = inject(FormBuilder);
  private readonly modalCtrl = inject(ModalController);

  acciones: AccionDto[] = [];
  loading = true;
  filtro = '';
  mostrandoForm = false;
  editandoId: number | null = null;
  form!: FormGroup;

  ngOnInit(): void {
    this.form = this.fb.group({
      codigo: ['', [Validators.required, Validators.maxLength(40)]],
      nombre: ['', [Validators.required, Validators.maxLength(120)]],
      activo: [true],
    });
    this.cargar();
  }

  cargar(): void {
    this.loading = true;
    this.api.listarAcciones().subscribe({
      next: res => { this.loading = false; this.acciones = res.data ?? []; },
      error: () => { this.loading = false; },
    });
  }

  get accionesFiltradas(): AccionDto[] {
    if (!this.filtro.trim()) return this.acciones;
    const q = this.filtro.toLowerCase();
    return this.acciones.filter(a => a.codigo.toLowerCase().includes(q) || a.nombre.toLowerCase().includes(q));
  }

  readonly columnasTabla: TablaColumna[] = [
    { key: 'id', header: 'ID', width: '70px' },
    { key: 'codigo', header: 'Código', width: '180px' },
    { key: 'nombre', header: 'Nombre', width: '260px' },
    { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
  ];

  protected get registrosTabla(): AccionDto[] { return this.accionesFiltradas; }
  protected aFila(a: AccionDto): Record<string, unknown> {
    return { id: a.id, codigo: a.codigo, nombre: a.nombre, flagEstado: a.activo ? '1' : '0' };
  }
  protected override editarRegistro(a: AccionDto): void { this.abrirEditar(a); }

  abrirCrear(): void { this.editandoId = null; this.form.reset({ codigo: '', nombre: '', activo: true }); this.mostrandoForm = true; }

  abrirEditar(a: AccionDto): void { this.editandoId = a.id; this.form.patchValue(a); this.mostrandoForm = true; }

  cancelar(): void { this.mostrandoForm = false; this.editandoId = null; }

  guardar(): void {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    const body = this.form.getRawValue();
    const obs = this.editandoId != null ? this.api.actualizarAccion(this.editandoId, body) : this.api.crearAccion(body);
    obs.subscribe({
      next: () => { this.mostrandoForm = false; this.editandoId = null; this.cargar(); },
      error: async (err: any) => {
        const modal = await this.modalCtrl.create({ component: ModalConfirmationComponent, cssClass: 'promo', componentProps: { titlemodal: '', tipemodal: 'error', title: 'Error', message: err?.error?.message ?? 'Error al guardar', btnOkTxt: 'Aceptar', mostrarCancelar: false } });
        await modal.present();
      },
    });
  }
}
