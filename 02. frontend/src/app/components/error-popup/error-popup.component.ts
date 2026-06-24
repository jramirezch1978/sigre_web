import { Component, Inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import {
  SigreMetoxiModalActionsComponent,
  SigreMetoxiModalShellComponent,
} from '@sigre-common';

export interface ErrorData {
  titulo: string;
  mensaje: string;
  codigoIngresado: string;
  tipoError: 'validacion' | 'procesamiento' | 'tiempo-minimo';
  trabajadorInfo?: string;
}

@Component({
  selector: 'app-error-popup',
  standalone: true,
  imports: [CommonModule, SigreMetoxiModalShellComponent, SigreMetoxiModalActionsComponent],
  templateUrl: './error-popup.component.html',
  styleUrls: ['./error-popup.component.scss'],
})
export class ErrorPopupComponent {
  constructor(
    public dialogRef: MatDialogRef<ErrorPopupComponent>,
    @Inject(MAT_DIALOG_DATA) public data: ErrorData
  ) {}

  cerrarYRegresar(): void {
    this.dialogRef.close(true);
  }
}
