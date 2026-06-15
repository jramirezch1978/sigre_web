package com.sigre.finanzas.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
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
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.finanzas.client.ContabilidadClient;
import com.sigre.finanzas.client.CoreMaestrosClient;
import com.sigre.finanzas.dto.request.DocumentoDirectoDetalleRequest;
import com.sigre.finanzas.dto.request.DocumentoDirectoRequest;
import com.sigre.finanzas.dto.response.DocumentoDirectoResponse;
import com.sigre.finanzas.entity.CntasPagar;
import com.sigre.finanzas.entity.CntasPagarDet;
import com.sigre.finanzas.mapper.DocumentoDirectoDetalleMapper;
import com.sigre.finanzas.mapper.DocumentoDirectoMapper;
import com.sigre.finanzas.repository.CntasPagarDetRepository;
import com.sigre.finanzas.repository.CntasPagarRepository;
import com.sigre.finanzas.service.CntasPagarDetImpService;
import com.sigre.finanzas.service.support.CntasPagarCabeceraValidator;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.mockito.Mockito.lenient;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - DocumentoDirectoServiceImpl")
class DocumentoDirectoServiceImplTest {

    @Mock private CntasPagarRepository repository;
    @Mock private CntasPagarDetRepository detalleRepository;
    @Mock private DocumentoDirectoMapper mapper;
    @Mock private DocumentoDirectoDetalleMapper detalleMapper;
    @Mock private ContabilidadClient contabilidadClient;
    @Mock private CoreMaestrosClient coreMaestrosClient;
    @Mock private CntasPagarCabeceraValidator cabeceraValidator;
    @Mock private CntasPagarDetImpService detImpService;

    @InjectMocks
    private DocumentoDirectoServiceImpl service;

    private CntasPagar cxp;
    private DocumentoDirectoResponse response;

    @BeforeEach
    void setUp() {
        cxp = new CntasPagar();
        cxp.setId(1L);
        cxp.setProveedorId(1L);
        cxp.setDocTipoId(1L);
        cxp.setSerie("D001");
        cxp.setNumero("00000001");
        cxp.setTotal(new BigDecimal("1500.00"));
        cxp.setSaldo(new BigDecimal("1500.00"));
        cxp.setFlagEstado("1");
        cxp.setDetalles(new ArrayList<>());

        response = new DocumentoDirectoResponse();
        response.setId(1L);
        response.setFlagEstado("1");

        // Default Feign client mocks (se usan en validarRequest)
        lenient().when(coreMaestrosClient.obtenerEntidadPorId(anyLong()))
                .thenReturn((ApiResponse) ApiResponse.ok(new Object()));
        lenient().when(coreMaestrosClient.obtenerDocTipoPorId(anyLong()))
                .thenReturn((ApiResponse) ApiResponse.ok(new Object()));
        lenient().when(coreMaestrosClient.obtenerMonedaPorId(anyLong()))
                .thenReturn((ApiResponse) ApiResponse.ok(new Object()));
        lenient().doNothing().when(cabeceraValidator).validar(any(), any(), any());
        lenient().doNothing().when(detImpService).guardarImpuestos(any(), any());
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }


    // ==== listar — otros ====

    @Test
    @DisplayName("listar - Debe retornar página de documentos directos")
    void listar_DebeRetornarPagina() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<CntasPagar> page = new PageImpl<>(List.of(cxp), pageable, 1);
        when(repository.findDocumentosDirectos(pageable)).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<DocumentoDirectoResponse> result = service.listarDirectos(pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }


    // ==== obtenerPorId — otros ====

    @Test
    @DisplayName("obtenerPorId - Debe retornar documento directo")
    void obtenerPorId_DebeRetornarDocumento() {
        when(repository.findDocumentoDirectoById(1L)).thenReturn(Optional.of(cxp));
        when(mapper.toResponse(cxp)).thenReturn(response);

        DocumentoDirectoResponse result = service.obtenerDirectoPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("obtenerPorId - Debe lanzar excepción si no existe")
    void obtenerPorId_NoExiste_DebeLanzarExcepcion() {
        when(repository.findDocumentoDirectoById(999L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.obtenerDirectoPorId(999L)).isInstanceOf(ResourceNotFoundException.class);
    }


    // ==== anular — otros ====

    @Test
    @DisplayName("anular - Debe anular documento directo")
    void anular_DebeAnularDocumento() {
        when(repository.findDocumentoDirectoById(1L)).thenReturn(Optional.of(cxp));
        when(repository.save(any())).thenReturn(cxp);
        lenient().when(mapper.toResponse(cxp)).thenReturn(response);

        DocumentoDirectoResponse result = service.anularDirecto(1L);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }


    // ==== crearDirecto — escenarios felices ====

    @Test
    @DisplayName("crearDirecto - Debe crear documento directo")
    void crearDirecto_DebeCrearDocumento() {
        TenantContext.setSucursalId(1L);
        TenantContext.setUsuarioId(1L);

        DocumentoDirectoRequest request = new DocumentoDirectoRequest();
        request.setProveedorId(1L);
        request.setDocTipoId(1L);
        request.setSerie("D001");
        request.setNumero("99999999");
        request.setMonedaId(1L);
        request.setTotal(new BigDecimal("1500.00"));
        request.setFechaEmision(java.time.LocalDate.now());

        DocumentoDirectoDetalleRequest detalle = new DocumentoDirectoDetalleRequest();
        detalle.setMonto(new BigDecimal("1500.00"));
        detalle.setTipoMov("DIRECTO");
        request.setDetalles(List.of(detalle));

        when(mapper.toEntity(any(DocumentoDirectoRequest.class), anyLong())).thenReturn(cxp);
        when(repository.save(any(CntasPagar.class))).thenReturn(cxp);
        when(detalleMapper.toEntity(any(DocumentoDirectoDetalleRequest.class), anyLong())).thenReturn(new CntasPagarDet());
        when(mapper.toResponse(cxp)).thenReturn(response);

        DocumentoDirectoResponse result = service.crearDirecto(request);

        assertThat(result).isNotNull();
        verify(repository, atLeastOnce()).save(any());
    }


    // ==== anular — edge cases ====

    @Test
    @DisplayName("anular() con documento inactivo -> lanza BusinessException")
    void anular_noActivo_lanzaBusinessException() {
        cxp.setFlagEstado("0");
        when(repository.findDocumentoDirectoById(1L)).thenReturn(Optional.of(cxp));

        assertThatThrownBy(() -> service.anularDirecto(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Solo se pueden anular documentos activos");

        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("anular() con ID inexistente -> lanza ResourceNotFoundException")
    void anular_noExiste_lanzaResourceNotFoundException() {
        when(repository.findDocumentoDirectoById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.anularDirecto(999L))
                .isInstanceOf(ResourceNotFoundException.class);

        verify(repository, never()).save(any());
    }


    // ==== crearDirecto — errores de validación ====

    @Test
    @DisplayName("crearDirecto() con proveedor inexistente -> lanza BusinessException")
    void crearDirecto_proveedorNoExiste_lanzaBusinessException() {
        TenantContext.setSucursalId(1L);

        DocumentoDirectoRequest request = buildRequestMinimo();
        request.setProveedorId(99L);

        lenient().when(coreMaestrosClient.obtenerEntidadPorId(99L))
                .thenThrow(new RuntimeException("Proveedor no encontrado"));

        assertThatThrownBy(() -> service.crearDirecto(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("El proveedor especificado no existe");

        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("crearDirecto() con tipo de documento inexistente -> lanza BusinessException")
    void crearDirecto_docTipoNoExiste_lanzaBusinessException() {
        TenantContext.setSucursalId(1L);

        DocumentoDirectoRequest request = buildRequestMinimo();
        request.setDocTipoId(99L);

        lenient().when(coreMaestrosClient.obtenerDocTipoPorId(99L))
                .thenThrow(new RuntimeException("Tipo doc no encontrado"));

        assertThatThrownBy(() -> service.crearDirecto(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("El tipo de documento especificado no existe");

        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("crearDirecto() con moneda inexistente -> lanza BusinessException")
    void crearDirecto_monedaNoExiste_lanzaBusinessException() {
        TenantContext.setSucursalId(1L);

        DocumentoDirectoRequest request = buildRequestMinimo();
        request.setMonedaId(99L);

        lenient().when(coreMaestrosClient.obtenerMonedaPorId(99L))
                .thenThrow(new RuntimeException("Moneda no encontrada"));

        assertThatThrownBy(() -> service.crearDirecto(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("La moneda especificada no existe");

        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("crearDirecto() con fecha de vencimiento anterior a emisión -> lanza BusinessException")
    void crearDirecto_fechaVencimientoAntesDeFechaEmision_lanzaBusinessException() {
        TenantContext.setSucursalId(1L);

        DocumentoDirectoRequest request = buildRequestMinimo();
        request.setFechaEmision(LocalDate.now());
        request.setFechaVencimiento(LocalDate.now().minusDays(1));

        assertThatThrownBy(() -> service.crearDirecto(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("La fecha de vencimiento no puede ser anterior a la fecha de emisión");

        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("crearDirecto() con detalle no DIRECTO -> lanza BusinessException")
    void crearDirecto_detalleNoDirecto_lanzaBusinessException() {
        TenantContext.setSucursalId(1L);

        DocumentoDirectoRequest request = buildRequestMinimo();
        DocumentoDirectoDetalleRequest detalleNoDirecto = new DocumentoDirectoDetalleRequest();
        detalleNoDirecto.setMonto(new BigDecimal("1500.00"));
        detalleNoDirecto.setTipoMov("CANJE");
        request.setDetalles(List.of(detalleNoDirecto));

        assertThatThrownBy(() -> service.crearDirecto(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Todos los detalles deben ser de tipo DIRECTO");

        verify(repository, never()).save(any());
    }


    // ==== actualizarDirecto — escenarios felices ====

    @Test
    @DisplayName("actualizarDirecto() con documento activo y detalles DIRECTO -> retorna actualizado")
    void actualizarDirecto_existeYActivo_retornaActualizado() {
        TenantContext.setSucursalId(1L);

        CntasPagar cxpExistente = new CntasPagar();
        cxpExistente.setId(1L);
        cxpExistente.setFlagEstado("1");
        cxpExistente.setCreatedBy(1L);
        cxpExistente.setFecCreacion(Instant.now());
        cxpExistente.setDetalles(new ArrayList<>());

        DocumentoDirectoRequest request = buildRequestMinimo();

        CntasPagar cxpActualizado = new CntasPagar();

        when(repository.findDocumentoDirectoById(1L)).thenReturn(Optional.of(cxpExistente));
        when(mapper.toEntity(any(DocumentoDirectoRequest.class), anyLong())).thenReturn(cxpActualizado);
        when(detalleMapper.toEntity(any(DocumentoDirectoDetalleRequest.class), anyLong()))
                .thenReturn(new CntasPagarDet());
        when(repository.save(any(CntasPagar.class))).thenReturn(cxpActualizado);
        when(mapper.toResponse(cxpActualizado)).thenReturn(response);

        DocumentoDirectoResponse result = service.actualizarDirecto(1L, request);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository).save(any(CntasPagar.class));
    }


    // ==== actualizarDirecto — edge cases ====

    @Test
    @DisplayName("actualizarDirecto() con ID inexistente -> lanza ResourceNotFoundException")
    void actualizarDirecto_noExiste_lanzaResourceNotFoundException() {
        DocumentoDirectoRequest request = buildRequestMinimo();

        when(repository.findDocumentoDirectoById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizarDirecto(999L, request))
                .isInstanceOf(ResourceNotFoundException.class);

        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("actualizarDirecto() con documento inactivo -> lanza BusinessException")
    void actualizarDirecto_noActivo_lanzaBusinessException() {
        DocumentoDirectoRequest request = buildRequestMinimo();

        CntasPagar cxpInactivo = new CntasPagar();
        cxpInactivo.setId(1L);
        cxpInactivo.setFlagEstado("0");
        cxpInactivo.setDetalles(new ArrayList<>());

        when(repository.findDocumentoDirectoById(1L)).thenReturn(Optional.of(cxpInactivo));

        assertThatThrownBy(() -> service.actualizarDirecto(1L, request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Solo se pueden modificar documentos activos");

        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("actualizarDirecto() con movimientos no DIRECTO -> lanza BusinessException")
    void actualizarDirecto_conMovimientosNoDirectos_lanzaBusinessException() {
        DocumentoDirectoRequest request = buildRequestMinimo();

        CntasPagarDet detalleNoDirecto = new CntasPagarDet();
        detalleNoDirecto.setTipoMov("CANJE");

        CntasPagar cxpConMovNoDirecto = new CntasPagar();
        cxpConMovNoDirecto.setId(1L);
        cxpConMovNoDirecto.setFlagEstado("1");
        cxpConMovNoDirecto.setDetalles(new ArrayList<>());
        cxpConMovNoDirecto.getDetalles().add(detalleNoDirecto);

        when(repository.findDocumentoDirectoById(1L)).thenReturn(Optional.of(cxpConMovNoDirecto));

        assertThatThrownBy(() -> service.actualizarDirecto(1L, request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No se puede modificar: documento tiene movimientos posteriores");

        verify(repository, never()).save(any());
    }


    // ==== helpers ====

    private DocumentoDirectoRequest buildRequestMinimo() {
        DocumentoDirectoRequest request = new DocumentoDirectoRequest();
        request.setProveedorId(1L);
        request.setDocTipoId(1L);
        request.setSerie("D001");
        request.setNumero("00000001");
        request.setMonedaId(1L);
        request.setTotal(new BigDecimal("1500.00"));
        request.setFechaEmision(LocalDate.now());
        request.setAno(LocalDate.now().getYear());
        request.setMes(LocalDate.now().getMonthValue());
        request.setCntblLibroId(1L);

        DocumentoDirectoDetalleRequest detalle = new DocumentoDirectoDetalleRequest();
        detalle.setMonto(new BigDecimal("1500.00"));
        detalle.setTipoMov("DIRECTO");
        request.setDetalles(List.of(detalle));

        return request;
    }
}
