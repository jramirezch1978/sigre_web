package pe.restaurant.activos.reporte;

/**
 * Columnas REP-001 según HU-AF-REP-001 §8.
 */
public final class AfReporteLibroColumnas {

    public static final String[] CABECERAS = {
            "Código de Activo",
            "Descripción del Activo",
            "Clase / Subclase",
            "Ubicación Física",
            "Fecha de Adquisición",
            "Fecha de Inicio de Depreciación",
            "Valor de Adquisición",
            "Depreciación Acumulada",
            "Valor Neto Contable",
            "Moneda",
            "Estado Actual",
            "Centro de Costo"
    };

    private AfReporteLibroColumnas() {
    }
}
