import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { forkJoin } from 'rxjs';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from '@sigre-common';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { StorageService } from '../../../core/services/storage.service';
import { JwtClaimsReaderService } from '../../services/jwt-claims-reader.service';
import { RolDto, ModuloDto, OpcionMenuDto, AccionDto, RolOpcionMenuDto, RolOpcionAccionDto } from '../../models/admin.models';
import { TablaColumna } from '../../../erp/shared/models/api-page.model';
import { AdminTablaPageBase } from '../../shared/admin-tabla-page-base';

export interface NodoArbol {
  opcionMenuId: number;
  codigo: string;
  nombre: string;
  profundidad: number;
  tipo: 'modulo' | 'carpeta' | 'asignada';
}

@Component({
  selector: 'app-admin-roles',
  templateUrl: './admin-roles.component.html',
  styleUrls: ['./admin-roles.component.scss'],
  standalone: false,
})
export class AdminRolesComponent extends AdminTablaPageBase<RolDto> implements OnInit {

  private readonly api = inject(AdminSeguridadApiService);
  private readonly fb = inject(FormBuilder);
  private readonly modalCtrl = inject(ModalController);
  private readonly storage = inject(StorageService);
  private readonly claims = inject(JwtClaimsReaderService);

  roles: RolDto[] = [];
  loading = true;
  filtro = '';
  mostrandoForm = false;
  editandoId: number | null = null;
  form!: FormGroup;

  modulosGlobal: ModuloDto[] = [];
  opcionesMenuGlobal: OpcionMenuDto[] = [];
  accionesGlobal: AccionDto[] = [];
  opcionesDelRol: RolOpcionMenuDto[] = [];
  accionesPorOpcion: Record<number, RolOpcionAccionDto[]> = {};
  loadingDetalle = false;
  opcionIdAsignar: number | null = null;
  expandidos = new Set<number>();

  /** IDs de opción de menú que tienen al menos un hijo (según catálogo global). */
  private opcionIdsConHijos = new Set<number>();
  private opPorId = new Map<number, OpcionMenuDto>();

  get empresaId(): number {
    const token = this.storage.getToken();
    return token ? (this.claims.getEmpresaId(token) ?? 0) : 0;
  }

  ngOnInit(): void {
    this.form = this.fb.group({
      codigo: ['', [Validators.required, Validators.maxLength(40)]],
      nombre: ['', [Validators.required, Validators.maxLength(120)]],
      esAdmin: [false],
      activo: [true],
    });
    this.cargarDatosIniciales();
  }

  private cargarDatosIniciales(): void {
    if (!this.empresaId) { this.loading = false; return; }
    this.loading = true;
    forkJoin({
      roles: this.api.listarRoles(this.empresaId),
      modulos: this.api.listarModulos(),
      opciones: this.api.listarOpcionesMenu(),
      acciones: this.api.listarAcciones(),
    }).subscribe({
      next: ({ roles, modulos, opciones, acciones }) => {
        this.loading = false;
        this.roles = roles.data ?? [];
        this.modulosGlobal = modulos.data ?? [];
        this.opcionesMenuGlobal = opciones.data ?? [];
        this.accionesGlobal = acciones.data ?? [];
        this.reconstruirIndicesMenu();
      },
      error: () => { this.loading = false; },
    });
  }

  protected override get todosLosRegistros(): RolDto[] { return this.roles; }

  get rolesFiltrados(): RolDto[] {
    let lista = this.roles;
    if (this.filtro.trim()) {
      const q = this.filtro.toLowerCase();
      lista = lista.filter(r => r.codigo.toLowerCase().includes(q) || r.nombre.toLowerCase().includes(q));
    }
    return this.filtrarPorEstado(lista);
  }

  readonly columnasTabla: TablaColumna[] = [
    { key: 'id', header: 'ID', width: '70px' },
    { key: 'codigo', header: 'Código', width: '160px' },
    { key: 'nombre', header: 'Nombre', width: '220px' },
    { key: 'tipo', header: 'Tipo', width: '130px' },
    { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
  ];

  protected get registrosTabla(): RolDto[] { return this.rolesFiltrados; }
  protected aFila(r: RolDto): Record<string, unknown> {
    return {
      id: r.id, codigo: r.codigo, nombre: r.nombre,
      tipo: r.esAdmin ? 'Administrador' : 'Normal',
      flagEstado: r.activo ? '1' : '0',
    };
  }
  protected override editarRegistro(r: RolDto): void { this.abrirEditar(r); }

  get opcionesDisponibles(): OpcionMenuDto[] {
    const asignadas = new Set(this.opcionesDelRol.map(o => o.opcionMenuId));
    return this.opcionesMenuGlobal.filter(o => !asignadas.has(o.id));
  }

  abrirCrear(): void {
    this.editandoId = null;
    this.form.reset({ codigo: '', nombre: '', esAdmin: false, activo: true });
    this.opcionesDelRol = [];
    this.accionesPorOpcion = {};
    this.opcionIdAsignar = null;
    this.mostrandoForm = true;
  }

  abrirEditar(r: RolDto): void {
    this.editandoId = r.id;
    this.form.patchValue(r);
    this.mostrandoForm = true;
    this.cargarOpcionesRol();
  }

  cancelar(): void {
    this.mostrandoForm = false;
    this.editandoId = null;
    this.opcionesDelRol = [];
    this.accionesPorOpcion = {};
    this.opcionIdAsignar = null;
  }

  guardar(): void {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    const body = this.form.getRawValue();
    const obs = this.editandoId != null
      ? this.api.actualizarRol(this.empresaId, this.editandoId, body)
      : this.api.crearRol(this.empresaId, body);
    obs.subscribe({
      next: (resp) => {
        const rolGuardado = resp.data;
        if (this.editandoId == null && rolGuardado) {
          this.editandoId = rolGuardado.id;
          this.form.patchValue(rolGuardado);
          this.cargarDatosIniciales();
        } else {
          this.cargarDatosIniciales();
        }
        this.showSuccess(this.editandoId != null ? 'Rol actualizado' : 'Rol creado exitosamente');
      },
      error: async (err: any) => { await this.showError(err?.error?.message ?? 'Error al guardar'); },
    });
  }

  cargarOpcionesRol(): void {
    if (this.editandoId == null) return;
    this.loadingDetalle = true;
    this.accionesPorOpcion = {};
    this.api.listarRolOpciones(this.empresaId, this.editandoId).subscribe({
      next: r => {
        this.loadingDetalle = false;
        this.opcionesDelRol = r.data ?? [];
        this.expandirPadresPorDefecto();
        for (const rom of this.opcionesDelRol) {
          this.cargarAccionesOpcion(rom.opcionMenuId);
        }
      },
      error: () => { this.loadingDetalle = false; },
    });
  }

  cargarAccionesOpcion(opcionMenuId: number): void {
    if (this.editandoId == null) return;
    this.api.listarAccionesRolOpcion(this.empresaId, this.editandoId, opcionMenuId).subscribe({
      next: r => { this.accionesPorOpcion = { ...this.accionesPorOpcion, [opcionMenuId]: r.data ?? [] }; },
    });
  }

  asignarOpcion(): void {
    if (this.editandoId == null || !this.opcionIdAsignar) return;
    this.api.asignarOpcionARol(this.empresaId, this.editandoId, this.opcionIdAsignar).subscribe({
      next: () => { this.opcionIdAsignar = null; this.cargarOpcionesRol(); },
      error: async (err: any) => { await this.showError(err?.error?.message ?? 'Error al asignar opción'); },
    });
  }

  quitarOpcion(opcionMenuId: number): void {
    if (this.editandoId == null) return;
    this.api.quitarOpcionDeRol(this.empresaId, this.editandoId, opcionMenuId).subscribe({
      next: () => this.cargarOpcionesRol(),
      error: async (err: any) => { await this.showError(err?.error?.message ?? 'Error al quitar opción'); },
    });
  }

  toggleAccion(opcionMenuId: number, accionId: number, permitido: boolean): void {
    if (this.editandoId == null) return;
    if (this.accionEstaPermitida(opcionMenuId, accionId) === permitido) return;
    this.api.upsertAccionRolOpcion(this.empresaId, this.editandoId, opcionMenuId, accionId, { permitido, activo: true }).subscribe({
      next: () => this.cargarAccionesOpcion(opcionMenuId),
    });
  }

  accionEstaPermitida(opcionMenuId: number, accionId: number): boolean {
    const lista = this.accionesPorOpcion[opcionMenuId] ?? [];
    const item = lista.find(a => a.accionId === accionId);
    return item?.permitido === true;
  }

  toggleExpandido(opcionMenuId: number): void {
    if (this.expandidos.has(opcionMenuId)) {
      this.expandidos.delete(opcionMenuId);
    } else {
      this.expandidos.add(opcionMenuId);
    }
  }

  trackNodoArbol(nodo: NodoArbol): string {
    return `${nodo.tipo}-${nodo.opcionMenuId}`;
  }

  /** True si en el catálogo existe al menos una opción hija (opcionPadreId = id). */
  opcionTieneHijosMenu(opcionId: number): boolean {
    if (opcionId <= 0) return false;
    return this.opcionIdsConHijos.has(opcionId);
  }

  /**
   * Determina si la fila del árbol debe mostrarse según el colapso de ancestros.
   */
  opcionVisibleEnArbol(nodo: NodoArbol): boolean {
    if (nodo.tipo === 'modulo') return true;
    const op = this.opPorId.get(nodo.opcionMenuId);
    if (!op) return true;
    let pid: number | null | undefined = op.opcionPadreId;
    while (pid != null) {
      if (!this.expandidos.has(pid)) return false;
      pid = this.opPorId.get(pid)?.opcionPadreId;
    }
    return true;
  }

  private reconstruirIndicesMenu(): void {
    const conHijos = new Set<number>();
    for (const o of this.opcionesMenuGlobal) {
      if (o.opcionPadreId != null) {
        conHijos.add(o.opcionPadreId);
      }
    }
    this.opcionIdsConHijos = conHijos;
    this.opPorId = new Map(this.opcionesMenuGlobal.map(o => [o.id, o]));
  }

  /** Al abrir el detalle: todos los nodos padre expandidos para ver el árbol completo (como antes). */
  private expandirPadresPorDefecto(): void {
    this.expandidos = new Set(this.opcionIdsConHijos);
  }

  get arbolPlano(): NodoArbol[] {
    const asignadasIds = new Set(this.opcionesDelRol.map(r => r.opcionMenuId));
    if (asignadasIds.size === 0) return [];

    const opMap = new Map(this.opcionesMenuGlobal.map(o => [o.id, o]));
    const modMap = new Map(this.modulosGlobal.map(m => [m.id, m]));

    const ancestrosRequeridos = new Set<number>();
    for (const opId of asignadasIds) {
      let currentId: number | null | undefined = opId;
      while (currentId) {
        ancestrosRequeridos.add(currentId);
        currentId = opMap.get(currentId)?.opcionPadreId;
      }
    }

    const modulosConOpciones = new Map<number, OpcionMenuDto[]>();
    for (const nodoId of ancestrosRequeridos) {
      const op = opMap.get(nodoId);
      if (!op) continue;
      const modId = op.moduloId ?? 0;
      if (!modulosConOpciones.has(modId)) modulosConOpciones.set(modId, []);
      modulosConOpciones.get(modId)!.push(op);
    }

    const resultado: NodoArbol[] = [];
    const modulosOrdenados = [...modulosConOpciones.keys()].sort((a, b) => {
      const na = modMap.get(a)?.nombre ?? '';
      const nb = modMap.get(b)?.nombre ?? '';
      return na.localeCompare(nb);
    });

    for (const modId of modulosOrdenados) {
      const mod = modMap.get(modId);
      resultado.push({
        opcionMenuId: -modId,
        codigo: mod?.codigo ?? '',
        nombre: mod?.nombre ?? 'Sin módulo',
        profundidad: 0,
        tipo: 'modulo',
      });

      const opcionesModulo = modulosConOpciones.get(modId)!;
      this.insertarHijosRecursivo(resultado, opcionesModulo, null, 1, asignadasIds);
    }

    return resultado;
  }

  private insertarHijosRecursivo(
    resultado: NodoArbol[],
    opciones: OpcionMenuDto[],
    padreId: number | null | undefined,
    profundidad: number,
    asignadasIds: Set<number>,
  ): void {
    const hijos = opciones
      .filter(o => (o.opcionPadreId ?? null) === (padreId ?? null))
      .sort((a, b) => (a.orden ?? 0) - (b.orden ?? 0) || (a.nombre ?? '').localeCompare(b.nombre ?? ''));

    for (const hijo of hijos) {
      const esAsignada = asignadasIds.has(hijo.id);
      resultado.push({
        opcionMenuId: hijo.id,
        codigo: hijo.codigo ?? '',
        nombre: hijo.nombre,
        profundidad,
        tipo: esAsignada ? 'asignada' : 'carpeta',
      });
      this.insertarHijosRecursivo(resultado, opciones, hijo.id, profundidad + 1, asignadasIds);
    }
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
