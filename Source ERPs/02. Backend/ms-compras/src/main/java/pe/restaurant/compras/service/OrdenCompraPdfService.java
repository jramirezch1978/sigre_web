package pe.restaurant.compras.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.data.JRMapCollectionDataSource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.compras.entity.*;
import pe.restaurant.compras.repository.*;

import pe.restaurant.compras.util.NumeroALetras;

import java.io.InputStream;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class OrdenCompraPdfService {

    private static final String JRXML_PATH = "/reports/orden_compra.jrxml";
    private static final DecimalFormat DF = new DecimalFormat("#,##0.00");
    private static final DateTimeFormatter FMT_FECHA = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter FMT_FECHA_HORA = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    private final OrdenCompraRepository ordenCompraRepository;
    private final EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    private final EntidadBancoCntaRefRepository entidadBancoCntaRefRepository;
    private final MonedaRefRepository monedaRefRepository;
    private final ArticuloRefRepository articuloRefRepository;
    private final UnidadMedidaRefRepository unidadMedidaRefRepository;
    private final CompradorRepository compradorRepository;
    private final UsuarioRefRepository usuarioRefRepository;
    private final FormaPagoRefRepository formaPagoRefRepository;
    private final ContactoRefRepository contactoRefRepository;
    private final TipoDocIdentidadRefRepository tipoDocIdentidadRefRepository;
    private final EmpresaInfoService empresaInfoService;

    @Transactional(readOnly = true)
    public byte[] generarPdf(Long ordenCompraId) {
        OrdenCompra oc = ordenCompraRepository.findById(ordenCompraId)
                .orElseThrow(() -> new ResourceNotFoundException("OrdenCompra", ordenCompraId));
        oc.getLineas().size();

        try {
            Map<String, Object> params = buildParametros(oc);
            List<Map<String, ?>> rows = buildLineas(oc);
            JRMapCollectionDataSource dataSource = new JRMapCollectionDataSource(rows);

            InputStream jrxmlStream = getClass().getResourceAsStream(JRXML_PATH);
            JasperReport report = JasperCompileManager.compileReport(jrxmlStream);
            JasperPrint print = JasperFillManager.fillReport(report, params, dataSource);
            return JasperExportManager.exportReportToPdf(print);

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.error("Error generando PDF para OC {}: {}", ordenCompraId, e.getMessage(), e);
            throw new BusinessException("Error al generar el PDF: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, "PDF_GENERATION_ERROR");
        }
    }

    private Map<String, Object> buildParametros(OrdenCompra oc) {
        Map<String, Object> p = new HashMap<>();

        Long empresaId = TenantContext.getEmpresaId();
        EmpresaInfoService.EmpresaInfo empresaInfo = empresaInfoService.obtener(empresaId);
        p.put("logoImage", empresaInfo.logoInputStream());
        p.put("empresaNombre", empresaInfo.razonSocial());
        p.put("empresaRuc", empresaInfo.ruc());
        p.put("empresaDireccion", empresaInfo.direccion());

        EntidadContribuyenteRef empresa = entidadContribuyenteRefRepository
                .findFirstByFlagEstadoOrderByIdAsc("1").orElse(null);
        p.put("empresaEmail", empresa != null ? nvl(empresa.getEmail()) : "");

        EntidadContribuyenteRef proveedor = entidadContribuyenteRefRepository
                .findById(oc.getProveedorId()).orElse(null);
        p.put("proveedorCodigo", proveedor != null ? nvl(proveedor.getNroDocumento()) : "");
        p.put("proveedorNombre", proveedor != null ? proveedor.getNombreCompleto() : "");
        p.put("proveedorDireccion", proveedor != null ? nvl(proveedor.getDireccion()) : "");
        p.put("proveedorTelefono", proveedor != null ? nvl(proveedor.getTelefono()) : "");
        p.put("proveedorDocIdentidad", proveedor != null ? nvl(proveedor.getNroDocumento()) : "");
        p.put("proveedorTipoDocLabel", proveedor != null
                ? resolverTipoDocLabel(proveedor.getTipoDocIdentidadId(), proveedor.getTipoDocumento()) : "");
        p.put("proveedorEmail", proveedor != null ? nvl(proveedor.getEmail()) : "");

        // Vendedor = contacto registrado del proveedor (primero activo).
        String vendedor = "";
        if (oc.getProveedorId() != null) {
            vendedor = contactoRefRepository
                    .findFirstByEntidadContribuyenteIdAndFlagEstadoOrderByIdAsc(oc.getProveedorId(), "1")
                    .map(c -> nvl(c.getNombre()))
                    .orElse("");
        }
        p.put("proveedorVendedor", vendedor);

        p.put("nroOrdenCompra", oc.getNroOrdenCompra());

        // Forma de pago: mostrar el nombre, no el id.
        String formaPago = "";
        if (oc.getFormaPagoId() != null) {
            formaPago = formaPagoRefRepository.findById(oc.getFormaPagoId())
                    .map(f -> nvl(f.getNombre()))
                    .orElse("");
        }
        p.put("formaPago", formaPago);

        // Datos bancarios: priorizar los registrados en la propia OC; si faltan,
        // caer a la cuenta bancaria activa registrada para el proveedor.
        EntidadBancoCntaRef cuentaProveedor = entidadBancoCntaRefRepository
                .findFirstByEntidadContribuyenteIdAndFlagEstadoOrderByIdAsc(oc.getProveedorId(), "1")
                .orElse(null);

        String bancoPago = oc.getBancoId() != null
                ? String.valueOf(oc.getBancoId())
                : (cuentaProveedor != null ? nvl(cuentaProveedor.getCodBanco()) : "");
        p.put("bancoPago", bancoPago);

        String nroCuenta = (oc.getNroCuenta() != null && !oc.getNroCuenta().isBlank())
                ? oc.getNroCuenta()
                : (cuentaProveedor != null ? nvl(cuentaProveedor.getNroCuenta()) : "");
        p.put("nroCuenta", nroCuenta);

        String cci = "";
        if (oc.getEntidadBancoCntaId() != null) {
            cci = entidadBancoCntaRefRepository.findById(oc.getEntidadBancoCntaId())
                    .map(b -> nvl(b.getCci()))
                    .orElse("");
        }
        if (cci.isBlank() && cuentaProveedor != null) {
            cci = nvl(cuentaProveedor.getCci());
        }
        p.put("cci", cci);

        p.put("lugarEntrega", nvl(oc.getLugarEntrega()));
        p.put("observacion", nvl(oc.getObservaciones()));

        MonedaRef moneda = oc.getMonedaId() != null
                ? monedaRefRepository.findById(oc.getMonedaId()).orElse(null)
                : null;
        p.put("monedaDescripcion", moneda != null ? nvl(moneda.getNombre()) : "");
        p.put("monedaSimbolo", moneda != null ? moneda.getSimbolo() : "");

        p.put("fechaRegistro", oc.getFecCreacion() != null
                ? oc.getFecCreacion().format(FMT_FECHA_HORA) : "");

        p.put("subtotal", fmt(oc.getSubtotal()));
        p.put("descuento", fmt(oc.getDescuentoTotal()));
        p.put("igv", fmt(oc.getIgvTotal()));
        p.put("isc", "0.00");
        p.put("percepcion", fmt(oc.getPercepcionTotal()));
        p.put("otrosImp", "0.00");
        p.put("total", fmt(oc.getTotal()));

        String monedaNombre = moneda != null ? moneda.getNombre() : "";
        p.put("totalEnLetras", NumeroALetras.convertir(oc.getTotal(), monedaNombre));

        p.put("generadoPor", resolverNombreUsuario(oc.getCompradorId()));
        p.put("autorizadoPor", resolverNombreUsuario(oc.getAprobadorId()));

        return p;
    }

    private List<Map<String, ?>> buildLineas(OrdenCompra oc) {
        List<Map<String, ?>> rows = new ArrayList<>();
        for (OrdenCompraDet l : oc.getLineas()) {
            if ("0".equals(l.getFlagEstado())) continue;

            ArticuloRef articulo = articuloRefRepository.findById(l.getArticuloId()).orElse(null);
            UnidadMedidaRef unidad = articulo != null && articulo.getUnidadMedidaId() != null
                    ? unidadMedidaRefRepository.findById(articulo.getUnidadMedidaId()).orElse(null)
                    : null;

            Map<String, String> row = new HashMap<>();
            row.put("codigo", articulo != null ? nvl(articulo.getCodigo()) : "");
            row.put("unidad", unidad != null ? unidad.getLabel() : "");
            row.put("descripcion", articulo != null ? nvl(articulo.getNombre()) : "");
            row.put("fechaAtencion", l.getFechaEntrega() != null ? l.getFechaEntrega().format(FMT_FECHA) : "");
            row.put("cantidad", fmt(l.getCantProyectada()));
            row.put("precioUnitario", fmt(l.getValorUnitario()));
            row.put("descuento", fmt(l.getDescuentoMonto()));
            row.put("importeVenta", fmt(l.getSubtotal()));
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

    /**
     * Resuelve el nombre del tipo de documento de identidad del proveedor
     * (ej. "RUC", "DNI") desde core.tipo_doc_identidad, para usarlo como etiqueta.
     * Se intenta por id (tipo_doc_identidad_id) y, en su defecto, por código.
     */
    private String resolverTipoDocLabel(Long tipoDocIdentidadId, String tipoDocumento) {
        if (tipoDocIdentidadId != null) {
            String nombre = tipoDocIdentidadRefRepository.findById(tipoDocIdentidadId)
                    .map(TipoDocIdentidadRef::getNombre)
                    .filter(n -> n != null && !n.isBlank())
                    .orElse(null);
            if (nombre != null) return nombre;
        }
        if (tipoDocumento != null && !tipoDocumento.isBlank()) {
            return tipoDocIdentidadRefRepository.findFirstByCodigoAndFlagEstado(tipoDocumento.trim(), "1")
                    .map(TipoDocIdentidadRef::getNombre)
                    .filter(n -> n != null && !n.isBlank())
                    .orElse("");
        }
        return "";
    }

    private String fmt(BigDecimal v) {
        return v != null ? DF.format(v) : "0.00";
    }

    private static String nvl(String s) {
        return s != null ? s : "";
    }
}
