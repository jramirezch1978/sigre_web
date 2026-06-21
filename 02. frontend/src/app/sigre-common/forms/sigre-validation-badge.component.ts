import { ChangeDetectorRef, Component, Input, OnDestroy, OnInit, inject } from '@angular/core';
import { AbstractControl } from '@angular/forms';
import { MatIconModule } from '@angular/material/icon';
import { merge, Subscription } from 'rxjs';
import { estadoValidacionCampo, SigreFieldValidationState } from './sigre-field-validation.util';

@Component({
  selector: 'sigre-validation-badge',
  standalone: true,
  imports: [MatIconModule],
  template: `
    @if (estado === 'valid') {
      <mat-icon class="sigre-validation-badge sigre-validation-badge--valid" aria-hidden="true">check</mat-icon>
    } @else if (estado === 'invalid') {
      <mat-icon class="sigre-validation-badge sigre-validation-badge--invalid" aria-hidden="true">close</mat-icon>
    }
  `,
  styles: [
    `
      .sigre-validation-badge {
        font-size: 18px;
        width: 18px;
        height: 18px;
        line-height: 18px;
      }
      .sigre-validation-badge--valid {
        color: #1abb9c;
      }
      .sigre-validation-badge--invalid {
        color: #e74c3c;
      }
    `,
  ],
})
export class SigreValidationBadgeComponent implements OnInit, OnDestroy {
  @Input({ required: true }) control!: AbstractControl;

  private readonly cdr = inject(ChangeDetectorRef);
  private sub?: Subscription;

  ngOnInit(): void {
    this.sub = merge(this.control.statusChanges, this.control.valueChanges).subscribe(() => {
      this.cdr.markForCheck();
    });
  }

  ngOnDestroy(): void {
    this.sub?.unsubscribe();
  }

  get estado(): SigreFieldValidationState {
    return estadoValidacionCampo(this.control);
  }
}
