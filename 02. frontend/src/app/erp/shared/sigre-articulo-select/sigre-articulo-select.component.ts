import { Component, ElementRef, ViewChild, forwardRef, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClient, HttpParams } from '@angular/common/http';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { CdkOverlayOrigin, ConnectedPosition, OverlayModule } from '@angular/cdk/overlay';
import { Subject, debounceTime, switchMap } from 'rxjs';
import { ApiBaseService } from '../../../services/api-base.service';
import { ApiResponse } from '../models/api-page.model';

interface ArticuloItem { id: number; codigo: string; nombre: string; }

/** Select de artículo con búsqueda en servidor (código o nombre). Valor = id del artículo. CVA. */
@Component({
  selector: 'sigre-articulo-select',
  standalone: true,
  imports: [CommonModule, OverlayModule],
  templateUrl: './sigre-articulo-select.component.html',
  styleUrls: ['./sigre-articulo-select.component.scss'],
  providers: [
    { provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => SigreArticuloSelectComponent), multi: true },
  ],
})
export class SigreArticuloSelectComponent implements ControlValueAccessor {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);

  @ViewChild('ssInput') private ssInput?: ElementRef<HTMLInputElement>;

  dropdownAbierto = false;
  filtro = '';
  anchoPanel = 280;
  valor: number | null = null;
  valorLabel = '';
  disabled = false;
  cargando = false;
  resultados: ArticuloItem[] = [];

  readonly posicionesOverlay: ConnectedPosition[] = [
    { originX: 'start', originY: 'bottom', overlayX: 'start', overlayY: 'top', offsetY: 2 },
    { originX: 'start', originY: 'top', overlayX: 'start', overlayY: 'bottom', offsetY: -2 },
  ];

  private readonly busqueda$ = new Subject<string>();
  private onChange: (v: number | null) => void = () => {};
  private onTouched: () => void = () => {};

  constructor() {
    this.busqueda$
      .pipe(
        debounceTime(250),
        switchMap(q => {
          this.cargando = true;
          const params = new HttpParams().set('q', q);
          return this.http.get<ApiResponse<ArticuloItem[]>>(`${this.base}/buscar`, { params });
        }),
      )
      .subscribe({
        next: res => { this.resultados = res.data ?? []; this.cargando = false; },
        error: () => { this.resultados = []; this.cargando = false; },
      });
  }

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
  setDisabledState(d: boolean): void { this.disabled = d; if (d) this.cerrar(); }

  get tieneValor(): boolean { return this.valor != null; }
  get etiquetaSeleccionada(): string { return this.valorLabel || 'Buscar artículo…'; }

  toggleDropdown(origin: CdkOverlayOrigin): void {
    if (this.disabled) return;
    if (this.dropdownAbierto) { this.cerrar(); return; }
    this.anchoPanel = Math.max(origin.elementRef.nativeElement.offsetWidth, 280);
    this.filtro = '';
    this.dropdownAbierto = true;
    this.busqueda$.next('');
    setTimeout(() => this.ssInput?.nativeElement.focus(), 0);
  }

  onFiltro(event: Event): void {
    this.filtro = (event.target as HTMLInputElement).value;
    this.busqueda$.next(this.filtro.trim());
  }

  seleccionar(a: ArticuloItem): void {
    this.valor = a.id;
    this.valorLabel = `${a.codigo} — ${a.nombre}`;
    this.onChange(a.id);
    this.onTouched();
    this.cerrar();
  }

  cerrar(): void { this.dropdownAbierto = false; this.filtro = ''; }
}
