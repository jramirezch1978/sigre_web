package pe.restaurant.activos.service.impl;

import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.activos.dto.reporte.AfReporteLibroLineaResponse;
import pe.restaurant.activos.dto.reporte.AfReporteLibroResponse;
import pe.restaurant.activos.reporte.AfReporteLibroColumnas;
import pe.restaurant.activos.reporte.AfReporteLibroLineaExport;
import pe.restaurant.activos.service.AfReporteExportService;
import pe.restaurant.activos.service.AfReporteService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.common.exception.BusinessException;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AfReporteExportServiceImpl implements AfReporteExportService {

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private final AfReporteService reporteService;

    @Override
    public AfReporteLibroResponse obtenerLibro(LocalDate fechaCorte, Long afSubClaseId, Long afUbicacionId,
                                               String flagEstado, String estadoActivo,
                                               BigDecimal valorMin, BigDecimal valorMax) {
        return reporteService.libroActivos(fechaCorte, afSubClaseId, afUbicacionId,
                flagEstado, estadoActivo, valorMin, valorMax);
    }

    @Override
    public byte[] exportarLibroActivos(AfReporteLibroResponse data, String formato) {
        String f = formato == null ? "xlsx" : formato.trim().toLowerCase();
        return switch (f) {
            case "csv" -> exportCsv(data);
            case "pdf" -> exportPdf(data);
            case "xlsx", "excel" -> exportExcel(data);
            default -> throw new BusinessException(
                    "Formato no soportado: " + formato + " (use csv, xlsx o pdf)",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.REPORTE_FORMATO_INVALIDO);
        };
    }

    private byte[] exportCsv(AfReporteLibroResponse data) {
        StringBuilder sb = new StringBuilder();
        sb.append(AfReporteLibroLineaExport.csvHeaderLine()).append('\n');
        for (AfReporteLibroLineaResponse l : data.getLineas()) {
            sb.append(AfReporteLibroLineaExport.csvDataLine(l)).append('\n');
        }
        return sb.toString().getBytes(StandardCharsets.UTF_8);
    }

    private byte[] exportExcel(AfReporteLibroResponse data) {
        try (Workbook wb = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = wb.createSheet("LibroActivos");
            Row header = sheet.createRow(0);
            String[] cols = AfReporteLibroColumnas.CABECERAS;
            for (int i = 0; i < cols.length; i++) {
                header.createCell(i).setCellValue(cols[i]);
            }
            int r = 1;
            for (AfReporteLibroLineaResponse l : data.getLineas()) {
                Row row = sheet.createRow(r++);
                escribirFilaExcel(row, l);
            }
            Row totales = sheet.createRow(r);
            totales.createCell(0).setCellValue("TOTALES");
            totales.createCell(6).setCellValue(toDouble(data.getTotalValorAdquisicion()));
            totales.createCell(7).setCellValue(toDouble(data.getTotalDepreciacionAcumulada()));
            totales.createCell(8).setCellValue(toDouble(data.getTotalValorNeto()));
            for (int i = 0; i < cols.length; i++) {
                sheet.autoSizeColumn(i);
            }
            wb.write(out);
            return out.toByteArray();
        } catch (Exception e) {
            throw new BusinessException("Error al generar Excel: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, ActivosErrorCodes.REPORTE_EXPORT_ERROR);
        }
    }

    private static void escribirFilaExcel(Row row, AfReporteLibroLineaResponse l) {
        List<String> valores = AfReporteLibroLineaExport.valoresCelda(l);
        for (int i = 0; i < valores.size(); i++) {
            String v = valores.get(i);
            if (i >= 6 && i <= 8 && v != null && !v.isBlank()) {
                try {
                    row.createCell(i).setCellValue(Double.parseDouble(v));
                    continue;
                } catch (NumberFormatException ignored) {
                    // texto
                }
            }
            row.createCell(i).setCellValue(v);
        }
    }

    private byte[] exportPdf(AfReporteLibroResponse data) {
        try (ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Document doc = new Document(PageSize.A4.rotate(), 24, 24, 24, 24);
            PdfWriter.getInstance(doc, out);
            doc.open();
            Font title = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);
            Font normal = FontFactory.getFont(FontFactory.HELVETICA, 7);
            doc.add(new Paragraph("Libro de activos fijos — corte " +
                    (data.getFechaCorte() != null ? data.getFechaCorte().format(FMT) : ""), title));
            doc.add(new Paragraph(" "));

            PdfPTable table = new PdfPTable(AfReporteLibroColumnas.CABECERAS.length);
            table.setWidthPercentage(100);
            for (String cab : AfReporteLibroColumnas.CABECERAS) {
                addHeader(table, cab, normal);
            }
            for (AfReporteLibroLineaResponse l : data.getLineas()) {
                for (String valor : AfReporteLibroLineaExport.valoresCelda(l)) {
                    table.addCell(cell(valor, normal));
                }
            }
            doc.add(table);
            doc.close();
            return out.toByteArray();
        } catch (Exception e) {
            throw new BusinessException("Error al generar PDF: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, ActivosErrorCodes.REPORTE_EXPORT_ERROR);
        }
    }

    private static void addHeader(PdfPTable table, String text, Font font) {
        PdfPCell c = new PdfPCell(new Phrase(text, font));
        c.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(c);
    }

    private static PdfPCell cell(String text, Font font) {
        return new PdfPCell(new Phrase(text != null ? text : "", font));
    }

    private static double toDouble(BigDecimal v) {
        return v != null ? v.doubleValue() : 0d;
    }
}
