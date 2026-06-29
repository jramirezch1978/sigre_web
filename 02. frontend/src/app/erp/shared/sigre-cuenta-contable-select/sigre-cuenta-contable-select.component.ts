import { Component, ElementRef, OnInit, ViewChild, forwardRef, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { ControlValueAccessor, FormsModule, NG_VALUE_ACCESSOR } from '@angular/forms';
import { CdkOverlayOrigin, ConnectedPosition, OverlayModule } from '@angular/cdk/overlay';
import { ApiBaseService } from '../../../services/api-base.service';
import { ApiResponse } from '../models/api-page.model';

interface PlanItem { id: number; codigo: string; nombre: string; anio: number; }
interface CuentaArbolItem {
  id: number; cntaCtbl: string; descCnta: string;
  codN1: string; descN1: string; codN2: string; descN2: string;
  codN3: string; descN3: string; codN4: string; descN4: string;
}
interface CuentaResumen { id: number; planContableId: number; cntaCtbl: string; descCnta: string; }

interface NivLeaf { id: number; cntaCtbl: string; descCnta: string; }
interface Niv4 { key: string; cod: string; desc: string; leaves: NivLeaf[]; }
interface Niv3 { key: string; cod: string; desc: string; hijos: Niv4[]; }
interface Niv2 { key: string; cod: string; desc: string; hijos: Niv3[]; }
interface Niv1 { key: string; cod: string; desc: string; hijos: Niv2[]; }

/**
 * Selector de cuenta contable: cabecera para elegir el plan contable y detalle en treeview
 * de 5 niveles (por longitud de código) con búsqueda por código o descripción. Solo cuentas
 * activas. Valor = id de la cuenta hoja (plan_contable_det.id). CVA reutilizable.
 */
@Component({
  selector: 'sigre-cuenta-contable-select',
  standalone: true,
  imports: [CommonModule, FormsModule, OverlayModule],
  templateUrl: './sigre-cuenta-contable-select.component.html',
  styleUrls: ['./sigre-cuenta-contable-select.component.scss'],
  providers: [
    { provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => SigreCuentaContableSelectComponent), multi: true },
  ],
})
export class SigreCuentaContableSelectComponent implements OnInit, ControlValueAccessor {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);

  @ViewChild('ssInput') private ssInput?: ElementRef<HTMLInputElement>;

  dropdownAbierto = false;
  filtro = '';
  anchoPanel = 360;
  valor: number | null = null;
  valorLabel = '';
  disabled = false;
  cargandoArbol = false;

  planes: PlanItem[] = [];
  planSeleccionadoId: number | null = null;

  private items: CuentaArbolItem[] = [];
  arbolVisible: Niv1[] = [];
  expandidos = new Set<string>();

  readonly posicionesOverlay: ConnectedPosition[] = [
    { originX: 'start', originY: 'bottom', overlayX: 'start', overlayY: 'top', offsetY: 2 },
    { originX: 'start', originY: 'top', overlayX: 'start', overlayY: 'bottom', offsetY: -2 },
  ];

  private onChange: (v: number | null) => void = () => {};
  private onTouched: () => void = () => {};

  private get base(): string { return `${this.apiBase.getApiBaseUrl()}/contabilidad/plan-contable`; }

  ngOnInit(): void { this.cargarPlanes(); }

  // ── ControlValueAccessor ──
  writeValue(v: number | null): void {
    this.valor = v ?? null;
    if (this.valor != null) this.resolverSeleccion(this.valor);
    else this.valorLabel = '';
  }
  registerOnChange(fn: (v: number | null) => void): void { this.onChange = fn; }
  registerOnTouched(fn: () => void): void { this.onTouched = fn; }
  setDisabledState(d: boolean): void { this.disabled = d; if (d) this.cerrar(); }

  private cargarPlanes(): void {
    this.http.get<ApiResponse<PlanItem[]>>(`${this.base}/planes`).subscribe({
      next: res => {
        this.planes = res.data ?? [];
        if (this.planSeleccionadoId == null && this.planes.length) {
          this.planSeleccionadoId = this.planes[0].id;
        }
      },
    });
  }

  private resolverSeleccion(id: number): void {
    this.http.get<ApiResponse<CuentaResumen>>(`${this.base}/det/${id}`).subscribe({
      next: res => {
        const c = res.data;
        if (c) {
          this.valorLabel = `${c.cntaCtbl} — ${c.descCnta}`;
          this.planSeleccionadoId = c.planContableId;
        }
      },
    });
  }

  private cargarArbol(): void {
    if (this.planSeleccionadoId == null) { this.items = []; this.recomputar(); return; }
    this.cargandoArbol = true;
    this.http
      .get<ApiResponse<CuentaArbolItem[]>>(`${this.base}/arbol`, { params: { planContableId: String(this.planSeleccionadoId) } })
      .subscribe({
        next: res => { this.items = res.data ?? []; this.recomputar(); this.cargandoArbol = false; },
        error: () => { this.cargandoArbol = false; },
      });
  }

  get tieneValor(): boolean { return this.valor != null; }
  get etiquetaSeleccionada(): string { return this.valorLabel || '— Sin asignar —'; }

  estaExpandido(key: string): boolean { return this.filtro.trim() !== '' || this.expandidos.has(key); }
  toggleNodo(key: string, event: Event): void {
    event.stopPropagation();
    if (this.expandidos.has(key)) this.expandidos.delete(key); else this.expandidos.add(key);
  }

  toggleDropdown(origin: CdkOverlayOrigin): void {
    if (this.disabled) return;
    if (this.dropdownAbierto) { this.cerrar(); return; }
    this.anchoPanel = Math.max(origin.elementRef.nativeElement.offsetWidth, 360);
    this.filtro = '';
    this.dropdownAbierto = true;
    this.cargarArbol();
    setTimeout(() => this.ssInput?.nativeElement.focus(), 0);
  }

  onPlanChange(): void {
    this.expandidos.clear();
    this.filtro = '';
    this.cargarArbol();
  }

  onFiltro(event: Event): void { this.filtro = (event.target as HTMLInputElement).value; this.recomputar(); }

  seleccionar(leaf: NivLeaf): void {
    this.valor = leaf.id;
    this.valorLabel = `${leaf.cntaCtbl} — ${leaf.descCnta}`;
    this.onChange(leaf.id);
    this.onTouched();
    this.cerrar();
  }

  limpiar(): void {
    this.valor = null; this.valorLabel = '';
    this.onChange(null); this.onTouched();
    this.cerrar();
  }

  cerrar(): void { this.dropdownAbierto = false; this.filtro = ''; }
  esSeleccionada(id: number): boolean { return id === this.valor; }

  private coincide(it: CuentaArbolItem): boolean {
    const f = this.filtro.trim().toLowerCase();
    if (!f) return true;
    return [it.cntaCtbl, it.descCnta, it.codN1, it.descN1, it.codN2, it.descN2, it.codN3, it.descN3, it.codN4, it.descN4]
      .some(v => (v ?? '').toLowerCase().includes(f));
  }

  private recomputar(): void {
    const filtrados = this.items.filter(it => this.coincide(it));
    const n1 = new Map<string, Niv1>();
    for (const it of filtrados) {
      const k1 = it.codN1;
      const k2 = `${it.codN1}|${it.codN2}`;
      const k3 = `${k2}|${it.codN3}`;
      const k4 = `${k3}|${it.codN4}`;
      let a = n1.get(k1);
      if (!a) { a = { key: k1, cod: it.codN1, desc: it.descN1, hijos: [] }; n1.set(k1, a); }
      let b = a.hijos.find(x => x.key === k2);
      if (!b) { b = { key: k2, cod: it.codN2, desc: it.descN2, hijos: [] }; a.hijos.push(b); }
      let c = b.hijos.find(x => x.key === k3);
      if (!c) { c = { key: k3, cod: it.codN3, desc: it.descN3, hijos: [] }; b.hijos.push(c); }
      let d = c.hijos.find(x => x.key === k4);
      if (!d) { d = { key: k4, cod: it.codN4, desc: it.descN4, leaves: [] }; c.hijos.push(d); }
      d.leaves.push({ id: it.id, cntaCtbl: it.cntaCtbl, descCnta: it.descCnta });
    }
    this.arbolVisible = [...n1.values()];
  }
}
