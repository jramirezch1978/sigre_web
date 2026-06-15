package com.sigre.finanzas.service.impl;

import feign.FeignException;
import feign.Request;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.finanzas.FinanzasTestFixtures;
import com.sigre.finanzas.client.ContabilidadClient;
import com.sigre.finanzas.client.CoreMaestrosClient;
import com.sigre.finanzas.domain.CntasPagarFlagEstado;
import com.sigre.finanzas.dto.request.CntasPagarDetRequest;
import com.sigre.finanzas.dto.request.DetImpuestoRequest;
import com.sigre.finanzas.dto.request.CntasPagarRequest;
import com.sigre.finanzas.dto.response.GenerarAsientoResponse;
import com.sigre.finanzas.entity.CntasPagar;
import com.sigre.finanzas.entity.CntasPagarDet;
import com.sigre.finanzas.mapper.CntasPagarDetMapper;
import com.sigre.finanzas.mapper.CntasPagarMapper;
import com.sigre.finanzas.repository.CntasPagarDetRepository;
import com.sigre.finanzas.repository.CntasPagarRepository;
import com.sigre.finanzas.service.CntasPagarDetImpService;
import com.sigre.finanzas.service.FinanzasErrorCodes;
import com.sigre.finanzas.service.support.CntasPagarCabeceraValidator;

import java.nio.charset.StandardCharsets;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("CntasPagarServiceImpl — Pruebas Unitarias")
class CntasPagarServiceImplTest {

    @Mock
    private CntasPagarRepository repository;

    @Mock
    private CntasPagarDetRepository detalleRepository;

    @Mock
    private CntasPagarMapper mapper;

    @Mock
    private CntasPagarDetMapper detalleMapper;

    @Mock
    private CoreMaestrosClient coreMaestrosClient;

    @Mock
    private ContabilidadClient contabilidadClient;

    @Mock
    private CntasPagarCabeceraValidator cabeceraValidator;

    @Mock
    private CntasPagarDetImpService detImpService;

    @InjectMocks
    private CntasPagarServiceImpl service;

    private static final Pageable PAGEABLE = PageRequest.of(0, 10);

    // ==== Setup compartido — lenient() para stubs reusados ====
    @BeforeEach
    void setUp() {
        lenient().when(coreMaestrosClient.obtenerEntidadPorId(anyLong()))
                .thenReturn(FinanzasTestFixtures.mockEntidadResponse());
        lenient().when(coreMaestrosClient.obtenerDocTipoPorId(anyLong()))
                .thenReturn(FinanzasTestFixtures.mockDocTipoResponse());
        lenient().when(coreMaestrosClient.obtenerMonedaPorId(anyLong()))
                .thenReturn(FinanzasTestFixtures.mockMonedaResponse());
        lenient().doNothing().when(cabeceraValidator).validar(any(), any(), any());
        lenient().doNothing().when(detImpService).guardarImpuestos(any(), any());
        lenient().when(detImpService.listarPorDetalle(anyLong())).thenReturn(Collections.emptyList());
    }

    // ========================================================================
    // validarDocumentoDuplicado
    // ========================================================================

    @Test
    @DisplayName("crear() con documento duplicado -> lanza BusinessException (FIN-107)")
    void crear_cuandoDocumentoDuplicado_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(
                eq(1L), eq(1L), eq("F001"), eq("00001")))
                .thenReturn(true);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.DOCUMENTO_UNIQUE_KEY_DUPLICADO);
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.CONFLICT);
                    assertThat(be.getMessage()).contains("proveedor");
                });
    }

    // ========================================================================
    // validarMoneda
    // ========================================================================

    @Test
    @DisplayName("crear() con monedaId nulo -> lanza BusinessException (FIN-005)")
    void crear_cuandoMonedaIdNulo_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        request.setMonedaId(null);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.MONEDA_NO_ENCONTRADA);
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.BAD_REQUEST);
                    assertThat(be.getMessage()).isEqualTo("La moneda es obligatoria");
                });
    }

    @Test
    @DisplayName("crear() con moneda no encontrada en core-maestros -> lanza BusinessException")
    void crear_cuandoMonedaNoExiste_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        when(coreMaestrosClient.obtenerMonedaPorId(1L))
                .thenThrow(crearFeignNotFound());

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.MONEDA_NO_ENCONTRADA);
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.NOT_FOUND);
                    assertThat(be.getMessage()).isEqualTo("Moneda no encontrada");
                });
    }

    // ========================================================================
    // validarProveedor
    // ========================================================================

    @Test
    @DisplayName("crear() con proveedor no encontrado -> lanza BusinessException (FIN-201)")
    void crear_cuandoProveedorNoExiste_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        when(coreMaestrosClient.obtenerEntidadPorId(1L))
                .thenThrow(crearFeignNotFound());

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.PROVEEDOR_NO_ENCONTRADO);
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.NOT_FOUND);
                    assertThat(be.getMessage()).isEqualTo("Proveedor no encontrado");
                });
    }

    // ========================================================================
    // validarDocTipo
    // ========================================================================

    @Test
    @DisplayName("crear() con tipo de documento no encontrado -> lanza BusinessException (FIN-202)")
    void crear_cuandoDocTipoNoExiste_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        when(coreMaestrosClient.obtenerDocTipoPorId(1L))
                .thenThrow(crearFeignNotFound());

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.DOC_TIPO_NO_ENCONTRADO);
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.NOT_FOUND);
                    assertThat(be.getMessage()).isEqualTo("Tipo de documento no encontrado");
                });
    }

    // ========================================================================
    // validarFechas
    // ========================================================================

    @Test
    @DisplayName("crear() con fecha de vencimiento anterior a emisión -> lanza BusinessException (FIN-301)")
    void crear_cuandoFechaVencimientoAnterior_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        request.setFechaEmision(LocalDate.of(2026, 5, 15));
        request.setFechaVencimiento(LocalDate.of(2026, 5, 10));

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.FECHA_VENCIMIENTO_INVALIDA);
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.UNPROCESSABLE_ENTITY);
                    assertThat(be.getMessage()).contains("fecha de vencimiento");
                });
    }

    // ========================================================================
    // validarTotal
    // ========================================================================

    @Test
    @DisplayName("crear() con total cero -> lanza BusinessException (FIN-103)")
    void crear_cuandoTotalCero_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        request.setTotal(BigDecimal.ZERO);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.SALDO_INVALIDO);
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.BAD_REQUEST);
                    assertThat(be.getMessage()).isEqualTo("El total debe ser mayor a cero");
                });
    }

    @Test
    @DisplayName("crear() con total negativo -> lanza BusinessException")
    void crear_cuandoTotalNegativo_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        request.setTotal(new BigDecimal("-100.00"));

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.SALDO_INVALIDO);
                    assertThat(be.getMessage()).isEqualTo("El total debe ser mayor a cero");
                });
    }

    // ========================================================================
    // validarDetalles
    // ========================================================================

    @Test
    @DisplayName("crear() con detalles nulos -> lanza BusinessException")
    void crear_cuandoDetallesNulos_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        request.setDetalles(null);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getMessage()).contains("al menos un detalle");
                });
    }

    @Test
    @DisplayName("crear() con detalles vacíos -> lanza BusinessException")
    void crear_cuandoDetallesVacios_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        request.setDetalles(Collections.emptyList());

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getMessage()).contains("al menos un detalle");
                });
    }

    @Test
    @DisplayName("crear() con detalle con articuloId no encontrado -> lanza BusinessException (FIN-203)")
    void crear_cuandoArticuloNoExiste_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        CntasPagarDetRequest det = new CntasPagarDetRequest();
        det.setItem(1);
        det.setConceptoFinancieroId(1L);
        det.setDescripcion("Artículo inválido");
        det.setArticuloId(999L);
        det.setCantidad(BigDecimal.ONE);
        det.setPrecioUnitario(new BigDecimal("100.00"));
        det.setMonto(new BigDecimal("100.00"));
        det.setCentrosCostoId(1L);
        det.setImpuestos(List.of(new DetImpuestoRequest(1L, BigDecimal.ZERO)));
        det.setFechaMov(LocalDate.now());
        det.setTipoMov("COMPRA");
        request.setDetalles(List.of(det));

        when(coreMaestrosClient.obtenerArticuloPorId(999L))
                .thenThrow(crearFeignNotFound());

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.ARTICULO_NO_ENCONTRADO);
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.NOT_FOUND);
                });
    }

    // ========================================================================
    // actualizar — estado no ACTIVO
    // ========================================================================

    @Test
    @DisplayName("actualizar() con CxP anulada -> lanza BusinessException (FIN-102)")
    void actualizar_cuandoFlagEstadoNoActivo_lanzaBusinessException() {
        CntasPagar anulada = FinanzasTestFixtures.cntasPagar(1L);
        anulada.setFlagEstado(CntasPagarFlagEstado.ANULADO);
        anulada.setDetalles(new ArrayList<>());

        CntasPagarRequest request = requestMinimo();

        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(anulada));

        assertThatThrownBy(() -> service.actualizar(1L, request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.ESTADO_INVALIDO);
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.UNPROCESSABLE_ENTITY);
                    assertThat(be.getMessage()).contains("ACTIVO");
                });

        verify(repository).findByIdWithDetalles(1L);
    }

    // ========================================================================
    // anular — contabilidadClient.anularAsiento lanza excepción
    // ========================================================================

    @Test
    @DisplayName("anular() cuando contabilidadClient falla -> lanza BusinessException (FIN-998)")
    void anular_cuandoAnularAsientoFalla_lanzaBusinessException() {
        CntasPagar cxp = FinanzasTestFixtures.cntasPagar(1L);
        cxp.setCntblAsientoId(10L);
        cxp.setSaldo(cxp.getTotal()); // saldo == total, para pasar validación
        cxp.setDetalles(new ArrayList<>());

        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(cxp));
        when(contabilidadClient.anularAsiento(10L))
                .thenThrow(new RuntimeException("Error de comunicación"));

        assertThatThrownBy(() -> service.anular(1L))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.ERROR_INTERNO);
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.INTERNAL_SERVER_ERROR);
                    assertThat(be.getMessage()).contains("asiento contable");
                });

        verify(contabilidadClient).anularAsiento(10L);
    }

    // ========================================================================
    // listar — edge cases de fechas parciales
    // ========================================================================

    @Test
    @DisplayName("listar() con solo fechaDesde (sin fechaHasta) -> retorna página")
    void listar_soloFechaDesde_retornaPagina() {
        Page<CntasPagar> page = new PageImpl<>(List.of(FinanzasTestFixtures.cntasPagar(1L)), PAGEABLE, 1);
        when(repository.findAll(any(Specification.class), eq(PAGEABLE))).thenReturn(page);

        Page<CntasPagar> result = service.listar(null, null, null,
                LocalDate.of(2026, 1, 1), null, null, null, PAGEABLE);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        verify(repository).findAll(any(Specification.class), eq(PAGEABLE));
    }

    @Test
    @DisplayName("listar() con solo fechaHasta (sin fechaDesde) -> retorna página")
    void listar_soloFechaHasta_retornaPagina() {
        Page<CntasPagar> page = new PageImpl<>(List.of(FinanzasTestFixtures.cntasPagar(1L)), PAGEABLE, 1);
        when(repository.findAll(any(Specification.class), eq(PAGEABLE))).thenReturn(page);

        Page<CntasPagar> result = service.listar(null, null, null,
                null, LocalDate.of(2026, 12, 31), null, null, PAGEABLE);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        verify(repository).findAll(any(Specification.class), eq(PAGEABLE));
    }

    @Test
    @DisplayName("listar() con solo fechaVencimientoDesde -> retorna página")
    void listar_soloFechaVencimientoDesde_retornaPagina() {
        Page<CntasPagar> page = new PageImpl<>(List.of(FinanzasTestFixtures.cntasPagar(1L)), PAGEABLE, 1);
        when(repository.findAll(any(Specification.class), eq(PAGEABLE))).thenReturn(page);

        Page<CntasPagar> result = service.listar(null, null, null,
                null, null,
                LocalDate.of(2026, 6, 1), null, PAGEABLE);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        verify(repository).findAll(any(Specification.class), eq(PAGEABLE));
    }

    @Test
    @DisplayName("listar() con solo fechaVencimientoHasta -> retorna página")
    void listar_soloFechaVencimientoHasta_retornaPagina() {
        Page<CntasPagar> page = new PageImpl<>(List.of(FinanzasTestFixtures.cntasPagar(1L)), PAGEABLE, 1);
        when(repository.findAll(any(Specification.class), eq(PAGEABLE))).thenReturn(page);

        Page<CntasPagar> result = service.listar(null, null, null,
                null, null,
                null, LocalDate.of(2026, 12, 31), PAGEABLE);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        verify(repository).findAll(any(Specification.class), eq(PAGEABLE));
    }

    @Test
    @DisplayName("listar() con estado no reconocido -> retorna sin filtro de estado")
    void listar_conEstadoNoReconocido_retornaSinFiltroEstado() {
        Page<CntasPagar> page = new PageImpl<>(List.of(FinanzasTestFixtures.cntasPagar(1L)), PAGEABLE, 1);
        when(repository.findAll(any(Specification.class), eq(PAGEABLE))).thenReturn(page);

        // "INEXISTENTE" no es ACTIVO, ANULADO, ni código 1/0 → fromFiltro retorna null
        Page<CntasPagar> result = service.listar(null, null, "INEXISTENTE",
                null, null, null, null, PAGEABLE);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        verify(repository).findAll(any(Specification.class), eq(PAGEABLE));
    }

    @Test
    @DisplayName("listar() con estado en blanco -> retorna sin filtro de estado")
    void listar_conEstadoBlanco_retornaSinFiltroEstado() {
        Page<CntasPagar> page = new PageImpl<>(List.of(FinanzasTestFixtures.cntasPagar(1L)), PAGEABLE, 1);
        when(repository.findAll(any(Specification.class), eq(PAGEABLE))).thenReturn(page);

        Page<CntasPagar> result = service.listar(null, null, "   ",
                null, null, null, null, PAGEABLE);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        verify(repository).findAll(any(Specification.class), eq(PAGEABLE));
    }

    // ========================================================================
    // generarAsientoContable — FeignException paths via crear()
    // ========================================================================

    @Test
    @DisplayName("crear() con FeignException.UnprocessableEntity -> lanza BusinessException (FIN-104)")
    void crear_cuandoContabilidadRetorna422_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        setupCrearHappyPathMocks();
        when(contabilidadClient.generarAsientoCarteraPagos(any()))
                .thenThrow(crearFeignException(422, "{\"message\":\"Asiento desbalanceado\"}"));

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.CONTABILIDAD_INVALIDA);
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.UNPROCESSABLE_ENTITY);
                    assertThat(be.getMessage()).isEqualTo("Asiento desbalanceado");
                });
    }

    @Test
    @DisplayName("crear() con FeignException.NotFound -> lanza BusinessException (FIN-902)")
    void crear_cuandoContabilidadRetorna404_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        setupCrearHappyPathMocks();
        when(contabilidadClient.generarAsientoCarteraPagos(any()))
                .thenThrow(crearFeignException(404, "{\"message\":\"Plan contable no encontrado\"}"));

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.ERROR_COMUNICACION_CONTABILIDAD);
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.NOT_FOUND);
                    assertThat(be.getMessage()).isEqualTo("Plan contable no encontrado");
                });
    }

    @Test
    @DisplayName("crear() con FeignException.BadRequest -> lanza BusinessException (FIN-902)")
    void crear_cuandoContabilidadRetorna400_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        setupCrearHappyPathMocks();
        when(contabilidadClient.generarAsientoCarteraPagos(any()))
                .thenThrow(crearFeignException(400, "{\"message\":\"Solicitud inválida\"}"));

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.ERROR_COMUNICACION_CONTABILIDAD);
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.BAD_REQUEST);
                    assertThat(be.getMessage()).isEqualTo("Solicitud inválida");
                });
    }

    @Test
    @DisplayName("crear() con FeignException genérico -> lanza BusinessException (FIN-902, 503)")
    void crear_cuandoContabilidadRetorna503_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        setupCrearHappyPathMocks();
        when(contabilidadClient.generarAsientoCarteraPagos(any()))
                .thenThrow(crearFeignException(503, "Service Unavailable"));

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.ERROR_COMUNICACION_CONTABILIDAD);
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.SERVICE_UNAVAILABLE);
                });
    }

    @Test
    @DisplayName("crear() con FeignException sin mensaje JSON -> usa mensaje por defecto")
    void crear_cuandoContabilidadErrorSinMensaje_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        setupCrearHappyPathMocks();
        when(contabilidadClient.generarAsientoCarteraPagos(any()))
                .thenThrow(crearFeignException(422, null));

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.CONTABILIDAD_INVALIDA);
                    assertThat(be.getMessage()).isEqualTo("Error de validación al crear asiento contable");
                });
    }

    // ========================================================================
    // compensarCreacionCxP — DataIntegrityViolationException paths
    // ========================================================================

    @Test
    @DisplayName("crear() con DataIntegrityViolationException (FK proveedor) -> compensa y lanza FIN-201")
    void crear_cuandoIntegridadProveedor_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        CntasPagar cxp = setupCrearHappyPathBaseMocks();

        DataIntegrityViolationException diEx = new DataIntegrityViolationException(
                "ERROR: insert or update on table finanzas.cntas_pagar violates foreign key constraint fk_cntas_pagar_proveedor");
        GenerarAsientoResponse asientoResp = new GenerarAsientoResponse();
        asientoResp.setAsientoId(999L);
        asientoResp.setVoucher("AS-999");

        when(contabilidadClient.generarAsientoCarteraPagos(any()))
                .thenReturn(ApiResponse.ok(asientoResp));
        // Primer save (crearCxPLocal) retorna ok; segundo (dentro del try) lanza DI
        when(repository.save(any(CntasPagar.class)))
                .thenReturn(cxp)
                .thenThrow(diEx);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.PROVEEDOR_NO_ENCONTRADO);
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.NOT_FOUND);
                    assertThat(be.getMessage()).isEqualTo("El proveedor especificado no existe");
                });
    }

    @Test
    @DisplayName("crear() con DataIntegrityViolationException (unique) -> compensa y lanza FIN-101")
    void crear_cuandoIntegridadUnique_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        CntasPagar cxp = setupCrearHappyPathBaseMocks();

        DataIntegrityViolationException diEx = new DataIntegrityViolationException(
                "ERROR: duplicate key value violates unique constraint cntas_pagar_proveedor_id_doc_tipo_id_serie_numero");
        GenerarAsientoResponse asientoResp = new GenerarAsientoResponse();
        asientoResp.setAsientoId(999L);
        asientoResp.setVoucher("AS-999");

        when(contabilidadClient.generarAsientoCarteraPagos(any()))
                .thenReturn(ApiResponse.ok(asientoResp));
        when(repository.save(any(CntasPagar.class)))
                .thenReturn(cxp)
                .thenThrow(diEx);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getErrorCode()).isEqualTo(FinanzasErrorCodes.DOCUMENTO_DUPLICADO);
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.CONFLICT);
                });
    }

    // ========================================================================
    // obtenerPorId — ResourceNotFoundException
    // ========================================================================

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza ResourceNotFoundException")
    void obtenerPorId_cuandoNoExiste_lanzaNotFoundException() {
        when(repository.findByIdWithDetalles(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
                .isInstanceOf(ResourceNotFoundException.class)
                .satisfies(ex -> {
                    assertThat(ex.getMessage()).contains("Cuenta por pagar");
                    assertThat(ex.getMessage()).contains("999");
                });

        verify(repository).findByIdWithDetalles(999L);
    }

    // ==== listar — filtros adicionales ====

    @Test
    @DisplayName("listar() con filtro proveedorId -> retorna página")
    void listar_conProveedorId_retornaPagina() {
        Page<CntasPagar> page = new PageImpl<>(List.of(crearCxpBasico()));
        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);

        Page<CntasPagar> result = service.listar(1L, null, null, null, null, null, null, PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("listar() con filtro docTipoId -> retorna página")
    void listar_conDocTipoId_retornaPagina() {
        Page<CntasPagar> page = new PageImpl<>(List.of(crearCxpBasico()));
        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);

        Page<CntasPagar> result = service.listar(null, 1L, null, null, null, null, null, PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("listar() con fechaDesde y fechaHasta -> retorna página")
    void listar_conFechaDesdeYHasta_retornaPagina() {
        Page<CntasPagar> page = new PageImpl<>(List.of(crearCxpBasico()));
        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);

        Page<CntasPagar> result = service.listar(null, null, null,
            LocalDate.of(2026, 5, 1), LocalDate.of(2026, 5, 31),
            null, null, PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("listar() con fechaVencimientoDesde y fechaVencimientoHasta -> retorna página")
    void listar_conFechaVencimientoDesdeYHasta_retornaPagina() {
        Page<CntasPagar> page = new PageImpl<>(List.of(crearCxpBasico()));
        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);

        Page<CntasPagar> result = service.listar(null, null, null, null, null,
            LocalDate.of(2026, 6, 1), LocalDate.of(2026, 6, 30),
            PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }


    // ==== anular — validaciones ====

    @Test
    @DisplayName("anular() con saldo != total (pagos aplicados) -> lanza BusinessException")
    void anular_cuandoSaldoDiferenteTotal_lanzaBusinessException() {
        CntasPagar cxp = crearCxpBasico();
        cxp.setSaldo(new BigDecimal("500.00"));

        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(cxp));

        assertThatThrownBy(() -> service.anular(1L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("No se puede anular una cuenta por pagar con pagos aplicados");
    }

    @Test
    @DisplayName("anular() con cntblAsientoId null -> no intenta anular asiento")
    void anular_cuandoSinAsientoContable_noIntentaAnular() {
        CntasPagar cxp = crearCxpBasico();
        cxp.setCntblAsientoId(null);
        cxp.setSaldo(new BigDecimal("1000.00"));

        CntasPagar cxpAnulada = crearCxpBasico();
        cxpAnulada.setCntblAsientoId(null);
        cxpAnulada.setSaldo(new BigDecimal("1000.00"));
        cxpAnulada.setFlagEstado(CntasPagarFlagEstado.ANULADO);

        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(cxp), Optional.of(cxpAnulada));
        when(repository.save(any())).thenReturn(cxpAnulada);

        CntasPagar result = service.anular(1L);

        assertThat(result).isNotNull();
        verify(contabilidadClient, never()).anularAsiento(any());
    }


    // ==== compensarCreacionCxP — variantes FK ====

    @Test
    @DisplayName("crear() con DataIntegrityViolationException (FK doc_tipo) -> compensa y lanza FIN-202")
    void crear_cuandoIntegridadDocTipo_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(anyLong(), anyLong(), any(), any()))
            .thenReturn(false);
        CntasPagar cxp = setupCrearHappyPathBaseMocks();
        when(repository.save(any(CntasPagar.class))).thenReturn(cxp);
        when(contabilidadClient.generarAsientoCarteraPagos(any()))
            .thenThrow(new DataIntegrityViolationException("viola foreign key constraint fk_cntas_pagar_doc_tipo"));

        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("El tipo de documento especificado no existe");
    }

    @Test
    @DisplayName("crear() con DataIntegrityViolationException (FK moneda) -> compensa y lanza FIN-005")
    void crear_cuandoIntegridadMoneda_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(anyLong(), anyLong(), any(), any()))
            .thenReturn(false);
        CntasPagar cxp = setupCrearHappyPathBaseMocks();
        when(repository.save(any(CntasPagar.class))).thenReturn(cxp);
        when(contabilidadClient.generarAsientoCarteraPagos(any()))
            .thenThrow(new DataIntegrityViolationException("viola foreign key constraint fk_moneda"));

        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("La moneda especificada no existe");
    }

    @Test
    @DisplayName("crear() con DataIntegrityViolationException (FK articulo) -> compensa y lanza FIN-203")
    void crear_cuandoIntegridadArticulo_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(anyLong(), anyLong(), any(), any()))
            .thenReturn(false);
        CntasPagar cxp = setupCrearHappyPathBaseMocks();
        when(repository.save(any(CntasPagar.class))).thenReturn(cxp);
        when(contabilidadClient.generarAsientoCarteraPagos(any()))
            .thenThrow(new DataIntegrityViolationException("viola foreign key constraint fk_articulo"));

        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("El artículo especificado no existe");
    }

    @Test
    @DisplayName("crear() con DataIntegrityViolationException (FK generico) -> compensa y lanza mensaje original")
    void crear_cuandoIntegridadFkGenerica_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(anyLong(), anyLong(), any(), any()))
            .thenReturn(false);
        CntasPagar cxp = setupCrearHappyPathBaseMocks();
        when(repository.save(any(CntasPagar.class))).thenReturn(cxp);
        when(contabilidadClient.generarAsientoCarteraPagos(any()))
            .thenThrow(new DataIntegrityViolationException("viola foreign key constraint fk_unknown_table"));

        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Error de referencia");
    }

    @Test
    @DisplayName("crear() con DataIntegrityViolationException generica sin FK -> compensa y lanza mensaje error interno")
    void crear_cuandoIntegridadGenerica_lanzaBusinessException() {
        CntasPagarRequest request = requestMinimo();
        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(anyLong(), anyLong(), any(), any()))
            .thenReturn(false);
        CntasPagar cxp = setupCrearHappyPathBaseMocks();
        when(repository.save(any(CntasPagar.class))).thenReturn(cxp);
        when(contabilidadClient.generarAsientoCarteraPagos(any()))
            .thenThrow(new DataIntegrityViolationException("error interno en base de datos"));

        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Error al crear la cuenta por pagar");
    }


    // ========================================================================
    // Métodos auxiliares para construir datos de prueba
    // ========================================================================

    /**
     * Request mínimo para pruebas de validación.
     */
    private CntasPagarRequest requestMinimo() {
        CntasPagarRequest request = new CntasPagarRequest();
        request.setProveedorId(1L);
        request.setDocTipoId(1L);
        request.setSerie("F001");
        request.setNumero("00001");
        request.setFechaEmision(LocalDate.of(2026, 5, 1));
        request.setFechaVencimiento(LocalDate.of(2026, 6, 1));
        request.setMonedaId(1L);
        request.setTotal(new BigDecimal("1000.00"));
        request.setAno(2026);
        request.setMes(5);
        request.setCntblLibroId(1L);

        CntasPagarDetRequest det = new CntasPagarDetRequest();
        det.setItem(1);
        det.setConceptoFinancieroId(1L);
        det.setDescripcion("Detalle de prueba");
        det.setCantidad(BigDecimal.ONE);
        det.setPrecioUnitario(new BigDecimal("1000.00"));
        det.setMonto(new BigDecimal("1000.00"));
        det.setCentrosCostoId(1L);
        det.setImpuestos(List.of(new DetImpuestoRequest(1L, BigDecimal.ZERO)));
        det.setFechaMov(LocalDate.now());
        det.setTipoMov("COMPRA");
        request.setDetalles(List.of(det));

        return request;
    }

    /**
     * Configura mocks para que crear() pase validaciones, crearCxPLocal y
     * prepararGenerarAsientoRequest.
     */
    private void setupCrearHappyPathMocks() {
        CntasPagar cxp = crearCxpBasico();
        CntasPagarDet detalle = crearDetalleBasico(cxp);

        when(mapper.toEntity(any(CntasPagarRequest.class))).thenReturn(cxp);
        when(repository.save(any(CntasPagar.class))).thenReturn(cxp);
        when(detalleMapper.toEntity(any(CntasPagarDetRequest.class))).thenReturn(detalle);
        when(detalleRepository.save(any(CntasPagarDet.class))).thenReturn(detalle);
    }

    /**
     * Configura mocks base (mapper + detalle) y retorna el CntasPagar.
     * El llamador debe configurar repository.save() y contabilidadClient según necesite.
     */
    private CntasPagar setupCrearHappyPathBaseMocks() {
        CntasPagar cxp = crearCxpBasico();
        CntasPagarDet detalle = crearDetalleBasico(cxp);

        when(mapper.toEntity(any(CntasPagarRequest.class))).thenReturn(cxp);
        when(detalleMapper.toEntity(any(CntasPagarDetRequest.class))).thenReturn(detalle);
        when(detalleRepository.save(any(CntasPagarDet.class))).thenReturn(detalle);

        return cxp;
    }

    private CntasPagar crearCxpBasico() {
        CntasPagar cxp = new CntasPagar();
        cxp.setId(1L);
        cxp.setSucursalId(1L);
        cxp.setProveedorId(1L);
        cxp.setDocTipoId(1L);
        cxp.setSerie("F001");
        cxp.setNumero("00001");
        cxp.setFechaEmision(LocalDate.of(2026, 5, 1));
        cxp.setFechaVencimiento(LocalDate.of(2026, 6, 1));
        cxp.setMonedaId(1L);
        cxp.setTotal(new BigDecimal("1000.00"));
        cxp.setSaldo(new BigDecimal("1000.00"));
        cxp.setAno(2026);
        cxp.setMes(5);
        cxp.setCntblLibroId(1L);
        cxp.setFlagEstado(CntasPagarFlagEstado.ACTIVO);
        cxp.setDetalles(new ArrayList<>());
        return cxp;
    }

    private CntasPagarDet crearDetalleBasico(CntasPagar cxp) {
        CntasPagarDet detalle = new CntasPagarDet();
        detalle.setId(100L);
        detalle.setCntasPagar(cxp);
        detalle.setItem(1);
        detalle.setConceptoFinancieroId(1L);
        detalle.setDescripcion("Detalle");
        detalle.setCantidad(BigDecimal.ONE);
        detalle.setPrecioUnitario(new BigDecimal("1000.00"));
        detalle.setMonto(new BigDecimal("1000.00"));
        detalle.setTipoMov("COMPRA");
        detalle.setCentrosCostoId(1L);
        detalle.setFechaMov(LocalDate.now());
        return detalle;
    }

    /**
     * Crea un FeignException.NotFound real para validaciones.
     * Usa el constructor real para evitar mocking de métodos final.
     */
    private static FeignException.NotFound crearFeignNotFound() {
        return new FeignException.NotFound(
                "Not Found",
                crearRequestVacio(),
                new byte[0],
                Collections.emptyMap());
    }

    /**
     * Crea un FeignException real con el body indicado.
     * contentUTF8() es final en FeignException — usar constructores reales con Request body.
     */
    private static FeignException crearFeignException(int status, String body) {
        byte[] bodyBytes = body != null ? body.getBytes(StandardCharsets.UTF_8) : new byte[0];
        Request request = Request.create(
                Request.HttpMethod.POST,
                "http://localhost/api/contabilidad/asientos/generar/cartera-pagos",
                Collections.emptyMap(),
                bodyBytes,
                StandardCharsets.UTF_8,
                null);

        return switch (status) {
            case 422 -> new FeignException.UnprocessableEntity("Unprocessable Entity", request, bodyBytes, Collections.emptyMap());
            case 404 -> new FeignException.NotFound("Not Found", request, bodyBytes, Collections.emptyMap());
            case 400 -> new FeignException.BadRequest("Bad Request", request, bodyBytes, Collections.emptyMap());
            // Generic FeignException: use InternalServerError as public subclass, caught by generic catch
            default -> new FeignException.InternalServerError("Internal Server Error", request, bodyBytes, Collections.emptyMap());
        };
    }

    private static Request crearRequestVacio() {
        return Request.create(
                Request.HttpMethod.GET,
                "http://localhost",
                Collections.emptyMap(),
                new byte[0],
                StandardCharsets.UTF_8,
                null);
    }
}
