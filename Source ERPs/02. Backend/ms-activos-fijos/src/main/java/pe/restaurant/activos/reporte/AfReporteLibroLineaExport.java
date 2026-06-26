package pe.restaurant.activos.reporte;

import pe.restaurant.activos.dto.reporte.AfReporteLibroLineaResponse;

import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/** Valores de fila REP-001 en el orden de {@link AfReporteLibroColumnas}. */
public final class AfReporteLibroLineaExport {

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private AfReporteLibroLineaExport() {
    }

    public static List<String> valoresCelda(AfReporteLibroLineaResponse l) {
        List<String> row = new ArrayList<>(AfReporteLibroColumnas.CABECERAS.length);
        row.add(nullSafe(l.getCodigo()));
        row.add(nullSafe(l.getNombre()));
        row.add(nullSafe(l.getClaseSubclase()));
        row.add(nullSafe(l.getUbicacionFisica()));
        row.add(l.getFechaAdquisicion() != null ? l.getFechaAdquisicion().format(FMT) : "");
        row.add(l.getFechaInicioDepreciacion() != null ? l.getFechaInicioDepreciacion().format(FMT) : "");
        row.add(formatDecimal(l.getValorAdquisicion()));
        row.add(formatDecimal(l.getDepreciacionAcumulada()));
        row.add(formatDecimal(l.getValorNeto()));
        row.add(nullSafe(l.getMoneda()));
        row.add(nullSafe(l.getEstadoActivo()));
        row.add(nullSafe(l.getCentroCosto()));
        return row;
    }

    public static String csvHeaderLine() {
        return String.join(",", AfReporteLibroColumnas.CABECERAS);
    }

    public static String csvDataLine(AfReporteLibroLineaResponse l) {
        return valoresCelda(l).stream()
                .map(AfReporteLibroLineaExport::csvEscape)
                .reduce((a, b) -> a + "," + b)
                .orElse("");
    }

    private static String csvEscape(String v) {
        if (v == null) {
            return "";
        }
        if (v.contains(",") || v.contains("\"") || v.contains("\n")) {
            return "\"" + v.replace("\"", "\"\"") + "\"";
        }
        return v;
    }

    private static String nullSafe(String v) {
        return v != null ? v : "";
    }

    private static String formatDecimal(BigDecimal v) {
        return v != null ? v.toPlainString() : "";
    }
}
