package com.sigre.asistencia.service;

import com.itextpdf.kernel.colors.Color;
import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.sigre.asistencia.dto.ReporteAsistenciaDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
@Slf4j
public class ReportePDFService {

    private static final Color HEADER_COLOR = new DeviceRgb(102, 126, 234);
    private static final Color ALT_ROW_COLOR = new DeviceRgb(249, 250, 251);
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public byte[] generarReporteAsistenciaPDF(List<ReporteAsistenciaDto> registros, 
                                              String codOrigen, 
                                              LocalDate fechaInicio, 
                                              LocalDate fechaFin) {
        log.info("Generando PDF del reporte de asistencia | Registros: {}", registros.size());
        
        try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
            PdfWriter writer = new PdfWriter(baos);
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf, PageSize.A4.rotate());
            document.setMargins(15, 10, 15, 10);
            
            // Título
            Paragraph titulo = new Paragraph("Reporte de Asistencia")
                    .setFontSize(18)
                    .setBold()
                    .setTextAlignment(TextAlignment.CENTER);
            document.add(titulo);
            
            // Subtítulo
            Paragraph subtitulo = new Paragraph("Análisis detallado de horas trabajadas, tardanzas y asistencia del personal")
                    .setFontSize(10)
                    .setTextAlignment(TextAlignment.CENTER)
                    .setMarginBottom(5);
            document.add(subtitulo);
            
            // Filtros
            Paragraph filtros = new Paragraph(String.format("Origen: %s | Período: %s - %s", 
                    codOrigen, 
                    fechaInicio.format(DATE_FORMATTER), 
                    fechaFin.format(DATE_FORMATTER)))
                    .setFontSize(9)
                    .setTextAlignment(TextAlignment.CENTER)
                    .setMarginBottom(10);
            document.add(filtros);
            
            // Tabla con 20 columnas optimizadas para A4 landscape (100% ancho página)
            // A4 landscape: 842pt - márgenes 20pt = 822pt disponibles
            float[] columnWidths = {
                1.5f,  // N° 
                4.5f,  // Tipo Trabajador
                2.5f,  // Código
                2.5f,  // DNI
                8.0f,  // Apellidos y Nombres
                5.0f,  // Área
                6.5f,  // Cargo/Puesto
                4.0f,  // Turno
                2.5f,  // Fecha
                2.5f,  // Hora Ingreso
                2.5f,  // Hora Salida
                3.0f,  // Horas Trabajadas
                3.0f,  // Horas Extras
                2.5f,  // Tardanza
                3.5f,  // Tot Hrs Sem
                3.5f,  // Extras Sem
                2.0f,  // Total Días
                2.5f,  // Total Faltas
                2.5f,  // % Asistencia
                3.0f   // % Ausentismo
            }; // Total: 70 unidades → distribuidas proporcionalmente
            
            Table table = new Table(columnWidths);
            table.setWidth(UnitValue.createPercentValue(100));
            table.setFontSize(6);
            
            // Headers
            String[] headers = {"N°", "Tipo de\nTrabajador", "Código\nTrabajador", "DNI", "Apellidos y Nombres", 
                               "Área", "Cargo/Puesto", "Turno", "Fecha", "Hora de\nIngreso", "Hora de\nSalida", 
                               "Horas\nTrabajadas", "Horas\nExtras", "Tardanza\n(min)", "Total Horas\nTrabajadas\n(Semana)",
                               "Total Horas\nExtras\n(Semana)", "Total Días\nAsistidos", "Total\nFaltas", 
                               "%\nAsistencia", "%\nAusentismo"};
            
            for (String header : headers) {
                Cell cell = new Cell().add(new Paragraph(header))
                        .setBackgroundColor(HEADER_COLOR)
                        .setFontColor(com.itextpdf.kernel.colors.ColorConstants.WHITE)
                        .setBold()
                        .setTextAlignment(TextAlignment.CENTER)
                        .setPadding(5);
                table.addHeaderCell(cell);
            }
            
            // Datos
            int rowIndex = 0;
            for (ReporteAsistenciaDto row : registros) {
                Color bgColor = rowIndex % 2 == 0 ? com.itextpdf.kernel.colors.ColorConstants.WHITE : ALT_ROW_COLOR;
                
                table.addCell(createCell(String.valueOf(row.getNro()), TextAlignment.CENTER, bgColor));
                table.addCell(createCell(row.getTipoTrabajador(), TextAlignment.LEFT, bgColor));
                table.addCell(createCell(row.getCodigoTrabajador(), TextAlignment.CENTER, bgColor));
                table.addCell(createCell(row.getDni(), TextAlignment.CENTER, bgColor));
                table.addCell(createCell(row.getApellidosNombres(), TextAlignment.LEFT, bgColor));
                table.addCell(createCell(row.getArea(), TextAlignment.LEFT, bgColor));
                table.addCell(createCell(row.getCargoPuesto(), TextAlignment.LEFT, bgColor));
                table.addCell(createCell(row.getTurno(), TextAlignment.CENTER, bgColor));
                table.addCell(createCell(row.getFecha() != null ? row.getFecha().format(DATE_FORMATTER) : "", TextAlignment.CENTER, bgColor));
                table.addCell(createCell(row.getHoraIngreso() != null ? row.getHoraIngreso().format(java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss")) : "", TextAlignment.CENTER, bgColor));
                table.addCell(createCell(row.getHoraSalida() != null ? row.getHoraSalida().format(java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss")) : "Pendiente", TextAlignment.CENTER, bgColor));
                table.addCell(createCell(String.format("%.2f", row.getHorasTrabajadas()), TextAlignment.RIGHT, bgColor));
                table.addCell(createCell(String.format("%.2f", row.getHorasExtras()), TextAlignment.RIGHT, bgColor));
                table.addCell(createCell(String.valueOf(row.getTardanzaMin()), TextAlignment.RIGHT, bgColor));
                table.addCell(createCell(String.format("%.2f", row.getTotalHorasTrabajadasSemana()), TextAlignment.RIGHT, bgColor));
                table.addCell(createCell(String.format("%.2f", row.getTotalHorasExtrasSemana()), TextAlignment.RIGHT, bgColor));
                table.addCell(createCell(String.valueOf(row.getTotalDiasAsistidos()), TextAlignment.RIGHT, bgColor));
                table.addCell(createCell(String.valueOf(row.getTotalFaltas()), TextAlignment.RIGHT, bgColor));
                table.addCell(createCell(String.format("%.2f%%", row.getPorcAsistencia()), TextAlignment.RIGHT, bgColor));
                table.addCell(createCell(String.format("%.2f%%", row.getPorcAusentismo()), TextAlignment.RIGHT, bgColor));
                
                rowIndex++;
            }
            
            document.add(table);
            
            // Pie de página
            Paragraph footer = new Paragraph(String.format("Generado: %s | Total registros: %d", 
                    LocalDate.now().format(DATE_FORMATTER), registros.size()))
                    .setFontSize(8)
                    .setTextAlignment(TextAlignment.CENTER)
                    .setMarginTop(10);
            document.add(footer);
            
            document.close();
            
            log.info("✅ PDF generado exitosamente: {} bytes", baos.size());
            return baos.toByteArray();
            
        } catch (Exception e) {
            log.error("❌ Error generando PDF", e);
            throw new RuntimeException("Error al generar PDF del reporte", e);
        }
    }
    
    private Cell createCell(String content, TextAlignment alignment, Color bgColor) {
        return new Cell()
                .add(new Paragraph(content != null ? content : ""))
                .setTextAlignment(alignment)
                .setBackgroundColor(bgColor)
                .setPadding(3)
                .setFontSize(7);
    }
}

