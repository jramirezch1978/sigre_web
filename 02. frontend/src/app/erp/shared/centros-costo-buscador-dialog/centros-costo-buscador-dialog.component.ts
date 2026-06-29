import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpClient } from '@angular/common/http';
import { MatDialogRef } from '@angular/material/dialog';
import { SigreMetoxiModalShellComponent } from '@sigre-common';
import { ApiBaseService } from '../../../services/api-base.service';
import { ApiResponse } from '../models/api-page.model';

interface CentroCostoArbolItem {
  id: number;
  cencos: string;
  descCencos: string;
  codN1: string; descN1: string;
  codN2: string; descN2: string;
  codN3: string; descN3: string;
}

export interface CentroCostoLeaf { id: number; cencos: string; descCencos: string; }

interface CcNivel3 { key: string; cod: string; desc: string; leaves: CentroCostoLeaf[]; }
interface CcNivel2 { key: string; cod: string; desc: string; hijos: CcNivel3[]; }
interface CcNivel1 { key: string; cod: string; desc: string; hijos: CcNivel2[]; }

/**
 * Ventana modal de selección de centros de costo en treeview por niveles (niv1 > niv2 > niv3 > centro).
 * Solo activos (los trae el backend). Busca por código o descripción en cualquier nivel.
 * Cierra con el centro (hoja) seleccionado o null.
 */
@Component({
  selector: 'app-centros-costo-buscador-dialog',
  standalone: true,
  imports: [CommonModule, FormsModule, SigreMetoxiModalShellComponent],
  templateUrl: './centros-costo-buscador-dialog.component.html',
  styleUrls: ['./centros-costo-buscador-dialog.component.scss'],
})
export class CentrosCostoBuscadorDialogComponent implements OnInit {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);
  private readonly dialogRef = inject(MatDialogRef<CentrosCostoBuscadorDialogComponent, CentroCostoLeaf | null>);

  filtro = '';
  cargando = false;
  arbolVisible: CcNivel1[] = [];
  expandidos = new Set<string>();
  seleccionado: CentroCostoLeaf | null = null;

  private items: CentroCostoArbolItem[] = [];

  ngOnInit(): void { this.cargar(); }

  private cargar(): void {
    this.cargando = true;
    this.http
      .get<ApiResponse<CentroCostoArbolItem[]>>(`${this.apiBase.getApiBaseUrl()}/contabilidad/centros-costo/arbol`)
      .subscribe({
        next: res => { this.items = res.data ?? []; this.recomputar(); this.cargando = false; },
        error: () => { this.items = []; this.recomputar(); this.cargando = false; },
      });
  }

  estaExpandido(key: string): boolean {
    return this.filtro.trim() !== '' || this.expandidos.has(key);
  }

  toggleNodo(key: string, event: Event): void {
    event.stopPropagation();
    if (this.expandidos.has(key)) this.expandidos.delete(key); else this.expandidos.add(key);
  }

  onFiltro(): void { this.recomputar(); }

  seleccionar(leaf: CentroCostoLeaf): void { this.seleccionado = leaf; }
  esSeleccionada(id: number): boolean { return this.seleccionado?.id === id; }

  aceptar(): void { if (this.seleccionado) this.dialogRef.close(this.seleccionado); }
  limpiar(): void { this.dialogRef.close(null); }
  cancelar(): void { this.dialogRef.close(undefined); }

  private coincide(it: CentroCostoArbolItem): boolean {
    const f = this.filtro.trim().toLowerCase();
    if (!f) return true;
    return [it.cencos, it.descCencos, it.codN1, it.descN1, it.codN2, it.descN2, it.codN3, it.descN3]
      .some(v => (v ?? '').toLowerCase().includes(f));
  }

  private recomputar(): void {
    const filtrados = this.items.filter(it => this.coincide(it));
    const n1 = new Map<string, CcNivel1>();
    for (const it of filtrados) {
      const k1 = it.codN1;
      const k2 = `${it.codN1}|${it.codN2}`;
      const k3 = `${it.codN1}|${it.codN2}|${it.codN3}`;
      let a = n1.get(k1);
      if (!a) { a = { key: k1, cod: it.codN1, desc: it.descN1, hijos: [] }; n1.set(k1, a); }
      let b = a.hijos.find(x => x.key === k2);
      if (!b) { b = { key: k2, cod: it.codN2, desc: it.descN2, hijos: [] }; a.hijos.push(b); }
      let c = b.hijos.find(x => x.key === k3);
      if (!c) { c = { key: k3, cod: it.codN3, desc: it.descN3, leaves: [] }; b.hijos.push(c); }
      c.leaves.push({ id: it.id, cencos: it.cencos, descCencos: it.descCencos });
    }
    this.arbolVisible = [...n1.values()];
  }
}
