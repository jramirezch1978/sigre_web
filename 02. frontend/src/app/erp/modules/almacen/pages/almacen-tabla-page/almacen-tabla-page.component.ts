import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { Observable, map, of } from 'rxjs';
import { ErpDataTableComponent } from '../../../../shared/erp-data-table/erp-data-table.component';
import {
  ALMACEN_TABLAS,
  AlmacenTablaKey,
  filtroNumeradorOtr,
  filtroNumeradorVales,
} from '../../config/almacen-tablas.config';
import { tablaKeyPorRutaFrontend } from '../../config/almacen-opciones-menu.config';
import { AlmacenApiService } from '../../services/almacen-api.service';
import { CoreApiService } from '../../services/core-api.service';

@Component({
  selector: 'app-almacen-tabla-page',
  standalone: true,
  imports: [CommonModule, MatButtonModule, MatIconModule, ErpDataTableComponent],
  templateUrl: './almacen-tabla-page.component.html',
  styleUrls: ['./almacen-tabla-page.component.scss'],
})
export class AlmacenTablaPageComponent implements OnInit {
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  private readonly almacenApi = inject(AlmacenApiService);
  private readonly coreApi = inject(CoreApiService);

  titulo = '';
  subtitulo = '';
  columnas = ALMACEN_TABLAS.almacenes.columnas;
  filas: Record<string, unknown>[] = [];
  cargando = true;
  error = '';

  private tablaKey: AlmacenTablaKey = 'almacenes';

  ngOnInit(): void {
    this.route.data.subscribe(data => {
      this.tablaKey =
        (data['tablaKey'] as AlmacenTablaKey) ??
        tablaKeyPorRutaFrontend(this.router.url) ??
        'almacenes';
      const def = ALMACEN_TABLAS[this.tablaKey];
      this.titulo = (data['titulo'] as string) ?? def.titulo;
      this.subtitulo = def.subtitulo ?? '';
      this.columnas = def.columnas;
      this.cargarDatos();
    });
  }

  recargar(): void {
    this.cargarDatos();
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
        return this.coreApi.listarNumeradores().pipe(
          map(items => {
            const filtrados = items.filter(n => filtroNumeradorVales(n.codigo, n.nombre));
            return filtrados.length ? filtrados : items;
          }),
          mapToRows()
        );
      case 'numeracion-otr':
        return this.coreApi.listarNumeradores().pipe(
          map(items => {
            const filtrados = items.filter(n => filtroNumeradorOtr(n.codigo, n.nombre));
            return filtrados.length ? filtrados : items;
          }),
          mapToRows()
        );
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
