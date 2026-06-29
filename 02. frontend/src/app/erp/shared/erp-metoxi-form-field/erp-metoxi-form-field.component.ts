import { Component, ElementRef, Input, ViewChild } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AbstractControl, ReactiveFormsModule } from '@angular/forms';
import { CdkOverlayOrigin, ConnectedPosition, OverlayModule } from '@angular/cdk/overlay';
import { SigreValidatedFieldComponent } from '@sigre-common';
import { ErpMetoxiFormFieldType, iconoMetoxiCampo } from '../utils/erp-metoxi-form-icons.util';

export type { ErpMetoxiFormFieldType };

export interface ErpMetoxiSelectOption {
  value: string | number | null;
  label: string;
}

@Component({
  selector: 'erp-metoxi-form-field',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, SigreValidatedFieldComponent, OverlayModule],
  templateUrl: './erp-metoxi-form-field.component.html',
  styleUrls: ['./erp-metoxi-form-field.component.scss'],
})
export class ErpMetoxiFormFieldComponent {
  @Input({ required: true }) control!: AbstractControl | null;
  @Input({ required: true }) fieldId!: string;
  @Input({ required: true }) label!: string;
  @Input() required = false;
  @Input() type: ErpMetoxiFormFieldType = 'text';
  @Input() colClass = 'col-12';
  @Input() icon = '';
  @Input() fieldKey = '';
  @Input() placeholder = '';
  @Input() maxLength: number | null = null;
  @Input() options: ErpMetoxiSelectOption[] = [];
  @Input() switchOnLabel = 'Activo';
  @Input() switchOffLabel = 'Anulado';
  @Input() layout: 'icon-inside' | 'input-group' = 'icon-inside';

  get labelText(): string {
    if (this.required) {
      return `${this.label} *`;
    }
    if (this.type === 'select') {
      return `${this.label} (opcional)`;
    }
    return this.label;
  }

  get placeholderSelect(): string {
    return this.required ? 'Seleccione…' : '— Sin asignar —';
  }

  get iconName(): string {
    return this.icon || iconoMetoxiCampo(this.fieldKey, this.type);
  }

  get switchLabel(): string {
    const valor = this.control?.value;
    return valor ? this.switchOnLabel : this.switchOffLabel;
  }

  // ── Select buscable (CDK Overlay) ──────────────────────────────
  @ViewChild('ssInput') private ssInput?: ElementRef<HTMLInputElement>;
  dropdownAbierto = false;
  filtro = '';
  anchoPanel = 240;

  /** Abajo preferente; arriba si no entra. */
  readonly posicionesOverlay: ConnectedPosition[] = [
    { originX: 'start', originY: 'bottom', overlayX: 'start', overlayY: 'top', offsetY: 2 },
    { originX: 'start', originY: 'top', overlayX: 'start', overlayY: 'bottom', offsetY: -2 },
  ];

  get tieneValor(): boolean {
    const v = this.control?.value;
    return v !== null && v !== undefined && v !== '';
  }

  get etiquetaSeleccionada(): string {
    const v = this.control?.value;
    if (v === null || v === undefined || v === '') return this.placeholderSelect;
    const opt = this.options.find(o => String(o.value) === String(v));
    return opt ? opt.label : this.placeholderSelect;
  }

  get opcionesFiltradas(): ErpMetoxiSelectOption[] {
    const f = this.filtro.trim().toLowerCase();
    if (!f) return this.options;
    return this.options.filter(o =>
      o.label.toLowerCase().includes(f) || String(o.value ?? '').toLowerCase().includes(f));
  }

  esSeleccionada(value: string | number | null): boolean {
    return String(value) === String(this.control?.value);
  }

  toggleDropdown(origin: CdkOverlayOrigin): void {
    if (this.control?.disabled) return;
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
    this.control?.setValue(value);
    this.control?.markAsDirty();
    this.control?.markAsTouched();
    this.cerrarDropdown();
  }

  cerrarDropdown(): void {
    this.dropdownAbierto = false;
    this.filtro = '';
  }
}
