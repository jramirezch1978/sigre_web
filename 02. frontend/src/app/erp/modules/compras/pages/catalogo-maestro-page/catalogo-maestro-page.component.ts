import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute } from '@angular/router';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { ErpDataTableComponent } from '../../../../shared/erp-data-table/erp-data-table.component';
import { ErpMetoxiListPageComponent, ErpMetoxiFiltroTab } from '../../../../shared/erp-metoxi-list-page/erp-metoxi-list-page.component';
import { contarRegistrosPorEstado, filtrarFilasListado } from '../../../../shared/utils/erp-list-filter.util';
import { ErpTablaPageBase } from '../../../../shared/base/erp-tabla-page-base';
import { abrirDialogoMetoxi, SigreModalService } from '@sigre-common';
import { CATALOGO_MAESTROS, CatalogoMaestroConfig } from '../../config/catalogo-maestros.config';
import { ComprasCatalogoService } from '../../services/compras-catalogo.service';
import {
  CatalogoFormDialogComponent,
  CatalogoFormDialogData,
} from '../../components/catalogo-form-dialog/catalogo-form-dialog.component';

/** Página genérica de un maestro de catálogo (marcas, colores, categorías, etc.). */
@Component({
  selector: 'app-catalogo-maestro-page',
  standalone: true,
  imports: [CommonModule, MatDialogModule, ErpDataTableComponent, ErpMetoxiListPageComponent],
  templateUrl: './catalogo-maestro-page.component.html',
})
export class CatalogoMaestroPageComponent extends ErpTablaPageBase implements OnInit {
  private readonly route = inject(ActivatedRoute);
  private readonly catalogoSvc = inject(ComprasCatalogoService);
  private readonly dialog = inject(MatDialog);
  private readonly modal = inject(SigreModalService);

  cfg: CatalogoMaestroConfig | null = null;
  filas: Record<string, unknown>[] = [];
  busqueda = '';
  filtroTab: ErpMetoxiFiltroTab = 'todos';
  cargando = true;
  error = '';

  get columnas() {
    return this.cfg?.columnas ?? [];
  }

  get conteo() {
    return contarRegistrosPorEstado(this.filas);
  }

  get filasVisibles(): Record<string, unknown>[] {
    return filtrarFilasListado(this.filas, this.columnas, this.busqueda, this.filtroTab);
  }

  ngOnInit(): void {
    this.route.data.subscribe(data => {
      const key = data['catalogoKey'] as string;
      this.cfg = CATALOGO_MAESTROS[key] ?? null;
      this.codigo = this.cfg?.codigo ?? key;
      this.nombre = this.cfg?.nombre ?? 'Maestro';
      this.cargarPreferenciasTabla();
      this.cargar();
    });
  }

  recargar(): void {
    this.cargar();
  }

  anadir(): void {
    this.abrirDialogo('Nuevo registro', null);
  }

  editar(fila: Record<string, unknown>): void {
    this.abrirDialogo('Editar registro', fila);
  }

  eliminar(fila: Record<string, unknown>): void {
    if (!this.cfg) return;
    const id = fila['id'] as number;
    const etiqueta = String(fila['nombre'] ?? fila['descClase'] ?? fila['descCateg'] ?? fila['descSubcateg'] ?? fila['codigo'] ?? id);
    this.modal.confirmEliminar$(etiqueta).subscribe(ok => {
      if (!ok) return;
      this.catalogoSvc.eliminar(this.cfg!.endpoint, id, this.cfg!.base).subscribe({
        next: () => this.cargar(),
        error: err => { this.error = err?.error?.message ?? 'No se pudo eliminar el registro'; },
      });
    });
  }

  anular(fila: Record<string, unknown>): void {
    if (!this.cfg) return;
    const id = fila['id'] as number;
    this.catalogoSvc.desactivar(this.cfg.endpoint, id, this.cfg.base).subscribe({
      next: () => this.cargar(),
      error: err => { this.error = err?.error?.message ?? 'No se pudo anular el registro'; },
    });
  }

  private abrirDialogo(titulo: string, registro: Record<string, unknown> | null): void {
    if (!this.cfg) return;
    const data: CatalogoFormDialogData = { titulo, config: this.cfg, registro };
    abrirDialogoMetoxi(this.dialog, CatalogoFormDialogComponent, { data, width: '720px' })
      .afterClosed()
      .subscribe(ok => { if (ok) this.cargar(); });
  }

  private cargar(): void {
    if (!this.cfg) { this.cargando = false; return; }
    this.cargando = true;
    this.error = '';
    this.catalogoSvc.listar<Record<string, unknown>>(this.cfg.endpoint, 200, this.cfg.base).subscribe({
      next: filas => { this.filas = filas; this.cargando = false; },
      error: err => {
        this.cargando = false;
        this.error = err?.error?.message ?? 'No se pudieron cargar los registros';
        this.filas = [];
      },
    });
  }
}
