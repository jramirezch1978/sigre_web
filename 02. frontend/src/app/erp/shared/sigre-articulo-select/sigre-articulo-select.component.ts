import { Component, forwardRef, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { ApiBaseService } from '../../../services/api-base.service';
import { ApiResponse } from '../models/api-page.model';
import { abrirDialogoMetoxi } from '@sigre-common';
import {
  ArticuloBuscadorDialogComponent, ArticuloBuscarItem,
} from '../articulo-buscador-dialog/articulo-buscador-dialog.component';

interface ArticuloItem { id: number; codigo: string; nombre: string; }

/**
 * Selector de artículo: abre la ventana de búsqueda (listado filtrable + equivalencias).
 * Valor = id del artículo. CVA reutilizable.
 */
@Component({
  selector: 'sigre-articulo-select',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './sigre-articulo-select.component.html',
  styleUrls: ['./sigre-articulo-select.component.scss'],
  providers: [
    { provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => SigreArticuloSelectComponent), multi: true },
  ],
})
export class SigreArticuloSelectComponent implements ControlValueAccessor {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);
  private readonly dialog = inject(MatDialog);

  valor: number | null = null;
  valorLabel = '';
  disabled = false;

  private onChange: (v: number | null) => void = () => {};
  private onTouched: () => void = () => {};

  private get base(): string { return `${this.apiBase.getApiBaseUrl()}/core/articulos`; }

  writeValue(v: number | null): void {
    this.valor = v ?? null;
    if (this.valor != null) {
      this.http.get<ApiResponse<ArticuloItem>>(`${this.base}/lookup/${this.valor}`)
        .subscribe({ next: res => { if (res.data) this.valorLabel = `${res.data.codigo} — ${res.data.nombre}`; } });
    } else {
      this.valorLabel = '';
    }
  }
  registerOnChange(fn: (v: number | null) => void): void { this.onChange = fn; }
  registerOnTouched(fn: () => void): void { this.onTouched = fn; }
  setDisabledState(d: boolean): void { this.disabled = d; }

  get tieneValor(): boolean { return this.valor != null; }
  get etiquetaSeleccionada(): string { return this.valorLabel || 'Buscar artículo…'; }

  abrir(): void {
    if (this.disabled) return;
    abrirDialogoMetoxi<ArticuloBuscadorDialogComponent, unknown, ArticuloBuscarItem | null>(
      this.dialog, ArticuloBuscadorDialogComponent, { width: '900px' },
    ).afterClosed().subscribe(sel => {
      if (sel) {
        this.valor = sel.id;
        this.valorLabel = `${sel.codigo} — ${sel.descripcion}`;
        this.onChange(sel.id);
        this.onTouched();
      }
    });
  }
}
