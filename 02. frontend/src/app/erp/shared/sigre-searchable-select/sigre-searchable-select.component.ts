import { Component, ElementRef, Input, ViewChild, forwardRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { CdkOverlayOrigin, ConnectedPosition, OverlayModule } from '@angular/cdk/overlay';

export interface SigreSelectOption {
  value: string | number | null;
  label: string;
}

/**
 * Select buscable reutilizable (ControlValueAccessor → sirve con [(ngModel)] y reactive forms).
 * Autónomo de Bootstrap: estiliza su propio toggle. El panel se proyecta vía CDK Overlay
 * (no se recorta con scroll/overflow del contenedor) y reutiliza los estilos globales .sigre-ss__*.
 */
@Component({
  selector: 'sigre-searchable-select',
  standalone: true,
  imports: [CommonModule, OverlayModule],
  templateUrl: './sigre-searchable-select.component.html',
  styleUrls: ['./sigre-searchable-select.component.scss'],
  providers: [
    {
      provide: NG_VALUE_ACCESSOR,
      useExisting: forwardRef(() => SigreSearchableSelectComponent),
      multi: true,
    },
  ],
})
export class SigreSearchableSelectComponent implements ControlValueAccessor {
  @Input() options: SigreSelectOption[] = [];
  @Input() placeholder = 'Seleccione…';
  /** Muestra una opción para limpiar el valor (al inicio de la lista). */
  @Input() permitirVacio = true;

  @ViewChild('ssInput') private ssInput?: ElementRef<HTMLInputElement>;

  dropdownAbierto = false;
  filtro = '';
  anchoPanel = 240;
  valor: string | number | null = null;
  disabled = false;

  readonly posicionesOverlay: ConnectedPosition[] = [
    { originX: 'start', originY: 'bottom', overlayX: 'start', overlayY: 'top', offsetY: 2 },
    { originX: 'start', originY: 'top', overlayX: 'start', overlayY: 'bottom', offsetY: -2 },
  ];

  private onChange: (valor: string | number | null) => void = () => {};
  private onTouched: () => void = () => {};

  // ── ControlValueAccessor ──
  writeValue(valor: string | number | null): void {
    this.valor = valor ?? null;
  }
  registerOnChange(fn: (valor: string | number | null) => void): void {
    this.onChange = fn;
  }
  registerOnTouched(fn: () => void): void {
    this.onTouched = fn;
  }
  setDisabledState(disabled: boolean): void {
    this.disabled = disabled;
    if (disabled) this.cerrarDropdown();
  }

  get tieneValor(): boolean {
    return this.valor !== null && this.valor !== undefined && this.valor !== '';
  }

  get etiquetaSeleccionada(): string {
    if (!this.tieneValor) return this.placeholder;
    const opt = this.options.find(o => String(o.value) === String(this.valor));
    return opt ? opt.label : this.placeholder;
  }

  get opcionesFiltradas(): SigreSelectOption[] {
    const f = this.filtro.trim().toLowerCase();
    if (!f) return this.options;
    return this.options.filter(o =>
      o.label.toLowerCase().includes(f) || String(o.value ?? '').toLowerCase().includes(f));
  }

  esSeleccionada(value: string | number | null): boolean {
    return String(value) === String(this.valor);
  }

  toggleDropdown(origin: CdkOverlayOrigin): void {
    if (this.disabled) return;
    if (this.dropdownAbierto) {
      this.cerrarDropdown();
      return;
    }
    this.anchoPanel = origin.elementRef.nativeElement.offsetWidth || 240;
    this.filtro = '';
    this.dropdownAbierto = true;
    setTimeout(() => this.ssInput?.nativeElement.focus(), 0);
  }

  onFiltro(event: Event): void {
    this.filtro = (event.target as HTMLInputElement).value;
  }

  seleccionar(value: string | number | null): void {
    this.valor = value;
    this.onChange(value);
    this.onTouched();
    this.cerrarDropdown();
  }

  cerrarDropdown(): void {
    this.dropdownAbierto = false;
    this.filtro = '';
  }
}
