import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { ErpDataTableComponent } from '../../../../shared/erp-data-table/erp-data-table.component';
import { TablaColumna } from '../../../../shared/models/api-page.model';
import { AlmacenVistaDef, ALMACEN_VISTAS_POR_RUTA } from '../../config/almacen-vistas.config';
import { crudConfigPorCodigoVista, VistaCrudConfig } from '../../config/almacen-vista-crud.config';
import { AlmacenApiService } from '../../services/almacen-api.service';
import { AlmacenCrudService } from '../../services/almacen-crud.service';
import { SigreModalService } from '@sigre-common';
import {
  AlmacenRegistroDialogComponent,
  AlmacenRegistroDialogData,
} from '../../components/almacen-registro-dialog/almacen-registro-dialog.component';

@Component({
  selector: 'app-almacen-listado-page',
  standalone: true,
  imports: [CommonModule, MatDialogModule, ErpDataTableComponent],
  templateUrl: './almacen-listado-page.component.html',
  styleUrls: ['./almacen-listado-page.component.scss'],
})
export class AlmacenListadoPageComponent implements OnInit {
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  private readonly almacenApi = inject(AlmacenApiService);
  private readonly crudService = inject(AlmacenCrudService);
  private readonly dialog = inject(MatDialog);
  private readonly confirmService = inject(SigreModalService);

  titulo = '';
  subtitulo = '';
  columnas: TablaColumna[] = [];
  filas: Record<string, unknown>[] = [];
  cargando = true;
  error = '';
  crudConfig: VistaCrudConfig | null = null;

  private vista: AlmacenVistaDef | null = null;

  get puedeGestionar(): boolean {
    return this.crudConfig != null;
  }

  ngOnInit(): void {
    this.route.data.subscribe(data => {
      const ruta = (data['rutaFrontend'] as string) ?? this.normalizarRuta(this.router.url);
      this.vista = (data['vista'] as AlmacenVistaDef) ?? ALMACEN_VISTAS_POR_RUTA[ruta] ?? null;
      this.titulo = (data['titulo'] as string) ?? this.vista?.nombre ?? 'Consulta';
      this.subtitulo = (data['subtitulo'] as string) ?? this.vista?.subtitulo ?? '';
      this.columnas = (data['columnas'] as TablaColumna[]) ?? this.vista?.columnas ?? [];
      this.crudConfig = this.vista ? crudConfigPorCodigoVista(this.vista.codigo) : null;
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
          this.error = err?.error?.message ?? 'No se pudo anular';
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
          this.error = err?.error?.message ?? 'No se pudo eliminar';
        },
      });
    });
  }

  private etiquetaRegistro(fila: Record<string, unknown>): string {
    return String(fila['numero'] ?? fila['nroVale'] ?? fila['nombre'] ?? fila['codigo'] ?? fila['id'] ?? 'registro');
  }

  private abrirDialogo(titulo: string, registro: Record<string, unknown> | null): void {
    if (!this.crudConfig) return;
    const data: AlmacenRegistroDialogData = {
      titulo,
      config: this.crudConfig,
      registro,
    };
    this.dialog
      .open(AlmacenRegistroDialogComponent, { data, width: '560px', disableClose: true })
      .afterClosed()
      .subscribe(ok => {
        if (ok) this.cargarDatos();
      });
  }

  private normalizarRuta(url: string): string {
    const sinQuery = url.split('?')[0];
    return sinQuery.startsWith('/sigre/') ? sinQuery : `/sigre${sinQuery.startsWith('/') ? '' : '/'}${sinQuery}`;
  }

  private cargarDatos(): void {
    const apiPath = this.vista?.apiPath;
    if (!apiPath) {
      this.cargando = false;
      this.error = 'Vista no configurada';
      return;
    }

    this.cargando = true;
    this.error = '';
    this.almacenApi.consultarVista(apiPath).subscribe({
      next: rows => {
        this.filas = rows;
        this.cargando = false;
      },
      error: err => {
        this.cargando = false;
        this.error = err?.error?.message ?? 'No se pudieron cargar los datos';
        this.filas = [];
      },
    });
  }
}
