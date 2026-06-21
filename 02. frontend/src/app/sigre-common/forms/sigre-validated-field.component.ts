import { Component, Input } from '@angular/core';
import { AbstractControl } from '@angular/forms';
import { SigreValidationBadgeComponent } from './sigre-validation-badge.component';

export type SigreValidatedFieldVariant = 'text' | 'select' | 'date';

@Component({
  selector: 'sigre-validated-field',
  standalone: true,
  imports: [SigreValidationBadgeComponent],
  template: `
    <div
      class="sigre-validated-field"
      [class.sigre-validated-field--select]="variant === 'select'"
      [class.sigre-validated-field--date]="variant === 'date'">
      <ng-content></ng-content>
      @if (control) {
        <sigre-validation-badge [control]="control" />
      }
    </div>
  `,
  styleUrls: ['./sigre-validated-field.component.scss'],
})
export class SigreValidatedFieldComponent {
  @Input({ required: true }) control!: AbstractControl | null;
  @Input() variant: SigreValidatedFieldVariant = 'text';
}
