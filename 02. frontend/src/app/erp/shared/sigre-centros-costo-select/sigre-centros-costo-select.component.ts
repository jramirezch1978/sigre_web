import { Component, ElementRef, OnInit, ViewChild, forwardRef, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { CdkOverlayOrigin, ConnectedPosition, OverlayModule } from '@angular/cdk/overlay';
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

interface CcNivel3 { key: string; cod: string; desc: string; leaves: { id: number; cencos: string; descCencos: string }[]; }
interface CcNivel2 { key: string; cod: string; desc: string; hijos: CcNivel3[]; }
interface CcNivel1 { key: string; cod: string; desc: string; hijos: CcNivel2[]; }

/**
 * Select buscable de centros de costo con jerarquía (niv1 > niv2 > niv3 > centro) en treeview.
 * Solo centros activos (los trae el backend). Busca por código o descripción en cualquier nivel.
 * Valor seleccionado = id del centro de costo (hoja). CVA → [(ngModel)] o reactive forms.
 */
@Component({
  selector: 'sigre-centros-costo-select',
  standalone: true,
  imports: [CommonModule, OverlayModule],
  templateUrl: './sigre-centros-costo-select.component.html',
  styleUrls: ['./sigre-centros-costo-select.component.scss'],
  providers: [
    { provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => SigreCentrosCostoSelectComponent), multi: true },
  ],
})
export class SigreCentrosCostoSelectComponent implements OnInit, ControlValueAccessor {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);

  @ViewChild('ssInput') private ssInput?: ElementRef<HTMLInputElement>;

  dropdownAbierto = false;
  filtro = '';
  anchoPanel = 320;
  valor: number | null = null;
  disabled = false;
  cargando = false;

  private items: CentroCostoArbolItem[] = [];
  private mapaLeaf = new Map<number, CentroCostoArbolItem>();
  arbolVisible: CcNivel1[] = [];
  expandidos = new Set<string>();

  readonly posicionesOverlay: ConnectedPosition[] = [
    { originX: 'start', originY: 'bottom', overlayX: 'start', overlayY: 'top', offsetY: 2 },
    { originX: 'start', originY: 'top', overlayX: 'start', overlayY: 'bottom', offsetY: -2 },
  ];

  private onChange: (v: number | null) => void = () => {};
  private onTouched: () => void = () => {};

  ngOnInit(): void {
    this.cargar();
  }

  // ── ControlValueAccessor ──
  writeValue(v: number | null): void { this.valor = v ?? null; }
  registerOnChange(fn: (v: number | null) => void): void { this.onChange = fn; }
  registerOnTouched(fn: () => void): void { this.onTouched = fn; }
  setDisabledState(d: boolean): void { this.disabled = d; if (d) this.cerrar(); }

  private cargar(): void {
    this.cargando = true;
    this.http
      .get<ApiResponse<CentroCostoArbolItem[]>>(`${this.apiBase.getApiBaseUrl()}/contabilidad/centros-costo/arbol`)
      .subscribe({
        next: res => {
          this.items = res.data ?? [];
          this.mapaLeaf = new Map(this.items.map(i => [i.id, i]));
          this.recomputar();
          this.cargando = false;
        },
        error: () => { this.cargando = false; },
      });
  }

  get tieneValor(): boolean { return this.valor != null; }

  get etiquetaSeleccionada(): string {
    if (this.valor == null) return '— Sin asignar —';
    const l = this.mapaLeaf.get(this.valor);
    return l ? `${l.cencos} — ${l.descCencos}` : '— Sin asignar —';
  }

  estaExpandido(key: string): boolean {
    return this.filtro.trim() !== '' || this.expandidos.has(key);
  }

  toggleNodo(key: string, event: Event): void {
    event.stopPropagation();
    if (this.expandidos.has(key)) this.expandidos.delete(key); else this.expandidos.add(key);
  }

  toggleDropdown(origin: CdkOverlayOrigin): void {
    if (this.disabled) return;
    if (this.dropdownAbierto) { this.cerrar(); return; }
    this.anchoPanel = Math.max(origin.elementRef.nativeElement.offsetWidth, 320);
    this.filtro = '';
    this.recomputar();
    this.dropdownAbierto = true;
    setTimeout(() => this.ssInput?.nativeElement.focus(), 0);
  }

  onFiltro(event: Event): void {
    this.filtro = (event.target as HTMLInputElement).value;
    this.recomputar();
  }

  seleccionar(id: number): void {
    this.valor = id;
    this.onChange(id);
    this.onTouched();
    this.cerrar();
  }

  limpiar(): void {
    this.valor = null;
    this.onChange(null);
    this.onTouched();
    this.cerrar();
  }

  cerrar(): void {
    this.dropdownAbierto = false;
    this.filtro = '';
  }

  esSeleccionada(id: number): boolean { return id === this.valor; }

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
