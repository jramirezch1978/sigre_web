import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { ErpMetoxiListPageComponent } from '../../../../shared/erp-metoxi-list-page/erp-metoxi-list-page.component';
import { AlmacenApiService, AlmacenTipoMovDto } from '../../services/almacen-api.service';
import { AlmacenCrudService } from '../../services/almacen-crud.service';
import { crudConfigPorTabla, TablaCrudConfig } from '../../config/almacen-tabla-crud.config';
import { ALMACEN_TABLAS } from '../../config/almacen-tablas.config';
import { abrirDialogoMetoxi, SigreModalService } from '@sigre-common';
import {
  AlmacenRegistroDialogComponent,
  AlmacenRegistroDialogData,
} from '../../components/almacen-registro-dialog/almacen-registro-dialog.component';

/** Un almacén con la lista de tipos de movimiento que tiene asignados. */
interface GrupoAlmacen {
  almacenId: number;
  codigo: string;
  nombre: string;
  tipos: AlmacenTipoMovDto[];
}

/**
 * "Movimientos por almacén" agrupado: en vez de duplicar el almacén por cada tipo de
 * movimiento, muestra cada almacén una sola vez (acordeón) con sus tipos asignados.
 */
@Component({
  selector: 'app-almacen-mov-agrupado-page',
  standalone: true,
  imports: [CommonModule, MatDialogModule, ErpMetoxiListPageComponent],
  templateUrl: './almacen-mov-agrupado-page.component.html',
  styleUrls: ['./almacen-mov-agrupado-page.component.scss'],
})
export class AlmacenMovAgrupadoPageComponent implements OnInit {
  private readonly almacenApi = inject(AlmacenApiService);
  private readonly crudService = inject(AlmacenCrudService);
  private readonly dialog = inject(MatDialog);
  private readonly confirmService = inject(SigreModalService);

  readonly codigo = ALMACEN_TABLAS['movimientos-almacen'].codigo;
  readonly nombre = ALMACEN_TABLAS['movimientos-almacen'].titulo;

  grupos: GrupoAlmacen[] = [];
  busqueda = '';
  cargando = true;
  error = '';
  abiertos = new Set<number>();
  crudConfig: TablaCrudConfig | null = crudConfigPorTabla('movimientos-almacen');

  get puedeGestionar(): boolean {
    return this.crudConfig != null;
  }

  /** Grupos filtrados por el texto de búsqueda (almacén o tipo de movimiento). */
  get gruposVisibles(): GrupoAlmacen[] {
    const f = this.busqueda.trim().toLowerCase();
    if (!f) return this.grupos;
    return this.grupos
      .map(g => {
        const coincideAlmacen =
          g.codigo.toLowerCase().includes(f) || g.nombre.toLowerCase().includes(f);
        if (coincideAlmacen) return g;
        const tipos = g.tipos.filter(
          t => t.tipoMov.toLowerCase().includes(f) || (t.descTipoMov ?? '').toLowerCase().includes(f),
        );
        return tipos.length ? { ...g, tipos } : null;
      })
      .filter((g): g is GrupoAlmacen => g != null);
  }

  ngOnInit(): void {
    this.cargar();
  }

  recargar(): void {
    this.cargar();
  }

  toggle(almacenId: number): void {
    if (this.abiertos.has(almacenId)) this.abiertos.delete(almacenId);
    else this.abiertos.add(almacenId);
  }

  estaAbierto(almacenId: number): boolean {
    return this.abiertos.has(almacenId);
  }

  estaActivo(valor: string): boolean {
    return valor === '1';
  }

  anadir(): void {
    if (!this.crudConfig) return;
    const data: AlmacenRegistroDialogData = {
      titulo: 'Asignar tipo de movimiento a almacén',
      config: this.crudConfig,
      registro: null,
    };
    abrirDialogoMetoxi(this.dialog, AlmacenRegistroDialogComponent, { data, width: '720px' })
      .afterClosed()
      .subscribe(ok => { if (ok) this.cargar(); });
  }

  eliminarTipo(grupo: GrupoAlmacen, tipo: AlmacenTipoMovDto): void {
    if (!this.crudConfig || !this.crudService.permiteEliminar(this.crudConfig)) return;
    const etiqueta = `${tipo.tipoMov} — ${tipo.descTipoMov} (${grupo.codigo})`;
    this.confirmService.confirmEliminar$(etiqueta).subscribe(confirmed => {
      if (!confirmed) return;
      this.crudService.eliminar(this.crudConfig!, tipo as unknown as Record<string, unknown>).subscribe({
        next: () => this.cargar(),
        error: err => { this.error = err?.error?.message ?? 'No se pudo quitar el tipo de movimiento'; },
      });
    });
  }

  private cargar(): void {
    this.cargando = true;
    this.error = '';
    this.almacenApi.listarMovimientosPorAlmacen().subscribe({
      next: filas => {
        this.grupos = this.agrupar(filas);
        this.cargando = false;
      },
      error: err => {
        this.cargando = false;
        this.error = err?.error?.message ?? 'No se pudieron cargar los movimientos por almacén';
        this.grupos = [];
      },
    });
  }

  /** Agrupa la lista plana (almacén × tipo) por almacén. */
  private agrupar(filas: AlmacenTipoMovDto[]): GrupoAlmacen[] {
    const mapa = new Map<number, GrupoAlmacen>();
    for (const f of filas) {
      let g = mapa.get(f.almacenId);
      if (!g) {
        g = {
          almacenId: f.almacenId,
          codigo: f.almacenCodigo ?? String(f.almacenId),
          nombre: f.almacenNombre ?? '',
          tipos: [],
        };
        mapa.set(f.almacenId, g);
      }
      g.tipos.push(f);
    }
    const grupos = [...mapa.values()];
    grupos.sort((a, b) => a.codigo.localeCompare(b.codigo, 'es', { numeric: true }));
    for (const g of grupos) {
      g.tipos.sort((a, b) => a.tipoMov.localeCompare(b.tipoMov, 'es', { numeric: true }));
    }
    return grupos;
  }
}
