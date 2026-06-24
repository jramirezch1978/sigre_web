import { Component, EventEmitter, Input, Output } from '@angular/core';

@Component({
  selector: 'sigre-metoxi-modal-actions',
  standalone: true,
  template: `
    <div class="d-md-flex d-grid gap-3 w-100 justify-content-end">
      @if (mostrarCancelar) {
        <button
          type="button"
          class="btn btn-filter px-4"
          (click)="cancelar.emit()"
          [disabled]="deshabilitado">
          {{ textoCancelar }}
        </button>
      }
      @if (mostrarGuardar) {
        <button
          type="button"
          class="btn btn-primary px-4"
          (click)="guardar.emit()"
          [disabled]="deshabilitado || guardando">
          @if (guardando) {
            <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
            {{ textoGuardando }}
          } @else {
            {{ textoGuardar }}
          }
        </button>
      }
      @if (mostrarPrimario) {
        <button
          type="button"
          class="btn px-4"
          [class.btn-danger]="primarioPeligroso"
          [class.btn-primary]="!primarioPeligroso"
          (click)="primario.emit()"
          [disabled]="deshabilitado">
          {{ textoPrimario }}
        </button>
      }
    </div>
  `,
})
export class SigreMetoxiModalActionsComponent {
  @Input() mostrarCancelar = true;
  @Input() mostrarGuardar = false;
  @Input() mostrarPrimario = false;
  @Input() textoCancelar = 'Cancelar';
  @Input() textoGuardar = 'Guardar';
  @Input() textoGuardando = 'Guardando…';
  @Input() textoPrimario = 'Aceptar';
  @Input() guardando = false;
  @Input() deshabilitado = false;
  @Input() primarioPeligroso = false;
  @Output() cancelar = new EventEmitter<void>();
  @Output() guardar = new EventEmitter<void>();
  @Output() primario = new EventEmitter<void>();
}
