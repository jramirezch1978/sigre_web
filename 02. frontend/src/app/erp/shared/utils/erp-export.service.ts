import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, map } from 'rxjs';
import { saveAs } from 'file-saver';
import { ApiBaseService } from '../../../services/api-base.service';
import { TablaColumna } from '../models/api-page.model';

export type ExportFormato = 'xlsx' | 'docx' | 'pdf';

type ValorCeldaFn = (fila: Record<string, unknown>, col: TablaColumna) => string;

function nombreArchivoSeguro(nombre: string): string {
  return nombre
    .trim()
    .toLowerCase()
    .replace(/\s+/g, '-')
    .replace(/[^a-z0-9-_]/g, '') || 'sigre-export';
}

/**
 * Exportación de tablas: el documento (Excel/Word/PDF) lo genera el BACKEND
 * (core-service /api/core/export) y aquí solo se descarga el archivo recibido.
 */
@Injectable({ providedIn: 'root' })
export class ErpExportService {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);

  exportar(
    formato: ExportFormato,
    columnas: TablaColumna[],
    filas: Record<string, unknown>[],
    nombreArchivo: string,
    valorCelda: ValorCeldaFn
  ): Observable<void> {
    const headers = columnas.map(c => c.header);
    const filasStr = filas.map(fila => columnas.map(col => valorCelda(fila, col)));
    const body = { titulo: nombreArchivo, headers, filas: filasStr };
    const url = `${this.apiBase.getApiBaseUrl()}/core/export`;
    const params = new HttpParams().set('formato', formato);

    return this.http
      .post(url, body, { params, responseType: 'blob' })
      .pipe(map(blob => saveAs(blob, `${nombreArchivoSeguro(nombreArchivo)}.${formato}`)));
  }
}
