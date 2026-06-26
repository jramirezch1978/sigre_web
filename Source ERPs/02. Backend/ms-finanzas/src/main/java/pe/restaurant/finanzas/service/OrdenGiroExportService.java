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
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.finanzas.constants.SolicitudGiroConstants;
import pe.restaurant.finanzas.entity.SolicitudGiro;
import pe.restaurant.finanzas.repository.SolicitudGiroRepository;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * Exportación de Órdenes de Giro a Excel / PDF / CSV (HU-FIN-ADL-001, acción "Exportar").
 * Genera el archivo en el backend con Apache POI + OpenPDF, <b>sin tocar la base de datos</b>.
 * Replica el patrón de {@link LiquidacionCierreExportService}.
 */
@Service
@RequiredArgsConstructor
public class OrdenGiroExportService {

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final String[] COLUMNAS_LISTADO = {
            "N° Orden de Giro", "Fecha Emisión", "Beneficiario", "Centro Costo",
            "Monto", "Estado", "Usuario Responsable", "Fecha Aprobación"
    };

    private final SolicitudGiroRepository repository;

    @Transactional(readOnly = true)
    public byte[] exportarListado(LocalDate fechaDesde, LocalDate fechaHasta, String estado,
                                  Long beneficiarioId, Long centrosCostoId, String formato) {
        List<SolicitudGiro> ordenes = repository.findAll(spec(fechaDesde, fechaHasta, estado, beneficiarioId, centrosCostoId));
        String f = normalizar(formato);
        return switch (f) {
            case "csv" -> listadoCsv(ordenes);
            case "pdf" -> listadoPdf(ordenes);
            case "xlsx", "excel" -> listadoExcel(ordenes);
            default -> formatoNoSoportado(formato);
        };
    }

    @Transactional(readOnly = true)
    public byte[] exportarOrden(Long id, String formato) {
        SolicitudGiro orden = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SolicitudGiro", id));
        if (!SolicitudGiroConstants.TIPO_ORDEN_GIRO.equals(orden.getTipoSolicitud())) {
            throw new BusinessException(
                    "El documento " + id + " no es una Orden de Giro (tipo O)",
                    HttpStatus.BAD_REQUEST, FinanzasErrorCodes.SOLICITUD_ESTADO_INVALIDO);
        }
        return exportarListado2(List.of(orden), normalizar(formato));
    }

    private byte[] exportarListado2(List<SolicitudGiro> ordenes, String f) {
        return switch (f) {
            case "csv" -> listadoCsv(ordenes);
            case "pdf" -> listadoPdf(ordenes);
            case "xlsx", "excel" -> listadoExcel(ordenes);
            default -> formatoNoSoportado(f);
        };
    }

    private Specification<SolicitudGiro> spec(LocalDate fechaDesde, LocalDate fechaHasta, String estado,
                                              Long beneficiarioId, Long centrosCostoId) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("tipoSolicitud"), SolicitudGiroConstants.TIPO_ORDEN_GIRO));
            if (fechaDesde != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fecha"), fechaDesde));
            }
            if (fechaHasta != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fecha"), fechaHasta));
            }
            if (estado != null && !estado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), estado));
            }
            if (beneficiarioId != null) {
                predicates.add(cb.equal(root.get("solicitanteId"), beneficiarioId));
            }
            if (centrosCostoId != null) {
                predicates.add(cb.equal(root.get("centrosCostoId"), centrosCostoId));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }

    private byte[] listadoCsv(List<SolicitudGiro> ordenes) {
        StringBuilder sb = new StringBuilder();
        sb.append(String.join(",", COLUMNAS_LISTADO)).append('\n');
        for (SolicitudGiro o : ordenes) {
            sb.append(safe(o.getNumero())).append(',')
              .append(o.getFecha() != null ? o.getFecha().format(FMT) : "").append(',')
              .append(idOrEmpty(o.getSolicitanteId())).append(',')
              .append(idOrEmpty(o.getCentrosCostoId())).append(',')
              .append(num(o.getMonto())).append(',')
              .append(estadoLabel(o.getFlagEstado())).append(',')
              .append(idOrEmpty(o.getCreatedBy())).append(',')
              .append(o.getFecAprobacion() != null ? o.getFecAprobacion().toString() : "").append('\n');
        }
        return sb.toString().getBytes(java.nio.charset.StandardCharsets.UTF_8);
    }

    private byte[] listadoExcel(List<SolicitudGiro> ordenes) {
        try (Workbook wb = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = wb.createSheet("OrdenesGiro");
            int r = 0;
            Row header = sheet.createRow(r++);
            for (int i = 0; i < COLUMNAS_LISTADO.length; i++) {
                header.createCell(i).setCellValue(COLUMNAS_LISTADO[i]);
            }
            for (SolicitudGiro o : ordenes) {
                Row row = sheet.createRow(r++);
                row.createCell(0).setCellValue(safe(o.getNumero()));
                row.createCell(1).setCellValue(o.getFecha() != null ? o.getFecha().format(FMT) : "");
                row.createCell(2).setCellValue(idOrEmpty(o.getSolicitanteId()));
                row.createCell(3).setCellValue(idOrEmpty(o.getCentrosCostoId()));
                row.createCell(4).setCellValue(toDouble(o.getMonto()));
                row.createCell(5).setCellValue(estadoLabel(o.getFlagEstado()));
                row.createCell(6).setCellValue(idOrEmpty(o.getCreatedBy()));
                row.createCell(7).setCellValue(o.getFecAprobacion() != null ? o.getFecAprobacion().toString() : "");
            }
            for (int i = 0; i < COLUMNAS_LISTADO.length; i++) {
                sheet.autoSizeColumn(i);
            }
            wb.write(out);
            return out.toByteArray();
        } catch (Exception e) {
            throw new BusinessException("Error al generar Excel: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, FinanzasErrorCodes.ERROR_INTERNO_FINANZAS);
        }
    }

    private byte[] listadoPdf(List<SolicitudGiro> ordenes) {
        try (ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Document doc = new Document(PageSize.A4.rotate(), 24, 24, 24, 24);
            PdfWriter.getInstance(doc, out);
            doc.open();

            Font title = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 13);
            Font normal = FontFactory.getFont(FontFactory.HELVETICA, 9);

            doc.add(new Paragraph("Órdenes de Giro", title));
            doc.add(new Paragraph(" "));

            PdfPTable table = new PdfPTable(COLUMNAS_LISTADO.length);
            table.setWidthPercentage(100);
            for (String cab : COLUMNAS_LISTADO) {
                PdfPCell c = new PdfPCell(new Phrase(cab, normal));
                c.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(c);
            }
            for (SolicitudGiro o : ordenes) {
                table.addCell(cell(safe(o.getNumero()), normal));
                table.addCell(cell(o.getFecha() != null ? o.getFecha().format(FMT) : "", normal));
                table.addCell(cell(idOrEmpty(o.getSolicitanteId()), normal));
                table.addCell(cell(idOrEmpty(o.getCentrosCostoId()), normal));
                table.addCell(cell(num(o.getMonto()), normal));
                table.addCell(cell(estadoLabel(o.getFlagEstado()), normal));
                table.addCell(cell(idOrEmpty(o.getCreatedBy()), normal));
                table.addCell(cell(o.getFecAprobacion() != null ? o.getFecAprobacion().toString() : "", normal));
            }
            doc.add(table);
            doc.close();
            return out.toByteArray();
        } catch (Exception e) {
            throw new BusinessException("Error al generar PDF: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, FinanzasErrorCodes.ERROR_INTERNO_FINANZAS);
        }
    }

    private byte[] formatoNoSoportado(String formato) {
        throw new BusinessException(
                "Formato no soportado: " + formato + " (use csv, xlsx o pdf)",
                HttpStatus.BAD_REQUEST, FinanzasErrorCodes.ERROR_INTERNO_FINANZAS);
    }

    private static String normalizar(String formato) {
        return formato == null ? "xlsx" : formato.trim().toLowerCase();
    }

    private static String estadoLabel(String flag) {
        if (flag == null) {
            return "";
        }
        return switch (flag) {
            case "3" -> "Pendiente";
            case "1" -> "Emitida";
            case "0" -> "Anulada";
            default -> flag;
        };
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
