package pe.restaurant.reportes.service.impl;

import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRMapCollectionDataSource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.report.HeaderReportHelper;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.reportes.service.EmpresaInfoService;

import javax.sql.DataSource;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class ReporteRegistroVentasService {

    private static final String SQL_PATH = "sql/reporte_registro_ventas.sql";
    private static final String JRXML_PATH = "/reports/reporte_registro_ventas.jrxml";

    private final NamedParameterJdbcTemplate namedJdbcTemplate;
    private final EmpresaInfoService empresaInfoService;

    public ReporteRegistroVentasService(DataSource dataSource, EmpresaInfoService empresaInfoService) {
        this.namedJdbcTemplate = new NamedParameterJdbcTemplate(dataSource);
        this.empresaInfoService = empresaInfoService;
    }

    @Transactional(readOnly = true)
    public byte[] generarPdf(Integer anio, Integer mes, String origen) {
        try {
            String sql = loadSql();
            Map<String, Object> params = buildSqlParams(anio, mes, origen);
            List<Map<String, Object>> rows = namedJdbcTemplate.queryForList(sql, params);

            Map<String, Object> reportParams = buildReportParams(anio, mes);
            JRMapCollectionDataSource dataSource = new JRMapCollectionDataSource((List) (List<?>) rows);

            InputStream jrxmlStream = getClass().getResourceAsStream(JRXML_PATH);
            if (jrxmlStream == null) {
                throw new BusinessException("Template de reporte no encontrado: " + JRXML_PATH,
                        HttpStatus.INTERNAL_SERVER_ERROR, "REPORT_TEMPLATE_NOT_FOUND");
            }

            JasperReport report = JasperCompileManager.compileReport(jrxmlStream);
            JasperPrint print = JasperFillManager.fillReport(report, reportParams, dataSource);
            return JasperExportManager.exportReportToPdf(print);

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.error("Error generando reporte Registro Ventas: {}", e.getMessage(), e);
            throw new BusinessException("Error al generar el reporte: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, "PDF_GENERATION_ERROR");
        }
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> ejecutarConsulta(Integer anio, Integer mes, String origen) {
        try {
            String sql = loadSql();
            Map<String, Object> params = buildSqlParams(anio, mes, origen);
            return namedJdbcTemplate.queryForList(sql, params);
        } catch (Exception e) {
            log.error("Error ejecutando consulta Registro Ventas: {}", e.getMessage(), e);
            throw new BusinessException("Error al ejecutar la consulta: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, "QUERY_ERROR");
        }
    }

    private String loadSql() throws Exception {
        ClassPathResource resource = new ClassPathResource(SQL_PATH);
        return new String(resource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
    }

    private Map<String, Object> buildSqlParams(Integer anio, Integer mes, String origen) {
        Map<String, Object> p = new HashMap<>();
        p.put("anio", anio);
        p.put("mes", mes);
        p.put("origen", origen != null ? origen : "%");
        return p;
    }

    private Map<String, Object> buildReportParams(Integer anio, Integer mes) {
        Long empresaId = TenantContext.getEmpresaId();
        EmpresaInfoService.EmpresaInfo empresaInfo = empresaInfoService.obtener(empresaId);

        String usuario = "";
        try {
            usuario = SecurityContextHolder.getContext().getAuthentication().getName();
        } catch (Exception e) {
            log.warn("No se pudo obtener el usuario del contexto de seguridad: {}", e.getMessage());
        }

        String nombreMoneda = obtenerNombreMonedaDefault();

        String reporteTitulo = "REPORTE DE VENTAS";
        String subtitulo = "Registro de ventas - Moneda " + nombreMoneda;

        return HeaderReportHelper.buildHeaderParams(
                empresaInfo.razonSocial(),
                empresaInfo.ruc(),
                empresaInfo.logoInputStream(),
                reporteTitulo,
                anio,
                mes,
                subtitulo,
                usuario
        );
    }

    private String obtenerNombreMonedaDefault() {
        try {
            String sql = """
                    SELECT m.nombre
                    FROM core.moneda m
                    WHERE m.id = core.fn_moneda_default_pen_id()
                    """;
            String nombreMoneda = namedJdbcTemplate.queryForObject(sql, Map.of(), String.class);
            return nombreMoneda != null ? nombreMoneda : "Soles";
        } catch (Exception e) {
            log.warn("No se pudo obtener el nombre de la moneda por defecto: {}", e.getMessage());
            return "Soles";
        }
    }
}
