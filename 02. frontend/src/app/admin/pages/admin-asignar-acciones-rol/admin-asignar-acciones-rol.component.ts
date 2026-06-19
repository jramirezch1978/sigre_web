import { Component, OnInit, inject } from '@angular/core';
import { forkJoin } from 'rxjs';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from '@sigre-common';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { StorageService } from '../../../core/services/storage.service';
import { JwtClaimsReaderService } from '../../services/jwt-claims-reader.service';
import { RolDto, OpcionMenuDto, AccionDto, RolOpcionMenuDto, RolOpcionAccionDto } from '../../models/admin.models';

@Component({
  selector: 'app-admin-asignar-acciones-rol',
  templateUrl: './admin-asignar-acciones-rol.component.html',
  styleUrls: ['./admin-asignar-acciones-rol.component.scss'],
  standalone: false,
})
export class AdminAsignarAccionesRolComponent implements OnInit {

  private readonly api = inject(AdminSeguridadApiService);
  private readonly modalCtrl = inject(ModalController);
  private readonly storage = inject(StorageService);
  private readonly claims = inject(JwtClaimsReaderService);

  roles: RolDto[] = [];
  opcionesMenuGlobal: OpcionMenuDto[] = [];
  accionesGlobal: AccionDto[] = [];

  rolSeleccionado: RolDto | null = null;
  opcionesDelRol: RolOpcionMenuDto[] = [];
  accionesPorOpcion: Record<number, RolOpcionAccionDto[]> = {};

  loading = true;
  loadingDetalle = false;

  opcionIdAsignar: number | null = null;

  private get empresaId(): number {
    const token = this.storage.getToken();
    return token ? (this.claims.getEmpresaId(token) ?? 0) : 0;
  }

  ngOnInit(): void {
    const opciones$ = this.api.listarOpcionesMenu();
    const acciones$ = this.api.listarAcciones();
    if (this.empresaId) {
      forkJoin({
        roles: this.api.listarRoles(this.empresaId),
        opcionesMenu: opciones$,
        acciones: acciones$,
      }).subscribe({
        next: ({ roles, opcionesMenu, acciones }) => {
          this.loading = false;
          this.roles = roles.data ?? [];
          this.opcionesMenuGlobal = opcionesMenu.data ?? [];
          this.accionesGlobal = acciones.data ?? [];
        },
        error: async err => {
          this.loading = false;
          await this.showError(err?.error?.message ?? 'No se pudo cargar roles, menú y acciones.');
        },
      });
    } else {
      forkJoin({ opcionesMenu: opciones$, acciones: acciones$ }).subscribe({
        next: ({ opcionesMenu, acciones }) => {
          this.loading = false;
          this.opcionesMenuGlobal = opcionesMenu.data ?? [];
          this.accionesGlobal = acciones.data ?? [];
        },
        error: async err => {
          this.loading = false;
          await this.showError(err?.error?.message ?? 'No se pudo cargar menú y acciones.');
        },
      });
    }
  }

  seleccionarRol(r: RolDto): void {
    this.rolSeleccionado = r;
    this.cargarOpcionesRol();
  }

  cargarOpcionesRol(): void {
    if (!this.rolSeleccionado) return;
    this.loadingDetalle = true;
    this.accionesPorOpcion = {};
    this.api.listarRolOpciones(this.empresaId, this.rolSeleccionado.id).subscribe({
      next: r => {
        this.loadingDetalle = false;
        this.opcionesDelRol = r.data ?? [];
        for (const rom of this.opcionesDelRol) {
          this.cargarAccionesOpcion(rom.opcionMenuId);
        }
      },
      error: () => { this.loadingDetalle = false; },
    });
  }

  cargarAccionesOpcion(opcionMenuId: number): void {
    if (!this.rolSeleccionado) return;
    this.api.listarAccionesRolOpcion(this.empresaId, this.rolSeleccionado.id, opcionMenuId).subscribe({
      next: r => { this.accionesPorOpcion = { ...this.accionesPorOpcion, [opcionMenuId]: r.data ?? [] }; },
    });
  }

  get opcionesDisponibles(): OpcionMenuDto[] {
    const asignadas = new Set(this.opcionesDelRol.map(o => o.opcionMenuId));
    return this.opcionesMenuGlobal.filter(o => !asignadas.has(o.id));
  }

  asignarOpcion(): void {
    if (!this.rolSeleccionado || !this.opcionIdAsignar) return;
    this.api.asignarOpcionARol(this.empresaId, this.rolSeleccionado.id, this.opcionIdAsignar).subscribe({
      next: () => { this.opcionIdAsignar = null; this.cargarOpcionesRol(); },
      error: async (err: any) => { await this.showError(err?.error?.message ?? 'Error'); },
    });
  }

  quitarOpcion(opcionMenuId: number): void {
    if (!this.rolSeleccionado) return;
    this.api.quitarOpcionDeRol(this.empresaId, this.rolSeleccionado.id, opcionMenuId).subscribe({
      next: () => this.cargarOpcionesRol(),
      error: async (err: any) => { await this.showError(err?.error?.message ?? 'Error'); },
    });
  }

  toggleAccion(opcionMenuId: number, accionId: number, permitido: boolean): void {
    if (!this.rolSeleccionado) return;
    this.api.upsertAccionRolOpcion(this.empresaId, this.rolSeleccionado.id, opcionMenuId, accionId, { permitido, activo: true }).subscribe({
      next: () => this.cargarAccionesOpcion(opcionMenuId),
    });
  }

  accionEstaPermitida(opcionMenuId: number, accionId: number): boolean {
    const lista = this.accionesPorOpcion[opcionMenuId] ?? [];
    const item = lista.find(a => a.accionId === accionId);
    return item?.permitido === true;
  }

  volver(): void { this.rolSeleccionado = null; this.opcionesDelRol = []; this.accionesPorOpcion = {}; }

  private async showError(message: string): Promise<void> {
    const modal = await this.modalCtrl.create({ component: ModalConfirmationComponent, cssClass: 'promo',
      componentProps: { titlemodal: '', tipemodal: 'error', title: 'Error', message, btnOkTxt: 'Aceptar', mostrarCancelar: false } });
    await modal.present();
  }
}
