import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { Observable, map, of } from 'rxjs';
import { ErpDataTableComponent } from '../../../../shared/erp-data-table/erp-data-table.component';
import { ErpMetoxiListPageComponent, ErpMetoxiFiltroTab } from '../../../../shared/erp-metoxi-list-page/erp-metoxi-list-page.component';
import { contarRegistrosPorEstado, filtrarFilasListado } from '../../../../shared/utils/erp-list-filter.util';
import {
  ALMACEN_TABLAS,
  AlmacenTablaKey,
} from '../../config/almacen-tablas.config';
import {
  ALMACEN_NUMERADOR_TABLA_OTR,
  ALMACEN_NUMERADOR_TABLA_VALES,
} from '../../config/almacen-opciones-menu.config';
import { tablaKeyPorRutaFrontend } from '../../config/almacen-opciones-menu.config';
import { crudConfigPorTabla, TablaCrudConfig } from '../../config/almacen-tabla-crud.config';
import { AlmacenApiService } from '../../services/almacen-api.service';
import { AlmacenCrudService } from '../../services/almacen-crud.service';
import { CoreApiService } from '../../services/core-api.service';
import { SigreModalService } from '@sigre-common';
import {
  AlmacenRegistroDialogComponent,
  AlmacenRegistroDialogData,
} from '../../components/almacen-registro-dialog/almacen-registro-dialog.component';

@Component({
  selector: 'app-almacen-tabla-page',
  standalone: true,
  imports: [CommonModule, MatDialogModule, ErpDataTableComponent, ErpMetoxiListPageComponent],
  templateUrl: './almacen-tabla-page.component.html',
  styleUrls: ['./almacen-tabla-page.component.scss'],
})
export class AlmacenTablaPageComponent implements OnInit {
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  private readonly almacenApi = inject(AlmacenApiService);
  private readonly coreApi = inject(CoreApiService);
  private readonly crudService = inject(AlmacenCrudService);
  private readonly dialog = inject(MatDialog);
  private readonly confirmService = inject(SigreModalService);

  titulo = '';
  subtitulo = '';
  columnas = ALMACEN_TABLAS.almacenes.columnas;
  filas: Record<string, unknown>[] = [];
  busqueda = '';
  filtroTab: ErpMetoxiFiltroTab = 'todos';
  cargando = true;
  error = '';
  crudConfig: TablaCrudConfig | null = null;

  private tablaKey: AlmacenTablaKey = 'almacenes';
  private nombreTablaDocumento: string | null = null;

  get puedeGestionar(): boolean {
    return this.crudConfig != null;
  }

  get tieneColumnaEstado(): boolean {
    return this.columnas.some(c => c.format === 'estado');
  }

  get conteo() {
    return contarRegistrosPorEstado(this.filas);
  }

  get filasVisibles(): Record<string, unknown>[] {
    return filtrarFilasListado(this.filas, this.columnas, this.busqueda, this.filtroTab);
  }

  ngOnInit(): void {
    this.route.data.subscribe(data => {
      this.tablaKey =
        (data['tablaKey'] as AlmacenTablaKey) ??
        tablaKeyPorRutaFrontend(this.router.url) ??
        'almacenes';
      this.nombreTablaDocumento = (data['nombreTablaDocumento'] as string | null) ?? null;
      const def = ALMACEN_TABLAS[this.tablaKey];
      this.titulo = (data['titulo'] as string) ?? def.titulo;
      this.subtitulo = def.subtitulo ?? '';
      this.columnas = def.columnas;
      this.crudConfig = crudConfigPorTabla(this.tablaKey);
      this.cargarDatos();
    });
  }

  recargar(): void {
    this.cargarDatos();
  }

  anadir(): void {
    if (!this.crudConfig) return;
    this.abrirDialogo('Nuevo registro', null);
  }

  editarRegistro(fila: Record<string, unknown>): void {
    if (!this.crudConfig) return;
    if (this.crudConfig.handler === 'tipo-mov-asignacion') return;
    this.abrirDialogo('Editar registro', fila);
  }

  anularRegistro(fila: Record<string, unknown>): void {
    if (!this.crudConfig || !this.crudService.permiteAnular(this.crudConfig)) return;
    const nombre = this.etiquetaRegistro(fila);

    this.confirmService.confirmAnular$(nombre).subscribe(confirmed => {
      if (!confirmed) return;
      this.crudService.anular(this.crudConfig!, fila).subscribe({
        next: () => this.cargarDatos(),
        error: err => {
          this.error = err?.error?.message ?? 'No se pudo anular el registro';
        },
      });
    });
  }

  eliminarRegistro(fila: Record<string, unknown>): void {
    if (!this.crudConfig || !this.crudService.permiteEliminar(this.crudConfig)) return;
    const nombre = this.etiquetaRegistro(fila);

    this.confirmService.confirmEliminar$(nombre).subscribe(confirmed => {
      if (!confirmed) return;
      this.crudService.eliminar(this.crudConfig!, fila).subscribe({
        next: () => this.cargarDatos(),
        error: err => {
          this.error = err?.error?.message ?? 'No se pudo eliminar el registro';
        },
      });
    });
  }

  private abrirDialogo(titulo: string, registro: Record<string, unknown> | null): void {
    if (!this.crudConfig) return;

    const data: AlmacenRegistroDialogData = {
      titulo,
      config: this.crudConfig,
      registro,
    };

    this.dialog
      .open(AlmacenRegistroDialogComponent, {
        data,
        width: '960px',
        maxWidth: '98vw',
        disableClose: true,
        panelClass: 'sigre-metoxi-dialog-panel',
      })
      .afterClosed()
      .subscribe(ok => {
        if (ok) this.cargarDatos();
      });
  }

  private etiquetaRegistro(fila: Record<string, unknown>): string {
    return String(
      fila['nombre'] ?? fila['descTipoMov'] ?? fila['codigo'] ?? fila['clave'] ?? fila['nroLote'] ?? fila['id'] ?? ''
    );
  }

  private cargarDatos(): void {
    this.cargando = true;
    this.error = '';
    this.obtenerDatos().subscribe({
      next: rows => {
        this.filas = rows as Record<string, unknown>[];
        this.cargando = false;
      },
      error: err => {
        this.cargando = false;
        this.error = err?.error?.message ?? 'No se pudieron cargar los registros';
        this.filas = [];
      },
    });
  }

  private obtenerDatos(): Observable<Record<string, unknown>[]> {
    switch (this.tablaKey) {
      case 'almacenes':
        return this.almacenApi.listarAlmacenes().pipe(mapToRows());
      case 'tipos-movimiento':
        return this.almacenApi.listarTiposMovimiento().pipe(mapToRows());
      case 'tipos-almacen':
        return this.almacenApi.listarTiposAlmacen().pipe(mapToRows());
      case 'ubicaciones':
        return this.almacenApi.listarUbicacionesTodas().pipe(mapToRows());
      case 'movimientos-almacen':
        return this.almacenApi.listarMovimientosPorAlmacen().pipe(mapToRows());
      case 'posiciones':
        return this.almacenApi.listarUbicacionesTodas().pipe(mapToRows());
      case 'motivos-traslado':
        return this.almacenApi.listarMotivosTraslado().pipe(mapToRows());
      case 'lotes':
        return this.almacenApi.listarLotes().pipe(mapToRows());
      case 'unidades-conversion':
        return this.coreApi.listarConversionesUnidad().pipe(mapToRows());
      case 'numeracion-vales':
        return this.coreApi
          .listarNumeradoresDocumento(this.nombreTablaDocumento ?? ALMACEN_NUMERADOR_TABLA_VALES)
          .pipe(mapToRows());
      case 'numeracion-otr':
        return this.coreApi
          .listarNumeradoresDocumento(this.nombreTablaDocumento ?? ALMACEN_NUMERADOR_TABLA_OTR)
          .pipe(mapToRows());
      case 'parametros':
        return this.coreApi.listarParametrosAlmacenConValor().pipe(mapToRows());
      default:
        return of([]);
    }
  }
}

function mapToRows<T extends object>() {
  return map((items: T[]) => items as unknown as Record<string, unknown>[]);
}
