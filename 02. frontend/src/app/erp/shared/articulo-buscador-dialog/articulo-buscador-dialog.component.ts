import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpClient, HttpParams } from '@angular/common/http';
import { MatDialogRef } from '@angular/material/dialog';
import { SigreMetoxiModalShellComponent } from '@sigre-common';
import { ApiBaseService } from '../../../services/api-base.service';
import { ApiResponse } from '../models/api-page.model';

export interface ArticuloBuscarItem {
  id: number;
  codigo: string;
  sku: string | null;
  descripcion: string;
  categoria: string | null;
  subCategoria: string | null;
  unidad: string | null;
  precioVenta: number | null;
}

/** Ventana de selección de artículos: listado filtrable (arriba) + equivalencias del seleccionado (abajo). */
@Component({
  selector: 'app-articulo-buscador-dialog',
  standalone: true,
  imports: [CommonModule, FormsModule, SigreMetoxiModalShellComponent],
  templateUrl: './articulo-buscador-dialog.component.html',
  styleUrls: ['./articulo-buscador-dialog.component.scss'],
})
export class ArticuloBuscadorDialogComponent implements OnInit {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);
  private readonly dialogRef = inject(MatDialogRef<ArticuloBuscadorDialogComponent>);

  q = '';
  cargando = false;
  articulos: ArticuloBuscarItem[] = [];
  equivalencias: ArticuloBuscarItem[] = [];
  seleccionado: ArticuloBuscarItem | null = null;
  private articuloPadreId: number | null = null;

  private get base(): string { return `${this.apiBase.getApiBaseUrl()}/core/articulos`; }

  ngOnInit(): void { this.buscar(); }

  buscar(): void {
    this.cargando = true;
    const params = new HttpParams().set('q', this.q.trim());
    this.http.get<ApiResponse<ArticuloBuscarItem[]>>(`${this.base}/buscar`, { params }).subscribe({
      next: res => { this.articulos = res.data ?? []; this.cargando = false; },
      error: () => { this.articulos = []; this.cargando = false; },
    });
  }

  seleccionarArticulo(a: ArticuloBuscarItem): void {
    this.seleccionado = a;
    this.articuloPadreId = a.id;
    this.equivalencias = [];
    this.http.get<ApiResponse<ArticuloBuscarItem[]>>(`${this.base}/equivalencias/${a.id}`).subscribe({
      next: res => { this.equivalencias = res.data ?? []; },
      error: () => { this.equivalencias = []; },
    });
  }

  seleccionarEquivalencia(e: ArticuloBuscarItem): void {
    this.seleccionado = e;
  }

  esSeleccionado(a: ArticuloBuscarItem): boolean {
    return this.seleccionado?.id === a.id;
  }

  esArticuloPadre(a: ArticuloBuscarItem): boolean {
    return this.articuloPadreId === a.id;
  }

  aceptar(): void {
    if (this.seleccionado) this.dialogRef.close(this.seleccionado);
  }

  cancelar(): void { this.dialogRef.close(null); }
}
