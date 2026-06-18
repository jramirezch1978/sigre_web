import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { ErpDataTableComponent } from '../../../../shared/erp-data-table/erp-data-table.component';
import { TablaColumna } from '../../../../shared/models/api-page.model';
import { AlmacenVistaDef, ALMACEN_VISTAS_POR_RUTA } from '../../config/almacen-vistas.config';
import { AlmacenApiService } from '../../services/almacen-api.service';

@Component({
  selector: 'app-almacen-listado-page',
  standalone: true,
  imports: [CommonModule, MatButtonModule, MatIconModule, ErpDataTableComponent],
  templateUrl: './almacen-listado-page.component.html',
  styleUrls: ['./almacen-listado-page.component.scss'],
})
export class AlmacenListadoPageComponent implements OnInit {
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  private readonly almacenApi = inject(AlmacenApiService);

  titulo = '';
  subtitulo = '';
  columnas: TablaColumna[] = [];
  filas: Record<string, unknown>[] = [];
  cargando = true;
  error = '';

  private vista: AlmacenVistaDef | null = null;

  ngOnInit(): void {
    this.route.data.subscribe(data => {
      const ruta = (data['rutaFrontend'] as string) ?? this.normalizarRuta(this.router.url);
      this.vista = (data['vista'] as AlmacenVistaDef) ?? ALMACEN_VISTAS_POR_RUTA[ruta] ?? null;
      this.titulo = (data['titulo'] as string) ?? this.vista?.nombre ?? 'Consulta';
      this.subtitulo = (data['subtitulo'] as string) ?? this.vista?.subtitulo ?? '';
      this.columnas = (data['columnas'] as TablaColumna[]) ?? this.vista?.columnas ?? [];
      this.cargarDatos();
    });
  }

  recargar(): void {
    this.cargarDatos();
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
