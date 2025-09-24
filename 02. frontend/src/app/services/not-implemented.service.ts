import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { NotImplementedPopupComponent, NotImplementedData } from '../components/not-implemented-popup/not-implemented-popup.component';

@Injectable({
  providedIn: 'root'
})
export class NotImplementedService {

  constructor(private dialog: MatDialog) {}

  /**
   * Mostrar popup de funcionalidad no implementada
   * @param featureName Nombre de la funcionalidad
   * @param description Descripción opcional adicional
   * @param expectedDate Fecha estimada opcional
   */
  mostrarPopup(
    featureName: string, 
    description?: string, 
    expectedDate?: string
  ): void {
    
    const data: NotImplementedData = {
      featureName,
      description: description || `La funcionalidad "${featureName}" está en desarrollo y estará disponible próximamente.`,
      expectedDate
    };

    this.dialog.open(NotImplementedPopupComponent, {
      width: '550px',
      maxWidth: '90vw',
      data: data,
      disableClose: false,
      autoFocus: true,
      restoreFocus: true,
      panelClass: 'gentelella-dialog'
    });
  }

  /**
   * Método rápido para opciones de menú
   */
  menuNotImplemented(nombreOpcion: string): void {
    this.mostrarPopup(
      nombreOpcion,
      `La opción "${nombreOpcion}" del menú lateral está planificada para una próxima actualización.`,
      'Próximamente'
    );
  }

  /**
   * Método rápido para botones de acción
   */
  actionNotImplemented(nombreAccion: string): void {
    this.mostrarPopup(
      nombreAccion,
      `La acción "${nombreAccion}" está en desarrollo. Mientras tanto, puedes usar las funcionalidades principales del sistema.`,
      'En desarrollo'
    );
  }

  /**
   * Método rápido para reportes
   */
  reportNotImplemented(nombreReporte: string): void {
    this.mostrarPopup(
      nombreReporte,
      `El reporte "${nombreReporte}" está siendo desarrollado con análisis avanzados y visualizaciones interactivas.`,
      'Próxima versión'
    );
  }
}
