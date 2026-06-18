import { Injectable } from '@angular/core';
import type { GridApi } from 'ag-grid-community';

export interface GridExportColumn {
  /** Encabezado a mostrar en el archivo. */
  header: string;
  /** Nombre del campo en la fila (rowData). */
  field: string;
}

/**
 * Servicio transversal para exportar listas a Excel (.xlsx) y PDF (.pdf)
 * desde el frontend, sin depender de reportes del backend.
 *
 * - Excel: usa la librería `xlsx` (import dinámico para no inflar el bundle inicial).
 * - PDF: usa `jspdf` + `jspdf-autotable` (también import dinámico).
 *
 * Las filas pueden venir de un GridApi (respetando filtro/orden actual) o de un
 * arreglo plano. Pensado para reutilizarse en todas las pantallas de Compras/Finanzas.
 */
@Injectable({ providedIn: 'root' })
export class GridExportService {

  /** Obtiene las filas visibles del grid (tras filtro y orden); si no hay grid, usa el fallback. */
  obtenerFilas<T = Record<string, unknown>>(gridApi: GridApi | null | undefined, fallback: T[] = []): T[] {
    if (gridApi) {
      const filas: T[] = [];
      gridApi.forEachNodeAfterFilterAndSort((node) => {
        if (node.data) {
          filas.push(node.data as T);
        }
      });
      if (filas.length) {
        return filas;
      }
    }
    return fallback ?? [];
  }

  /** Genera y descarga un archivo Excel (.xlsx). */
  async exportarExcel(
    nombreArchivo: string,
    columnas: GridExportColumn[],
    filas: Array<Record<string, unknown>>,
    nombreHoja = 'Datos',
  ): Promise<void> {
    const datos = filas.map((fila) => {
      const registro: Record<string, unknown> = {};
      columnas.forEach((col) => {
        registro[col.header] = fila?.[col.field] ?? '';
      });
      return registro;
    });

    const XLSX = await import('xlsx');
    const hoja = XLSX.utils.json_to_sheet(datos, { header: columnas.map((c) => c.header) });
    const libro = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(libro, hoja, nombreHoja.substring(0, 28) || 'Datos');
    XLSX.writeFile(libro, `${nombreArchivo}.xlsx`);
  }

  /** Genera y descarga un PDF (.pdf) con la tabla, sin abrir el diálogo de impresión. */
  async exportarPdf(
    titulo: string,
    nombreArchivo: string,
    columnas: GridExportColumn[],
    filas: Array<Record<string, unknown>>,
  ): Promise<void> {
    const { jsPDF } = await import('jspdf');
    const autoTable = (await import('jspdf-autotable')).default;

    const doc = new jsPDF({ orientation: 'landscape', unit: 'pt', format: 'a4' });
    doc.setFontSize(14);
    doc.text(titulo, 40, 40);
    doc.setFontSize(9);
    doc.setTextColor(110);
    doc.text(
      `Generado: ${new Date().toLocaleString('es-PE')} — ${filas.length} registro(s)`,
      40,
      56,
    );
    doc.setTextColor(0);

    autoTable(doc, {
      startY: 70,
      head: [columnas.map((c) => c.header)],
      body: filas.map((fila) => columnas.map((c) => String(fila?.[c.field] ?? ''))),
      styles: { fontSize: 8, cellPadding: 3 },
      headStyles: { fillColor: [240, 240, 240], textColor: 20, fontStyle: 'bold' },
      margin: { left: 40, right: 40 },
    });

    doc.save(`${nombreArchivo}.pdf`);
  }

  /** Sufijo de fecha YYYY-MM-DD para nombres de archivo. */
  fechaHoy(): string {
    return new Date().toISOString().slice(0, 10);
  }

  /**
   * Convierte un valor a Date admitiendo: Date, ISO (yyyy-MM-dd…),
   * dd/MM/yyyy y dd/MM/yyyy HH:mm:ss. Devuelve null si no se puede parsear.
   */
  parseFecha(valor: unknown): Date | null {
    if (!valor) {
      return null;
    }
    if (valor instanceof Date) {
      return isNaN(valor.getTime()) ? null : valor;
    }
    const texto = String(valor).trim();
    if (!texto) {
      return null;
    }
    // Formato dd/MM/yyyy [HH:mm:ss]
    const m = texto.match(/^(\d{1,2})\/(\d{1,2})\/(\d{4})/);
    if (m) {
      const d = new Date(Number(m[3]), Number(m[2]) - 1, Number(m[1]));
      return isNaN(d.getTime()) ? null : d;
    }
    // Formato ISO o cualquier otro reconocido por Date
    const iso = new Date(texto);
    return isNaN(iso.getTime()) ? null : iso;
  }

  /**
   * Filtra filas cuyo campo de fecha (obtenido con getFecha) caiga dentro del
   * rango [start, end] inclusive (a nivel de día). Si no hay rango, devuelve todo.
   */
  filtrarPorRango<T>(
    rows: T[],
    getFecha: (fila: T) => unknown,
    start?: Date | null,
    end?: Date | null,
  ): T[] {
    if (!Array.isArray(rows) || (!start && !end)) {
      return rows ?? [];
    }
    const desde = start ? new Date(start.getFullYear(), start.getMonth(), start.getDate(), 0, 0, 0, 0) : null;
    const hasta = end ? new Date(end.getFullYear(), end.getMonth(), end.getDate(), 23, 59, 59, 999) : null;
    return rows.filter((fila) => {
      const fecha = this.parseFecha(getFecha(fila));
      if (!fecha) {
        return false;
      }
      if (desde && fecha < desde) {
        return false;
      }
      if (hasta && fecha > hasta) {
        return false;
      }
      return true;
    });
  }
}
