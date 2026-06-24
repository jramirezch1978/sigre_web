import { Component, Inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import {
  SigreMetoxiModalActionsComponent,
  SigreMetoxiModalShellComponent,
} from '@sigre-common';

export interface NotImplementedData {
  featureName: string;
  description?: string;
  expectedDate?: string;
}

@Component({
  selector: 'app-not-implemented-popup',
  standalone: true,
  imports: [CommonModule, SigreMetoxiModalShellComponent, SigreMetoxiModalActionsComponent],
  templateUrl: './not-implemented-popup.component.html',
  styleUrls: ['./not-implemented-popup.component.scss'],
})
export class NotImplementedPopupComponent {
  constructor(
    public dialogRef: MatDialogRef<NotImplementedPopupComponent>,
    @Inject(MAT_DIALOG_DATA) public data: NotImplementedData
  ) {}

  cerrar(): void {
    this.dialogRef.close();
  }
}
