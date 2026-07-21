import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { firstValueFrom } from 'rxjs';
import { abrirDialogoMetoxi, SigreModalService } from '@sigre-common';
import { ErpMetoxiListPageComponent } from '../../../../shared/erp-metoxi-list-page/erp-metoxi-list-page.component';
import { ErpTablaPageBase } from '../../../../shared/base/erp-tabla-page-base';
import { MotivoDialogComponent, MotivoDialogData } from '../../../../shared/motivo-dialog/motivo-dialog.component';
import {
  SolicitudCompraApiService, SolicitudCompraFila, SolicitudCompraFiltro,
} from '../../services/solicitud-compra-api.service';
import { SolicitudCompraDialogComponent, SolicitudCompraDialogData } from '../../components/solicitud-compra-dialog/solicitud-compra-dialog.component';
import { ConvertirSolicitudDialogComponent, ConvertirSolicitudDialogData } from '../../components/convertir-solicitud-dialog/convertir-solicitud-dialog.component';

interface EstadoInfo { texto: string; clase: string; }

const ESTADOS: Record<string, EstadoInfo> = {
  '0': { texto: 'Rechazada / Anulada', clase: 'bg-danger-subtle text-danger' },
  '1': { texto: 'Activa', clase: 'bg-primary-subtle text-primary' },
  '2': { texto: 'Convertida', clase: 'bg-success-subtle text-success' },
};

/** Solicitud de Compra — listado + flujo (enviar/aprobar/rechazar/anular/convertir). */
@Component({
  selector: 'app-solicitud-compra-list-page',
  standalone: true,
  imports: [CommonModule, FormsModule, MatDialogModule, ErpMetoxiListPageComponent],
  templateUrl: './solicitud-compra-list-page.component.html',
})
export class SolicitudCompraListPageComponent extends ErpTablaPageBase implements OnInit {
  private readonly api = inject(SolicitudCompraApiService);
  private readonly dialog = inject(MatDialog);
  private readonly modal = inject(SigreModalService);

  // Nota: el dump legado reutiliza "CM016" para varias ventanas distintas de Compras
  // (Solicitud de Compras, Cotizaciones, Orden de Compra, etc.) — es un artefacto de
  // la fuente, no un código real único. Se asigna aquí un código propio para evitar
  // colisión de persistencia (config.configuracion se guarda por código+usuario+empresa).
  override codigo = 'CM003';
  override nombre = 'Solicitud de Compras';

  filas: SolicitudCompraFila[] = [];
  busqueda = '';
  cargando = true;

  filtroEstado = '';
  filtroPrioridad = '';
  filtroFechaDesde = '';
  filtroFechaHasta = '';

  readonly estados = ESTADOS;

  get filasVisibles(): SolicitudCompraFila[] {
    const q = this.busqueda.trim().toLowerCase();
    if (!q) return this.filas;
    return this.filas.filter(f => (f.numero ?? '').toLowerCase().includes(q));
  }

  ngOnInit(): void {
    this.cargarPreferenciasTabla();
    this.cargar();
  }

  recargar(): void { this.cargar(); }

  aplicarFiltros(): void { this.cargar(); }

  etiquetaEstado(flagEstado: string): EstadoInfo {
    return ESTADOS[flagEstado] ?? { texto: flagEstado, clase: 'bg-secondary-subtle text-secondary' };
  }

  puedeEditar(f: SolicitudCompraFila): boolean { return f.flagEstado === '0' || f.flagEstado === '1'; }
  puedeAccionar(f: SolicitudCompraFila): boolean { return f.flagEstado === '1'; }

  anadir(): void { this.abrirFicha(null); }

  ver(f: SolicitudCompraFila): void { this.abrirFicha(f.id, f.flagEstado === '2'); }

  editar(f: SolicitudCompraFila): void { this.abrirFicha(f.id, false); }

  private abrirFicha(registroId: number | null, soloLectura = false): void {
    const data: SolicitudCompraDialogData = { registroId, soloLectura };
    abrirDialogoMetoxi(this.dialog, SolicitudCompraDialogComponent, { data, width: '1100px' })
      .afterClosed()
      .subscribe(cambio => { if (cambio) this.cargar(); });
  }

  enviar(f: SolicitudCompraFila): void {
    this.api.enviar(f.id).subscribe(() => this.cargar());
  }

  aprobar(f: SolicitudCompraFila): void {
    this.modal.confirm({
      titulo: 'Aprobar solicitud',
      mensaje: `¿Aprobar la solicitud ${f.numero}?`,
      tipo: 'warning',
      conCancelar: true,
      textoConfirmar: 'Aprobar',
    }).then(ok => { if (ok) this.api.aprobar(f.id).subscribe(() => this.cargar()); });
  }

  rechazar(f: SolicitudCompraFila): void {
    this.abrirMotivo(`Rechazar solicitud ${f.numero}`, 'Motivo de rechazo *', 'Rechazar')
      .then(motivo => { if (motivo) this.api.rechazar(f.id, motivo).subscribe(() => this.cargar()); });
  }

  anular(f: SolicitudCompraFila): void {
    this.abrirMotivo(`Anular solicitud ${f.numero}`, 'Motivo de anulación *', 'Anular')
      .then(motivo => { if (motivo) this.api.anular(f.id, motivo).subscribe(() => this.cargar()); });
  }

  private async abrirMotivo(titulo: string, etiqueta: string, textoConfirmar: string): Promise<string | null> {
    const data: MotivoDialogData = { titulo, etiqueta, textoConfirmar };
    const ref = abrirDialogoMetoxi<MotivoDialogComponent, MotivoDialogData, string>(
      this.dialog, MotivoDialogComponent, { data, width: '520px' });
    const resultado = await firstValueFrom(ref.afterClosed());
    return resultado ?? null;
  }

  convertir(f: SolicitudCompraFila): void {
    const data: ConvertirSolicitudDialogData = { solicitudId: f.id, numero: f.numero };
    abrirDialogoMetoxi(this.dialog, ConvertirSolicitudDialogComponent, { data, width: '560px' })
      .afterClosed()
      .subscribe(cambio => { if (cambio) this.cargar(); });
  }

  private cargar(): void {
    this.cargando = true;
    const filtro: SolicitudCompraFiltro = {
      flagEstado: this.filtroEstado || null,
      prioridad: this.filtroPrioridad || null,
      fechaDesde: this.filtroFechaDesde || null,
      fechaHasta: this.filtroFechaHasta || null,
    };
    this.api.listar(filtro).subscribe({
      next: page => { this.filas = page.content ?? []; this.cargando = false; },
      error: () => { this.filas = []; this.cargando = false; },
    });
  }
}
