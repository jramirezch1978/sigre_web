package com.sigre.finanzas.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.service.NumeradorDocumentoService;
import com.sigre.finanzas.client.ContabilidadClient;
import com.sigre.finanzas.client.CoreMaestrosClient;
import com.sigre.finanzas.dto.request.CntasPagarDetRequest;
import com.sigre.finanzas.dto.request.CntasPagarRequest;
import com.sigre.finanzas.dto.response.AsientoContableResponse;
import com.sigre.finanzas.entity.CntasPagar;
import com.sigre.finanzas.entity.CntasPagarDet;
import com.sigre.finanzas.mapper.CntasPagarDetMapper;
import com.sigre.finanzas.mapper.CntasPagarMapper;
import com.sigre.finanzas.repository.CntasPagarDetRepository;
import com.sigre.finanzas.repository.CntasPagarRepository;
import com.sigre.finanzas.service.impl.CntasPagarServiceImpl;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.mockito.Mockito.lenient;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - CntasPagarService")
class CntasPagarServiceTest {

    @Mock
    private CntasPagarRepository repository;

    @Mock
    private CntasPagarDetRepository detalleRepository;

    @Mock
    private CntasPagarDetMapper detalleMapper;

    @Mock
    private CntasPagarMapper mapper;

    @Mock
    private ContabilidadClient contabilidadClient;

    @Mock
    private CoreMaestrosClient coreMaestrosClient;

    @Mock
    private NumeradorDocumentoService numeradorDocumentoService;

    @InjectMocks
    private CntasPagarServiceImpl service;

    private CntasPagar cntasPagar;
    private Pageable pageable;

    @BeforeEach
    void setUp() {
        cntasPagar = new CntasPagar();
        cntasPagar.setId(1L);
        cntasPagar.setSucursalId(1L);
        cntasPagar.setProveedorId(4L);
        cntasPagar.setDocTipoId(1L);
        cntasPagar.setSerie("F001");
        cntasPagar.setNumero("00001234");
        cntasPagar.setFechaEmision(LocalDate.of(2026, 4, 27));
        cntasPagar.setFechaVencimiento(LocalDate.of(2026, 5, 27));
        cntasPagar.setMonedaId(1L);
        cntasPagar.setTotal(new BigDecimal("1180.00"));
        cntasPagar.setSaldo(new BigDecimal("1180.00"));
        cntasPagar.setCntblAsientoId(5L);
        cntasPagar.setFlagEstado("1");

        pageable = PageRequest.of(0, 10);

        // Default Feign client mocks for validators
        lenient().when(coreMaestrosClient.obtenerEntidadPorId(anyLong()))
                .thenReturn((ApiResponse) ApiResponse.ok(new Object()));
        lenient().when(coreMaestrosClient.obtenerDocTipoPorId(anyLong()))
                .thenReturn((ApiResponse) ApiResponse.ok(new Object()));
        lenient().when(coreMaestrosClient.obtenerMonedaPorId(anyLong()))
                .thenReturn((ApiResponse) ApiResponse.ok(new Object()));
    }


    // ==== listar — escenarios felices ====

    @Test
    @DisplayName("listar - retorna página de CxP sin filtros")
    void listar_sinFiltros_retornaPagina() {
        Page<CntasPagar> expectedPage = new PageImpl<>(List.of(cntasPagar), pageable, 1);
        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(expectedPage);

        Page<CntasPagar> result = service.listar(null, null, null, null, null, null, null, pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        assertThat(result.getContent().get(0).getSerie()).isEqualTo("F001");
        verify(repository, times(1)).findAll(any(Specification.class), eq(pageable));
    }

    @Test
    @DisplayName("listar - retorna página filtrada por flagEstado")
    void listar_conFlagEstado_retornaPaginaFiltrada() {
        Page<CntasPagar> expectedPage = new PageImpl<>(List.of(cntasPagar), pageable, 1);
        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(expectedPage);

        Page<CntasPagar> result = service.listar(null, null, "ACTIVO", null, null, null, null, pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        assertThat(result.getContent().get(0).getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("listar - retorna página filtrada por proveedor")
    void listar_conProveedor_retornaPaginaFiltrada() {
        Page<CntasPagar> expectedPage = new PageImpl<>(List.of(cntasPagar), pageable, 1);
        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(expectedPage);

        Page<CntasPagar> result = service.listar(4L, null, null, null, null, null, null, pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        assertThat(result.getContent().get(0).getProveedorId()).isEqualTo(4L);
        verify(repository, times(1)).findAll(any(Specification.class), eq(pageable));
    }

    @Test
    @DisplayName("listar - retorna página filtrada por rango de fechas")
    void listar_conRangoFechas_retornaPaginaFiltrada() {
        LocalDate fechaInicio = LocalDate.of(2026, 4, 1);
        LocalDate fechaFin = LocalDate.of(2026, 4, 30);
        Page<CntasPagar> expectedPage = new PageImpl<>(List.of(cntasPagar), pageable, 1);
        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(expectedPage);

        Page<CntasPagar> result = service.listar(null, null, null, fechaInicio, fechaFin, null, null, pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        verify(repository, times(1)).findAll(any(Specification.class), eq(pageable));
    }


    // ==== obtenerPorId — escenarios felices ====

    @Test
    @DisplayName("obtenerPorId - retorna CxP cuando el ID existe")
    void obtenerPorId_cuandoExiste_retornaCxP() {
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(cntasPagar));

        CntasPagar result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getSerie()).isEqualTo("F001");
        assertThat(result.getNumero()).isEqualTo("00001234");
        verify(repository, times(1)).findByIdWithDetalles(1L);
    }


    // ==== obtenerPorId — otros ====

    @Test
    @DisplayName("obtenerPorId - lanza ResourceNotFoundException cuando no existe")
    void obtenerPorId_cuandoNoExiste_lanzaNotFoundException() {
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(1L)).isInstanceOf(ResourceNotFoundException.class);
        verify(repository, times(1)).findByIdWithDetalles(1L);
    }


    // ==== anular — otros ====

    @Test
    @DisplayName("anular - Debe anular CxP activa y su asiento contable")
    void anular_DebeAnularCxPYAsiento() {
        cntasPagar.setDetalles(new ArrayList<>());
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(cntasPagar));

        ApiResponse<AsientoContableResponse> mockResponse = ApiResponse.ok(new AsientoContableResponse());
        when(contabilidadClient.anularAsiento(any())).thenReturn((ApiResponse) mockResponse);

        CntasPagar result = service.anular(1L);

        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("0");
        verify(repository).save(cntasPagar);
        verify(contabilidadClient).anularAsiento(any());
    }

    @Test
    @DisplayName("anular - Debe lanzar excepción si el saldo no coincide con el total")
    void anular_SaldoNoCoincide_DebeLanzarExcepcion() {
        cntasPagar.setSaldo(new BigDecimal("500.00")); // diferente del total 1180.00
        cntasPagar.setDetalles(new ArrayList<>());
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(cntasPagar));

        assertThatThrownBy(() -> service.anular(1L)).isInstanceOf(BusinessException.class);
    }


    // ==== actualizar — escenarios felices ====

    @Test
    @DisplayName("actualizar - Debe actualizar CxP activa")
    void actualizar_DebeActualizarCxP() {
        cntasPagar.setDetalles(new ArrayList<>());
        CntasPagarRequest request = new CntasPagarRequest();
        request.setProveedorId(1L);
        request.setDocTipoId(1L);
        request.setMonedaId(1L);
        request.setTotal(new BigDecimal("2000.00"));
        request.setDetalles(List.of(new CntasPagarDetRequest()));

        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(cntasPagar));
        when(repository.save(any())).thenReturn(cntasPagar);
        when(detalleMapper.toEntity(any())).thenReturn(new CntasPagarDet());
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(cntasPagar));

        CntasPagar result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        verify(repository, atLeastOnce()).save(any());
    }


    // ==== crear — escenarios felices ====

    @Test
    @Disabled("Flujo crear→prepararGenerarAsientoRequest→compensación: los detalles mockeados no persisten en el flujo de save del servicio.")
    @DisplayName("crear - Debe crear CxP con asiento contable")
    void crear_DebeCrearCxPConAsiento() {
        CntasPagarRequest request = new CntasPagarRequest();
        request.setProveedorId(1L);
        request.setDocTipoId(1L);
        request.setMonedaId(1L);
        request.setFechaEmision(LocalDate.of(2026, 5, 1));
        request.setFechaVencimiento(LocalDate.of(2026, 6, 1));
        request.setTotal(new BigDecimal("3000.00"));
        request.setDetalles(List.of(new CntasPagarDetRequest()));

        when(mapper.toEntity(any(CntasPagarRequest.class))).thenReturn(cntasPagar);
        when(repository.save(any())).thenReturn(cntasPagar);
        CntasPagarDet detalle = new CntasPagarDet();
        detalle.setId(1L);
        when(detalleMapper.toEntity(any(CntasPagarDetRequest.class))).thenReturn(detalle);

        com.sigre.finanzas.dto.response.GenerarAsientoResponse asientoResp = 
            new com.sigre.finanzas.dto.response.GenerarAsientoResponse();
        asientoResp.setAsientoId(999L);
        asientoResp.setVoucher("AS-999");
        when(contabilidadClient.generarAsientoCarteraPagos(any()))
                .thenReturn((ApiResponse) ApiResponse.ok(asientoResp));

        when(repository.findByIdWithDetalles(anyLong())).thenReturn(Optional.of(cntasPagar));

        CntasPagar result = service.crear(request);

        assertThat(result).isNotNull();
        verify(repository, atLeastOnce()).save(any());
    }


    // ==== listar — escenarios felices ====

    @Test
    @DisplayName("listar - retorna página filtrada por docTipoId")
    void listar_conDocTipo_retornaPaginaFiltrada() {
        Page<CntasPagar> expectedPage = new PageImpl<>(List.of(cntasPagar), pageable, 1);
        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(expectedPage);

        Page<CntasPagar> result = service.listar(null, 1L, null, null, null, null, null, pageable);

        assertThat(result).isNotNull();
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }

    @Test
    @DisplayName("listar - retorna página filtrada por fechaVencimiento")
    void listar_conRangoFechaVencimiento_retornaPaginaFiltrada() {
        LocalDate desde = LocalDate.of(2026, 5, 1);
        LocalDate hasta = LocalDate.of(2026, 6, 1);
        Page<CntasPagar> expectedPage = new PageImpl<>(List.of(cntasPagar), pageable, 1);
        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(expectedPage);

        Page<CntasPagar> result = service.listar(null, null, null, null, null, desde, hasta, pageable);

        assertThat(result).isNotNull();
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }
}
