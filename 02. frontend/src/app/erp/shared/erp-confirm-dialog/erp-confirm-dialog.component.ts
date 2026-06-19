import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatButtonModule } from '@angular/material/button';
import { MatDialogModule, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatIconModule } from '@angular/material/icon';

export type ErpConfirmTipo = 'warning' | 'danger';

export interface ErpConfirmDialogData {
  titulo: string;
  mensaje: string;
  submensaje?: string;
  tipo?: ErpConfirmTipo;
  textoCancelar?: string;
  textoConfirmar?: string;
}

@Component({
  selector: 'app-erp-confirm-dialog',
  standalone: true,
  imports: [CommonModule, MatDialogModule, MatButtonModule, MatIconModule],
  templateUrl: './erp-confirm-dialog.component.html',
  styleUrls: ['./erp-confirm-dialog.component.scss'],
})
export class ErpConfirmDialogComponent {
  private readonly dialogRef = inject(MatDialogRef<ErpConfirmDialogComponent>);
  readonly data = inject<ErpConfirmDialogData>(MAT_DIALOG_DATA);

  cancelar(): void {
    this.dialogRef.close(false);
  }

  confirmar(): void {
    this.dialogRef.close(true);
  }

  get icono(): string {
    return this.data.tipo === 'danger' ? 'delete_forever' : 'warning_amber';
  }
}
