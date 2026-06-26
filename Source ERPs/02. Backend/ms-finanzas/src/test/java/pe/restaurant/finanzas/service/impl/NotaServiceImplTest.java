package pe.restaurant.finanzas.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import org.junit.jupiter.api.AfterEach;
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
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.finanzas.client.ContabilidadClient;
import pe.restaurant.finanzas.client.CoreMaestrosClient;
import pe.restaurant.finanzas.dto.request.NotaDetalleRequest;
import pe.restaurant.finanzas.dto.request.DetImpuestoRequest;
import pe.restaurant.finanzas.dto.request.NotaRequest;
import pe.restaurant.finanzas.dto.response.AsientoContableResponse;
import pe.restaurant.finanzas.dto.response.GenerarAsientoResponse;
import pe.restaurant.finanzas.dto.response.NotaResponse;
import pe.restaurant.finanzas.entity.CntasPagar;
import pe.restaurant.finanzas.entity.CntasPagarDet;
import pe.restaurant.finanzas.enums.TipoNota;
import pe.restaurant.finanzas.mapper.NotaDetalleMapper;
import pe.restaurant.finanzas.mapper.NotaMapper;
import pe.restaurant.finanzas.repository.CntasPagarRepository;
import pe.restaurant.finanzas.service.CntasPagarDetImpService;
import pe.restaurant.finanzas.service.support.CntasPagarCabeceraValidator;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - NotaServiceImpl")
class NotaServiceImplTest {

    @Mock
    private CntasPagarRepository repository;

    @Mock
    private NotaMapper mapper;

    @Mock
    private NotaDetalleMapper detalleMapper;

    @Mock
    private ContabilidadClient contabilidadClient;

    @Mock
    private CoreMaestrosClient coreMaestrosClient;

    @Mock
    private CntasPagarDetImpService detImpService;

    @Mock
    private CntasPagarCabeceraValidator cabeceraValidator;

    @InjectMocks
    private NotaServiceImpl service;

    private CntasPagar cxp;
    private NotaResponse notaResponse;

    @BeforeEach
    void setUp() {
        cxp = new CntasPagar();
        cxp.setId(1L);
        cxp.setTotal(new BigDecimal("1180.00"));
        cxp.setSaldo(new BigDecimal("1180.00"));
        cxp.setFlagEstado("1");
        cxp.setDetalles(new ArrayList<>());

        notaResponse = new NotaResponse();
        notaResponse.setId(1L);
        notaResponse.setFlagEstado("1");

        // Stubs compartidos (lenient para evitar UnnecessaryStubbingException)
        lenient().when(coreMaestrosClient.obtenerEntidadPorId(anyLong()))
                .thenReturn(pe.restaurant.finanzas.FinanzasTestFixtures.mockEntidadResponse());
        lenient().when(coreMaestrosClient.obtenerDocTipoPorId(anyLong()))
                .thenReturn(pe.restaurant.finanzas.FinanzasTestFixtures.mockDocTipoResponse());
        lenient().when(coreMaestrosClient.obtenerMonedaPorId(anyLong()))
                .thenReturn(pe.restaurant.finanzas.FinanzasTestFixtures.mockMonedaResponse());
        lenient().doNothing().when(cabeceraValidator).validar(any(), any(), any());
        lenient().doNothing().when(detImpService).guardarImpuestos(any(), any());
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }


    // ==== listarNotas — otros ====

    @Test
    @DisplayName("listarNotas - Debe retornar página de notas")
    void listarNotas_DebeRetornarPagina() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<CntasPagar> page = new PageImpl<>(List.of(cxp), pageable, 1);

        when(repository.findNotas(pageable)).thenReturn(page);
        when(mapper.toResponse(any(CntasPagar.class))).thenReturn(notaResponse);

        Page<NotaResponse> result = service.listarNotas(pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        verify(repository).findNotas(pageable);
    }


    // ==== obtenerNotaPorId — otros ====

    @Test
    @DisplayName("obtenerNotaPorId - Debe retornar nota por ID")
    void obtenerNotaPorId_DebeRetornarNota() {
        when(repository.findNotaById(1L)).thenReturn(Optional.of(cxp));
        when(mapper.toResponse(cxp)).thenReturn(notaResponse);

        NotaResponse result = service.obtenerNotaPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("obtenerNotaPorId - Debe lanzar excepción si no existe")
    void obtenerNotaPorId_NoExiste_DebeLanzarExcepcion() {
        when(repository.findNotaById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerNotaPorId(999L)).isInstanceOf(ResourceNotFoundException.class);
    }


    // ==== anularNota — otros ====

    @Test
    @DisplayName("anularNota - Debe anular nota activa")
    void anularNota_DebeAnularNota() {
        when(repository.findNotaById(1L)).thenReturn(Optional.of(cxp));

        ApiResponse<AsientoContableResponse> mockAsiento = ApiResponse.ok(new AsientoContableResponse());
        lenient().when(contabilidadClient.anularAsiento(any())).thenReturn((ApiResponse) mockAsiento);
        when(repository.save(any(CntasPagar.class))).thenReturn(cxp);
        lenient().when(mapper.toResponse(cxp)).thenReturn(notaResponse);

        NotaResponse result = service.anularNota(1L);

        assertThat(result).isNotNull();
        verify(repository).save(any(CntasPagar.class));
    }

    @Test
    @DisplayName("anularNota - Debe lanzar excepción si no existe")
    void anularNota_NoExiste_DebeLanzarExcepcion() {
        when(repository.findNotaById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.anularNota(999L)).isInstanceOf(ResourceNotFoundException.class);
    }


    // ==== crearNota — escenarios felices ====

    @Test
    @Disabled("Requiere AsientoRequest anidado con libroId, fecha, detalles. Pendiente de completar datos del request.")
    @DisplayName("crearNota - Debe crear nota débito con asiento contable")
    void crearNota_DebeCrearNotaDebito() {
        TenantContext.setSucursalId(1L);
        TenantContext.setUsuarioId(1L);

        NotaRequest request = new NotaRequest();
        request.setTipoNota(TipoNota.DEBITO);
        request.setProveedorId(1L);
        request.setDocTipoId(1L);
        request.setMonedaId(1L);
        request.setTotal(new BigDecimal("500.00"));
        request.setFechaEmision(java.time.LocalDate.now());
        NotaDetalleRequest detalle = new NotaDetalleRequest();
        detalle.setTipoMov("NOTA_DEBITO");
        detalle.setMonto(new BigDecimal("500.00"));
        request.setDetalles(List.of(detalle));

        AsientoContableResponse asientoResponse = new AsientoContableResponse();
        asientoResponse.setId(999L);
        ApiResponse<AsientoContableResponse> mockAsiento = ApiResponse.ok(asientoResponse);
        when(contabilidadClient.generarAsientoRegistroCntasPagar(any())).thenReturn((ApiResponse) mockAsiento);
        when(mapper.toEntity(any(NotaRequest.class), anyLong(), anyLong())).thenReturn(cxp);
        when(repository.save(any(CntasPagar.class))).thenReturn(cxp);
        when(mapper.toResponse(cxp)).thenReturn(notaResponse);

        NotaResponse result = service.crearNota(request);

        assertThat(result).isNotNull();
        verify(contabilidadClient).generarAsientoRegistroCntasPagar(any());
    }


    // ==== anularNota — edge cases ====

    @Test
    @DisplayName("anularNota() con estado inactivo -> lanza BusinessException")
    void anularNota_cuandoEstadoNoEsActivo_lanzaBusinessException() {
        // Arrange
        cxp.setFlagEstado("0");
        when(repository.findNotaById(1L)).thenReturn(Optional.of(cxp));

        // Act & Assert
        assertThatThrownBy(() -> service.anularNota(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Solo se pueden anular notas activas");
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("anularNota() con asiento contable -> debe anular asiento")
    void anularNota_cuandoTieneAsientoContable_debeAnularAsiento() {
        // Arrange
        cxp.setCntblAsientoId(100L);
        when(repository.findNotaById(1L)).thenReturn(Optional.of(cxp));

        ApiResponse<AsientoContableResponse> mockAnularAsiento = ApiResponse.ok(new AsientoContableResponse());
        when(contabilidadClient.anularAsiento(100L)).thenReturn((ApiResponse) mockAnularAsiento);
        when(repository.save(any(CntasPagar.class))).thenReturn(cxp);

        // Act
        NotaResponse result = service.anularNota(1L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getFlagEstado()).isEqualTo("0");
        verify(contabilidadClient).anularAsiento(100L);
        verify(repository).save(any(CntasPagar.class));
    }

    @Test
    @DisplayName("anularNota() cuando contabilidad falla -> lanza BusinessException")
    void anularNota_cuandoContabilidadFalla_lanzaBusinessException() {
        // Arrange
        cxp.setCntblAsientoId(200L);
        when(repository.findNotaById(1L)).thenReturn(Optional.of(cxp));
        when(contabilidadClient.anularAsiento(200L))
                .thenThrow(new RuntimeException("Error de conexión"));

        // Act & Assert
        assertThatThrownBy(() -> service.anularNota(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Error al anular asiento contable");
        verify(repository, never()).save(any());
    }


    // ==== crearNota — escenarios felices (con validarRequest cubierto) ====

    @Test
    @DisplayName("crearNota() con nota débito y detalles válidos -> retorna NotaResponse")
    void crearNota_debito_conDetallesValidos_retornaNotaResponse() {
        // Arrange
        TenantContext.setSucursalId(1L);
        TenantContext.setUsuarioId(1L);

        NotaRequest request = crearNotaRequest(TipoNota.DEBITO, "NOTA_DEBITO", null);

        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(
                anyLong(), anyLong(), anyString(), anyString())).thenReturn(false);

        configurarMocksCrearNota(request);

        // Act
        NotaResponse result = service.crearNota(request);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository, times(3)).save(any(CntasPagar.class));
        verify(contabilidadClient).generarAsientoRegistroCntasPagar(any());
    }

    @Test
    @DisplayName("crearNota() con nota crédito y detalles válidos -> retorna NotaResponse")
    void crearNota_credito_conDetallesValidos_retornaNotaResponse() {
        // Arrange
        TenantContext.setSucursalId(1L);
        TenantContext.setUsuarioId(1L);

        NotaRequest request = crearNotaRequest(TipoNota.CREDITO, "NOTA_CREDITO", null);

        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(
                anyLong(), anyLong(), anyString(), anyString())).thenReturn(false);

        configurarMocksCrearNota(request);

        // Act
        NotaResponse result = service.crearNota(request);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(contabilidadClient).generarAsientoRegistroCntasPagar(any());
    }

    @Test
    @DisplayName("crearNota() sin fecha de vencimiento -> crea correctamente")
    void crearNota_sinFechaVencimiento_creaCorrectamente() {
        // Arrange
        TenantContext.setSucursalId(1L);
        TenantContext.setUsuarioId(1L);

        NotaRequest request = crearNotaRequest(TipoNota.DEBITO, "NOTA_DEBITO", null);

        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(
                anyLong(), anyLong(), anyString(), anyString())).thenReturn(false);

        configurarMocksCrearNota(request);

        // Act
        NotaResponse result = service.crearNota(request);

        // Assert
        assertThat(result).isNotNull();
        verify(contabilidadClient).generarAsientoRegistroCntasPagar(any());
    }

    @Test
    @DisplayName("crearNota() con fecha vencimiento válida -> crea correctamente")
    void crearNota_conFechaVencimientoValida_creaCorrectamente() {
        // Arrange
        TenantContext.setSucursalId(1L);
        TenantContext.setUsuarioId(1L);

        LocalDate fechaVencimiento = LocalDate.of(2026, 6, 20);
        NotaRequest request = crearNotaRequest(TipoNota.DEBITO, "NOTA_DEBITO", fechaVencimiento);

        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(
                anyLong(), anyLong(), anyString(), anyString())).thenReturn(false);

        configurarMocksCrearNota(request);

        // Act
        NotaResponse result = service.crearNota(request);

        // Assert
        assertThat(result).isNotNull();
        verify(contabilidadClient).generarAsientoRegistroCntasPagar(any());
    }


    // ==== crearNota — validaciones (validarRequest) ====

    @Test
    @DisplayName("crearNota() con documento duplicado -> lanza BusinessException")
    void crearNota_cuandoDocumentoDuplicado_lanzaBusinessException() {
        // Arrange
        NotaRequest request = crearNotaRequest(TipoNota.DEBITO, "NOTA_DEBITO", null);

        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(
                anyLong(), anyLong(), anyString(), anyString())).thenReturn(true);

        // Act & Assert
        assertThatThrownBy(() -> service.crearNota(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe un documento");
        verify(repository, never()).save(any());
        verifyNoInteractions(contabilidadClient);
    }

    @Test
    @DisplayName("crearNota() con proveedor inexistente -> lanza BusinessException")
    void crearNota_cuandoProveedorNoExiste_lanzaBusinessException() {
        // Arrange
        NotaRequest request = crearNotaRequest(TipoNota.DEBITO, "NOTA_DEBITO", null);

        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(
                anyLong(), anyLong(), anyString(), anyString())).thenReturn(false);
        when(coreMaestrosClient.obtenerEntidadPorId(anyLong()))
                .thenThrow(new RuntimeException("Proveedor no encontrado"));

        // Act & Assert
        assertThatThrownBy(() -> service.crearNota(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("El proveedor especificado no existe");
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("crearNota() con tipo de documento inexistente -> lanza BusinessException")
    void crearNota_cuandoDocTipoNoExiste_lanzaBusinessException() {
        // Arrange
        NotaRequest request = crearNotaRequest(TipoNota.DEBITO, "NOTA_DEBITO", null);

        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(
                anyLong(), anyLong(), anyString(), anyString())).thenReturn(false);
        // obtenerEntidadPorId pasa (lenient stub del @BeforeEach)
        when(coreMaestrosClient.obtenerDocTipoPorId(anyLong()))
                .thenThrow(new RuntimeException("DocTipo no encontrado"));

        // Act & Assert
        assertThatThrownBy(() -> service.crearNota(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("El tipo de documento especificado no existe");
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("crearNota() con moneda inexistente -> lanza BusinessException")
    void crearNota_cuandoMonedaNoExiste_lanzaBusinessException() {
        // Arrange
        NotaRequest request = crearNotaRequest(TipoNota.DEBITO, "NOTA_DEBITO", null);

        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(
                anyLong(), anyLong(), anyString(), anyString())).thenReturn(false);
        // obtenerEntidadPorId y obtenerDocTipoPorId pasan (lenient stubs)
        when(coreMaestrosClient.obtenerMonedaPorId(anyLong()))
                .thenThrow(new RuntimeException("Moneda no encontrada"));

        // Act & Assert
        assertThatThrownBy(() -> service.crearNota(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("La moneda especificada no existe");
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("crearNota() con fecha vencimiento anterior a emisión -> lanza BusinessException")
    void crearNota_cuandoFechaVencimientoAnteriorAFechaEmision_lanzaBusinessException() {
        // Arrange
        LocalDate fechaEmision = LocalDate.of(2026, 5, 20);
        LocalDate fechaVencimiento = LocalDate.of(2026, 5, 15);
        NotaRequest request = crearNotaRequest(TipoNota.DEBITO, "NOTA_DEBITO", fechaVencimiento);
        request.setFechaEmision(fechaEmision);

        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(
                anyLong(), anyLong(), anyString(), anyString())).thenReturn(false);

        // Act & Assert
        assertThatThrownBy(() -> service.crearNota(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("La fecha de vencimiento no puede ser anterior");
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("crearNota() con detalle tipoMov incorrecto para débito -> lanza BusinessException")
    void crearNota_debito_cuandoDetalleTipoMovIncorrecto_lanzaBusinessException() {
        // Arrange
        NotaRequest request = crearNotaRequest(TipoNota.DEBITO, "NOTA_CREDITO", null);

        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(
                anyLong(), anyLong(), anyString(), anyString())).thenReturn(false);

        // Act & Assert
        assertThatThrownBy(() -> service.crearNota(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Los detalles deben ser de tipo NOTA_DEBITO");
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("crearNota() con detalle tipoMov incorrecto para crédito -> lanza BusinessException")
    void crearNota_credito_cuandoDetalleTipoMovIncorrecto_lanzaBusinessException() {
        // Arrange
        NotaRequest request = crearNotaRequest(TipoNota.CREDITO, "NOTA_DEBITO", null);

        when(repository.existsByProveedorIdAndDocTipoIdAndSerieAndNumero(
                anyLong(), anyLong(), anyString(), anyString())).thenReturn(false);

        // Act & Assert
        assertThatThrownBy(() -> service.crearNota(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Los detalles deben ser de tipo NOTA_CREDITO");
        verify(repository, never()).save(any());
    }


    // ==== Métodos helper ====

    /**
     * Crea un NotaRequest con un solo detalle.
     * @param tipoNota     DEBITO o CREDITO
     * @param tipoMov      Tipo de movimiento del detalle (NOTA_DEBITO o NOTA_CREDITO)
     * @param fechaVenc    Fecha de vencimiento (puede ser null)
     */
    private NotaRequest crearNotaRequest(TipoNota tipoNota, String tipoMov, LocalDate fechaVenc) {
        NotaRequest request = new NotaRequest();
        request.setTipoNota(tipoNota);
        request.setProveedorId(1L);
        request.setDocTipoId(1L);
        request.setSerie("F001");
        request.setNumero("00001001");
        request.setFechaEmision(LocalDate.of(2026, 5, 20));
        request.setFechaVencimiento(fechaVenc);
        request.setMonedaId(1L);
        request.setTotal(new BigDecimal("500.00"));
        request.setAno(2026);
        request.setMes(5);
        request.setCntblLibroId(1L);

        NotaDetalleRequest detalle = new NotaDetalleRequest();
        detalle.setItem(1);
        detalle.setConceptoFinancieroId(1L);
        detalle.setDescripcion("Detalle de prueba");
        detalle.setCantidad(BigDecimal.ONE);
        detalle.setPrecioUnitario(new BigDecimal("500.00"));
        detalle.setFechaMov(LocalDate.of(2026, 5, 20));
        detalle.setTipoMov(tipoMov);
        detalle.setMonto(new BigDecimal("500.00"));
        detalle.setCentrosCostoId(1L);
        detalle.setImpuestos(List.of(new DetImpuestoRequest(1L, BigDecimal.ZERO)));

        request.setDetalles(List.of(detalle));
        return request;
    }

    /**
     * Configura los mocks comunes para el flujo exitoso de crearNota.
     */
    private void configurarMocksCrearNota(NotaRequest request) {
        // Configurar cxp rico para que convertirGenerarAsientoRequest tenga datos
        CntasPagar cxpCompleto = new CntasPagar();
        cxpCompleto.setId(1L);
        cxpCompleto.setSucursalId(1L);
        cxpCompleto.setProveedorId(request.getProveedorId());
        cxpCompleto.setDocTipoId(request.getDocTipoId());
        cxpCompleto.setSerie(request.getSerie());
        cxpCompleto.setNumero(request.getNumero());
        cxpCompleto.setFechaEmision(request.getFechaEmision());
        cxpCompleto.setFechaVencimiento(request.getFechaVencimiento());
        cxpCompleto.setMonedaId(request.getMonedaId());
        cxpCompleto.setTotal(request.getTotal());
        cxpCompleto.setSaldo(request.getTotal());
        cxpCompleto.setFlagEstado("1");
        cxpCompleto.setDetalles(new ArrayList<>());

        when(mapper.toEntity(any(NotaRequest.class), anyLong(), isNull()))
                .thenReturn(cxpCompleto);
        when(repository.save(any(CntasPagar.class))).thenReturn(cxpCompleto);

        // Detalle mapper
        CntasPagarDet detalleEntity = new CntasPagarDet();
        detalleEntity.setItem(1);
        detalleEntity.setConceptoFinancieroId(1L);
        detalleEntity.setDescripcion("Detalle de prueba");
        detalleEntity.setCantidad(BigDecimal.ONE);
        detalleEntity.setPrecioUnitario(new BigDecimal("500.00"));
        detalleEntity.setMonto(new BigDecimal("500.00"));
        detalleEntity.setCentrosCostoId(1L);
        detalleEntity.setFechaMov(request.getFechaEmision());
        detalleEntity.setTipoMov(request.getDetalles().get(0).getTipoMov());
        when(detalleMapper.toEntity(any(NotaDetalleRequest.class), anyLong()))
                .thenReturn(detalleEntity);

        // Contabilidad client
        GenerarAsientoResponse asientoResponse = new GenerarAsientoResponse();
        asientoResponse.setAsientoId(999L);
        when(contabilidadClient.generarAsientoRegistroCntasPagar(any()))
                .thenReturn(ApiResponse.ok(asientoResponse));

        // Mapper toResponse
        when(mapper.toResponse(any(CntasPagar.class))).thenReturn(notaResponse);
    }
}
