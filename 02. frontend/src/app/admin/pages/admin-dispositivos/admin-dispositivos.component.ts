import { Component, OnInit, inject } from '@angular/core';
import { ToastController } from '@ionic/angular';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { DispositivoAdminDto, DispositivoLoginDto } from '../../models/admin.models';
import { TablaColumna } from '../../../erp/shared/models/api-page.model';
import { AdminTablaPageBase } from '../../shared/admin-tabla-page-base';
import { SigreModalService } from '@sigre-common';

/**
 * Dispositivos móviles registrados por la app Hermes (POST /api/auth/dispositivo/registrar).
 * Nacen autorizados; aquí se pueden revocar/reautorizar. Un dispositivo con flag_autorizado=false
 * recibe 403 DISPOSITIVO_NO_AUTORIZADO en /api/auth/login/mobile, con mensaje explícito en el equipo.
 */
@Component({
  selector: 'app-admin-dispositivos',
  templateUrl: './admin-dispositivos.component.html',
  styleUrls: ['../admin-page-common.scss', './admin-dispositivos.component.scss'],
  standalone: false,
})
export class AdminDispositivosComponent extends AdminTablaPageBase<DispositivoAdminDto> implements OnInit {
  columnasTabla: TablaColumna[] = [];
  protected get registrosTabla(): DispositivoAdminDto[] { return this.dispositivosFiltrados; }
  protected aFila(d: DispositivoAdminDto): Record<string, unknown> { return { id: d.id }; }
  protected override activoDe(d: DispositivoAdminDto): boolean { return d.autorizado; }

  private readonly api = inject(AdminSeguridadApiService);
  private readonly sigreModal = inject(SigreModalService);
  private readonly toastCtrl = inject(ToastController);

  dispositivos: DispositivoAdminDto[] = [];
  loading = true;
  filtro = '';

  mostrandoHistorial = false;
  dispositivoHistorial: DispositivoAdminDto | null = null;
  historial: DispositivoLoginDto[] = [];
  loadingHistorial = false;

  ngOnInit(): void {
    this.cargar();
  }

  cargar(): void {
    this.loading = true;
    this.api.listarDispositivos().subscribe({
      next: res => {
        this.loading = false;
        this.dispositivos = res.data ?? [];
      },
      error: async () => {
        this.loading = false;
        await this.presentError('No se pudieron cargar los dispositivos.');
      },
    });
  }

  get dispositivosFiltrados(): DispositivoAdminDto[] {
    if (!this.filtro.trim()) return this.dispositivos;
    const q = this.filtro.toLowerCase();
    return this.dispositivos.filter(d =>
      d.deviceId?.toLowerCase().includes(q)
      || d.ultimoNroRegistro?.toLowerCase().includes(q)
      || d.nombreDispositivo?.toLowerCase().includes(q)
      || d.fabricante?.toLowerCase().includes(q)
      || d.modelo?.toLowerCase().includes(q)
      || d.ipPublica?.toLowerCase().includes(q)
      || d.ipPrivada?.toLowerCase().includes(q)
      || d.usuarioNombre?.toLowerCase().includes(q)
    );
  }

  async confirmarCambioAutorizacion(d: DispositivoAdminDto, autorizar: boolean): Promise<void> {
    const nombre = this.escapeHtmlLite(d.nombreDispositivo ?? d.deviceId);
    const confirmed = await this.sigreModal.confirm({
      titulo: autorizar ? 'Autorizar dispositivo' : 'Revocar dispositivo',
      mensaje: autorizar
        ? `¿Autorizar «${nombre}»? Podrá volver a iniciar sesión desde la app móvil.`
        : `¿Revocar «${nombre}»? No podrá iniciar sesión desde la app móvil hasta que se reautorice.`,
      tipo: autorizar ? 'confirm' : 'warning',
      textoConfirmar: autorizar ? 'Autorizar' : 'Revocar',
      conCancelar: true,
    });
    if (!confirmed) return;

    this.api.actualizarAutorizacionDispositivo(d.id, autorizar).subscribe({
      next: () => {
        void this.presentToast(autorizar ? 'Dispositivo autorizado' : 'Dispositivo revocado', 'success');
        this.cargar();
      },
      error: async (err: any) => await this.presentError(err?.error?.message ?? 'No se pudo cambiar la autorización.'),
    });
  }

  abrirHistorial(d: DispositivoAdminDto): void {
    this.dispositivoHistorial = d;
    this.mostrandoHistorial = true;
    this.loadingHistorial = true;
    this.historial = [];
    this.api.listarLoginsDispositivo(d.id).subscribe({
      next: res => {
        this.loadingHistorial = false;
        this.historial = res.data ?? [];
      },
      error: async () => {
        this.loadingHistorial = false;
        await this.presentError('No se pudo cargar el historial de inicios de sesión.');
      },
    });
  }

  cerrarHistorial(): void {
    this.mostrandoHistorial = false;
    this.dispositivoHistorial = null;
    this.historial = [];
  }

  private escapeHtmlLite(s: string): string {
    return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  }

  private async presentToast(message: string, color: string): Promise<void> {
    const t = await this.toastCtrl.create({ message, duration: 2600, color, position: 'bottom' });
    await t.present();
  }

  private async presentError(message: string): Promise<void> {
    await this.sigreModal.error(message);
  }
}
