import { Injectable, inject } from '@angular/core';
import type { GridApi } from 'ag-grid-community';
import { PdfExportService } from 'src/app/core/infrastructure/export/pdf-export.service';

/**
 * Servicio de exportación reutilizable para las pantallas de Almacén.
 *
 * - Excel: exporta la grilla AG Grid a `.xlsx` (módulo ExcelExport enterprise,
 *   ya registrado en `AgGridSharedModule`).
 * - PDF: usa el servicio transversal del proyecto (`PdfExportService`), que
 *   imprime la vista (el navegador permite "Guardar como PDF"). No se agregan
 *   dependencias nuevas. Para un PDF dedicado se usaría un reporte Jasper en
 *   `ms-reportes` vía `PdfExportService.downloadReport(...)`.
 */
@Injectable({ providedIn: 'root' })
export class AlmacenExportService {

  private readonly pdf = inject(PdfExportService);

  /** Exporta la grilla a Excel (.xlsx). No hace nada si el grid no está listo. */
  exportarExcel(gridApi: GridApi | null | undefined, nombre: string): void {
    if (!gridApi) {
      return;
    }
    gridApi.exportDataAsExcel({ fileName: `${nombre}.xlsx`, sheetName: nombre.substring(0, 28) });
  }

  /** Exporta a PDF imprimiendo la vista actual (diálogo del navegador → Guardar como PDF). */
  exportarPdf(): void {
    this.pdf.printCurrentPage();
  }

  /** Descarga un Blob (p. ej. el PDF Jasper que devuelve el backend) como archivo. */
  descargarBlob(blob: Blob, filename: string): void {
    const url = window.URL.createObjectURL(blob);
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = filename;
    anchor.click();
    window.URL.revokeObjectURL(url);
  }
}
