import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import {
  SigreMetoxiModalShellComponent, SigreMetoxiModalActionsComponent,
} from '@sigre-common';

export interface MotivoDialogData {
  titulo: string;
  etiqueta?: string;
  textoConfirmar?: string;
}

/** Diálogo genérico para capturar un motivo de texto (rechazar/anular), reutilizable en todo Compras. */
@Component({
  selector: 'app-motivo-dialog',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, SigreMetoxiModalShellComponent, SigreMetoxiModalActionsComponent],
  templateUrl: './motivo-dialog.component.html',
})
export class MotivoDialogComponent {
  private readonly fb = inject(FormBuilder);
  private readonly dialogRef = inject(MatDialogRef<MotivoDialogComponent>);
  readonly data = inject<MotivoDialogData>(MAT_DIALOG_DATA);

  form: FormGroup = this.fb.group({
    motivo: ['', [Validators.required, Validators.minLength(5)]],
  });

  cancelar(): void {
    this.dialogRef.close(null);
  }

  confirmar(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    this.dialogRef.close(this.form.getRawValue().motivo as string);
  }
}
