import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AbstractControl, ReactiveFormsModule } from '@angular/forms';
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
  imports: [CommonModule, ReactiveFormsModule, SigreValidatedFieldComponent],
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
    return this.required ? `${this.label} *` : this.label;
  }

  get iconName(): string {
    return this.icon || iconoMetoxiCampo(this.fieldKey, this.type);
  }

  get switchLabel(): string {
    const valor = this.control?.value;
    return valor ? this.switchOnLabel : this.switchOffLabel;
  }
}
