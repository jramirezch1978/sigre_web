package pe.restaurant.common.report;

import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperReport;

import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

/**
 * Helper centralizado para construir parámetros del header reutilizable de reportes.
 * Facilita la configuración del subreporte header_empresa.jrxml en todos los reportes del sistema.
 */
@Slf4j
public final class HeaderReportHelper {

    private static final String HEADER_JRXML_PATH = "/reports/header_empresa.jrxml";
    private static final String LOGO_JRXML_PATH = "/reports/logo_container.jrxml";
    
    private static final String[] MESES = {
        "", "ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO",
        "JULIO", "AGOSTO", "SETIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE"
    };

    private HeaderReportHelper() {
        // Utility class
    }

    /**
     * Construye los parámetros necesarios para el header reutilizable del reporte.
     * Incluye compilación de subreportes (header y logo) y todos los parámetros requeridos.
     *
     * @param empresaNombre Razón social de la empresa
     * @param empresaRuc RUC de la empresa
     * @param logoInputStream InputStream con la imagen del logo (puede ser null)
     * @param reporteTitulo Título principal del reporte
     * @param anio Año del reporte
     * @param mes Mes del reporte (1-12)
     * @param subtitulo Subtítulo adicional del reporte
     * @param usuario Nombre del usuario que genera el reporte
     * @return Map con todos los parámetros necesarios para el header
     */
    public static Map<String, Object> buildHeaderParams(
            String empresaNombre,
            String empresaRuc,
            InputStream logoInputStream,
            String reporteTitulo,
            Integer anio,
            Integer mes,
            String subtitulo,
            String usuario) {
        
        Map<String, Object> params = new HashMap<>();
        
        // Compilar subreporte del header
        try {
            InputStream headerJrxml = HeaderReportHelper.class.getResourceAsStream(HEADER_JRXML_PATH);
            if (headerJrxml != null) {
                JasperReport headerSubreport = JasperCompileManager.compileReport(headerJrxml);
                params.put("headerSubreport", headerSubreport);
            } else {
                log.warn("No se encontró el subreporte del header: {}", HEADER_JRXML_PATH);
            }
        } catch (Exception e) {
            log.error("Error compilando subreporte del header: {}", e.getMessage(), e);
        }
        
        // Compilar subreporte del logo
        try {
            InputStream logoJrxml = HeaderReportHelper.class.getResourceAsStream(LOGO_JRXML_PATH);
            if (logoJrxml != null) {
                JasperReport logoSubreport = JasperCompileManager.compileReport(logoJrxml);
                params.put("logoSubreport", logoSubreport);
            } else {
                log.warn("No se encontró el subreporte del logo: {}", LOGO_JRXML_PATH);
            }
        } catch (Exception e) {
            log.error("Error compilando subreporte del logo: {}", e.getMessage(), e);
        }
        
        // Parámetros de la empresa
        params.put("empresaNombre", empresaNombre != null ? empresaNombre : "");
        params.put("empresaRuc", empresaRuc != null ? empresaRuc : "");
        params.put("logoImage", logoInputStream);
        params.put("logoSize", "M");
        
        // Parámetros del reporte
        params.put("reporteTitulo", reporteTitulo != null ? reporteTitulo : "");
        params.put("anio", anio);
        params.put("mes", mes);
        params.put("mesNombre", obtenerNombreMes(mes));
        params.put("subtitulo", subtitulo != null ? subtitulo : "");
        params.put("usuario", usuario != null ? usuario : "");
        
        return params;
    }

    /**
     * Obtiene el nombre del mes en español.
     *
     * @param mes Número del mes (1-12)
     * @return Nombre del mes en mayúsculas (ej: "ENERO")
     */
    private static String obtenerNombreMes(Integer mes) {
        if (mes == null || mes < 1 || mes > 12) {
            return "";
        }
        return MESES[mes];
    }

    /**
     * Construye los parámetros del header con el nombre del mes calculado automáticamente.
     * Versión simplificada sin necesidad de pasar el nombre del mes.
     *
     * @param empresaNombre Razón social de la empresa
     * @param empresaRuc RUC de la empresa
     * @param logoInputStream InputStream con la imagen del logo (puede ser null)
     * @param reporteTitulo Título principal del reporte
     * @param anio Año del reporte
     * @param mes Mes del reporte (1-12)
     * @param subtitulo Subtítulo adicional del reporte
     * @param usuario Nombre del usuario que genera el reporte
     * @return Map con todos los parámetros necesarios para el header
     */
    public static Map<String, Object> buildHeaderParamsSimple(
            String empresaNombre,
            String empresaRuc,
            InputStream logoInputStream,
            String reporteTitulo,
            Integer anio,
            Integer mes,
            String subtitulo,
            String usuario) {
        
        return buildHeaderParams(
                empresaNombre,
                empresaRuc,
                logoInputStream,
                reporteTitulo,
                anio,
                mes,
                subtitulo,
                usuario
        );
    }
}
