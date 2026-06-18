import { Injectable } from '@angular/core';

export interface ExcelColumn {
  header: string;
  field: string;
  width?: number;
  format?: 'text' | 'number' | 'currency' | 'date' | 'percentage';
}

/**
 * Servicio transversal de exportación a Excel/CSV.
 * Genera archivos .csv descargables desde cualquier módulo.
 *
 * El proyecto también tiene la librería 'xlsx' disponible para
 * exportaciones .xlsx nativas cuando sea necesario.
 */
@Injectable({ providedIn: 'root' })
export class ExcelExportService {

  exportToCsv<T extends Record<string, unknown>>(
    filename: string,
    columns: ExcelColumn[],
    data: T[],
  ): void {
    const separator = ';';
    const BOM = '\uFEFF';

    const header = columns.map(col => `"${col.header}"`).join(separator);

    const rows = data.map(row =>
      columns.map(col => {
        const value = row[col.field];
        if (value === null || value === undefined) return '""';
        if (col.format === 'currency' || col.format === 'number') return String(value);
        return `"${String(value).replace(/"/g, '""')}"`;
      }).join(separator)
    );

    const csvContent = BOM + [header, ...rows].join('\r\n');
    this.downloadFile(csvContent, `${filename}.csv`, 'text/csv;charset=utf-8');
  }

  downloadBlob(blob: Blob, filename: string): void {
    const url = window.URL.createObjectURL(blob);
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = filename;
    anchor.click();
    window.URL.revokeObjectURL(url);
  }

  private downloadFile(content: string, filename: string, mimeType: string): void {
    const blob = new Blob([content], { type: mimeType });
    this.downloadBlob(blob, filename);
  }
}
