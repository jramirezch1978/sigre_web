import { Component, OnInit, forwardRef, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { abrirDialogoMetoxi } from '@sigre-common';
import { ApiBaseService } from '../../../services/api-base.service';
import { ApiResponse } from '../models/api-page.model';
import {
  CentrosCostoBuscadorDialogComponent, CentroCostoLeaf,
} from '../centros-costo-buscador-dialog/centros-costo-buscador-dialog.component';

interface CentroCostoArbolItem {
  id: number; cencos: string; descCencos: string;
}

/**
 * Selector de centro de costo: abre la ventana modal con treeview por niveles (no dropdown).
 * Valor = id del centro (hoja). CVA reutilizable.
 */
@Component({
  selector: 'sigre-centros-costo-select',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './sigre-centros-costo-select.component.html',
  styleUrls: ['./sigre-centros-costo-select.component.scss'],
  providers: [
    { provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => SigreCentrosCostoSelectComponent), multi: true },
  ],
})
export class SigreCentrosCostoSelectComponent implements OnInit, ControlValueAccessor {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);
  private readonly dialog = inject(MatDialog);

  valor: number | null = null;
  valorLabel = '';
  disabled = false;

  private mapaLeaf = new Map<number, CentroCostoArbolItem>();

  private onChange: (v: number | null) => void = () => {};
  private onTouched: () => void = () => {};

  ngOnInit(): void { this.cargarMapa(); }

  // ── ControlValueAccessor ──
  writeValue(v: number | null): void { this.valor = v ?? null; this.resolverLabel(); }
  registerOnChange(fn: (v: number | null) => void): void { this.onChange = fn; }
  registerOnTouched(fn: () => void): void { this.onTouched = fn; }
  setDisabledState(d: boolean): void { this.disabled = d; }

  get tieneValor(): boolean { return this.valor != null; }
  get etiquetaSeleccionada(): string { return this.valorLabel || '— Sin asignar —'; }

  /** Carga el árbol solo para resolver la etiqueta del id ya guardado (edición). */
  private cargarMapa(): void {
    this.http
      .get<ApiResponse<CentroCostoArbolItem[]>>(`${this.apiBase.getApiBaseUrl()}/contabilidad/centros-costo/arbol`)
      .subscribe({
        next: res => {
          this.mapaLeaf = new Map((res.data ?? []).map(i => [i.id, i]));
          this.resolverLabel();
        },
        error: () => { /* la etiqueta queda como id; el modal igual permite elegir */ },
      });
  }

  private resolverLabel(): void {
    if (this.valor == null) { this.valorLabel = ''; return; }
    const l = this.mapaLeaf.get(this.valor);
    this.valorLabel = l ? `${l.cencos} — ${l.descCencos}` : '';
  }

  abrir(): void {
    if (this.disabled) return;
    abrirDialogoMetoxi<CentrosCostoBuscadorDialogComponent, unknown, CentroCostoLeaf | null>(
      this.dialog, CentrosCostoBuscadorDialogComponent, { width: '760px' },
    ).afterClosed().subscribe(sel => {
      // undefined => cancelado (no tocar). null => "Sin asignar". objeto => seleccion.
      if (sel === undefined) return;
      if (sel === null) {
        this.valor = null;
        this.valorLabel = '';
      } else {
        this.valor = sel.id;
        this.valorLabel = `${sel.cencos} — ${sel.descCencos}`;
        this.mapaLeaf.set(sel.id, sel);
      }
      this.onChange(this.valor);
      this.onTouched();
    });
  }
}
