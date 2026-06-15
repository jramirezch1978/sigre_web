package com.sigre.almacen.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.almacen.domain.MovimientoErrorCode;
import com.sigre.almacen.domain.ValeMovFlagEstado;
import com.sigre.almacen.dto.*;
import com.sigre.almacen.entity.*;
import com.sigre.almacen.event.publisher.AlmacenPreAsientoPublisher;
import com.sigre.almacen.repository.*;
import com.sigre.almacen.service.EmpresaInfoService;
import com.sigre.common.report.JasperLogoContainer;
import com.sigre.almacen.service.ValeMovService;
import com.sigre.almacen.spec.ValeMovSpecifications;
import com.sigre.almacen.support.UsuarioResumenLoader;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.service.NumeradorDocumentoService;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ValeMovServiceImpl implements ValeMovService {

    private static final String NOMBRE_TABLA_DOCUMENTO = "almacen.vale_mov";
    private static final String GRP_CNTBL_DEFAULT = "20";
    /** {@code core.parametro_sistema.codigo} para grupo contable por tenant (fallback {@link #GRP_CNTBL_DEFAULT}). */
    private static final String PARAM_GRP_CNTBL_DEFAULT = "ALMACEN_GRP_CNTBL_DEFAULT";
    /** Sufijo de {@code core.parametro_sistema.codigo} por {@code articulo_mov_tipo.tipo_mov} (ej. {@code ALMACEN_GRP_CNTBL_I01}). */
    private static final String PARAM_GRP_CNTBL_PREFIX = "ALMACEN_GRP_CNTBL_";

    private final ValeMovRepository valeMovRepository;
    private final ArticuloMovTipoRepository articuloMovTipoRepository;
    private final AlmacenRepository almacenRepository;
    private final AlmacenTipoMovRepository almacenTipoMovRepository;
    private final UbicacionAlmacenRepository ubicacionAlmacenRepository;
    private final ArticuloAlmacenRepository articuloAlmacenRepository;
    private final ArticuloAlmacenPosicionRepository articuloAlmacenPosicionRepository;
    private final ArticuloSaldoMensualRepository articuloSaldoMensualRepository;
    private final CntblCierreRepository cntblCierreRepository;
    private final ArticuloRefRepository articuloRefRepository;
    private final ArticuloSubCategRefRepository articuloSubCategRefRepository;
    private final TipoMovMatrizSubcatRepository tipoMovMatrizSubcatRepository;
    private final OrdenTrasladoRepository ordenTrasladoRepository;
    private final GuiaRepository guiaRepository;
    private final JdbcTemplate jdbcTemplate;
    private final NumeradorDocumentoService numeradorDocumentoService;
    private final SucursalRefRepository sucursalRefRepository;
    private final EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    private final UnidadMedidaRefRepository unidadMedidaRefRepository;
    private final EmpresaInfoService empresaInfoService;
    private final UsuarioResumenLoader usuarioResumenLoader;
    private final AlmacenPreAsientoPublisher preAsientoPublisher;

    @Override
    public Page<MovimientoListItemResponse> listar(Long sucursalId,
                                                   Long almacenId,
                                                   Long articuloMovTipoId,
                                                   String estado,
                                                   LocalDate fechaDesde,
                                                   LocalDate fechaHasta,
                                                   Long ordenCompraId,
                                                   Long ordenVentaId,
                                                   String tipoReferenciaOrigen,
                                                   Pageable pageable) {
        var spec = ValeMovSpecifications.conFiltros(
                sucursalId, almacenId, articuloMovTipoId, estado,
                fechaDesde, fechaHasta, ordenCompraId, ordenVentaId, tipoReferenciaOrigen);
        return valeMovRepository.findAll(spec, pageable).map(this::toListItem);
    }

    @Override
    public MovimientoDetalleResponse obtener(Long id) {
        return toDetalle(buscar(id));
    }

    @Override
    @Transactional
    public MovimientoDetalleResponse crear(MovimientoCabeceraRequest request) {
        ArticuloMovTipo tipo = cargarYValidarTipo(request.getArticuloMovTipoId());
        if (request.getOrdenTrasladoId() != null) {
            Long otId = request.getOrdenTrasladoId();
            ordenTrasladoRepository.findByIdForUpdate(otId)
                    .orElseThrow(() -> new BusinessException(
                            "La orden de traslado con ID " + otId + " no existe.",
                            HttpStatus.NOT_FOUND, MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA));
        }
        validarAlmacenExiste(request.getAlmacenId());
        validarTipoHabilitadoParaAlmacen(request.getAlmacenId(), request.getArticuloMovTipoId());
        validarPeriodoAbierto(request.getFechaMov());
        validarCamposObligatoriosPorTipo(request, tipo);

        ValeMov mov = new ValeMov();
        aplicarCabecera(mov, request);
        validarTipoReferenciaSiAplica(mov, tipo);
        for (MovimientoLineaRequest lr : request.getLineas()) {
            mov.addLinea(mapearLinea(lr));
        }

        resolverMatrizContableSiAplica(mov, tipo);
        validarLineas(mov, tipo);

        mov.setNroVale(numeradorDocumentoService.siguienteNroDocumento(
                NOMBRE_TABLA_DOCUMENTO,
                request.getSucursalId(),
                mov.getFechaMov().getYear()));

        aplicarStock(mov, tipo, false);
        ValeMov guardado = valeMovRepository.save(mov);
        sincronizarAcumuladosDocumentosOrigen(guardado, false);

        if ("1".equals(tipo.getFlagMovEntreAlm())) {
            crearMovimientoEspejo(guardado, tipo, request.getSucursalId());
        }

        return toDetalle(guardado);
    }

    @Override
    @Transactional
    public MovimientoDetalleResponse actualizar(Long id, MovimientoCabeceraRequest request) {
        ValeMov mov = buscar(id);
        if (!ValeMovFlagEstado.ACTIVO.equals(mov.getFlagEstado())) {
            throw new BusinessException("Solo se puede modificar un vale Activo.",
                    HttpStatus.CONFLICT, MovimientoErrorCode.SOLO_EDITABLE_ACTIVO);
        }

        ArticuloMovTipo tipo = articuloMovTipoRepository.findById(mov.getArticuloMovTipoId())
                .orElseThrow(() -> new BusinessException("Tipo de movimiento anterior no encontrado.",
                        HttpStatus.NOT_FOUND, MovimientoErrorCode.TIPO_MOV_NO_ENCONTRADO));

        validarCabeceraInmutableSalvoObservaciones(mov, request);
        validarDetalleSoloCantidadPrecio(mov, request.getLineas());

        cargarYValidarTipo(request.getArticuloMovTipoId());
        validarAlmacenExiste(request.getAlmacenId());
        validarTipoHabilitadoParaAlmacen(request.getAlmacenId(), request.getArticuloMovTipoId());
        validarPeriodoAbierto(request.getFechaMov());
        validarCamposObligatoriosPorTipo(request, tipo);

        aplicarStock(mov, tipo, true);

        sincronizarAcumuladosDocumentosOrigen(mov, true);

        mov.setObservaciones(request.getObservaciones());
        aplicarSoloCantidadYCostoUnitarioEnLineas(mov, request.getLineas());

        validarTipoReferenciaSiAplica(mov, tipo);
        resolverMatrizContableSiAplica(mov, tipo);
        validarLineas(mov, tipo);

        aplicarStock(mov, tipo, false);

        ValeMov guardado = valeMovRepository.save(mov);
        sincronizarAcumuladosDocumentosOrigen(guardado, false);
        return toDetalle(guardado);
    }

    @Override
    @Transactional
    public MovimientoDetalleResponse confirmar(MovimientoConfirmarRequest request) {
        ValeMov mov = buscar(request.getId());
        if (!ValeMovFlagEstado.ACTIVO.equals(mov.getFlagEstado())) {
            throw new BusinessException("Solo se puede confirmar un vale Activo.",
                    HttpStatus.CONFLICT, MovimientoErrorCode.SOLO_CONFIRMABLE_ACTIVO);
        }
        ArticuloMovTipo tipo = articuloMovTipoRepository.findById(mov.getArticuloMovTipoId())
                .orElseThrow(() -> new BusinessException("Tipo de movimiento no encontrado.",
                        HttpStatus.NOT_FOUND, MovimientoErrorCode.TIPO_MOV_NO_ENCONTRADO));
        validarLineas(mov, tipo);
        if (request.getObservacion() != null && !request.getObservacion().isBlank()) {
            String obs = mov.getObservaciones() != null ? mov.getObservaciones() + "\n" : "";
            mov.setObservaciones(obs + request.getObservacion());
        }
        ValeMov guardado = valeMovRepository.save(mov);
        preAsientoPublisher.publicarMovimientoConfirmado(guardado, tipo);
        return toDetalle(guardado);
    }

    @Override
    @Transactional
    public MovimientoDetalleResponse anular(MovimientoAnularRequest request) {
        ValeMov mov = buscar(request.getId());
        if (ValeMovFlagEstado.CERRADO.equals(mov.getFlagEstado())) {
            throw new BusinessException("No se puede anular un vale cerrado contablemente.",
                    HttpStatus.CONFLICT, MovimientoErrorCode.NO_ANULAR_CERRADO);
        }
        if (ValeMovFlagEstado.ANULADO.equals(mov.getFlagEstado())) {
            throw new BusinessException("El movimiento ya está anulado.",
                    HttpStatus.CONFLICT, MovimientoErrorCode.MOVIMIENTO_YA_ANULADO);
        }

        validarPeriodoAbierto(mov.getFechaMov());
        validarBloqueosAnulacion(mov);

        String obs = mov.getObservaciones() != null ? mov.getObservaciones() + "\n" : "";
        mov.setObservaciones(obs + "[ANULADO] " + request.getMotivo());

        if (ValeMovFlagEstado.ACTIVO.equals(mov.getFlagEstado())) {
            ArticuloMovTipo tipo = articuloMovTipoRepository.findById(mov.getArticuloMovTipoId())
                    .orElseThrow(() -> new BusinessException("Tipo de movimiento no encontrado.",
                            HttpStatus.NOT_FOUND, MovimientoErrorCode.TIPO_MOV_NO_ENCONTRADO));
            aplicarStock(mov, tipo, true);
        }

        mov.setFlagEstado(ValeMovFlagEstado.ANULADO);
        for (ValeMovDet linea : mov.getLineas()) {
            linea.setFlagEstado(ValeMovFlagEstado.ANULADO);
        }
        ValeMov guardado = valeMovRepository.save(mov);
        sincronizarAcumuladosDocumentosOrigen(guardado, true);
        return toDetalle(guardado);
    }

    /**
     * HU §15.1 A-02…A-09: bloqueos de anulación por vínculos activos.
     */
    private void validarBloqueosAnulacion(ValeMov mov) {
        if (valeMovRepository.tieneGuiaRemisionActiva(mov.getId())) {
            throw new BusinessException(
                    "No se puede anular: el vale tiene una guía de remisión activa.",
                    HttpStatus.CONFLICT, MovimientoErrorCode.NO_ANULAR_GUIA_ACTIVA);
        }
        if (valeMovRepository.tieneCantidadFacturada(mov.getId())) {
            throw new BusinessException(
                    "No se puede anular: el vale tiene cantidades facturadas.",
                    HttpStatus.CONFLICT, MovimientoErrorCode.NO_ANULAR_FACTURADO);
        }
        if (valeMovRepository.tieneConsignacionActiva(mov.getId())) {
            throw new BusinessException(
                    "No se puede anular: el vale tiene consignación activa.",
                    HttpStatus.CONFLICT, MovimientoErrorCode.NO_ANULAR_CONSIGNACION);
        }
        if (valeMovRepository.tieneGuiaRecepcionMP(mov.getId())) {
            throw new BusinessException(
                    "No se puede anular: el vale está vinculado a una guía de recepción de materia prima.",
                    HttpStatus.CONFLICT, MovimientoErrorCode.NO_ANULAR_GUIA_RECEPCION_MP);
        }
        if (valeMovRepository.tieneParteProduccionInsumoActivo(mov.getId())) {
            throw new BusinessException(
                    "No se puede anular: el vale está referenciado en un parte de producción (insumo) activo.",
                    HttpStatus.CONFLICT, MovimientoErrorCode.NO_ANULAR_PARTE_PRODUCCION);
        }
        if (valeMovRepository.existeValeHijoReferenciandoOrigen(mov.getId())) {
            throw new BusinessException(
                    "No se puede anular: existe otro vale activo que referencia este documento como origen.",
                    HttpStatus.CONFLICT, MovimientoErrorCode.NO_ANULAR_REFERENCIA_HIJO);
        }
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Validaciones de cabecera
    // ──────────────────────────────────────────────────────────────────────────

    private ArticuloMovTipo cargarYValidarTipo(Long articuloMovTipoId) {
        ArticuloMovTipo tipo = articuloMovTipoRepository.findById(articuloMovTipoId)
                .orElseThrow(() -> new BusinessException(
                        "Tipo de movimiento no encontrado o inactivo.",
                        HttpStatus.NOT_FOUND, MovimientoErrorCode.TIPO_MOV_NO_ENCONTRADO));
        if (!"1".equals(tipo.getFlagEstado())) {
            throw new BusinessException("El tipo de movimiento está inactivo.",
                    HttpStatus.NOT_FOUND, MovimientoErrorCode.TIPO_MOV_NO_ENCONTRADO);
        }
        return tipo;
    }

    private void validarAlmacenExiste(Long almacenId) {
        if (!almacenRepository.existsById(almacenId)) {
            throw new BusinessException("Almacén no encontrado o inactivo.",
                    HttpStatus.NOT_FOUND, MovimientoErrorCode.ALMACEN_NO_ENCONTRADO);
        }
    }

    /** C-03: tipo de movimiento habilitado para el almacén (almacen_tipo_mov). */
    private void validarTipoHabilitadoParaAlmacen(Long almacenId, Long articuloMovTipoId) {
        if (!almacenTipoMovRepository.existsByAlmacenIdAndArticuloMovTipoIdAndFlagEstado(
                almacenId, articuloMovTipoId, "1")) {
            throw new BusinessException(
                    "El tipo de movimiento no está habilitado para este almacén.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.TIPO_MOV_NO_HABILITADO);
        }
    }

    /** C-10: la fecha no debe caer en un período contable cerrado. */
    private void validarPeriodoAbierto(LocalDate fechaMov) {
        int anio = fechaMov.getYear();
        int mes = fechaMov.getMonthValue();
        cntblCierreRepository.findByAnoAndMes(anio, mes).ifPresent(cierre -> {
            if ("1".equals(cierre.getFlagCierreMes())) {
                throw new BusinessException(
                        "El período contable está cerrado para la fecha indicada.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.PERIODO_CERRADO);
            }
        });
    }

    /** C-06, C-07, C-08: campos condicionales según flags del tipo de movimiento. */
    private void validarCamposObligatoriosPorTipo(MovimientoCabeceraRequest request,
                                                  ArticuloMovTipo tipo) {
        if ("1".equals(tipo.getFlagSolicitaProv()) && request.getProveedorId() == null) {
            throw new BusinessException(
                    "El proveedor es obligatorio para este tipo de movimiento.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.PROVEEDOR_OBLIGATORIO);
        }
        if ("1".equals(tipo.getFlagSolicitaDocExt())) {
            if (request.getTipoDocExtId() == null
                    || request.getNroDocExt() == null
                    || request.getNroDocExt().isBlank()) {
                throw new BusinessException(
                        "Debe indicar tipo y número de documento externo.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.DOC_EXTERNO_OBLIGATORIO);
            }
        }
        if ("1".equals(tipo.getFlagSolicitaDocInt())) {
            if (request.getTipoDocIntId() == null
                    || request.getNroDocInt() == null
                    || request.getNroDocInt().isBlank()) {
                throw new BusinessException(
                        "Debe indicar tipo y número de documento interno.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.DOC_INTERNO_OBLIGATORIO);
            }
        }
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Helpers internos
    // ──────────────────────────────────────────────────────────────────────────

    private ValeMov buscar(Long id) {
        ValeMov mov = valeMovRepository.findById(id)
                .orElseThrow(() -> new BusinessException("Movimiento no encontrado.",
                        HttpStatus.NOT_FOUND, MovimientoErrorCode.MOVIMIENTO_NO_ENCONTRADO));
        mov.getLineas().size();
        return mov;
    }

    private void aplicarCabecera(ValeMov mov, MovimientoCabeceraRequest request) {
        mov.setSucursalId(request.getSucursalId());
        mov.setAlmacenId(request.getAlmacenId());
        mov.setArticuloMovTipoId(request.getArticuloMovTipoId());
        mov.setFechaMov(request.getFechaMov());
        mov.setFecProduccion(request.getFecProduccion());
        mov.setProveedorId(request.getProveedorId());
        mov.setNomReceptor(request.getNomReceptor());
        mov.setTipoDocIntId(request.getTipoDocIntId());
        mov.setNroDocInt(request.getNroDocInt());
        mov.setTipoDocExtId(request.getTipoDocExtId());
        mov.setNroDocExt(request.getNroDocExt());
        mov.setTipoReferenciaOrigen(request.getTipoReferenciaOrigen() != null
                ? request.getTipoReferenciaOrigen().trim() : null);
        mov.setOrdenCompraId(request.getOrdenCompraId());
        mov.setProgComprasId(request.getProgComprasId());
        mov.setOrdenTrasladoId(request.getOrdenTrasladoId());
        mov.setOrdenTrabajoId(request.getOrdenTrabajoId());
        mov.setOrdenVentaId(request.getOrdenVentaId());
        mov.setObservaciones(request.getObservaciones());
        mov.setValeMovOrigId(request.getValeMovOrigId());
    }

    /**
     * Alineado a {@code almacen.vale_mov.tipo_referencia_origen} (CHECK I|C|V|T|G|P)
     * y FKs opcionales del DDL. Valida coherencia con flag_clase_mov del tipo,
     * existencia y estado del documento referenciado.
     */
    private void validarTipoReferenciaSiAplica(ValeMov mov, ArticuloMovTipo tipo) {
        if (!"1".equals(tipo.getFlagSolicitaRef())) {
            return;
        }
        String tr = mov.getTipoReferenciaOrigen();
        if (tr == null || tr.isBlank()) {
            throw new BusinessException(
                    "Debe indicar tipoReferenciaOrigen (I, C, V, T, G o P) para este tipo de movimiento.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
        }
        if (tr.length() != 1) {
            throw new BusinessException(
                    "tipoReferenciaOrigen debe ser un solo carácter (I, C, V, T, G o P).",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
        }
        char c = Character.toUpperCase(tr.charAt(0));
        if ("ICVTGP".indexOf(c) < 0) {
            throw new BusinessException(
                    "tipoReferenciaOrigen inválido: use I, C, V, T, G o P.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
        }
        mov.setTipoReferenciaOrigen(String.valueOf(c));

        // Validar coherencia flag_clase_mov ↔ tipoReferenciaOrigen
        if (tipo.getFlagClaseMov() != null && !tipo.getFlagClaseMov().isBlank()) {
            char claseEsperada = Character.toUpperCase(tipo.getFlagClaseMov().charAt(0));
            if (claseEsperada != c) {
                throw new BusinessException(
                        "El tipo de movimiento tiene clase '" + claseEsperada
                                + "' pero se envió tipoReferenciaOrigen='" + c + "'. Deben coincidir.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.COHERENCIA_CLASE_MOV);
            }
        }

        switch (c) {
            case 'I' -> {
                if (mov.getOrdenCompraId() == null) {
                    throw new BusinessException(
                            "Para clase I (ingresos por compra) debe enviar ordenCompraId.",
                            HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
                }
                validarOrdenCompraExisteYAprobada(mov.getOrdenCompraId());
            }
            case 'T' -> {
                if (mov.getOrdenTrasladoId() == null) {
                    throw new BusinessException(
                            "Para clase T (traslado) debe enviar ordenTrasladoId.",
                            HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
                }
                validarOrdenTrasladoExisteYEstadoValido(mov.getOrdenTrasladoId());
            }
            case 'P' -> {
                if (mov.getOrdenTrabajoId() == null) {
                    throw new BusinessException(
                            "Para clase P (producción) debe enviar ordenTrabajoId.",
                            HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
                }
                validarOrdenTrabajoExisteYEstado(mov.getOrdenTrabajoId());
            }
            case 'V' -> {
                if (mov.getOrdenVentaId() == null) {
                    throw new BusinessException(
                            "Para clase V (ventas a clientes) debe enviar ordenVentaId.",
                            HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
                }
                validarOrdenVentaExisteYEstado(mov.getOrdenVentaId());
            }
            case 'C' -> {
                if (mov.getProgComprasId() == null) {
                    throw new BusinessException(
                            "Para clase C (consumo / programación) debe enviar progComprasId.",
                            HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
                }
                validarProgComprasExisteYEstado(mov.getProgComprasId());
            }
            case 'G' -> {
                validarGuiaRecepcionReferencia(mov);
            }
            default -> { }
        }
    }

    /**
     * Valida referencia de guía (clase G) sin agregar columnas nuevas en vale_mov.
     * Acepta:
     * - {@code nroDocExt} numérico (id de guía), o
     * - {@code nroDocExt} en formato {@code SERIE-NUMERO}.
     */
    private void validarGuiaRecepcionReferencia(ValeMov mov) {
        String ref = mov.getNroDocExt() != null ? mov.getNroDocExt().trim() : "";
        if (ref.isBlank()) {
            throw new BusinessException(
                    "Para clase G (guía) debe enviar nroDocExt (id de guía o SERIE-NUMERO).",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
        }

        Optional<Guia> guiaOpt = Optional.empty();
        if (ref.matches("\\d+")) {
            Long guiaId = Long.parseLong(ref);
            guiaOpt = guiaRepository.findByIdAndSucursalIdAndFlagEstado(guiaId, mov.getSucursalId(), "1");
        }
        if (guiaOpt.isEmpty()) {
            String[] parts = ref.split("[-/]", 2);
            if (parts.length == 2 && !parts[0].isBlank() && !parts[1].isBlank()) {
                guiaOpt = guiaRepository.findBySucursalIdAndSerieIgnoreCaseAndNumeroIgnoreCaseAndFlagEstado(
                        mov.getSucursalId(),
                        parts[0].trim(),
                        parts[1].trim(),
                        "1");
            }
        }

        Guia guia = guiaOpt.orElseThrow(() -> new BusinessException(
                "No se encontró una guía activa para la sucursal y referencia indicada en nroDocExt.",
                HttpStatus.NOT_FOUND, MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA));

        if ("0".equals(guia.getFlagEstado())) {
            throw new BusinessException(
                    "La guía referenciada está anulada.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.REFERENCIA_ESTADO_INVALIDO);
        }
    }

    private void validarOrdenCompraExisteYAprobada(Long ordenCompraId) {
        String flagEstado = valeMovRepository.obtenerFlagEstadoOrdenCompra(ordenCompraId);
        if (flagEstado == null) {
            throw new BusinessException(
                    "La orden de compra con ID " + ordenCompraId + " no existe.",
                    HttpStatus.NOT_FOUND, MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
        }
        if (!"1".equals(flagEstado)) {
            throw new BusinessException(
                    "La orden de compra " + ordenCompraId + " no está activa.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.REFERENCIA_ESTADO_INVALIDO);
        }
    }

    private void validarOrdenTrasladoExisteYEstadoValido(Long ordenTrasladoId) {
        OrdenTraslado ot = ordenTrasladoRepository.findById(ordenTrasladoId)
                .orElseThrow(() -> new BusinessException(
                        "La orden de traslado con ID " + ordenTrasladoId + " no existe.",
                        HttpStatus.NOT_FOUND, MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA));
        if (!"1".equals(ot.getFlagEstado())) {
            throw new BusinessException(
                    "La orden de traslado " + ot.getNumero() + " no está activa (flagEstado='"
                            + ot.getFlagEstado() + "'). Solo se aceptan órdenes activas.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.REFERENCIA_ESTADO_INVALIDO);
        }
    }

    private void validarProgComprasExisteYEstado(Long progComprasId) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT flag_estado FROM compras.prog_compras WHERE id = ?", progComprasId);
        if (rows.isEmpty()) {
            throw new BusinessException(
                    "Programación de compras " + progComprasId + " no existe.",
                    HttpStatus.NOT_FOUND, MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
        }
        String flagEstado = (String) rows.get(0).get("flag_estado");
        if (!"1".equals(flagEstado)) {
            throw new BusinessException(
                    "La programación de compras " + progComprasId + " no está activa.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.REFERENCIA_ESTADO_INVALIDO);
        }
    }

    private void validarOrdenTrabajoExisteYEstado(Long ordenTrabajoId) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT flag_estado FROM produccion.orden_trabajo WHERE id = ?", ordenTrabajoId);
        if (rows.isEmpty()) {
            throw new BusinessException(
                    "Orden de trabajo " + ordenTrabajoId + " no existe.",
                    HttpStatus.NOT_FOUND, MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
        }
        String flagEstado = (String) rows.get(0).get("flag_estado");
        if (!"1".equals(flagEstado)) {
            throw new BusinessException(
                    "La orden de trabajo " + ordenTrabajoId + " no está activa.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.REFERENCIA_ESTADO_INVALIDO);
        }
    }

    private void validarOrdenVentaExisteYEstado(Long ordenVentaId) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT flag_estado FROM ventas.orden_venta WHERE id = ?", ordenVentaId);
        if (rows.isEmpty()) {
            throw new BusinessException(
                    "Orden de venta " + ordenVentaId + " no existe.",
                    HttpStatus.NOT_FOUND, MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
        }
        String flagEstado = (String) rows.get(0).get("flag_estado");
        if (!"1".equals(flagEstado)) {
            throw new BusinessException(
                    "La orden de venta " + ordenVentaId + " no está activa.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.REFERENCIA_ESTADO_INVALIDO);
        }
    }

    private ValeMovDet mapearLinea(MovimientoLineaRequest lr) {
        ValeMovDet d = new ValeMovDet();
        d.setArticuloId(lr.getArticuloId());
        d.setCantProcesada(lr.getCantProcesada());
        d.setCostoUnitario(lr.getCostoUnitario());
        d.setMatrizContableId(lr.getMatrizContableId());
        d.setLotePalletId(lr.getLotePalletId());
        d.setUbicacionAlmacenId(lr.getUbicacionAlmacenId());
        d.setCentrosCostoId(lr.getCentrosCostoId());
        d.setMonedaId(lr.getMonedaId());
        d.setPesoNetoTm(lr.getPesoNetoTm() != null ? lr.getPesoNetoTm() : BigDecimal.ZERO);
        d.setOcDetId(lr.getOcDetId());
        d.setOrdenTrasladoDetId(lr.getOrdenTrasladoDetId());
        d.setOrdenVentaDetId(lr.getOrdenVentaDetId());
        d.setOperacionesDetId(lr.getOperacionesDetId());
        return d;
    }

    /** Validaciones de detalle: duplicados, lote, matriz, ubicación, centro de costo, coherencia FK línea↔cabecera. */
    private void validarLineas(ValeMov mov, ArticuloMovTipo tipo) {
        if (mov.getLineas() == null || mov.getLineas().isEmpty()) {
            throw new BusinessException("El movimiento debe tener al menos una línea.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.CANTIDAD_INVALIDA);
        }

        Set<Long> articuloIds = new HashSet<>();
        for (ValeMovDet linea : mov.getLineas()) {
            if (!articuloIds.add(linea.getArticuloId())) {
                throw new BusinessException(
                        "Artículo " + linea.getArticuloId() + " duplicado en el detalle del vale.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.ARTICULO_DUPLICADO);
            }
            if ("1".equals(tipo.getFlagSolicitaLote()) && linea.getLotePalletId() == null) {
                throw new BusinessException(
                        "Línea de artículo " + linea.getArticuloId()
                                + ": el lote/pallet es obligatorio para este tipo.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.LOTE_OBLIGATORIO);
            }
            if ("1".equals(tipo.getFlagContabiliza()) && linea.getMatrizContableId() == null) {
                throw new BusinessException(
                        "Línea de artículo " + linea.getArticuloId()
                                + ": la matriz contable es obligatoria para este tipo.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.MATRIZ_NO_ENCONTRADA);
            }
            if (linea.getUbicacionAlmacenId() != null) {
                ubicacionAlmacenRepository.findByIdAndAlmacenId(
                        linea.getUbicacionAlmacenId(), mov.getAlmacenId())
                        .orElseThrow(() -> new BusinessException(
                                "La ubicación " + linea.getUbicacionAlmacenId()
                                        + " no pertenece al almacén de la cabecera.",
                                HttpStatus.UNPROCESSABLE_ENTITY,
                                MovimientoErrorCode.UBICACION_NO_PERTENECE));
            }
            if ("1".equals(tipo.getFlagSolicitaCenbef()) && linea.getCentrosCostoId() == null) {
                throw new BusinessException(
                        "Línea de artículo " + linea.getArticuloId()
                                + ": debe indicar el centro de costo.",
                        HttpStatus.UNPROCESSABLE_ENTITY,
                        MovimientoErrorCode.CENTRO_COSTO_OBLIGATORIO);
            }
            validarCoherenciaFKLinea(linea, mov);
        }
        validarConsumoProgComprasPorLineasSiAplica(mov);
    }

    /**
     * Clase C: cada artículo del vale debe existir en {@code prog_compras_det} y la cantidad no debe superar
     * el saldo programado menos lo ya consumido en otros vales activos (mismo {@code prog_compras_id}).
     */
    private void validarConsumoProgComprasPorLineasSiAplica(ValeMov mov) {
        if (mov.getProgComprasId() == null) {
            return;
        }
        if (!"C".equals(normalizarTipoRefUnCaracter(mov.getTipoReferenciaOrigen()))) {
            return;
        }
        Long excludeValeId = mov.getId();
        for (ValeMovDet linea : mov.getLineas()) {
            List<Map<String, Object>> progQtyRows = jdbcTemplate.queryForList(
                    "SELECT COALESCE(SUM(cantidad), 0) AS total FROM compras.prog_compras_det "
                            + "WHERE prog_compras_id = ? AND articulo_id = ?",
                    mov.getProgComprasId(), linea.getArticuloId());
            BigDecimal progQty = progQtyRows.isEmpty()
                    ? BigDecimal.ZERO : toBigDecimal(progQtyRows.get(0).get("total"));
            if (progQty.compareTo(BigDecimal.ZERO) <= 0) {
                throw new BusinessException(
                        "El artículo " + linea.getArticuloId() + " no tiene cantidad programada en la programación "
                                + mov.getProgComprasId() + ".",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
            }
            List<Map<String, Object>> consRows = jdbcTemplate.queryForList(
                    "SELECT COALESCE(SUM(vmd.cant_procesada), 0) AS total "
                            + "FROM almacen.vale_mov_det vmd "
                            + "INNER JOIN almacen.vale_mov vm ON vm.id = vmd.vale_mov_id "
                            + "WHERE vm.prog_compras_id = ? AND vmd.articulo_id = ? "
                            + "AND vm.flag_estado = '1' AND vmd.flag_estado = '1' "
                            + "AND (? IS NULL OR vm.id <> ?)",
                    mov.getProgComprasId(), linea.getArticuloId(), excludeValeId, excludeValeId);
            BigDecimal consumedOthers = consRows.isEmpty()
                    ? BigDecimal.ZERO : toBigDecimal(consRows.get(0).get("total"));
            BigDecimal pend = progQty.subtract(consumedOthers);
            if (linea.getCantProcesada().compareTo(pend) > 0) {
                throw new BusinessException(
                        "Cantidad a procesar (" + linea.getCantProcesada()
                                + ") supera el saldo contra programación (" + pend + ") para artículo "
                                + linea.getArticuloId() + ".",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.CANTIDAD_INVALIDA);
            }
        }
    }

    private static BigDecimal toBigDecimal(Object value) {
        if (value == null) {
            return BigDecimal.ZERO;
        }
        if (value instanceof BigDecimal bd) {
            return bd;
        }
        if (value instanceof Number n) {
            return BigDecimal.valueOf(n.doubleValue());
        }
        return new BigDecimal(value.toString());
    }

    /**
     * §4/§11: valida que los FK de línea (ocDetId, ordenTrasladoDetId, etc.)
     * correspondan al FK de cabecera respectivo.
     */
    private void validarCoherenciaFKLinea(ValeMovDet linea, ValeMov mov) {
        if (linea.getOcDetId() != null && mov.getOrdenCompraId() == null) {
            throw new BusinessException(
                    "Línea de artículo " + linea.getArticuloId()
                            + ": tiene ocDetId pero la cabecera no tiene ordenCompraId.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
        }
        if (linea.getOrdenTrasladoDetId() != null && mov.getOrdenTrasladoId() == null) {
            throw new BusinessException(
                    "Línea de artículo " + linea.getArticuloId()
                            + ": tiene ordenTrasladoDetId pero la cabecera no tiene ordenTrasladoId.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
        }
        if (linea.getOrdenVentaDetId() != null && mov.getOrdenVentaId() == null) {
            throw new BusinessException(
                    "Línea de artículo " + linea.getArticuloId()
                            + ": tiene ordenVentaDetId pero la cabecera no tiene ordenVentaId.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
        }
        if (linea.getOperacionesDetId() != null && mov.getOrdenTrabajoId() == null) {
            throw new BusinessException(
                    "Línea de artículo " + linea.getArticuloId()
                            + ": tiene operacionesDetId pero la cabecera no tiene ordenTrabajoId.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
        }
        validarExistenciaYCoherenciaReferenciasDetalle(linea, mov);
    }

    /**
     * Comprueba existencia en BD y pertenencia al documento cabecera; saldo pendiente OC/OV/OT según aplique.
     */
    private void validarExistenciaYCoherenciaReferenciasDetalle(ValeMovDet linea, ValeMov mov) {
        if (linea.getOcDetId() != null) {
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                    "SELECT orden_compra_id, articulo_id, cant_proyectada, cant_procesada FROM compras.orden_compra_det WHERE id = ?",
                    linea.getOcDetId());
            if (rows.isEmpty()) {
                throw new BusinessException(
                        "Línea OC detalle " + linea.getOcDetId() + " no existe.",
                        HttpStatus.NOT_FOUND, MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
            }
            Map<String, Object> row = rows.get(0);
            Long ocId = ((Number) row.get("orden_compra_id")).longValue();
            Long art = ((Number) row.get("articulo_id")).longValue();
            BigDecimal proj = (BigDecimal) row.get("cant_proyectada");
            BigDecimal proc = (BigDecimal) row.get("cant_procesada");
            if (mov.getOrdenCompraId() == null || !ocId.equals(mov.getOrdenCompraId())) {
                throw new BusinessException(
                        "ocDetId " + linea.getOcDetId() + " no pertenece a la orden de compra de cabecera.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
            }
            if (!art.equals(linea.getArticuloId())) {
                throw new BusinessException(
                        "El artículo de la línea no coincide con orden_compra_det " + linea.getOcDetId() + ".",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
            }
            BigDecimal pend = proj.subtract(proc != null ? proc : BigDecimal.ZERO);
            if (linea.getCantProcesada().compareTo(pend) > 0) {
                throw new BusinessException(
                        "Cantidad a procesar (" + linea.getCantProcesada()
                                + ") supera el saldo pendiente (" + pend + ") en línea OC " + linea.getOcDetId() + ".",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.CANTIDAD_INVALIDA);
            }
        }
        if (linea.getOrdenTrasladoDetId() != null) {
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                    "SELECT orden_traslado_id, articulo_id, cantidad, cantidad_despachada, cantidad_recibida "
                            + "FROM almacen.orden_traslado_det WHERE id = ?",
                    linea.getOrdenTrasladoDetId());
            if (rows.isEmpty()) {
                throw new BusinessException(
                        "Línea orden traslado det " + linea.getOrdenTrasladoDetId() + " no existe.",
                        HttpStatus.NOT_FOUND, MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
            }
            Map<String, Object> row = rows.get(0);
            Long otId = ((Number) row.get("orden_traslado_id")).longValue();
            Long art = ((Number) row.get("articulo_id")).longValue();
            BigDecimal cantOt = (BigDecimal) row.get("cantidad");
            BigDecimal desp = (BigDecimal) row.get("cantidad_despachada");
            BigDecimal rec = (BigDecimal) row.get("cantidad_recibida");
            if (mov.getOrdenTrasladoId() == null || !otId.equals(mov.getOrdenTrasladoId())) {
                throw new BusinessException(
                        "ordenTrasladoDetId no pertenece a la orden de traslado de cabecera.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
            }
            if (!art.equals(linea.getArticuloId())) {
                throw new BusinessException(
                        "Artículo inconsistente con orden_traslado_det.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
            }
            OrdenTraslado ot = ordenTrasladoRepository.findById(mov.getOrdenTrasladoId())
                    .orElseThrow(() -> new BusinessException(
                            "Orden de traslado no encontrada.",
                            HttpStatus.NOT_FOUND, MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA));
            boolean origen = mov.getAlmacenId().equals(ot.getAlmacenOrigenId());
            boolean destino = mov.getAlmacenId().equals(ot.getAlmacenDestinoId());
            if (origen) {
                BigDecimal despBd = desp != null ? desp : BigDecimal.ZERO;
                BigDecimal pendDesp = cantOt.subtract(despBd);
                if (linea.getCantProcesada().compareTo(pendDesp) > 0) {
                    throw new BusinessException(
                            "Cantidad supera saldo por despachar en línea OT " + linea.getOrdenTrasladoDetId() + ".",
                            HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.CANTIDAD_INVALIDA);
                }
            } else if (destino) {
                BigDecimal recBd = rec != null ? rec : BigDecimal.ZERO;
                BigDecimal pendRec = cantOt.subtract(recBd);
                if (linea.getCantProcesada().compareTo(pendRec) > 0) {
                    throw new BusinessException(
                            "Cantidad supera saldo por recibir en línea OT " + linea.getOrdenTrasladoDetId() + ".",
                            HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.CANTIDAD_INVALIDA);
                }
            }
        }
        if (linea.getOrdenVentaDetId() != null) {
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                    "SELECT orden_venta_id, articulo_id, cant_proyectada, cant_procesada FROM ventas.orden_venta_det WHERE id = ?",
                    linea.getOrdenVentaDetId());
            if (rows.isEmpty()) {
                throw new BusinessException(
                        "Línea OV detalle " + linea.getOrdenVentaDetId() + " no existe.",
                        HttpStatus.NOT_FOUND, MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
            }
            Map<String, Object> row = rows.get(0);
            Long ovId = ((Number) row.get("orden_venta_id")).longValue();
            Long art = ((Number) row.get("articulo_id")).longValue();
            BigDecimal proj = (BigDecimal) row.get("cant_proyectada");
            BigDecimal proc = (BigDecimal) row.get("cant_procesada");
            if (mov.getOrdenVentaId() == null || !ovId.equals(mov.getOrdenVentaId())) {
                throw new BusinessException(
                        "ordenVentaDetId no pertenece a la orden de venta de cabecera.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
            }
            if (!art.equals(linea.getArticuloId())) {
                throw new BusinessException(
                        "Artículo inconsistente con orden_venta_det.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
            }
            BigDecimal pend = proj.subtract(proc != null ? proc : BigDecimal.ZERO);
            if (linea.getCantProcesada().compareTo(pend) > 0) {
                throw new BusinessException(
                        "Cantidad supera saldo pendiente en línea OV " + linea.getOrdenVentaDetId() + ".",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.CANTIDAD_INVALIDA);
            }
        }
        if (linea.getOperacionesDetId() != null) {
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                    "SELECT od.articulo_id AS articulo_id, op.orden_trabajo_id AS orden_trabajo_id "
                            + "FROM produccion.operaciones_det od "
                            + "INNER JOIN produccion.operacion op ON op.id = od.operacion_id WHERE od.id = ?",
                    linea.getOperacionesDetId());
            if (rows.isEmpty()) {
                throw new BusinessException(
                        "operaciones_det " + linea.getOperacionesDetId() + " no existe.",
                        HttpStatus.NOT_FOUND, MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
            }
            Map<String, Object> row = rows.get(0);
            Long otId = ((Number) row.get("orden_trabajo_id")).longValue();
            Long art = ((Number) row.get("articulo_id")).longValue();
            if (mov.getOrdenTrabajoId() == null || !otId.equals(mov.getOrdenTrabajoId())) {
                throw new BusinessException(
                        "operacionesDetId no pertenece al orden de trabajo de cabecera.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
            }
            if (!art.equals(linea.getArticuloId())) {
                throw new BusinessException(
                        "Artículo inconsistente con operaciones_det.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
            }
        }
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Stock + Kardex
    // ──────────────────────────────────────────────────────────────────────────

    private void aplicarStock(ValeMov mov, ArticuloMovTipo tipo, boolean reversa) {
        BigDecimal factorBase = tipo.getFactorSldoTotal() != null
                ? tipo.getFactorSldoTotal() : BigDecimal.ZERO;
        int signo = reversa ? -1 : 1;
        for (ValeMovDet linea : mov.getLineas()) {
            BigDecimal delta = linea.getCantProcesada()
                    .multiply(factorBase)
                    .multiply(BigDecimal.valueOf(signo));
            if (delta.compareTo(BigDecimal.ZERO) == 0) {
                continue;
            }

            BigDecimal costoPromedioAnterior = obtenerCostoPromedioActual(
                    mov.getAlmacenId(), linea.getArticuloId());

            if (!reversa && linea.getCostoUnitario() == null
                    && "0".equals(tipo.getFlagSolicitaPrecio())) {
                linea.setCostoUnitario(costoPromedioAnterior);
            }

            if (!reversa && linea.getCostoUnitario() != null) {
                linea.setPrecioUnitAnt(costoPromedioAnterior);
            }

            ArticuloAlmacen stockActualizado = actualizarArticuloAlmacen(
                    mov.getAlmacenId(), linea.getArticuloId(), delta, linea.getCostoUnitario());

            if (linea.getUbicacionAlmacenId() != null) {
                actualizarPosicion(
                        linea.getUbicacionAlmacenId(), linea.getArticuloId(),
                        delta, linea.getCostoUnitario());
            }

            registrarKardex(mov, linea, delta, stockActualizado, reversa);
        }
    }

    private BigDecimal obtenerCostoPromedioActual(Long almacenId, Long articuloId) {
        return articuloAlmacenRepository.findByAlmacenIdAndArticuloId(almacenId, articuloId)
                .map(ArticuloAlmacen::getCostoPromedio)
                .orElse(BigDecimal.ZERO);
    }

    private ArticuloAlmacen actualizarArticuloAlmacen(Long almacenId, Long articuloId,
                                                      BigDecimal delta, BigDecimal costoUnitario) {
        ArticuloAlmacen row = articuloAlmacenRepository
                .findByAlmacenIdAndArticuloId(almacenId, articuloId)
                .orElseGet(() -> {
                    ArticuloAlmacen a = new ArticuloAlmacen();
                    a.setAlmacenId(almacenId);
                    a.setArticuloId(articuloId);
                    return a;
                });

        BigDecimal saldoAnterior = row.getCantidadDisponible();
        BigDecimal nuevoSaldo = saldoAnterior.add(delta);
        if (nuevoSaldo.compareTo(BigDecimal.ZERO) < 0) {
            throw new BusinessException(
                    "Stock insuficiente para el artículo " + articuloId
                            + " en el almacén " + almacenId
                            + ". Saldo disponible: " + saldoAnterior,
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.STOCK_INSUFICIENTE);
        }

        if (costoUnitario != null && delta.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal costoAnterior = row.getCostoPromedio() != null
                    ? row.getCostoPromedio() : BigDecimal.ZERO;
            BigDecimal nuevoCosto;
            if (saldoAnterior.compareTo(BigDecimal.ZERO) == 0) {
                nuevoCosto = costoUnitario;
            } else {
                nuevoCosto = saldoAnterior.multiply(costoAnterior)
                        .add(delta.multiply(costoUnitario))
                        .divide(saldoAnterior.add(delta), 6, RoundingMode.HALF_UP);
            }
            row.setCostoPromedio(nuevoCosto);
        }

        row.setCantidadDisponible(nuevoSaldo);
        return articuloAlmacenRepository.save(row);
    }

    private void actualizarPosicion(Long ubicacionId, Long articuloId,
                                    BigDecimal delta, BigDecimal costoUnitario) {
        ArticuloAlmacenPosicion row = articuloAlmacenPosicionRepository
                .findByUbicacionAlmacenIdAndArticuloId(ubicacionId, articuloId)
                .orElseGet(() -> {
                    ArticuloAlmacenPosicion p = new ArticuloAlmacenPosicion();
                    p.setUbicacionAlmacenId(ubicacionId);
                    p.setArticuloId(articuloId);
                    return p;
                });

        BigDecimal saldoAnterior = row.getCantidadDisponible();
        BigDecimal nuevoSaldo = saldoAnterior.add(delta);
        if (nuevoSaldo.compareTo(BigDecimal.ZERO) < 0) {
            throw new BusinessException(
                    "Stock insuficiente en la posición para el artículo " + articuloId
                            + ". Saldo disponible: " + saldoAnterior,
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.STOCK_INSUFICIENTE);
        }

        if (costoUnitario != null && delta.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal costoAnterior = row.getCostoPromedio() != null
                    ? row.getCostoPromedio() : BigDecimal.ZERO;
            BigDecimal nuevoCosto;
            if (saldoAnterior.compareTo(BigDecimal.ZERO) == 0) {
                nuevoCosto = costoUnitario;
            } else {
                nuevoCosto = saldoAnterior.multiply(costoAnterior)
                        .add(delta.multiply(costoUnitario))
                        .divide(saldoAnterior.add(delta), 6, RoundingMode.HALF_UP);
            }
            row.setCostoPromedio(nuevoCosto);
        }

        row.setCantidadDisponible(nuevoSaldo);
        articuloAlmacenPosicionRepository.save(row);
    }

    /**
     * Inserta un registro en {@code almacen.articulo_saldo_mensual} (kardex valorizado)
     * por cada línea que impacta stock. HU §13.3.
     */
    private void registrarKardex(ValeMov mov, ValeMovDet linea, BigDecimal delta,
                                 ArticuloAlmacen stockActualizado, boolean reversa) {
        BigDecimal cantidad = delta.abs();
        BigDecimal costoUnit = linea.getCostoUnitario() != null
                ? linea.getCostoUnitario() : BigDecimal.ZERO;

        String tipoKardex;
        if (reversa) {
            tipoKardex = delta.compareTo(BigDecimal.ZERO) > 0 ? "REVERSA_INGRESO" : "REVERSA_SALIDA";
        } else {
            tipoKardex = delta.compareTo(BigDecimal.ZERO) > 0 ? "INGRESO" : "SALIDA";
        }

        ArticuloSaldoMensual kardex = new ArticuloSaldoMensual();
        kardex.setAlmacenId(mov.getAlmacenId());
        kardex.setArticuloId(linea.getArticuloId());
        kardex.setValeMovDetId(linea.getId());
        kardex.setFecha(mov.getFechaMov());
        kardex.setTipo(tipoKardex);
        kardex.setCantidad(cantidad);
        kardex.setCostoUnitario(costoUnit);
        kardex.setCostoTotal(cantidad.multiply(costoUnit).setScale(4, RoundingMode.HALF_UP));
        kardex.setSaldoCantidad(stockActualizado.getCantidadDisponible());
        kardex.setSaldoCostoUnitario(stockActualizado.getCostoPromedio());
        kardex.setSaldoCostoTotal(
                stockActualizado.getCantidadDisponible()
                        .multiply(stockActualizado.getCostoPromedio())
                        .setScale(4, RoundingMode.HALF_UP));
        articuloSaldoMensualRepository.save(kardex);
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Resolución de matriz contable (HU §10)
    // ──────────────────────────────────────────────────────────────────────────

    /**
     * Grupo contable: primero parámetro específico {@code ALMACEN_GRP_CNTBL_<TIPOMOV>},
     * luego {@value #PARAM_GRP_CNTBL_DEFAULT}, y por último {@value #GRP_CNTBL_DEFAULT}.
     */
    private String resolverGrpCntbl(String tipoMov) {
        String sufijo = sanitizarSufijoTipoMovParaParametro(tipoMov);
        if (!sufijo.isEmpty()) {
            String porTipo = leerValorParametroSistema(PARAM_GRP_CNTBL_PREFIX + sufijo);
            if (porTipo != null && !porTipo.isBlank()) {
                return porTipo.trim();
            }
        }
        String tenant = leerValorParametroSistema(PARAM_GRP_CNTBL_DEFAULT);
        if (tenant != null && !tenant.isBlank()) {
            return tenant.trim();
        }
        return GRP_CNTBL_DEFAULT;
    }

    private static String sanitizarSufijoTipoMovParaParametro(String tipoMov) {
        if (tipoMov == null || tipoMov.isBlank()) {
            return "";
        }
        return tipoMov.trim().toUpperCase(Locale.ROOT).replaceAll("[^A-Z0-9_]", "");
    }

    private String leerValorParametroSistema(String codigo) {
        if (codigo == null || codigo.isBlank()) {
            return null;
        }
        try {
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                    "SELECT valor FROM core.parametro_sistema WHERE codigo = ? AND flag_estado = '1'",
                    codigo);
            if (!rows.isEmpty()) {
                Object v = rows.get(0).get("valor");
                return v != null ? v.toString() : null;
            }
        } catch (Exception ex) {
            log.debug("Leyendo parámetro sistema {}: {}", codigo, ex.getMessage());
        }
        return null;
    }

    /**
     * Actualiza acumulados en compras/ventas/traslado según líneas del vale (bloque E.6).
     *
     * @param reversa {@code false} al crear ingreso/salida; {@code true} al anular o revertir efecto acumulado.
     */
    private void sincronizarAcumuladosDocumentosOrigen(ValeMov mov, boolean reversa) {
        OrdenTraslado otSync = null;
        if (mov.getOrdenTrasladoId() != null) {
            otSync = ordenTrasladoRepository.findById(mov.getOrdenTrasladoId()).orElse(null);
        }
        if (reversa) {
            validarSaldoAcumuladoPermiteReversa(mov, otSync);
        }
        int mult = reversa ? -1 : 1;
        for (ValeMovDet linea : mov.getLineas()) {
            BigDecimal cant = linea.getCantProcesada();
            if (cant == null) {
                continue;
            }
            BigDecimal delta = cant.multiply(BigDecimal.valueOf(mult));

            if (linea.getOcDetId() != null && mov.getOrdenCompraId() != null) {
                int u = jdbcTemplate.update(
                        "UPDATE compras.orden_compra_det SET cant_procesada = cant_procesada + ? "
                                + "WHERE id = ? AND orden_compra_id = ? AND articulo_id = ?",
                        delta, linea.getOcDetId(), mov.getOrdenCompraId(), linea.getArticuloId());
                assertFilasSync(u, "orden_compra_det id=" + linea.getOcDetId() + " orden_compra_id=" + mov.getOrdenCompraId());
            }
            if (linea.getOrdenVentaDetId() != null && mov.getOrdenVentaId() != null) {
                int u = jdbcTemplate.update(
                        "UPDATE ventas.orden_venta_det SET cant_procesada = cant_procesada + ? "
                                + "WHERE id = ? AND orden_venta_id = ? AND articulo_id = ?",
                        delta, linea.getOrdenVentaDetId(), mov.getOrdenVentaId(), linea.getArticuloId());
                assertFilasSync(u, "orden_venta_det id=" + linea.getOrdenVentaDetId() + " orden_venta_id=" + mov.getOrdenVentaId());
            }
            if (linea.getOrdenTrasladoDetId() != null && mov.getOrdenTrasladoId() != null) {
                if (otSync == null) {
                    throw new BusinessException(
                            "Orden de traslado no encontrada al sincronizar acumulados.",
                            HttpStatus.NOT_FOUND, MovimientoErrorCode.ORDEN_TRASLADO_NO_ENCONTRADA);
                }
                boolean origen = mov.getAlmacenId().equals(otSync.getAlmacenOrigenId());
                boolean destino = mov.getAlmacenId().equals(otSync.getAlmacenDestinoId());
                if (!origen && !destino) {
                    throw new BusinessException(
                            "El almacén del vale no coincide con el origen ni el destino de la orden de traslado.",
                            HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
                }
                int u = ejecutarUpdateAcumuladoOrdenTrasladoDet(origen, destino, delta, linea, otSync.getId());
                assertFilasSync(u, "orden_traslado_det id=" + linea.getOrdenTrasladoDetId());
            }
        }
    }

    /**
     * Evita dejar acumulados negativos al revertir (anulación / rollback de sincronización).
     */
    private void validarSaldoAcumuladoPermiteReversa(ValeMov mov, OrdenTraslado otSync) {
        for (ValeMovDet linea : mov.getLineas()) {
            BigDecimal cant = linea.getCantProcesada();
            if (cant == null) {
                continue;
            }
            if (linea.getOcDetId() != null && mov.getOrdenCompraId() != null) {
                List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                        "SELECT COALESCE(cant_procesada, 0) AS c FROM compras.orden_compra_det "
                                + "WHERE id = ? AND orden_compra_id = ? AND articulo_id = ?",
                        linea.getOcDetId(), mov.getOrdenCompraId(), linea.getArticuloId());
                if (rows.isEmpty()) {
                    throw new BusinessException(
                            "No se pudo validar saldo acumulado en orden_compra_det id=" + linea.getOcDetId() + ".",
                            HttpStatus.CONFLICT, MovimientoErrorCode.SYNC_ACUMULADO_ORIGEN_FALLIDO);
                }
                BigDecimal ac = toBigDecimal(rows.get(0).get("c"));
                if (ac.compareTo(cant) < 0) {
                    throw new BusinessException(
                            "No se puede revertir acumulados: cantidad procesada en OC (" + ac
                                    + ") es menor que la del vale (" + cant + ") en línea oc_det_id="
                                    + linea.getOcDetId() + ".",
                            HttpStatus.CONFLICT, MovimientoErrorCode.SYNC_ACUMULADO_ORIGEN_FALLIDO);
                }
            }
            if (linea.getOrdenVentaDetId() != null && mov.getOrdenVentaId() != null) {
                List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                        "SELECT COALESCE(cant_procesada, 0) AS c FROM ventas.orden_venta_det "
                                + "WHERE id = ? AND orden_venta_id = ? AND articulo_id = ?",
                        linea.getOrdenVentaDetId(), mov.getOrdenVentaId(), linea.getArticuloId());
                if (rows.isEmpty()) {
                    throw new BusinessException(
                            "No se pudo validar saldo acumulado en orden_venta_det id="
                                    + linea.getOrdenVentaDetId() + ".",
                            HttpStatus.CONFLICT, MovimientoErrorCode.SYNC_ACUMULADO_ORIGEN_FALLIDO);
                }
                BigDecimal ac = toBigDecimal(rows.get(0).get("c"));
                if (ac.compareTo(cant) < 0) {
                    throw new BusinessException(
                            "No se puede revertir acumulados: cantidad procesada en OV (" + ac
                                    + ") es menor que la del vale (" + cant + ").",
                            HttpStatus.CONFLICT, MovimientoErrorCode.SYNC_ACUMULADO_ORIGEN_FALLIDO);
                }
            }
            if (linea.getOrdenTrasladoDetId() != null && mov.getOrdenTrasladoId() != null) {
                if (otSync == null) {
                    throw new BusinessException(
                            "Orden de traslado no encontrada al validar reversa de acumulados.",
                            HttpStatus.NOT_FOUND, MovimientoErrorCode.ORDEN_TRASLADO_NO_ENCONTRADA);
                }
                boolean origen = mov.getAlmacenId().equals(otSync.getAlmacenOrigenId());
                boolean destino = mov.getAlmacenId().equals(otSync.getAlmacenDestinoId());
                List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                        "SELECT COALESCE(cantidad_despachada, 0) AS desp, COALESCE(cantidad_recibida, 0) AS rec "
                                + "FROM almacen.orden_traslado_det WHERE id = ? AND orden_traslado_id = ? "
                                + "AND articulo_id = ?",
                        linea.getOrdenTrasladoDetId(), otSync.getId(), linea.getArticuloId());
                if (rows.isEmpty()) {
                    throw new BusinessException(
                            "No se pudo validar saldo acumulado en orden_traslado_det id="
                                    + linea.getOrdenTrasladoDetId() + ".",
                            HttpStatus.CONFLICT, MovimientoErrorCode.SYNC_ACUMULADO_ORIGEN_FALLIDO);
                }
                Map<String, Object> row = rows.get(0);
                if (origen) {
                    BigDecimal desp = toBigDecimal(row.get("desp"));
                    if (desp.compareTo(cant) < 0) {
                        throw new BusinessException(
                                "No se puede revertir acumulados: cantidad despachada en OT (" + desp
                                        + ") es menor que la del vale (" + cant + ").",
                                HttpStatus.CONFLICT, MovimientoErrorCode.SYNC_ACUMULADO_ORIGEN_FALLIDO);
                    }
                } else if (destino) {
                    BigDecimal rec = toBigDecimal(row.get("rec"));
                    if (rec.compareTo(cant) < 0) {
                        throw new BusinessException(
                                "No se puede revertir acumulados: cantidad recibida en OT (" + rec
                                        + ") es menor que la del vale (" + cant + ").",
                                HttpStatus.CONFLICT, MovimientoErrorCode.SYNC_ACUMULADO_ORIGEN_FALLIDO);
                    }
                }
            }
        }
    }

    /**
     * Política negocio: PUT solo permite cambiar observaciones en cabecera; el resto debe coincidir con el vale persistido.
     */
    private void validarCabeceraInmutableSalvoObservaciones(ValeMov mov, MovimientoCabeceraRequest r) {
        if (!Objects.equals(mov.getSucursalId(), r.getSucursalId())
                || !Objects.equals(mov.getAlmacenId(), r.getAlmacenId())
                || !Objects.equals(mov.getArticuloMovTipoId(), r.getArticuloMovTipoId())
                || !Objects.equals(mov.getFechaMov(), r.getFechaMov())
                || !Objects.equals(mov.getFecProduccion(), r.getFecProduccion())
                || !Objects.equals(mov.getProveedorId(), r.getProveedorId())
                || !mismoTextoOpcional(mov.getNomReceptor(), r.getNomReceptor())
                || !Objects.equals(mov.getTipoDocIntId(), r.getTipoDocIntId())
                || !mismoTextoOpcional(mov.getNroDocInt(), r.getNroDocInt())
                || !Objects.equals(mov.getTipoDocExtId(), r.getTipoDocExtId())
                || !mismoTextoOpcional(mov.getNroDocExt(), r.getNroDocExt())
                || !mismoTipoRefOrigen(mov.getTipoReferenciaOrigen(), r.getTipoReferenciaOrigen())
                || !Objects.equals(mov.getOrdenCompraId(), r.getOrdenCompraId())
                || !Objects.equals(mov.getProgComprasId(), r.getProgComprasId())
                || !Objects.equals(mov.getOrdenTrasladoId(), r.getOrdenTrasladoId())
                || !Objects.equals(mov.getOrdenTrabajoId(), r.getOrdenTrabajoId())
                || !Objects.equals(mov.getOrdenVentaId(), r.getOrdenVentaId())
                || !Objects.equals(mov.getValeMovOrigId(), r.getValeMovOrigId())) {
            throw new BusinessException(
                    "Solo se puede editar cantidad y costo unitario por línea, y observaciones en cabecera. "
                            + "Para otros cambios anule el movimiento o use el flujo correspondiente.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.ACTUALIZACION_MOV_SOLO_CANT_PRECIO);
        }
    }

    private static boolean mismoTextoOpcional(String a, String b) {
        String x = a == null ? "" : a.trim();
        String y = b == null ? "" : b.trim();
        return x.equals(y);
    }

    private static boolean mismoTipoRefOrigen(String movTr, String reqTr) {
        return Objects.equals(normalizarTipoRefUnCaracter(movTr), normalizarTipoRefUnCaracter(reqTr));
    }

    private static String normalizarTipoRefUnCaracter(String tr) {
        if (tr == null || tr.isBlank()) {
            return null;
        }
        return String.valueOf(Character.toUpperCase(tr.trim().charAt(0)));
    }

    private void validarDetalleSoloCantidadPrecio(ValeMov mov, List<MovimientoLineaRequest> lineasReq) {
        if (lineasReq == null || lineasReq.isEmpty()) {
            throw new BusinessException(
                    "El movimiento debe conservar al menos una línea de detalle.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.ACTUALIZACION_MOV_SOLO_CANT_PRECIO);
        }
        List<ValeMovDet> existentes = mov.getLineas();
        if (existentes.size() != lineasReq.size()) {
            throw new BusinessException(
                    "No se pueden agregar ni quitar líneas por esta operación: debe enviar exactamente "
                            + existentes.size()
                            + " línea(s) con sus ids. Para eliminar un detalle use el proceso definido por negocio.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.ACTUALIZACION_MOV_SOLO_CANT_PRECIO);
        }
        Map<Long, ValeMovDet> porId = new LinkedHashMap<>();
        for (ValeMovDet d : existentes) {
            porId.put(d.getId(), d);
        }
        Set<Long> vistos = new HashSet<>();
        for (MovimientoLineaRequest lr : lineasReq) {
            if (lr.getId() == null) {
                throw new BusinessException(
                        "Cada línea debe incluir su id (vale_mov_det.id) para editar cantidad o costo unitario.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.ACTUALIZACION_MOV_SOLO_CANT_PRECIO);
            }
            ValeMovDet det = porId.get(lr.getId());
            if (det == null || !vistos.add(lr.getId())) {
                throw new BusinessException(
                        "Las líneas no coinciden con el movimiento (id de detalle inválido o duplicado).",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.ACTUALIZACION_MOV_SOLO_CANT_PRECIO);
            }
            assertLineaSoloDifiereCantidadPrecio(det, lr);
        }
    }

    private static void assertLineaSoloDifiereCantidadPrecio(ValeMovDet det, MovimientoLineaRequest lr) {
        if (!Objects.equals(det.getArticuloId(), lr.getArticuloId())) {
            falloActualizacionRestringida();
        }
        if (!Objects.equals(det.getMatrizContableId(), lr.getMatrizContableId())) {
            falloActualizacionRestringida();
        }
        if (!Objects.equals(det.getLotePalletId(), lr.getLotePalletId())) {
            falloActualizacionRestringida();
        }
        if (!Objects.equals(det.getUbicacionAlmacenId(), lr.getUbicacionAlmacenId())) {
            falloActualizacionRestringida();
        }
        if (!Objects.equals(det.getCentrosCostoId(), lr.getCentrosCostoId())) {
            falloActualizacionRestringida();
        }
        if (!Objects.equals(det.getMonedaId(), lr.getMonedaId())) {
            falloActualizacionRestringida();
        }
        if (!mismoBigDecimalCantidadOPeso(det.getPesoNetoTm(), lr.getPesoNetoTm())) {
            falloActualizacionRestringida();
        }
        if (!Objects.equals(det.getOcDetId(), lr.getOcDetId())) {
            falloActualizacionRestringida();
        }
        if (!Objects.equals(det.getOrdenTrasladoDetId(), lr.getOrdenTrasladoDetId())) {
            falloActualizacionRestringida();
        }
        if (!Objects.equals(det.getOrdenVentaDetId(), lr.getOrdenVentaDetId())) {
            falloActualizacionRestringida();
        }
        if (!Objects.equals(det.getOperacionesDetId(), lr.getOperacionesDetId())) {
            falloActualizacionRestringida();
        }
    }

    /** Compara cantidades/pesos tratando null como cero (alineado con {@link #mapearLinea}). */
    private static boolean mismoBigDecimalCantidadOPeso(BigDecimal a, BigDecimal b) {
        BigDecimal ax = a != null ? a : BigDecimal.ZERO;
        BigDecimal bx = b != null ? b : BigDecimal.ZERO;
        return ax.compareTo(bx) == 0;
    }

    private static void falloActualizacionRestringida() {
        throw new BusinessException(
                "Solo se puede modificar cantidad procesada y costo unitario por línea; el resto debe mantenerse igual.",
                HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.ACTUALIZACION_MOV_SOLO_CANT_PRECIO);
    }

    private void aplicarSoloCantidadYCostoUnitarioEnLineas(ValeMov mov, List<MovimientoLineaRequest> lineasReq) {
        Map<Long, MovimientoLineaRequest> porId = new HashMap<>();
        for (MovimientoLineaRequest lr : lineasReq) {
            porId.put(lr.getId(), lr);
        }
        for (ValeMovDet det : mov.getLineas()) {
            MovimientoLineaRequest lr = porId.get(det.getId());
            det.setCantProcesada(lr.getCantProcesada());
            det.setCostoUnitario(lr.getCostoUnitario());
        }
    }

    /**
     * Actualiza {@code cantidad_despachada} / {@code cantidad_recibida} con tope para evitar doble despacho
     * concurrente (WHERE falla si se excede {@code cantidad} o si la reversa dejaría negativo).
     */
    private int ejecutarUpdateAcumuladoOrdenTrasladoDet(boolean origen, boolean destino, BigDecimal delta,
                                                       ValeMovDet linea, Long ordenTrasladoId) {
        Long detId = linea.getOrdenTrasladoDetId();
        Long articuloId = linea.getArticuloId();
        if (origen) {
            if (delta.compareTo(BigDecimal.ZERO) > 0) {
                return jdbcTemplate.update(
                        "UPDATE almacen.orden_traslado_det SET cantidad_despachada = cantidad_despachada + ? "
                                + "WHERE id = ? AND orden_traslado_id = ? AND articulo_id = ? "
                                + "AND COALESCE(cantidad_despachada, 0) + ? <= COALESCE(cantidad, 0)",
                        delta, detId, ordenTrasladoId, articuloId, delta);
            }
            return jdbcTemplate.update(
                    "UPDATE almacen.orden_traslado_det SET cantidad_despachada = cantidad_despachada + ? "
                            + "WHERE id = ? AND orden_traslado_id = ? AND articulo_id = ? "
                            + "AND COALESCE(cantidad_despachada, 0) + ? >= 0",
                    delta, detId, ordenTrasladoId, articuloId, delta);
        }
        if (destino) {
            if (delta.compareTo(BigDecimal.ZERO) > 0) {
                return jdbcTemplate.update(
                        "UPDATE almacen.orden_traslado_det SET cantidad_recibida = cantidad_recibida + ? "
                                + "WHERE id = ? AND orden_traslado_id = ? AND articulo_id = ? "
                                + "AND COALESCE(cantidad_recibida, 0) + ? <= COALESCE(cantidad, 0)",
                        delta, detId, ordenTrasladoId, articuloId, delta);
            }
            return jdbcTemplate.update(
                    "UPDATE almacen.orden_traslado_det SET cantidad_recibida = cantidad_recibida + ? "
                            + "WHERE id = ? AND orden_traslado_id = ? AND articulo_id = ? "
                            + "AND COALESCE(cantidad_recibida, 0) + ? >= 0",
                    delta, detId, ordenTrasladoId, articuloId, delta);
        }
        throw new IllegalStateException("ejecutarUpdateAcumuladoOrdenTrasladoDet requiere origen o destino");
    }

    private void assertFilasSync(int filasActualizadas, String detalle) {
        if (filasActualizadas != 1) {
            throw new BusinessException(
                    "No se pudo sincronizar acumulados con el documento origen (" + detalle + ").",
                    HttpStatus.CONFLICT, MovimientoErrorCode.SYNC_ACUMULADO_ORIGEN_FALLIDO);
        }
    }

    /**
     * §10: si {@code flag_contabiliza = '1'}, resuelve automáticamente {@code matrizContableId}
     * en cada línea que no lo tenga. Si ya viene explícito, lo valida.
     */
    private void resolverMatrizContableSiAplica(ValeMov mov, ArticuloMovTipo tipo) {
        if (!"1".equals(tipo.getFlagContabiliza())) {
            return;
        }
        String grpCntbl = resolverGrpCntbl(tipo.getTipoMov());
        for (ValeMovDet linea : mov.getLineas()) {
            String codSubCat = obtenerCodSubCategoria(linea.getArticuloId());
            if (codSubCat == null) {
                throw new BusinessException(
                        "Artículo " + linea.getArticuloId()
                                + " no tiene subcategoría asignada. No se puede resolver la matriz contable.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.ARTICULO_SIN_SUBCATEGORIA);
            }
            if (linea.getMatrizContableId() == null) {
                Long matrizId = buscarMatrizSubcategoria(tipo.getTipoMov(), grpCntbl, codSubCat);
                linea.setMatrizContableId(matrizId);
            } else {
                validarMatrizManual(linea.getMatrizContableId(), tipo.getTipoMov(), grpCntbl, codSubCat);
            }
        }
    }

    private String obtenerCodSubCategoria(Long articuloId) {
        ArticuloRef artRef = articuloRefRepository.findById(articuloId).orElse(null);
        if (artRef == null || artRef.getArticuloSubCategId() == null) {
            return null;
        }
        return articuloSubCategRefRepository.findById(artRef.getArticuloSubCategId())
                .map(ArticuloSubCategRef::getCodSubCat)
                .orElse(null);
    }

    private Long buscarMatrizSubcategoria(String tipoMov, String grpCntbl, String codSubCat) {
        return tipoMovMatrizSubcatRepository
                .findFirstByTipoMovAndGrpCntblAndCodSubCatOrderByItemAsc(tipoMov, grpCntbl, codSubCat)
                .map(TipoMovMatrizSubcat::getMatrizCntblFinanId)
                .orElseThrow(() -> new BusinessException(
                        "No se encontró matriz contable para tipo " + tipoMov
                                + ", subcategoría " + codSubCat + ", grupo " + grpCntbl + ".",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.MATRIZ_NO_ENCONTRADA));
    }

    /** §10.3: si el usuario envía matrizContableId explícito, validar que coincida. */
    private void validarMatrizManual(Long matrizContableId, String tipoMov,
                                     String grpCntbl, String codSubCat) {
        tipoMovMatrizSubcatRepository
                .findFirstByTipoMovAndGrpCntblAndCodSubCatOrderByItemAsc(tipoMov, grpCntbl, codSubCat)
                .ifPresent(found -> {
                    if (!found.getMatrizCntblFinanId().equals(matrizContableId)) {
                        throw new BusinessException(
                                "La matriz indicada no corresponde a la combinación de tipo de movimiento, "
                                        + "subcategoría y grupo contable.",
                                HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.MATRIZ_INVALIDA);
                    }
                });
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Traslado entre almacenes — movimiento espejo (HU §11.5)
    // ──────────────────────────────────────────────────────────────────────────

    /**
     * §11.5: cuando {@code flag_mov_entre_alm = '1'}, genera un movimiento espejo de ingreso
     * en el almacén destino de la orden de traslado.
     */
    private void crearMovimientoEspejo(ValeMov salidaOrigen, ArticuloMovTipo tipoSalida,
                                       Long sucursalId) {
        if (salidaOrigen.getOrdenTrasladoId() == null) {
            throw new BusinessException(
                    "Para movimientos entre almacenes se requiere una orden de traslado.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.ORDEN_TRASLADO_REQUERIDA);
        }

        OrdenTraslado ot = ordenTrasladoRepository.findById(salidaOrigen.getOrdenTrasladoId())
                .orElseThrow(() -> new BusinessException(
                        "Orden de traslado no encontrada.",
                        HttpStatus.NOT_FOUND, MovimientoErrorCode.ORDEN_TRASLADO_NO_ENCONTRADA));

        Long almacenDestinoId = ot.getAlmacenDestinoId();
        validarAlmacenExiste(almacenDestinoId);

        ArticuloMovTipo tipoIngreso = articuloMovTipoRepository
                .findFirstByFlagMovEntreAlmAndFactorSldoTotalGreaterThanAndFlagEstado(
                        "1", BigDecimal.ZERO, "1")
                .orElseThrow(() -> new BusinessException(
                        "No se encontró un tipo de movimiento de ingreso por traslado activo.",
                        HttpStatus.UNPROCESSABLE_ENTITY,
                        MovimientoErrorCode.TIPO_INGRESO_TRASLADO_NO_ENCONTRADO));

        if (tipoIngreso.getId().equals(tipoSalida.getId())) {
            tipoIngreso = articuloMovTipoRepository.findAll().stream()
                    .filter(t -> "1".equals(t.getFlagMovEntreAlm())
                            && "1".equals(t.getFlagEstado())
                            && t.getFactorSldoTotal().compareTo(BigDecimal.ZERO) > 0
                            && !t.getId().equals(tipoSalida.getId()))
                    .findFirst()
                    .orElseThrow(() -> new BusinessException(
                            "No se encontró un tipo de movimiento de ingreso por traslado distinto al de salida.",
                            HttpStatus.UNPROCESSABLE_ENTITY,
                            MovimientoErrorCode.TIPO_INGRESO_TRASLADO_NO_ENCONTRADO));
        }

        ValeMov espejo = new ValeMov();
        espejo.setSucursalId(sucursalId);
        espejo.setAlmacenId(almacenDestinoId);
        espejo.setArticuloMovTipoId(tipoIngreso.getId());
        espejo.setFechaMov(salidaOrigen.getFechaMov());
        espejo.setFecProduccion(salidaOrigen.getFecProduccion());
        espejo.setOrdenTrasladoId(salidaOrigen.getOrdenTrasladoId());
        espejo.setTipoReferenciaOrigen("T");
        espejo.setObservaciones("Movimiento espejo generado desde vale " + salidaOrigen.getNroVale());

        for (ValeMovDet lineaOrigen : salidaOrigen.getLineas()) {
            ValeMovDet lineaEspejo = new ValeMovDet();
            lineaEspejo.setArticuloId(lineaOrigen.getArticuloId());
            lineaEspejo.setCantProcesada(lineaOrigen.getCantProcesada());
            lineaEspejo.setCostoUnitario(lineaOrigen.getCostoUnitario());
            lineaEspejo.setLotePalletId(lineaOrigen.getLotePalletId());
            lineaEspejo.setUbicacionAlmacenId(null);
            lineaEspejo.setCentrosCostoId(lineaOrigen.getCentrosCostoId());
            lineaEspejo.setMonedaId(lineaOrigen.getMonedaId());
            lineaEspejo.setPesoNetoTm(lineaOrigen.getPesoNetoTm());
            lineaEspejo.setOrdenTrasladoDetId(lineaOrigen.getOrdenTrasladoDetId());
            espejo.addLinea(lineaEspejo);
        }

        resolverMatrizContableSiAplica(espejo, tipoIngreso);

        espejo.setNroVale(numeradorDocumentoService.siguienteNroDocumento(
                NOMBRE_TABLA_DOCUMENTO, sucursalId,
                espejo.getFechaMov().getYear()));

        aplicarStock(espejo, tipoIngreso, false);
        ValeMov espejoGuardado = valeMovRepository.save(espejo);
        sincronizarAcumuladosDocumentosOrigen(espejoGuardado, false);
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Devoluciones (HU §12)
    // ──────────────────────────────────────────────────────────────────────────

    @Override
    public DevolvibleResponse obtenerDevolvible(Long valeMovId) {
        ValeMov movOriginal = buscar(valeMovId);
        if (!ValeMovFlagEstado.ACTIVO.equals(movOriginal.getFlagEstado())) {
            throw new BusinessException("Solo se puede devolver un movimiento Activo.",
                    HttpStatus.CONFLICT, MovimientoErrorCode.MOVIMIENTO_ORIGEN_NO_DEVOLVIBLE);
        }

        ArticuloMovTipo tipo = articuloMovTipoRepository.findById(movOriginal.getArticuloMovTipoId())
                .orElseThrow(() -> new BusinessException("Tipo de movimiento no encontrado.",
                        HttpStatus.NOT_FOUND, MovimientoErrorCode.TIPO_MOV_NO_ENCONTRADO));

        if (tipo.getTipoMovDev() == null || tipo.getTipoMovDev().isBlank()) {
            throw new BusinessException("Este tipo de movimiento no permite devoluciones.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.TIPO_SIN_DEVOLUCION);
        }

        List<DevolvibleLineaResponse> lineas = new ArrayList<>();
        for (ValeMovDet det : movOriginal.getLineas()) {
            if (!ValeMovFlagEstado.ACTIVO.equals(det.getFlagEstado())) {
                continue;
            }
            BigDecimal yaDevuelta = valeMovRepository.sumCantDevueltaPorArticulo(
                    valeMovId, det.getArticuloId());
            BigDecimal devolvible = det.getCantProcesada().subtract(yaDevuelta);
            if (devolvible.compareTo(BigDecimal.ZERO) > 0) {
                lineas.add(DevolvibleLineaResponse.builder()
                        .articuloId(det.getArticuloId())
                        .cantOriginal(det.getCantProcesada())
                        .cantYaDevuelta(yaDevuelta)
                        .cantDevolvible(devolvible)
                        .costoUnitario(det.getCostoUnitario())
                        .build());
            }
        }

        return DevolvibleResponse.builder()
                .valeMovId(movOriginal.getId())
                .nroVale(movOriginal.getNroVale())
                .almacenId(movOriginal.getAlmacenId())
                .articuloMovTipoId(movOriginal.getArticuloMovTipoId())
                .fechaMov(movOriginal.getFechaMov())
                .tipoMovDevolucion(tipo.getTipoMovDev())
                .lineas(lineas)
                .build();
    }

    @Override
    @Transactional
    public MovimientoDetalleResponse crearDevolucion(DevolucionRequest request) {
        ValeMov movOriginal = buscar(request.getValeMovOrigenId());
        if (!ValeMovFlagEstado.ACTIVO.equals(movOriginal.getFlagEstado())) {
            throw new BusinessException("Solo se puede devolver un movimiento Activo.",
                    HttpStatus.CONFLICT, MovimientoErrorCode.MOVIMIENTO_ORIGEN_NO_DEVOLVIBLE);
        }

        ArticuloMovTipo tipoOrigen = articuloMovTipoRepository.findById(movOriginal.getArticuloMovTipoId())
                .orElseThrow(() -> new BusinessException("Tipo de movimiento no encontrado.",
                        HttpStatus.NOT_FOUND, MovimientoErrorCode.TIPO_MOV_NO_ENCONTRADO));

        if (tipoOrigen.getTipoMovDev() == null || tipoOrigen.getTipoMovDev().isBlank()) {
            throw new BusinessException("Este tipo de movimiento no permite devoluciones.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.TIPO_SIN_DEVOLUCION);
        }

        ArticuloMovTipo tipoDev = articuloMovTipoRepository.findByTipoMov(tipoOrigen.getTipoMovDev())
                .orElseThrow(() -> new BusinessException(
                        "Tipo de movimiento de devolución '" + tipoOrigen.getTipoMovDev() + "' no encontrado.",
                        HttpStatus.NOT_FOUND, MovimientoErrorCode.TIPO_MOV_NO_ENCONTRADO));

        validarPeriodoAbierto(request.getFechaMov());

        ValeMov devolucion = new ValeMov();
        devolucion.setSucursalId(request.getSucursalId());
        devolucion.setAlmacenId(movOriginal.getAlmacenId());
        devolucion.setArticuloMovTipoId(tipoDev.getId());
        devolucion.setFechaMov(request.getFechaMov());
        devolucion.setValeMovOrigId(movOriginal.getId());
        devolucion.setObservaciones(
                "Devolución del vale " + movOriginal.getNroVale()
                        + (request.getObservaciones() != null ? ". " + request.getObservaciones() : ""));

        for (DevolucionLineaRequest lr : request.getLineas()) {
            BigDecimal yaDevuelta = valeMovRepository.sumCantDevueltaPorArticulo(
                    movOriginal.getId(), lr.getArticuloId());

            BigDecimal cantOriginal = movOriginal.getLineas().stream()
                    .filter(d -> d.getArticuloId().equals(lr.getArticuloId())
                            && ValeMovFlagEstado.ACTIVO.equals(d.getFlagEstado()))
                    .map(ValeMovDet::getCantProcesada)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            BigDecimal devolvible = cantOriginal.subtract(yaDevuelta);
            if (lr.getCantDevolver().compareTo(devolvible) > 0) {
                throw new BusinessException(
                        "Artículo " + lr.getArticuloId() + ": cantidad a devolver ("
                                + lr.getCantDevolver() + ") excede lo devolvible (" + devolvible + ").",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.CANTIDAD_DEVOLUCION_EXCEDIDA);
            }

            BigDecimal costoUnit = movOriginal.getLineas().stream()
                    .filter(d -> d.getArticuloId().equals(lr.getArticuloId()))
                    .map(d -> d.getCostoUnitario() != null ? d.getCostoUnitario() : BigDecimal.ZERO)
                    .findFirst().orElse(BigDecimal.ZERO);

            ValeMovDet lineaOriginal = movOriginal.getLineas().stream()
                    .filter(d -> d.getArticuloId().equals(lr.getArticuloId())
                            && ValeMovFlagEstado.ACTIVO.equals(d.getFlagEstado()))
                    .findFirst().orElse(null);

            ValeMovDet lineaDev = new ValeMovDet();
            lineaDev.setArticuloId(lr.getArticuloId());
            lineaDev.setCantProcesada(lr.getCantDevolver());
            lineaDev.setCostoUnitario(costoUnit);
            lineaDev.setUbicacionAlmacenId(lr.getUbicacionAlmacenId());
            lineaDev.setCentrosCostoId(lr.getCentrosCostoId());
            if (lineaOriginal != null) {
                lineaDev.setMonedaId(lineaOriginal.getMonedaId());
                lineaDev.setPesoNetoTm(lineaOriginal.getPesoNetoTm());
                lineaDev.setOcDetId(lineaOriginal.getOcDetId());
            }
            devolucion.addLinea(lineaDev);
        }

        resolverMatrizContableSiAplica(devolucion, tipoDev);
        validarLineas(devolucion, tipoDev);

        devolucion.setNroVale(numeradorDocumentoService.siguienteNroDocumento(
                NOMBRE_TABLA_DOCUMENTO, request.getSucursalId(),
                devolucion.getFechaMov().getYear()));

        aplicarStock(devolucion, tipoDev, false);
        ValeMov guardadoDev = valeMovRepository.save(devolucion);
        sincronizarAcumuladosDocumentosOrigen(guardadoDev, true);
        return toDetalle(guardadoDev);
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Excel Export (HU §18.8)
    // ──────────────────────────────────────────────────────────────────────────

    @Override
    public byte[] exportarExcel(Long sucursalId, Long almacenId, Long articuloMovTipoId,
                                String estado, LocalDate fechaDesde, LocalDate fechaHasta) {
        var spec = ValeMovSpecifications.conFiltros(
                sucursalId, almacenId, articuloMovTipoId, estado,
                fechaDesde, fechaHasta, null, null, null);
        List<ValeMov> movimientos = valeMovRepository.findAll(spec);

        try (XSSFWorkbook wb = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = wb.createSheet("Movimientos");

            CellStyle headerStyle = wb.createCellStyle();
            Font font = wb.createFont();
            font.setBold(true);
            headerStyle.setFont(font);

            String[] headers = {"ID", "Nro Vale", "Almacén ID", "Tipo Mov ID", "Fecha Mov",
                    "Estado", "Proveedor ID", "Tipo Ref", "Observaciones"};
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            int rowIdx = 1;
            for (ValeMov m : movimientos) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(m.getId());
                row.createCell(1).setCellValue(m.getNroVale() != null ? m.getNroVale() : "");
                row.createCell(2).setCellValue(m.getAlmacenId());
                row.createCell(3).setCellValue(m.getArticuloMovTipoId());
                row.createCell(4).setCellValue(m.getFechaMov() != null ? m.getFechaMov().format(dtf) : "");
                row.createCell(5).setCellValue(ValeMovFlagEstado.toLabel(m.getFlagEstado()));
                row.createCell(6).setCellValue(m.getProveedorId() != null ? m.getProveedorId() : 0);
                row.createCell(7).setCellValue(m.getTipoReferenciaOrigen() != null ? m.getTipoReferenciaOrigen() : "");
                row.createCell(8).setCellValue(m.getObservaciones() != null ? m.getObservaciones() : "");
            }

            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            wb.write(out);
            return out.toByteArray();
        } catch (Exception e) {
            throw new BusinessException("Error al generar el archivo Excel: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, MovimientoErrorCode.EXCEL_ERROR);
        }
    }

    // ──────────────────────────────────────────────────────────────────────────
    // PDF (HU §18.9)
    // ──────────────────────────────────────────────────────────────────────────

    /** Usuario del JWT ({@code TenantContext}) para el bloque "Generado:" del PDF. */
    private String resolverNombreUsuarioGeneradorPdf() {
        Long uid = com.sigre.common.security.TenantContext.getUsuarioId();
        if (uid == null) {
            return "";
        }
        try {
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                    "SELECT nombre_completo FROM auth.usuario WHERE id = ?", uid);
            if (rows.isEmpty()) {
                return "";
            }
            Object v = rows.get(0).get("nombre_completo");
            return v != null ? v.toString().trim() : "";
        } catch (Exception ex) {
            log.debug("PDF nombre usuario generador: {}", ex.getMessage());
            return "";
        }
    }

    @Override
    public byte[] generarPdf(Long valeMovId) {
        ValeMov mov = buscar(valeMovId);
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        // Proyección [id, tipoMov, descTipoMov] en vez de la entidad completa:
        // algunos tenants migrados no tienen todas las columnas de articulo_mov_tipo
        // (p. ej. cnta_cntbl en Cantabria), y findById fallaría al hacer SELECT *.
        Object[] tipoRes = mov.getArticuloMovTipoId() != null
                ? articuloMovTipoRepository.findResumenByIds(List.of(mov.getArticuloMovTipoId()))
                        .stream().findFirst().orElse(null)
                : null;
        String tipoMovCodigo = tipoRes != null && tipoRes[1] != null ? tipoRes[1].toString() : "";
        String tipoMovDesc = tipoRes != null && tipoRes[2] != null ? tipoRes[2].toString() : "";
        Almacen almacen = almacenRepository.findById(mov.getAlmacenId()).orElse(null);
        SucursalRef sucursal = sucursalRefRepository.findById(mov.getSucursalId()).orElse(null);
        EntidadContribuyenteRef proveedor = mov.getProveedorId() != null
                ? entidadContribuyenteRefRepository.findById(mov.getProveedorId()).orElse(null)
                : null;

        Long empresaId = com.sigre.common.security.TenantContext.getEmpresaId();
        EmpresaInfoService.EmpresaInfo empresaInfo = empresaInfoService.obtener(empresaId);

        java.util.Map<String, Object> params = new java.util.HashMap<>();
        params.put("logoImage", empresaInfo.logoInputStream());
        params.put("logoSubreport", JasperLogoContainer.requireCompiledSubreport());
        params.put("logoSize", "L");
        params.put("empresaNombre", empresaInfo.razonSocial());
        params.put("empresaRuc", empresaInfo.ruc());
        params.put("empresaDireccion", empresaInfo.direccion());
        params.put("nroVale", nvl(mov.getNroVale()));
        params.put("fechaMov", mov.getFechaMov() != null ? mov.getFechaMov().format(dtf) : "");
        params.put("tipoMovCodigo", tipoMovCodigo);
        params.put("tipoMovDesc", tipoMovDesc);
        params.put("almacenNombre", almacen != null ? almacen.getNombre() : "");
        params.put("almacenCodigo", almacen != null ? almacen.getCodigo() : "");
        params.put("proveedorNombre", proveedor != null ? proveedor.getNombreCompleto() : "-");
        params.put("proveedorDoc", proveedor != null ? nvl(proveedor.getNroDocumento()) : null);
        params.put("docInterno", nvl(mov.getNroDocInt()));
        params.put("docExterno", nvl(mov.getNroDocExt()));
        params.put("referencia", nvl(mov.getTipoReferenciaOrigen()));
        params.put("observaciones", nvl(mov.getObservaciones()));
        params.put("sucursalCodigo", sucursal != null ? sucursal.getCodigo() : "");
        params.put("nomReceptor", nvl(mov.getNomReceptor()));
        params.put("valeMovOrigId", mov.getValeMovOrigId() != null ? String.valueOf(mov.getValeMovOrigId()) : "");
        params.put("flagEstadoCabecera", nvl(mov.getFlagEstado()));
        params.put("estadoCabeceraLabel", nvl(ValeMovFlagEstado.toLabel(mov.getFlagEstado())));
        params.put("usuarioGeneradorNombre", nvl(resolverNombreUsuarioGeneradorPdf()));

        List<java.util.Map<String, String>> rows = new ArrayList<>();
        BigDecimal totalCant = BigDecimal.ZERO;

        for (ValeMovDet d : mov.getLineas()) {
            ArticuloRef art = articuloRefRepository.findById(d.getArticuloId()).orElse(null);
            UnidadMedidaRef um = art != null && art.getUnidadMedidaId() != null
                    ? unidadMedidaRefRepository.findById(art.getUnidadMedidaId()).orElse(null)
                    : null;

            totalCant = totalCant.add(d.getCantProcesada());

            java.util.Map<String, String> row = new java.util.HashMap<>();
            row.put("codigo", art != null ? nvl(art.getCodigo()) : String.valueOf(d.getArticuloId()));
            row.put("descripcion", art != null ? nvl(art.getNombre()) : "");
            row.put("unidad", um != null ? um.getLabel() : "");
            row.put("cantidad", d.getCantProcesada().setScale(4, RoundingMode.HALF_UP).toPlainString());
            row.put("centroCosto", d.getCentrosCostoId() != null ? String.valueOf(d.getCentrosCostoId()) : "");
            row.put("costoUnitario", d.getCostoUnitario() != null
                    ? d.getCostoUnitario().setScale(6, RoundingMode.HALF_UP).toPlainString()
                    : "-");
            rows.add(row);
        }
        params.put("totalCantidad", totalCant.setScale(4, RoundingMode.HALF_UP).toPlainString());

        try {
            java.io.InputStream jrxml = getClass().getResourceAsStream("/reports/vale_movimiento.jrxml");
            if (jrxml == null) {
                throw new BusinessException("Plantilla vale_movimiento.jrxml no encontrada",
                        HttpStatus.INTERNAL_SERVER_ERROR, MovimientoErrorCode.PDF_ERROR);
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
            log.error("Error generando PDF para vale {}: {}", valeMovId, e.getMessage(), e);
            throw new BusinessException("Error al generar PDF: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, MovimientoErrorCode.PDF_ERROR);
        }
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Excel Import (HU §18.7)
    // ──────────────────────────────────────────────────────────────────────────

    @Override
    @Transactional
    public ImportResultResponse importarExcel(org.springframework.web.multipart.MultipartFile file,
                                              Long sucursalId) {
        List<String> errores = new ArrayList<>();
        int totalLeidas = 0;
        int totalImportadas = 0;

        if (file == null || file.isEmpty()) {
            throw new BusinessException(
                    "El archivo está vacío o no se envió. Use POST multipart/form-data con el campo \"file\" "
                            + "conteniendo un .xlsx (no JSON en body). Opcional: campo \"sucursalId\".",
                    HttpStatus.BAD_REQUEST,
                    MovimientoErrorCode.EXCEL_ERROR);
        }

        try (Workbook wb = new XSSFWorkbook(file.getInputStream())) {
            Sheet sheet = wb.getSheetAt(0);
            Long sucursalEfectiva = sucursalId;
            if (sucursalEfectiva == null) {
                sucursalEfectiva = inferirSucursalDesdePrimeraFilaAlmacen(sheet);
            }
            if (sucursalEfectiva == null) {
                throw new BusinessException(
                        "Indique sucursalId o incluya un almacénId válido en la primera fila de datos del archivo.",
                        HttpStatus.BAD_REQUEST,
                        MovimientoErrorCode.EXCEL_ERROR);
            }
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;
                totalLeidas++;
                try {
                    MovimientoCabeceraRequest req = parsearFilaExcel(row, sucursalEfectiva);
                    crear(req);
                    totalImportadas++;
                } catch (Exception e) {
                    errores.add("Fila " + (i + 1) + ": " + e.getMessage());
                }
            }
        } catch (Exception e) {
            throw new BusinessException("Error al leer el archivo Excel: " + e.getMessage(),
                    HttpStatus.BAD_REQUEST, MovimientoErrorCode.EXCEL_ERROR);
        }

        return ImportResultResponse.builder()
                .totalLeidas(totalLeidas)
                .totalImportadas(totalImportadas)
                .totalErrores(errores.size())
                .errores(errores)
                .build();
    }

    /**
     * Si no se envió {@code sucursalId}, obtiene la sucursal desde el almacén de la primera fila con datos.
     */
    private Long inferirSucursalDesdePrimeraFilaAlmacen(Sheet sheet) {
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null) {
                continue;
            }
            try {
                Long almacenId = longVal(row, 0);
                if (almacenId == null) {
                    continue;
                }
                return almacenRepository.findById(almacenId).map(Almacen::getSucursalId).orElse(null);
            } catch (Exception ex) {
                log.debug("Inferencia sucursal fila {}: {}", i + 1, ex.getMessage());
            }
        }
        return null;
    }

    /**
     * Parsea una fila del Excel de importación.
     * Columnas esperadas: almacenId | articuloMovTipoId | fechaMov(dd/MM/yyyy) | articuloId | cantidad | costoUnitario
     */
    private MovimientoCabeceraRequest parsearFilaExcel(Row row, Long sucursalId) {
        MovimientoCabeceraRequest req = new MovimientoCabeceraRequest();
        req.setSucursalId(sucursalId);
        req.setAlmacenId(longVal(row, 0));
        req.setArticuloMovTipoId(longVal(row, 1));
        req.setFechaMov(dateVal(row, 2));

        List<MovimientoLineaRequest> lineas = new ArrayList<>();
        MovimientoLineaRequest linea = new MovimientoLineaRequest();
        linea.setArticuloId(longVal(row, 3));
        linea.setCantProcesada(decimalVal(row, 4));
        BigDecimal costo = decimalVal(row, 5);
        if (costo != null && costo.compareTo(BigDecimal.ZERO) > 0) {
            linea.setCostoUnitario(costo);
        }
        lineas.add(linea);
        req.setLineas(lineas);
        return req;
    }

    private Long longVal(Row row, int col) {
        Cell c = row.getCell(col);
        if (c == null) return null;
        return (long) c.getNumericCellValue();
    }

    private BigDecimal decimalVal(Row row, int col) {
        Cell c = row.getCell(col);
        if (c == null) return null;
        return BigDecimal.valueOf(c.getNumericCellValue());
    }

    private LocalDate dateVal(Row row, int col) {
        Cell c = row.getCell(col);
        if (c == null) return null;
        if (c.getCellType() == CellType.NUMERIC && DateUtil.isCellDateFormatted(c)) {
            return c.getLocalDateTimeCellValue().toLocalDate();
        }
        return LocalDate.parse(c.getStringCellValue(), DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    private static String nvl(String s) {
        return s != null ? s : "";
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Mapeo a DTOs
    // ──────────────────────────────────────────────────────────────────────────

    private MovimientoListItemResponse toListItem(ValeMov m) {
        return MovimientoListItemResponse.builder()
                .id(m.getId())
                .sucursalId(m.getSucursalId())
                .almacenId(m.getAlmacenId())
                .articuloMovTipoId(m.getArticuloMovTipoId())
                .nroVale(m.getNroVale())
                .tipoReferenciaOrigen(m.getTipoReferenciaOrigen())
                .ordenCompraId(m.getOrdenCompraId())
                .ordenVentaId(m.getOrdenVentaId())
                .fechaMov(m.getFechaMov())
                .fecProduccion(m.getFecProduccion())
                .flagEstado(m.getFlagEstado())
                .build();
    }

    private MovimientoDetalleResponse toDetalle(ValeMov m) {
        Set<Long> userIds = new HashSet<>();
        UsuarioResumenLoader.addId(userIds, m.getCreatedBy());
        UsuarioResumenLoader.addId(userIds, m.getUpdatedBy());
        for (ValeMovDet d : m.getLineas()) {
            UsuarioResumenLoader.addId(userIds, d.getCreatedBy());
            UsuarioResumenLoader.addId(userIds, d.getUpdatedBy());
        }
        Map<Long, UsuarioResumenDto> usersMap = usuarioResumenLoader.loadByIds(userIds);

        Set<Long> artIds = m.getLineas().stream()
                .map(ValeMovDet::getArticuloId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        Map<Long, ArticuloRef> artMap = new HashMap<>();
        if (!artIds.isEmpty()) {
            for (ArticuloRef ar : articuloRefRepository.findAllById(artIds)) {
                artMap.put(ar.getId(), ar);
            }
        }

        String sucursalNombre = sucursalRefRepository.findById(m.getSucursalId())
                .map(SucursalRef::getNombre)
                .orElse(null);
        String almacenNombre = almacenRepository.findById(m.getAlmacenId())
                .map(Almacen::getNombre)
                .orElse(null);
        String tipoDesc = articuloMovTipoRepository.findById(m.getArticuloMovTipoId())
                .map(ArticuloMovTipo::getDescTipoMov)
                .orElse(null);

        List<MovimientoLineaResponse> lineas = new ArrayList<>();
        for (ValeMovDet d : m.getLineas()) {
            ArticuloRef ar = artMap.get(d.getArticuloId());
            lineas.add(MovimientoLineaResponse.builder()
                    .id(d.getId())
                    .articuloId(d.getArticuloId())
                    .articuloCodigo(ar != null ? ar.getCodigo() : null)
                    .articuloNombre(ar != null ? ar.getNombre() : null)
                    .cantProcesada(d.getCantProcesada())
                    .costoUnitario(d.getCostoUnitario())
                    .matrizContableId(d.getMatrizContableId())
                    .lotePalletId(d.getLotePalletId())
                    .ubicacionAlmacenId(d.getUbicacionAlmacenId())
                    .centrosCostoId(d.getCentrosCostoId())
                    .monedaId(d.getMonedaId())
                    .pesoNetoTm(d.getPesoNetoTm())
                    .precioUnitAnt(d.getPrecioUnitAnt())
                    .flagEstado(d.getFlagEstado())
                    .ocDetId(d.getOcDetId())
                    .ordenTrasladoDetId(d.getOrdenTrasladoDetId())
                    .ordenVentaDetId(d.getOrdenVentaDetId())
                    .operacionesDetId(d.getOperacionesDetId())
                    .createdBy(d.getCreatedBy())
                    .createdByUsuario(UsuarioResumenLoader.fromMap(usersMap, d.getCreatedBy()))
                    .fecCreacion(d.getFecCreacion())
                    .updatedBy(d.getUpdatedBy())
                    .updatedByUsuario(UsuarioResumenLoader.fromMap(usersMap, d.getUpdatedBy()))
                    .fecModificacion(d.getFecModificacion())
                    .build());
        }
        return MovimientoDetalleResponse.builder()
                .id(m.getId())
                .sucursalId(m.getSucursalId())
                .sucursalNombre(sucursalNombre)
                .almacenId(m.getAlmacenId())
                .almacenNombre(almacenNombre)
                .articuloMovTipoId(m.getArticuloMovTipoId())
                .articuloMovTipoDescripcion(tipoDesc)
                .nroVale(m.getNroVale())
                .fechaMov(m.getFechaMov())
                .fecProduccion(m.getFecProduccion())
                .proveedorId(m.getProveedorId())
                .nomReceptor(m.getNomReceptor())
                .tipoDocIntId(m.getTipoDocIntId())
                .nroDocInt(m.getNroDocInt())
                .tipoDocExtId(m.getTipoDocExtId())
                .nroDocExt(m.getNroDocExt())
                .tipoReferenciaOrigen(m.getTipoReferenciaOrigen())
                .ordenCompraId(m.getOrdenCompraId())
                .progComprasId(m.getProgComprasId())
                .ordenTrasladoId(m.getOrdenTrasladoId())
                .ordenTrabajoId(m.getOrdenTrabajoId())
                .ordenVentaId(m.getOrdenVentaId())
                .observaciones(m.getObservaciones())
                .valeMovOrigId(m.getValeMovOrigId())
                .flagEstado(m.getFlagEstado())
                .createdBy(m.getCreatedBy())
                .createdByUsuario(UsuarioResumenLoader.fromMap(usersMap, m.getCreatedBy()))
                .fecCreacion(m.getFecCreacion())
                .updatedBy(m.getUpdatedBy())
                .updatedByUsuario(UsuarioResumenLoader.fromMap(usersMap, m.getUpdatedBy()))
                .fecModificacion(m.getFecModificacion())
                .lineas(lineas)
                .build();
    }
}
