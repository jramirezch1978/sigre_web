/**
 * Genera un sufijo de fecha/hora para nombres de archivo: yyyymmdd_hhmmss.
 */
export function generarSufijoFechaHoraArchivo(fecha: Date = new Date()): string {
  const p = (n: number) => String(n).padStart(2, '0');
  return `${fecha.getFullYear()}${p(fecha.getMonth() + 1)}${p(fecha.getDate())}_${p(fecha.getHours())}${p(fecha.getMinutes())}${p(fecha.getSeconds())}`;
}

/**
 * Nombre de archivo para reportes de asistencia/produccion:
 * reporte-asistencia_yyyymmdd_hhmmss.xlsx
 */
export function generarNombreArchivoReporte(prefijo: string, extension: string, fecha: Date = new Date()): string {
  const ext = extension.replace(/^\./, '');
  return `${prefijo}_${generarSufijoFechaHoraArchivo(fecha)}.${ext}`;
}

export function escaparHtml(texto: string): string {
  return texto
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

/**
 * Genera un documento Word (.doc) a partir de una tabla HTML.
 * Compatible con Microsoft Word sin dependencias adicionales.
 */
export function generarDocumentoWordDesdeTabla(
  titulo: string,
  subtitulo: string,
  encabezados: string[],
  filas: (string | number | null | undefined)[][]
): Blob {
  const filasHtml = filas
    .map(fila => `<tr>${fila.map(celda => `<td>${escaparHtml(String(celda ?? ''))}</td>`).join('')}</tr>`)
    .join('');

  const html = `<!DOCTYPE html>
<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word">
<head>
  <meta charset="utf-8">
  <title>${escaparHtml(titulo)}</title>
</head>
<body>
  <h2>${escaparHtml(titulo)}</h2>
  <p>${escaparHtml(subtitulo)}</p>
  <table border="1" cellspacing="0" cellpadding="4" style="border-collapse:collapse;font-size:10pt;width:100%;">
    <thead>
      <tr>${encabezados.map(h => `<th style="background:#667eea;color:#fff;">${escaparHtml(h)}</th>`).join('')}</tr>
    </thead>
    <tbody>${filasHtml}</tbody>
  </table>
</body>
</html>`;

  return new Blob(['\ufeff', html], { type: 'application/msword' });
}
