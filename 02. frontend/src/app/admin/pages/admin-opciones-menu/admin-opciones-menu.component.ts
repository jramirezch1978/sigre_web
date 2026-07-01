import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from '@sigre-common';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { ModuloDto, OpcionMenuDto } from '../../models/admin.models';
import { TablaColumna } from '../../../erp/shared/models/api-page.model';
import { AdminTablaPageBase } from '../../shared/admin-tabla-page-base';

@Component({
  selector: 'app-admin-opciones-menu',
  templateUrl: './admin-opciones-menu.component.html',
  styleUrls: ['./admin-opciones-menu.component.scss'],
  standalone: false,
})
export class AdminOpcionesMenuComponent extends AdminTablaPageBase<OpcionMenuDto> implements OnInit {

  private readonly api = inject(AdminSeguridadApiService);
  private readonly fb = inject(FormBuilder);
  private readonly modalCtrl = inject(ModalController);

  modulos: ModuloDto[] = [];
  opciones: OpcionMenuDto[] = [];
  loading = true;
  filtroModuloId: number | null = null;
  filtro = '';
  mostrandoForm = false;
  editandoId: number | null = null;
  form!: FormGroup;

  ngOnInit(): void {
    this.form = this.fb.group({
      moduloId: [null as number | null, [Validators.required]],
      codigo: ['', [Validators.required, Validators.maxLength(80)]],
      nombre: ['', [Validators.required, Validators.maxLength(160)]],
      rutaFrontend: ['', [Validators.maxLength(250)]],
      opcionPadreId: [null as number | null],
      orden: [0],
      activo: [true],
    });
    this.api.listarModulos().subscribe({ next: r => { this.modulos = r.data ?? []; } });
    this.cargar();
  }

  cargar(): void {
    this.loading = true;
    this.api.listarOpcionesMenu(this.filtroModuloId ?? undefined).subscribe({
      next: r => { this.loading = false; this.opciones = r.data ?? []; },
      error: () => { this.loading = false; },
    });
  }

  onModuloChange(ev: any): void {
    this.filtroModuloId = ev.detail?.value ?? null;
    this.cargar();
  }

  protected override get todosLosRegistros(): OpcionMenuDto[] { return this.opciones; }

  get opcionesFiltradas(): OpcionMenuDto[] {
    let lista = this.opciones;
    if (this.filtro.trim()) {
      const q = this.filtro.toLowerCase();
      lista = lista.filter(o => (o.codigo ?? '').toLowerCase().includes(q) || o.nombre.toLowerCase().includes(q));
    }
    return this.filtrarPorEstado(lista);
  }

  // ── Tabla ERP (erp-data-table): columnas + filas mapeadas ──
  readonly columnasTabla: TablaColumna[] = [
    { key: 'id', header: 'ID', width: '70px' },
    { key: 'codigo', header: 'Código', width: '220px' },
    { key: 'nombre', header: 'Nombre', width: '220px' },
    { key: 'moduloNombre', header: 'Módulo', width: '120px' },
    { key: 'rutaFrontend', header: 'Ruta', width: '220px' },
    { key: 'orden', header: 'Orden', width: '70px', format: 'numero' },
    { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
  ];

  protected get registrosTabla(): OpcionMenuDto[] { return this.opcionesFiltradas; }
  protected aFila(o: OpcionMenuDto): Record<string, unknown> {
    return {
      id: o.id,
      codigo: o.codigo ?? '—',
      nombre: o.nombre,
      moduloNombre: this.moduloNombre(o.moduloId),
      rutaFrontend: o.rutaFrontend ?? '—',
      orden: o.orden ?? 0,
      flagEstado: o.activo ? '1' : '0',
    };
  }
  protected override editarRegistro(o: OpcionMenuDto): void { this.abrirEditar(o); }

  moduloNombre(id?: number): string {
    if (id == null) return '—';
    return this.modulos.find(m => m.id === id)?.nombre ?? String(id);
  }

  abrirCrear(): void {
    this.editandoId = null;
    this.form.reset({ moduloId: this.filtroModuloId, codigo: '', nombre: '', rutaFrontend: '', opcionPadreId: null, orden: 0, activo: true });
    this.mostrandoForm = true;
  }

  abrirEditar(o: OpcionMenuDto): void {
    this.editandoId = o.id;
    this.form.patchValue({ ...o, opcionPadreId: o.opcionPadreId ?? null });
    this.mostrandoForm = true;
  }

  cancelar(): void { this.mostrandoForm = false; this.editandoId = null; }

  guardar(): void {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    const body = this.form.getRawValue();
    const obs = this.editandoId != null
      ? this.api.actualizarOpcionMenu(this.editandoId, body)
      : this.api.crearOpcionMenu(body);
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
