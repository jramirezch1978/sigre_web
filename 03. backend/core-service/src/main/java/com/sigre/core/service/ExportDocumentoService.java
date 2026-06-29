package com.sigre.core.service;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.util.List;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;
import org.springframework.stereotype.Service;

import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

/**
 * Genera documentos (Excel/Word/PDF) en el backend a partir de datos ya formateados.
 * El frontend envía cabeceras + filas (strings); aquí solo se construye el archivo.
 */
@Service
public class ExportDocumentoService {

    private static final String AZUL_HEX = "0D6EFD";

    public byte[] excel(String titulo, List<String> headers, List<List<String>> filas) {
        try (XSSFWorkbook libro = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet hoja = libro.createSheet("Datos");

            Font fontHeader = libro.createFont();
            fontHeader.setBold(true);
            fontHeader.setColor(org.apache.poi.ss.usermodel.IndexedColors.WHITE.getIndex());
            CellStyle headerStyle = libro.createCellStyle();
            headerStyle.setFont(fontHeader);
            headerStyle.setFillForegroundColor(org.apache.poi.ss.usermodel.IndexedColors.BLUE.getIndex());
            headerStyle.setFillPattern(org.apache.poi.ss.usermodel.FillPatternType.SOLID_FOREGROUND);

            Row filaHeader = hoja.createRow(0);
            for (int c = 0; c < headers.size(); c++) {
                Cell celda = filaHeader.createCell(c);
                celda.setCellValue(headers.get(c));
                celda.setCellStyle(headerStyle);
            }

            int r = 1;
            for (List<String> fila : filas) {
                Row row = hoja.createRow(r++);
                for (int c = 0; c < fila.size(); c++) {
                    row.createCell(c).setCellValue(fila.get(c) == null ? "" : fila.get(c));
                }
            }
            for (int c = 0; c < headers.size(); c++) {
                hoja.autoSizeColumn(c);
            }

            libro.write(out);
            return out.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("No se pudo generar el Excel: " + e.getMessage(), e);
        }
    }

    public byte[] word(String titulo, List<String> headers, List<List<String>> filas) {
        try (XWPFDocument doc = new XWPFDocument(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            if (titulo != null && !titulo.isBlank()) {
                XWPFParagraph p = doc.createParagraph();
                XWPFRun run = p.createRun();
                run.setBold(true);
                run.setFontSize(14);
                run.setText(titulo);
            }

            XWPFTable tabla = doc.createTable();
            XWPFTableRow filaHeader = tabla.getRow(0);
            for (int c = 0; c < headers.size(); c++) {
                if (c == 0) {
                    filaHeader.getCell(0).setText(headers.get(0));
                } else {
                    filaHeader.addNewTableCell().setText(headers.get(c));
                }
                filaHeader.getCell(c).setColor(AZUL_HEX);
            }

            for (List<String> fila : filas) {
                XWPFTableRow row = tabla.createRow();
                for (int c = 0; c < headers.size(); c++) {
                    String valor = c < fila.size() && fila.get(c) != null ? fila.get(c) : "";
                    row.getCell(c).setText(valor);
                }
            }

            doc.write(out);
            return out.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("No se pudo generar el Word: " + e.getMessage(), e);
        }
    }

    public byte[] pdf(String titulo, List<String> headers, List<List<String>> filas) {
        try (ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            boolean horizontal = headers.size() > 6;
            Document doc = new Document(horizontal ? PageSize.A4.rotate() : PageSize.A4, 24, 24, 36, 24);
            PdfWriter.getInstance(doc, out);
            doc.open();

            if (titulo != null && !titulo.isBlank()) {
                Paragraph t = new Paragraph(titulo);
                t.setSpacingAfter(8f);
                doc.add(t);
            }

            PdfPTable tabla = new PdfPTable(headers.size());
            tabla.setWidthPercentage(100);

            Color azul = new Color(13, 110, 253);
            for (String header : headers) {
                PdfPCell celda = new PdfPCell(new Phrase(header));
                celda.setBackgroundColor(azul);
                celda.setHorizontalAlignment(Element.ALIGN_CENTER);
                celda.setPadding(4f);
                Phrase ph = new Phrase(header);
                ph.getFont().setColor(Color.WHITE);
                celda.setPhrase(ph);
                tabla.addCell(celda);
            }
            tabla.setHeaderRows(1);

            for (List<String> fila : filas) {
                for (int c = 0; c < headers.size(); c++) {
                    String valor = c < fila.size() && fila.get(c) != null ? fila.get(c) : "";
                    PdfPCell celda = new PdfPCell(new Phrase(valor));
                    celda.setPadding(3f);
                    tabla.addCell(celda);
                }
            }

            doc.add(tabla);
            doc.close();
            return out.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("No se pudo generar el PDF: " + e.getMessage(), e);
        }
    }
}
