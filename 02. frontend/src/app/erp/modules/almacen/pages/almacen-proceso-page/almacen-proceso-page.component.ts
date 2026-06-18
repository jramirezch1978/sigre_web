import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { AlmacenVistaDef, ALMACEN_VISTAS_POR_RUTA } from '../../config/almacen-vistas.config';
import { AlmacenApiService } from '../../services/almacen-api.service';

@Component({
  selector: 'app-almacen-proceso-page',
  standalone: true,
  imports: [CommonModule, MatButtonModule, MatIconModule],
  templateUrl: './almacen-proceso-page.component.html',
  styleUrls: ['./almacen-proceso-page.component.scss'],
})
export class AlmacenProcesoPageComponent implements OnInit {
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  private readonly almacenApi = inject(AlmacenApiService);

  titulo = '';
  subtitulo = '';
  ejecutando = false;
  mensaje = '';
  esError = false;

  private procesoPath = '';

  ngOnInit(): void {
    this.route.data.subscribe(data => {
      const ruta = (data['rutaFrontend'] as string) ?? this.normalizarRuta(this.router.url);
      const vista = (data['vista'] as AlmacenVistaDef) ?? ALMACEN_VISTAS_POR_RUTA[ruta] ?? null;
      this.titulo = (data['titulo'] as string) ?? vista?.nombre ?? 'Proceso';
      this.subtitulo = (data['subtitulo'] as string) ?? vista?.subtitulo ?? '';
      this.procesoPath = (data['procesoPath'] as string) ?? vista?.procesoPath ?? '';
    });
  }

  ejecutar(): void {
    if (!this.procesoPath || this.ejecutando) return;

    this.ejecutando = true;
    this.mensaje = '';
    this.esError = false;

    this.almacenApi.ejecutarProceso(this.procesoPath).subscribe({
      next: res => {
        this.ejecutando = false;
        const detalle = res?.mensaje ?? res?.detalle ?? JSON.stringify(res, null, 2);
        this.mensaje = typeof detalle === 'string' ? detalle : 'Proceso completado correctamente.';
      },
      error: err => {
        this.ejecutando = false;
        this.esError = true;
        this.mensaje = err?.error?.message ?? 'Error al ejecutar el proceso';
      },
    });
  }

  private normalizarRuta(url: string): string {
    const sinQuery = url.split('?')[0];
    return sinQuery.startsWith('/sigre/') ? sinQuery : `/sigre${sinQuery.startsWith('/') ? '' : '/'}${sinQuery}`;
  }
}
