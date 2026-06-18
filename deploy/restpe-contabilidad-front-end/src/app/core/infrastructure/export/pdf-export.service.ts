import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, tap } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { ExcelExportService } from './excel-export.service';

/**
 * Servicio transversal de generación de PDFs.
 *
 * Los PDFs se generan en el backend (ms-reportes con JasperReports).
 * Este servicio solicita el PDF al backend y lo descarga en el navegador.
 */
@Injectable({ providedIn: 'root' })
export class PdfExportService {
  private readonly http = inject(HttpClient);
  private readonly excelExport = inject(ExcelExportService);
  private readonly baseUrl = `${environment.apiBaseUrl}/reportes`;

  downloadReport(reportPath: string, params: Record<string, string>, filename: string): Observable<Blob> {
    return this.http.get(`${this.baseUrl}/${reportPath}`, {
      params,
      responseType: 'blob',
    }).pipe(
      tap(blob => this.excelExport.downloadBlob(blob, `${filename}.pdf`)),
    );
  }

  printCurrentPage(): void {
    window.print();
  }
}
