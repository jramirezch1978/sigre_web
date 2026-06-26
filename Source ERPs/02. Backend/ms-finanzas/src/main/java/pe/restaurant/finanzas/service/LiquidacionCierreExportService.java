package pe.restaurant.finanzas.service;

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
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.finanzas.entity.Liquidacion;
import pe.restaurant.finanzas.entity.LiquidacionDet;
import pe.restaurant.finanzas.repository.LiquidacionDetRepository;
import pe.restaurant.finanzas.repository.LiquidacionRepository;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Exportación del detalle de cierre de liquidación a Excel / PDF / CSV
 * (HU-FIN-ADL-004). Genera el archivo en el backend siguiendo el patrón del
 * módulo de reportes (Apache POI + OpenPDF), sin tocar la base de datos.
 */
@Service
@RequiredArgsConstructor
public class LiquidacionCierreExportService {

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final String[] COLUMNAS_DETALLE = {
            "Item", "Concepto Fin.", "Centro Costo", "Moneda", "Importe", "Importe Retenido"
    };

    private final LiquidacionRepository repository;
    private final LiquidacionDetRepository detRepository;
    private final PermisoCierreValidator permisoValidator;

    @Transactional(readOnly = true)
    public byte[] exportarCierre(Long id, String formato) {
        permisoValidator.validar(PermisoCierreValidator.ACCION_CONSULTAR);

        Liquidacion liquidacion = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));
        List<LiquidacionDet> detalles = detRepository.findByLiquidacionIdAndFlagEstado(id, "1");

        String f = formato == null ? "xlsx" : formato.trim().toLowerCase();
        return switch (f) {
            case "csv" -> exportCsv(liquidacion, detalles);
            case "pdf" -> exportPdf(liquidacion, detalles);
            case "xlsx", "excel" -> exportExcel(liquidacion, detalles);
            default -> throw new BusinessException(
                    "Formato no soportado: " + formato + " (use csv, xlsx o pdf)",
                    HttpStatus.BAD_REQUEST,
                    FinanzasErrorCodes.ERROR_INTERNO_FINANZAS);
        };
    }

    private byte[] exportCsv(Liquidacion l, List<LiquidacionDet> detalles) {
        StringBuilder sb = new StringBuilder();
        sb.append("N° Liquidación,").append(safe(l.getNroLiquidacion())).append('\n');
        sb.append("Fecha Liquidación,").append(l.getFechaLiquidacion() != null ? l.getFechaLiquidacion().format(FMT) : "").append('\n');
        sb.append("Estado,").append(safe(l.getFlagEstado())).append('\n');
        sb.append("Importe Neto,").append(num(l.getImporteNeto())).append('\n');
        sb.append("Saldo,").append(num(l.getSaldo())).append('\n');
        sb.append("Asiento Contable,").append(l.getCntblAsientoId() != null ? l.getCntblAsientoId() : "").append('\n');
        sb.append('\n');
        sb.append(String.join(",", COLUMNAS_DETALLE)).append('\n');
        for (LiquidacionDet d : detalles) {
            sb.append(d.getItem()).append(',')
              .append(idOrEmpty(d.getConceptoFinancieroId())).append(',')
              .append(idOrEmpty(d.getCentrosCostoId())).append(',')
              .append(idOrEmpty(d.getMonedaId())).append(',')
              .append(num(d.getImporte())).append(',')
              .append(num(d.getImporteRetenido())).append('\n');
        }
        return sb.toString().getBytes(java.nio.charset.StandardCharsets.UTF_8);
    }

    private byte[] exportExcel(Liquidacion l, List<LiquidacionDet> detalles) {
        try (Workbook wb = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = wb.createSheet("CierreLiquidacion");
            int r = 0;
            r = cabeceraExcel(sheet, r, "N° Liquidación", safe(l.getNroLiquidacion()));
            r = cabeceraExcel(sheet, r, "Fecha Liquidación",
                    l.getFechaLiquidacion() != null ? l.getFechaLiquidacion().format(FMT) : "");
            r = cabeceraExcel(sheet, r, "Estado", safe(l.getFlagEstado()));
            r = cabeceraExcel(sheet, r, "Importe Neto", num(l.getImporteNeto()));
            r = cabeceraExcel(sheet, r, "Saldo", num(l.getSaldo()));
            r = cabeceraExcel(sheet, r, "Asiento Contable",
                    l.getCntblAsientoId() != null ? String.valueOf(l.getCntblAsientoId()) : "");
            r++; // fila en blanco

            Row header = sheet.createRow(r++);
            for (int i = 0; i < COLUMNAS_DETALLE.length; i++) {
                header.createCell(i).setCellValue(COLUMNAS_DETALLE[i]);
            }
            for (LiquidacionDet d : detalles) {
                Row row = sheet.createRow(r++);
                row.createCell(0).setCellValue(d.getItem() != null ? d.getItem() : 0);
                row.createCell(1).setCellValue(idOrEmpty(d.getConceptoFinancieroId()));
                row.createCell(2).setCellValue(idOrEmpty(d.getCentrosCostoId()));
                row.createCell(3).setCellValue(idOrEmpty(d.getMonedaId()));
                row.createCell(4).setCellValue(toDouble(d.getImporte()));
                row.createCell(5).setCellValue(toDouble(d.getImporteRetenido()));
            }
            for (int i = 0; i < COLUMNAS_DETALLE.length; i++) {
                sheet.autoSizeColumn(i);
            }
            wb.write(out);
            return out.toByteArray();
        } catch (Exception e) {
            throw new BusinessException("Error al generar Excel: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, FinanzasErrorCodes.ERROR_INTERNO_FINANZAS);
        }
    }

    private int cabeceraExcel(Sheet sheet, int r, String etiqueta, String valor) {
        Row row = sheet.createRow(r);
        row.createCell(0).setCellValue(etiqueta);
        row.createCell(1).setCellValue(valor);
        return r + 1;
    }

    private byte[] exportPdf(Liquidacion l, List<LiquidacionDet> detalles) {
        try (ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Document doc = new Document(PageSize.A4, 24, 24, 24, 24);
            PdfWriter.getInstance(doc, out);
            doc.open();

            Font title = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 13);
            Font normal = FontFactory.getFont(FontFactory.HELVETICA, 9);

            doc.add(new Paragraph("Cierre de Liquidación " + safe(l.getNroLiquidacion()), title));
            doc.add(new Paragraph(" "));
            doc.add(new Paragraph("Fecha Liquidación: "
                    + (l.getFechaLiquidacion() != null ? l.getFechaLiquidacion().format(FMT) : "-"), normal));
            doc.add(new Paragraph("Estado: " + safe(l.getFlagEstado()), normal));
            doc.add(new Paragraph("Importe Neto: " + num(l.getImporteNeto()), normal));
            doc.add(new Paragraph("Saldo a devolver/regularizar: " + num(l.getSaldo()), normal));
            doc.add(new Paragraph("Asiento Contable: "
                    + (l.getCntblAsientoId() != null ? l.getCntblAsientoId() : "-"), normal));
            doc.add(new Paragraph(" "));

            PdfPTable table = new PdfPTable(COLUMNAS_DETALLE.length);
            table.setWidthPercentage(100);
            for (String cab : COLUMNAS_DETALLE) {
                PdfPCell c = new PdfPCell(new Phrase(cab, normal));
                c.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(c);
            }
            for (LiquidacionDet d : detalles) {
                table.addCell(cell(String.valueOf(d.getItem()), normal));
                table.addCell(cell(idOrEmpty(d.getConceptoFinancieroId()), normal));
                table.addCell(cell(idOrEmpty(d.getCentrosCostoId()), normal));
                table.addCell(cell(idOrEmpty(d.getMonedaId()), normal));
                table.addCell(cell(num(d.getImporte()), normal));
                table.addCell(cell(num(d.getImporteRetenido()), normal));
            }
            doc.add(table);
            doc.close();
            return out.toByteArray();
        } catch (Exception e) {
            throw new BusinessException("Error al generar PDF: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, FinanzasErrorCodes.ERROR_INTERNO_FINANZAS);
        }
    }

    private static PdfPCell cell(String text, Font font) {
        return new PdfPCell(new Phrase(text != null ? text : "", font));
    }

    private static String safe(String v) {
        return v != null ? v : "";
    }

    private static String num(BigDecimal v) {
        return v != null ? v.toPlainString() : "0";
    }

    private static String idOrEmpty(Long v) {
        return v != null ? String.valueOf(v) : "";
    }

    private static double toDouble(BigDecimal v) {
        return v != null ? v.doubleValue() : 0d;
    }
}
