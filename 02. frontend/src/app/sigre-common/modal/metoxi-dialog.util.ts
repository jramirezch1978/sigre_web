import { MatDialog, MatDialogConfig, MatDialogRef } from '@angular/material/dialog';
import { Type } from '@angular/core';

export const SIGRE_METOXI_DIALOG_PANEL = 'sigre-metoxi-dialog-panel';

export function configDialogoMetoxi<T>(
  partial: MatDialogConfig<T> = {}
): MatDialogConfig<T> {
  return {
    panelClass: SIGRE_METOXI_DIALOG_PANEL,
    maxWidth: '98vw',
    disableClose: true,
    autoFocus: false,
    restoreFocus: true,
    ...partial,
  };
}

export function abrirDialogoMetoxi<T, D = unknown, R = unknown>(
  dialog: MatDialog,
  component: Type<T>,
  partial: MatDialogConfig<D> = {}
): MatDialogRef<T, R> {
  return dialog.open(component, configDialogoMetoxi(partial));
}
