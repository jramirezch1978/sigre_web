package com.sigre.almacen.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.almacen.dto.*;
import com.sigre.almacen.entity.Almacen;
import com.sigre.almacen.entity.ArticuloRef;
import com.sigre.almacen.entity.OrdenTraslado;
import com.sigre.almacen.entity.OrdenTrasladoDet;
import com.sigre.almacen.repository.AlmacenRepository;
import com.sigre.almacen.repository.ArticuloRefRepository;
import com.sigre.almacen.repository.OrdenTrasladoDetRepository;
import com.sigre.almacen.repository.OrdenTrasladoRepository;
import com.sigre.almacen.service.EmpresaInfoService;
import com.sigre.common.report.JasperLogoContainer;
import com.sigre.almacen.service.OrdenTrasladoOperacionService;
import com.sigre.almacen.spec.OrdenTrasladoSpecifications;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.common.service.NumeradorDocumentoService;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class OrdenTrasladoOperacionServiceImpl implements OrdenTrasladoOperacionService {

    private static final String NOMBRE_TABLA_DOCUMENTO = "almacen.orden_traslado";

    private final OrdenTrasladoRepository ordenTrasladoRepository;
    private final OrdenTrasladoDetRepository ordenTrasladoDetRepository;
    private final AlmacenRepository almacenRepository;
    private final ArticuloRefRepository articuloRefRepository;
    private final NumeradorDocumentoService numeradorDocumentoService;
    private final EmpresaInfoService empresaInfoService;
    private final JdbcTemplate jdbcTemplate;

    @Override
    public Page<OrdenTrasladoResponse> buscar(Long almacenOrigenId, Long almacenDestinoId, String estado,
                                              LocalDate fechaDesde, LocalDate fechaHasta, Pageable pageable) {
        var spec = OrdenTrasladoSpecifications.conFiltros(
                almacenOrigenId, almacenDestinoId, estado, fechaDesde, fechaHasta);
        return ordenTrasladoRepository.findAll(spec, pageable).map(this::toResponseSinLineas);
    }

    @Override
    public OrdenTrasladoResponse obtener(Long id) {
        OrdenTraslado ot = ordenTrasladoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("OrdenTraslado", id));
        return toResponseCompleto(ot);
    }

    @Override
    @Transactional
    public OrdenTrasladoResponse crear(OrdenTrasladoRequest request) {
        validarAlmacenes(request.getAlmacenOrigenId(), request.getAlmacenDestinoId());
        for (OrdenTrasladoLineaRequest lr : request.getLineas()) {
            assertArticuloExiste(lr.getArticuloId());
            if (lr.getCantidad() == null || lr.getCantidad().compareTo(BigDecimal.ZERO) <= 0) {
                throw new BusinessException("Cada línea debe tener cantidad mayor a cero.",
                        HttpStatus.UNPROCESSABLE_ENTITY, "ALM-OT-001");
            }
        }
        Almacen origen = almacenRepository.findById(request.getAlmacenOrigenId())
                .orElseThrow(() -> new ResourceNotFoundException("Almacen", request.getAlmacenOrigenId()));

        OrdenTraslado ot = new OrdenTraslado();
        ot.setAlmacenOrigenId(request.getAlmacenOrigenId());
        ot.setAlmacenDestinoId(request.getAlmacenDestinoId());
        ot.setFecha(request.getFecha());
        ot.setObservacion(request.getObservacion());

        ot.setNumero(numeradorDocumentoService.siguienteNroDocumento(
                NOMBRE_TABLA_DOCUMENTO, origen.getSucursalId(), request.getFecha().getYear()));

        OrdenTraslado guardado = ordenTrasladoRepository.save(ot);

        for (OrdenTrasladoLineaRequest lr : request.getLineas()) {
            OrdenTrasladoDet det = new OrdenTrasladoDet();
            det.setOrdenTrasladoId(guardado.getId());
            det.setArticuloId(lr.getArticuloId());
            det.setCantidad(lr.getCantidad());
            ordenTrasladoDetRepository.save(det);
        }
        return toResponseCompleto(guardado);
    }

    @Override
    @Transactional
    public OrdenTrasladoResponse actualizar(Long id, OrdenTrasladoRequest request) {
        OrdenTraslado ot = ordenTrasladoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("OrdenTraslado", id));
        if (!"1".equals(ot.getFlagEstado())) {
            throw new BusinessException("Solo se puede editar una orden activa.",
                    HttpStatus.CONFLICT, "ALM-OT-002");
        }
        validarAlmacenes(request.getAlmacenOrigenId(), request.getAlmacenDestinoId());
        for (OrdenTrasladoLineaRequest lr : request.getLineas()) {
            assertArticuloExiste(lr.getArticuloId());
            if (lr.getCantidad() == null || lr.getCantidad().compareTo(BigDecimal.ZERO) <= 0) {
                throw new BusinessException("Cada línea debe tener cantidad mayor a cero.",
                        HttpStatus.UNPROCESSABLE_ENTITY, "ALM-OT-001");
            }
        }
        ot.setAlmacenOrigenId(request.getAlmacenOrigenId());
        ot.setAlmacenDestinoId(request.getAlmacenDestinoId());
        ot.setFecha(request.getFecha());
        ot.setObservacion(request.getObservacion());
        ordenTrasladoDetRepository.deleteByOrdenTrasladoId(id);
        ordenTrasladoRepository.save(ot);
        for (OrdenTrasladoLineaRequest lr : request.getLineas()) {
            OrdenTrasladoDet det = new OrdenTrasladoDet();
            det.setOrdenTrasladoId(id);
            det.setArticuloId(lr.getArticuloId());
            det.setCantidad(lr.getCantidad());
            ordenTrasladoDetRepository.save(det);
        }
        return toResponseCompleto(ot);
    }

    @Override
    @Transactional
    public OrdenTrasladoResponse cambiarEstado(Long id, String nuevoEstado) {
        if (nuevoEstado == null || nuevoEstado.isBlank()) {
            throw new BusinessException("Estado requerido.", HttpStatus.BAD_REQUEST, "ALM-OT-004");
        }
        OrdenTraslado ot = ordenTrasladoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("OrdenTraslado", id));
        if (!"1".equals(ot.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede cambiar el estado de una orden que no está activa.",
                    HttpStatus.CONFLICT, "ALM-OT-006");
        }
        ot.setFlagEstado(nuevoEstado.trim());
        return toResponseCompleto(ordenTrasladoRepository.save(ot));
    }

    @Override
    @Transactional
    public OrdenTrasladoResponse aprobar(Long id) {
        OrdenTraslado ot = ordenTrasladoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("OrdenTraslado", id));
        if (!"1".equals(ot.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede aprobar una orden activa.",
                    HttpStatus.CONFLICT, "ALM-OT-006");
        }
        return toResponseCompleto(ot);
    }

    @Override
    @Transactional
    public OrdenTrasladoResponse rechazar(Long id) {
        return cambiarEstado(id, "0");
    }

    @Override
    @Transactional
    public OrdenTrasladoResponse cerrar(Long id) {
        return cambiarEstado(id, "2");
    }

    @Override
    @Transactional
    public OrdenTrasladoResponse anular(Long id) {
        return cambiarEstado(id, "0");
    }

    @Override
    public byte[] exportarExcel(Long almacenOrigenId,
                                Long almacenDestinoId,
                                String estado,
                                LocalDate fechaDesde,
                                LocalDate fechaHasta) {
        var spec = OrdenTrasladoSpecifications.conFiltros(
                almacenOrigenId, almacenDestinoId, estado, fechaDesde, fechaHasta);
        List<OrdenTraslado> ordenes = ordenTrasladoRepository.findAll(spec);
        try (XSSFWorkbook wb = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = wb.createSheet("OrdenesTraslado");
            CellStyle headerStyle = wb.createCellStyle();
            Font font = wb.createFont();
            font.setBold(true);
            headerStyle.setFont(font);
            String[] headers = {"ID", "Número", "Alm. origen", "Alm. destino", "Fecha", "Estado", "Observación"};
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            int rowIdx = 1;
            for (OrdenTraslado ot : ordenes) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(ot.getId());
                row.createCell(1).setCellValue(ot.getNumero() != null ? ot.getNumero() : "");
                row.createCell(2).setCellValue(ot.getAlmacenOrigenId());
                row.createCell(3).setCellValue(ot.getAlmacenDestinoId());
                row.createCell(4).setCellValue(ot.getFecha() != null ? ot.getFecha().format(dtf) : "");
                row.createCell(5).setCellValue(ot.getFlagEstado() != null ? ot.getFlagEstado() : "");
                row.createCell(6).setCellValue(ot.getObservacion() != null ? ot.getObservacion() : "");
            }
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }
            wb.write(out);
            return out.toByteArray();
        } catch (Exception e) {
            throw new BusinessException("Error al generar el archivo Excel: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, "ALM-OT-010");
        }
    }

    @Override
    public byte[] generarPdf(Long id) {
        OrdenTraslado ot = ordenTrasladoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("OrdenTraslado", id));
        Almacen ao = almacenRepository.findById(ot.getAlmacenOrigenId()).orElse(null);
        Almacen ad = almacenRepository.findById(ot.getAlmacenDestinoId()).orElse(null);
        List<OrdenTrasladoDet> dets = ordenTrasladoDetRepository.findByOrdenTrasladoIdOrderById(ot.getId());
        List<Map<String, String>> rows = new ArrayList<>();
        BigDecimal totalCantidad = BigDecimal.ZERO;
        for (OrdenTrasladoDet d : dets) {
            if (d.getCantidad() != null) {
                totalCantidad = totalCantidad.add(d.getCantidad());
            }
            ArticuloRef art = articuloRefRepository.findById(d.getArticuloId()).orElse(null);
            Map<String, String> row = new HashMap<>();
            row.put("codigo", art != null && art.getCodigo() != null ? art.getCodigo() : String.valueOf(d.getArticuloId()));
            row.put("descripcion", art != null && art.getNombre() != null ? art.getNombre() : "");
            row.put("cantidad", d.getCantidad() != null
                    ? d.getCantidad().setScale(4, RoundingMode.HALF_UP).toPlainString()
                    : "");
            rows.add(row);
        }
        Long empresaId = TenantContext.getEmpresaId();
        EmpresaInfoService.EmpresaInfo empresaInfo = empresaInfoService.obtener(empresaId);
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        Map<String, Object> params = new HashMap<>();
        params.put("logoImage", empresaInfo.logoInputStream());
        params.put("logoSubreport", JasperLogoContainer.requireCompiledSubreport());
        params.put("logoSize", "L");
        params.put("empresaNombre", empresaInfo.razonSocial());
        params.put("empresaRuc", empresaInfo.ruc());
        params.put("numeroOt", ot.getNumero() != null ? ot.getNumero() : "");
        params.put("fechaOt", ot.getFecha() != null ? ot.getFecha().format(dtf) : "");
        params.put("estadoOt", ot.getFlagEstado() != null ? ot.getFlagEstado() : "");
        params.put("almOrigen", ao != null ? ao.getCodigo() + " — " + ao.getNombre() : String.valueOf(ot.getAlmacenOrigenId()));
        params.put("almDestino", ad != null ? ad.getCodigo() + " — " + ad.getNombre() : String.valueOf(ot.getAlmacenDestinoId()));
        params.put("observaciones", ot.getObservacion() != null ? ot.getObservacion() : "");
        params.put("totalCantidad", totalCantidad.setScale(4, RoundingMode.HALF_UP).toPlainString());
        try (java.io.InputStream jrxml = getClass().getResourceAsStream("/reports/orden_traslado.jrxml")) {
            if (jrxml == null) {
                throw new BusinessException("Plantilla orden_traslado.jrxml no encontrada",
                        HttpStatus.INTERNAL_SERVER_ERROR, "ALM-OT-011");
            }
            net.sf.jasperreports.engine.JasperReport jasperReport =
                    net.sf.jasperreports.engine.JasperCompileManager.compileReport(jrxml);
            net.sf.jasperreports.engine.data.JRBeanCollectionDataSource dataSource =
                    new net.sf.jasperreports.engine.data.JRBeanCollectionDataSource(rows);
            net.sf.jasperreports.engine.JasperPrint jasperPrint =
                    net.sf.jasperreports.engine.JasperFillManager.fillReport(jasperReport, params, dataSource);
            return net.sf.jasperreports.engine.JasperExportManager.exportReportToPdf(jasperPrint);
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.error("Error generando PDF orden traslado {}: {}", id, e.getMessage(), e);
            throw new BusinessException("Error al generar PDF: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, "ALM-OT-011");
        }
    }

    private void validarAlmacenes(Long origenId, Long destinoId) {
        if (origenId.equals(destinoId)) {
            throw new BusinessException("El almacén origen y destino deben ser distintos.",
                    HttpStatus.UNPROCESSABLE_ENTITY, "ALM-OT-005");
        }
        if (!almacenRepository.existsById(origenId)) {
            throw new ResourceNotFoundException("Almacen", origenId);
        }
        if (!almacenRepository.existsById(destinoId)) {
            throw new ResourceNotFoundException("Almacen", destinoId);
        }
    }

    private void assertArticuloExiste(Long articuloId) {
        Integer c = jdbcTemplate.queryForObject(
                "SELECT COUNT(*)::int FROM core.articulo WHERE id = ?", Integer.class, articuloId);
        if (c == null || c == 0) {
            throw new ResourceNotFoundException("Articulo", articuloId);
        }
    }

    private OrdenTrasladoResponse toResponseSinLineas(OrdenTraslado ot) {
        return OrdenTrasladoResponse.builder()
                .id(ot.getId())
                .almacenOrigenId(ot.getAlmacenOrigenId())
                .almacenDestinoId(ot.getAlmacenDestinoId())
                .numero(ot.getNumero())
                .fecha(ot.getFecha())
                .flagEstado(ot.getFlagEstado())
                .observacion(ot.getObservacion())
                .usuarioId(ot.getUsuarioId())
                .lineas(List.of())
                .build();
    }

    private OrdenTrasladoResponse toResponseCompleto(OrdenTraslado ot) {
        List<OrdenTrasladoDet> dets = ordenTrasladoDetRepository.findByOrdenTrasladoIdOrderById(ot.getId());
        List<OrdenTrasladoLineaResponse> lineas = new ArrayList<>();
        for (OrdenTrasladoDet d : dets) {
            lineas.add(OrdenTrasladoLineaResponse.builder()
                    .id(d.getId())
                    .articuloId(d.getArticuloId())
                    .cantidad(d.getCantidad())
                    .cantidadDespachada(d.getCantidadDespachada())
                    .cantidadRecibida(d.getCantidadRecibida())
                    .build());
        }
        return OrdenTrasladoResponse.builder()
                .id(ot.getId())
                .almacenOrigenId(ot.getAlmacenOrigenId())
                .almacenDestinoId(ot.getAlmacenDestinoId())
                .numero(ot.getNumero())
                .fecha(ot.getFecha())
                .flagEstado(ot.getFlagEstado())
                .observacion(ot.getObservacion())
                .usuarioId(ot.getUsuarioId())
                .lineas(lineas)
                .build();
    }
}
