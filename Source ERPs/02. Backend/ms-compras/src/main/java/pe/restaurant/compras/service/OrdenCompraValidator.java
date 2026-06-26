package pe.restaurant.compras.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import pe.restaurant.compras.dto.OrdenCompraCabeceraRequest;
import pe.restaurant.compras.dto.OrdenCompraLineaRequest;
import pe.restaurant.compras.entity.DocTipoRef;
import pe.restaurant.compras.entity.*;
import pe.restaurant.compras.repository.*;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.service.ConfigParameterService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class OrdenCompraValidator {

    private static final String TIPO_DOC_CODIGO = "OC";
    private static final Long MONEDA_BASE_PEN = 1L;

    private final CompradorRepository compradorRepository;
    private final AprobadorConfiguradoRepository aprobadorConfiguradoRepository;
    private final CompraFondoRepository compraFondoRepository;
    private final EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    private final MonedaRefRepository monedaRefRepository;
    private final SucursalRefRepository sucursalRefRepository;
    private final ArticuloRefRepository articuloRefRepository;
    private final TiposImpuestoRefRepository tiposImpuestoRefRepository;
    private final ConfigParameterService configParameterService;
    private final ValeMovRefRepository valeMovRefRepository;
    private final JdbcTemplate jdbcTemplate;

    @Autowired(required = false)
    private DocTipoRefRepository docTipoRefRepository;

    public Long verificarCompradorActivo() {
        Long usuarioId = TenantContext.getUsuarioId();
        if (usuarioId == null) {
            throw new BusinessException("Usuario no autenticado", HttpStatus.UNAUTHORIZED, "TOKEN_REQUERIDO");
        }
        return compradorRepository.findByUsuarioIdAndFlagEstado(usuarioId, "1")
                .orElseThrow(() -> new BusinessException(
                        "El usuario actual no está registrado como comprador activo",
                        HttpStatus.UNPROCESSABLE_ENTITY, "COM-002"))
                .getId();
    }

    public void validarCabecera(OrdenCompraCabeceraRequest request) {
        validarProveedorExiste(request.getProveedorId());
        validarMonedaExiste(request.getMonedaId());
        validarSucursalExiste(request.getSucursalId());

        if (request.getMonedaId() != null && !MONEDA_BASE_PEN.equals(request.getMonedaId())) {
            if (request.getTipoCambio() == null || request.getTipoCambio().signum() <= 0) {
                throw new BusinessException(
                        "El tipo de cambio es obligatorio para moneda extranjera",
                        HttpStatus.UNPROCESSABLE_ENTITY, "COM-003");
            }
        }

        if (Boolean.TRUE.equals(request.getFlagImportacion())
                && request.getImportacion() == null) {
            throw new BusinessException(
                    "Datos de importación son obligatorios para OC de importación",
                    HttpStatus.UNPROCESSABLE_ENTITY, "COM-004");
        }
    }

    public void validarDetalle(List<OrdenCompraLineaRequest> lineas) {
        if (lineas == null || lineas.isEmpty()) {
            throw new BusinessException(
                    "La orden de compra debe tener al menos una línea",
                    HttpStatus.BAD_REQUEST, "COM-005");
        }
        for (int i = 0; i < lineas.size(); i++) {
            OrdenCompraLineaRequest l = lineas.get(i);
            int n = i + 1;
            if (l.getCantProyectada() == null || l.getCantProyectada().compareTo(BigDecimal.ZERO) <= 0) {
                throw new BusinessException(
                        "La cantidad debe ser mayor a cero (línea " + n + ")",
                        HttpStatus.BAD_REQUEST, "COM-006");
            }
            if (l.getValorUnitario() == null || l.getValorUnitario().compareTo(BigDecimal.ZERO) <= 0) {
                throw new BusinessException(
                        "El precio unitario debe ser mayor a cero (línea " + n + ")",
                        HttpStatus.BAD_REQUEST, "COM-007");
            }
            if (l.getFechaEntrega() == null) {
                throw new BusinessException(
                        "La fecha de entrega es obligatoria (línea " + n + ")",
                        HttpStatus.BAD_REQUEST, "COM-008");
            }
        }
    }

    public void validarDetalleFino(List<OrdenCompraLineaRequest> lineas, LocalDate fechaEmision) {
        if (lineas == null) return;
        for (int i = 0; i < lineas.size(); i++) {
            OrdenCompraLineaRequest l = lineas.get(i);
            int n = i + 1;

            validarArticuloActivo(l.getArticuloId(), n);

            if (l.getTipoImpuestoId() != null) {
                validarTipoImpuestoExiste(l.getTipoImpuestoId(), n);
            }

            if (fechaEmision != null && l.getFechaEntrega() != null
                    && l.getFechaEntrega().isBefore(fechaEmision)) {
                throw new BusinessException(
                        "La fecha de entrega no puede ser anterior a la fecha de emisión (línea " + n + ")",
                        HttpStatus.BAD_REQUEST, "COM-026");
            }
        }
    }

    private void validarArticuloActivo(Long articuloId, int numLinea) {
        if (articuloId == null) return;
        ArticuloRef articulo = articuloRefRepository.findById(articuloId)
                .orElseThrow(() -> new BusinessException(
                        "El artículo id " + articuloId + " no existe (línea " + numLinea + ")",
                        HttpStatus.BAD_REQUEST, "COM-028"));
        if (!"1".equals(articulo.getFlagEstado())) {
            throw new BusinessException(
                    "El artículo id " + articuloId + " no está activo (línea " + numLinea + ")",
                    HttpStatus.BAD_REQUEST, "COM-027");
        }
    }

    private void validarTipoImpuestoExiste(Long tipoImpuestoId, int numLinea) {
        if (!tiposImpuestoRefRepository.existsById(tipoImpuestoId)) {
            throw new BusinessException(
                    "El tipo de impuesto id " + tipoImpuestoId + " no existe (línea " + numLinea + ")",
                    HttpStatus.BAD_REQUEST, "COM-029");
        }
    }

    public void verificarPrecios(OrdenCompra oc) {
        if ("0".equals(oc.getFlagEstado())) return;
        for (OrdenCompraDet linea : oc.getLineas()) {
            if ("0".equals(linea.getFlagEstado())) continue;
            if (linea.getValorUnitario() == null || linea.getValorUnitario().signum() == 0) {
                throw new BusinessException(
                        "No se permite precio cero en línea activa (artículo id: " + linea.getArticuloId() + ")",
                        HttpStatus.UNPROCESSABLE_ENTITY, "COM-009");
            }
            if (linea.getCantProyectada() == null || linea.getCantProyectada().signum() == 0) {
                throw new BusinessException(
                        "No se permite cantidad cero en línea activa (artículo id: " + linea.getArticuloId() + ")",
                        HttpStatus.UNPROCESSABLE_ENTITY, "COM-010");
            }
        }
    }

    public void validarAprobadorConfigurado(Long usuarioId, BigDecimal montoOc) {
        Long docTipoId = resolveDocTipoId(TIPO_DOC_CODIGO);
        List<AprobadorConfigurado> aprobadores = aprobadorConfiguradoRepository.findAll().stream()
                .filter(a -> docTipoId.equals(a.getDocTipoId())
                        && usuarioId.equals(a.getAprobadorId())
                        && "1".equals(a.getFlagEstado()))
                .toList();

        if (aprobadores.isEmpty()) {
            throw new BusinessException(
                    "El usuario no es aprobador configurado para este documento",
                    HttpStatus.FORBIDDEN, "COM-022");
        }

        boolean dentroDeRango = aprobadores.stream().anyMatch(a -> {
            boolean minOk = a.getMontoMinimo() == null || montoOc.compareTo(a.getMontoMinimo()) >= 0;
            boolean maxOk = a.getMontoMaximo() == null || montoOc.compareTo(a.getMontoMaximo()) <= 0;
            return minOk && maxOk;
        });

        if (!dentroDeRango) {
            throw new BusinessException(
                    "El monto de la OC está fuera del rango autorizado del aprobador",
                    HttpStatus.FORBIDDEN, "COM-023");
        }
    }

    public void verificarNoVieneDeAprovisionamiento(Long ordenCompraId) {
        if (!valeMovRefRepository.findByOrdenCompraIdOrderByFechaDesc(ordenCompraId).isEmpty()) {
            throw new BusinessException(
                    "No se puede anular una OC generada desde Aprovisionamiento",
                    HttpStatus.CONFLICT, "COM-012");
        }
    }

    public void verificarSinAnticipos(Long ordenCompraId) {
        BigDecimal totalAnticipos = BigDecimal.ZERO;
        try {
            totalAnticipos = jdbcTemplate.queryForObject(
                    "SELECT COALESCE(SUM(monto), 0) FROM compras.oc_nota_credito " +
                    "WHERE orden_compra_id = ? AND estado = 'EMITIDA'",
                    BigDecimal.class, ordenCompraId);
        } catch (Exception ignored) {
            return;
        }
        if (totalAnticipos != null && totalAnticipos.signum() > 0) {
            throw new BusinessException(
                    "No se puede anular: la OC tiene anticipos emitidos por " + totalAnticipos,
                    HttpStatus.CONFLICT, "COM-014");
        }
    }

    public void verificarAnticiposNoExcedenTotal(Long ordenCompraId, BigDecimal nuevoTotal) {
        BigDecimal totalAnticipos = BigDecimal.ZERO;
        try {
            totalAnticipos = jdbcTemplate.queryForObject(
                    "SELECT COALESCE(SUM(monto), 0) FROM compras.oc_nota_credito " +
                    "WHERE orden_compra_id = ? AND estado = 'EMITIDA'",
                    BigDecimal.class, ordenCompraId);
        } catch (Exception ignored) {
            return;
        }
        if (totalAnticipos != null && nuevoTotal.compareTo(totalAnticipos) < 0) {
            throw new BusinessException(
                    "El nuevo total (" + nuevoTotal + ") no puede ser menor a los anticipos emitidos (" + totalAnticipos + ")",
                    HttpStatus.UNPROCESSABLE_ENTITY, "COM-019");
        }
    }

    public boolean isFondosControlActivo() {
        return configParameterService.isTextFlagOn("flag_cntrl_fondos", "0");
    }

    public void verificarFondosDisponibles(OrdenCompra oc) {
        int anio = oc.getFechaEmision().getYear();
        for (OrdenCompraDet linea : oc.getLineas()) {
            if ("0".equals(linea.getFlagEstado())) continue;
            if (linea.getCentrosCostoId() == null) continue;

            CompraFondo fondo = compraFondoRepository
                    .findByCentrosCostoIdAndAnioAndFlagEstado(linea.getCentrosCostoId(), anio, "1")
                    .orElseThrow(() -> new BusinessException(
                            "No existe fondo presupuestal para centros_costo_id=" + linea.getCentrosCostoId(),
                            HttpStatus.UNPROCESSABLE_ENTITY, "COM-017"));

            BigDecimal disponible = fondo.getMontoTotal().subtract(fondo.getMontoUsado());
            BigDecimal requerido = linea.getSubtotal() != null ? linea.getSubtotal() : BigDecimal.ZERO;

            if (requerido.compareTo(disponible) > 0) {
                throw new BusinessException(
                        "Fondo insuficiente para centros_costo_id=" + linea.getCentrosCostoId()
                                + ". Disponible: " + disponible + ", requerido: " + requerido,
                        HttpStatus.UNPROCESSABLE_ENTITY, "COM-018");
            }
        }
    }

    public void consumirFondos(OrdenCompra oc) {
        int anio = oc.getFechaEmision().getYear();
        for (OrdenCompraDet linea : oc.getLineas()) {
            if ("0".equals(linea.getFlagEstado())) continue;
            if (linea.getCentrosCostoId() == null) continue;

            compraFondoRepository
                    .findByCentrosCostoIdAndAnioAndFlagEstado(linea.getCentrosCostoId(), anio, "1")
                    .ifPresent(fondo -> {
                        BigDecimal monto = linea.getSubtotal() != null ? linea.getSubtotal() : BigDecimal.ZERO;
                        fondo.setMontoUsado(fondo.getMontoUsado().add(monto));
                        compraFondoRepository.save(fondo);
                    });
        }
    }

    public void liberarFondos(OrdenCompra oc) {
        int anio = oc.getFechaEmision().getYear();
        for (OrdenCompraDet linea : oc.getLineas()) {
            if (linea.getCentrosCostoId() == null) continue;

            compraFondoRepository
                    .findByCentrosCostoIdAndAnioAndFlagEstado(linea.getCentrosCostoId(), anio, "1")
                    .ifPresent(fondo -> {
                        BigDecimal monto = linea.getSubtotal() != null ? linea.getSubtotal() : BigDecimal.ZERO;
                        fondo.setMontoUsado(fondo.getMontoUsado().subtract(monto).max(BigDecimal.ZERO));
                        compraFondoRepository.save(fondo);
                    });
        }
    }

    private void validarProveedorExiste(Long id) {
        if (id == null) return;
        if (!entidadContribuyenteRefRepository.existsById(id)) {
            throw new BusinessException("Proveedor con id " + id + " no existe",
                    HttpStatus.BAD_REQUEST, "VALIDATION_ERROR");
        }
    }

    private void validarMonedaExiste(Long id) {
        if (id == null) return;
        if (!monedaRefRepository.existsById(id)) {
            throw new BusinessException("Moneda con id " + id + " no existe",
                    HttpStatus.BAD_REQUEST, "VALIDATION_ERROR");
        }
    }

    private void validarSucursalExiste(Long id) {
        if (id == null) return;
        if (!sucursalRefRepository.existsById(id)) {
            throw new BusinessException("Sucursal con id " + id + " no existe",
                    HttpStatus.BAD_REQUEST, "VALIDATION_ERROR");
        }
    }

    private Long resolveDocTipoId(String codigo) {
        if (docTipoRefRepository != null) {
            return docTipoRefRepository.findFirstByCodigoAndFlagEstado(codigo, "1")
                    .map(DocTipoRef::getId)
                    .orElseThrow(() -> new BusinessException(
                            "No existe tipo de documento activo para codigo " + codigo,
                            HttpStatus.UNPROCESSABLE_ENTITY, "COM-030"));
        }
        return jdbcTemplate.queryForObject(
                "SELECT id FROM core.doc_tipo WHERE codigo = ? AND flag_estado = '1'",
                Long.class, codigo);
    }
}
