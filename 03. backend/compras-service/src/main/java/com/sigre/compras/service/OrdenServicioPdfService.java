package com.sigre.compras.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.data.JRMapCollectionDataSource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.compras.entity.*;
import com.sigre.compras.repository.*;

import java.io.InputStream;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class OrdenServicioPdfService {

    private static final String JRXML_OS = "/reports/orden_servicio.jrxml";
    private static final String JRXML_ACTA = "/reports/acta_conformidad.jrxml";
    private static final DecimalFormat DF = new DecimalFormat("#,##0.00");
    private static final DateTimeFormatter FMT_FECHA = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter FMT_FECHA_HORA = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    private final OrdenServicioRepository ordenServicioRepository;
    private final EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    private final MonedaRefRepository monedaRefRepository;
    private final ServicioCatalogoRepository servicioCatalogoRepository;
    private final CompradorRepository compradorRepository;
    private final UsuarioRefRepository usuarioRefRepository;
    private final EmpresaInfoService empresaInfoService;

    @Transactional(readOnly = true)
    public byte[] generarPdf(Long ordenServicioId) {
        return generarReporte(ordenServicioId, JRXML_OS);
    }

    @Transactional(readOnly = true)
    public byte[] generarActaConformidadPdf(Long ordenServicioId) {
        return generarReporte(ordenServicioId, JRXML_ACTA);
    }

    private byte[] generarReporte(Long ordenServicioId, String jrxmlPath) {
        OrdenServicio os = ordenServicioRepository.findById(ordenServicioId)
                .orElseThrow(() -> new ResourceNotFoundException("OrdenServicio", ordenServicioId));
        os.getLineas().size();

        try {
            Map<String, Object> params = buildParametros(os);
            List<Map<String, ?>> rows = buildLineas(os);
            JRMapCollectionDataSource dataSource = new JRMapCollectionDataSource(rows);

            InputStream jrxmlStream = getClass().getResourceAsStream(jrxmlPath);
            if (jrxmlStream == null) {
                throw new BusinessException("Plantilla de reporte no encontrada: " + jrxmlPath,
                        HttpStatus.INTERNAL_SERVER_ERROR, "PDF_TEMPLATE_NOT_FOUND");
            }
            JasperReport report = JasperCompileManager.compileReport(jrxmlStream);
            JasperPrint print = JasperFillManager.fillReport(report, params, dataSource);
            return JasperExportManager.exportReportToPdf(print);

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.error("Error generando PDF para OS {}: {}", ordenServicioId, e.getMessage(), e);
            throw new BusinessException("Error al generar el PDF: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, "PDF_GENERATION_ERROR");
        }
    }

    private Map<String, Object> buildParametros(OrdenServicio os) {
        Map<String, Object> p = new HashMap<>();

        Long empresaId = TenantContext.getEmpresaId();
        EmpresaInfoService.EmpresaInfo empresaInfo = empresaInfoService.obtener(empresaId);
        p.put("logoImage", empresaInfo.logoInputStream());
        p.put("empresaNombre", empresaInfo.razonSocial());
        p.put("empresaRuc", empresaInfo.ruc());
        p.put("empresaDireccion", empresaInfo.direccion());

        EntidadContribuyenteRef proveedor = entidadContribuyenteRefRepository
                .findById(os.getProveedorId()).orElse(null);
        p.put("proveedorNombre", proveedor != null ? proveedor.getNombreCompleto() : "");
        p.put("proveedorRuc", proveedor != null ? nvl(proveedor.getNroDocumento()) : "");
        p.put("proveedorDireccion", "");

        MonedaRef moneda = os.getMonedaId() != null
                ? monedaRefRepository.findById(os.getMonedaId()).orElse(null)
                : null;
        p.put("monedaDescripcion", moneda != null ? nvl(moneda.getNombre()) : "");
        p.put("monedaSimbolo", moneda != null ? moneda.getSimbolo() : "");

        p.put("nroOs", nvl(os.getNroOs()));
        p.put("formaPago", os.getFormaPagoId() != null ? String.valueOf(os.getFormaPagoId()) : "");
        p.put("fechaRegistro", os.getFecCreacion() != null
                ? os.getFecCreacion().format(FMT_FECHA_HORA) : "");
        p.put("total", fmt(os.getMontoTotal()));
        p.put("descripcion", nvl(os.getDescripcion()));

        p.put("generadoPor", resolverNombreUsuario(os.getCompradorId()));
        p.put("autorizadoPor", resolverNombreUsuario(os.getAprobadorId()));

        return p;
    }

    private List<Map<String, ?>> buildLineas(OrdenServicio os) {
        List<Map<String, ?>> rows = new ArrayList<>();
        for (OrdenServicioDet l : os.getLineas()) {
            if ("0".equals(l.getFlagEstado())) continue;

            ServicioCatalogo serv = servicioCatalogoRepository.findById(l.getServicioId()).orElse(null);

            Map<String, String> row = new HashMap<>();
            row.put("codigo", serv != null ? nvl(serv.getServicio()) : "");
            row.put("descripcion", nvl(l.getDescripcion()));
            row.put("fechaProyectada", l.getFecProyect() != null ? l.getFecProyect().format(FMT_FECHA) : "");
            row.put("importe", fmt(l.getImporte()));
            row.put("descuento", fmt(l.getDecuento()));
            row.put("impuesto", fmt(l.getImpuesto()));
            row.put("subtotal", fmt(l.getSubtotal()));
            rows.add(row);
        }
        return rows;
    }

    private String resolverNombreUsuario(Long compradorId) {
        if (compradorId == null) return "";
        return compradorRepository.findById(compradorId)
                .map(c -> {
                    if (c.getNombre() != null && !c.getNombre().isBlank()) return c.getNombre();
                    return usuarioRefRepository.findById(c.getUsuarioId())
                            .map(UsuarioRef::getUsername)
                            .orElse("");
                })
                .orElseGet(() -> usuarioRefRepository.findById(compradorId)
                        .map(UsuarioRef::getUsername)
                        .orElse(""));
    }

    private String fmt(BigDecimal v) {
        return v != null ? DF.format(v) : "0.00";
    }

    private static String nvl(String s) {
        return s != null ? s : "";
    }
}
