import * as XLSX from 'xlsx';
import { saveAs } from 'file-saver';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import {
  Document, Packer, Paragraph, Table, TableCell, TableRow, TextRun, WidthType,
} from 'docx';
import { TablaColumna } from '../models/api-page.model';

type ValorCeldaFn = (fila: Record<string, unknown>, col: TablaColumna) => string;

function nombreArchivoSeguro(nombre: string): string {
  return nombre
    .trim()
    .toLowerCase()
    .replace(/\s+/g, '-')
    .replace(/[^a-z0-9-_]/g, '') || 'sigre-tabla';
}

export function exportarTablaExcel(
  columnas: TablaColumna[],
  filas: Record<string, unknown>[],
  nombreArchivo: string,
  valorCelda: ValorCeldaFn
): void {
  const headers = columnas.map(c => c.header);
  const data = filas.map(fila => columnas.map(col => valorCelda(fila, col)));
  const hoja = XLSX.utils.aoa_to_sheet([headers, ...data]);
  const libro = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(libro, hoja, 'Datos');
  const buffer = XLSX.write(libro, { bookType: 'xlsx', type: 'array' });
  saveAs(
    new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }),
    `${nombreArchivoSeguro(nombreArchivo)}.xlsx`
  );
}

export function exportarTablaPdf(
  columnas: TablaColumna[],
  filas: Record<string, unknown>[],
  nombreArchivo: string,
  valorCelda: ValorCeldaFn
): void {
  const doc = new jsPDF({
    orientation: columnas.length > 6 ? 'landscape' : 'portrait',
    unit: 'pt',
    format: 'a4',
  });

  autoTable(doc, {
    head: [columnas.map(c => c.header)],
    body: filas.map(fila => columnas.map(col => valorCelda(fila, col))),
    styles: { fontSize: 8, cellPadding: 4, overflow: 'linebreak' },
    headStyles: { fillColor: [13, 110, 253], textColor: 255 },
    alternateRowStyles: { fillColor: [248, 249, 250] },
    margin: { top: 36, left: 24, right: 24 },
    didDrawPage: data => {
      doc.setFontSize(10);
      doc.text(nombreArchivo, data.settings.margin.left, 24);
    },
  });

  doc.save(`${nombreArchivoSeguro(nombreArchivo)}.pdf`);
}

export async function exportarTablaWord(
  columnas: TablaColumna[],
  filas: Record<string, unknown>[],
  nombreArchivo: string,
  valorCelda: ValorCeldaFn
): Promise<void> {
  const headerRow = new TableRow({
    tableHeader: true,
    children: columnas.map(c => new TableCell({
      shading: { fill: '0D6EFD' },
      children: [new Paragraph({ children: [new TextRun({ text: c.header, bold: true, color: 'FFFFFF', size: 18 })] })],
    })),
  });

  const dataRows = filas.map(fila => new TableRow({
    children: columnas.map(col => new TableCell({
      children: [new Paragraph({ children: [new TextRun({ text: valorCelda(fila, col), size: 18 })] })],
    })),
  }));

  const tabla = new Table({
    width: { size: 100, type: WidthType.PERCENTAGE },
    rows: [headerRow, ...dataRows],
  });

  const doc = new Document({
    sections: [{
      children: [
        new Paragraph({ children: [new TextRun({ text: nombreArchivo, bold: true, size: 28 })] }),
        new Paragraph({ children: [] }),
        tabla,
      ],
    }],
  });

  const blob = await Packer.toBlob(doc);
  saveAs(blob, `${nombreArchivoSeguro(nombreArchivo)}.docx`);
}
