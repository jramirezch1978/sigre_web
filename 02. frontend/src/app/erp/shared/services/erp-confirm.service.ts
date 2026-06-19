import { Injectable, inject } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Observable, map } from 'rxjs';
import {
  ErpConfirmDialogComponent,
  ErpConfirmDialogData,
} from '../erp-confirm-dialog/erp-confirm-dialog.component';

@Injectable({ providedIn: 'root' })
export class ErpConfirmService {
  private readonly dialog = inject(MatDialog);

  confirm(data: ErpConfirmDialogData): Observable<boolean> {
    return this.dialog
      .open(ErpConfirmDialogComponent, {
        data,
        width: '420px',
        disableClose: true,
      })
      .afterClosed()
      .pipe(map(result => result === true));
  }

  confirmAnular(nombre: string): Observable<boolean> {
    return this.confirm({
      titulo: 'Anular registro',
      mensaje: `¿Anular «${nombre}»?`,
      tipo: 'warning',
      textoConfirmar: 'Anular',
    });
  }

  confirmEliminar(nombre: string): Observable<boolean> {
    return this.confirm({
      titulo: 'Eliminar registro',
      mensaje: `¿Eliminar permanentemente «${nombre}»?`,
      submensaje: 'Esta acción no se puede deshacer.',
      tipo: 'danger',
      textoConfirmar: 'Eliminar',
    });
  }
}
