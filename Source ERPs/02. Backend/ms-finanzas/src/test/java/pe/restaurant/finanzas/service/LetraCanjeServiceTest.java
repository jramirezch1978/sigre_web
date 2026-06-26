package pe.restaurant.finanzas.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.service.NumeradorDocumentoService;
import pe.restaurant.common.service.NumeradorDocumentoService.DocumentoSerieNumero;
import pe.restaurant.finanzas.dto.request.DestinoCanjeRequest;
import pe.restaurant.finanzas.dto.request.LetraCanjeRequest;
import pe.restaurant.finanzas.dto.request.OrigenCanjeRequest;
import pe.restaurant.finanzas.dto.response.LetraCanjeDetalleResponse;
import pe.restaurant.finanzas.dto.response.LetraCanjeResponse;
import pe.restaurant.finanzas.entity.CntasPagar;
import pe.restaurant.finanzas.entity.CntasPagarDet;
import pe.restaurant.finanzas.entity.ConceptoFinanciero;
import pe.restaurant.finanzas.mapper.LetraCanjeMapper;
import pe.restaurant.finanzas.repository.CntasPagarDetRepository;
import pe.restaurant.finanzas.repository.CntasPagarRepository;
import pe.restaurant.finanzas.repository.ConceptoFinancieroRepository;
import pe.restaurant.finanzas.service.CntasPagarDetImpService;
import pe.restaurant.finanzas.service.impl.LetraCanjeServiceImpl;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class LetraCanjeServiceTest {

    @Mock
    private CntasPagarRepository cntasPagarRepository;

    @Mock
    private CntasPagarDetRepository cntasPagarDetRepository;

    @Mock
    private ConceptoFinancieroRepository conceptoFinancieroRepository;

    @Mock
    private LetraCanjeMapper mapper;

    @Mock
    private NumeradorDocumentoService numeradorDocumentoService;

    @Mock
    private CntasPagarDetImpService detImpService;

    @InjectMocks
    private LetraCanjeServiceImpl service;

    private LetraCanjeRequest canjeRequest;
    private CntasPagar documentoOrigen;
    private List<CntasPagar> origenes;
    private List<CntasPagar> destinos;

    @BeforeEach
    void setUp() {
        documentoOrigen = new CntasPagar();
        documentoOrigen.setId(1L);
        documentoOrigen.setProveedorId(100L);
        documentoOrigen.setMonedaId(1L);
        documentoOrigen.setSerie("F001");
        documentoOrigen.setNumero("00001");
        documentoOrigen.setTotal(new BigDecimal("1000.00"));
        documentoOrigen.setSaldo(new BigDecimal("1000.00"));
        documentoOrigen.setFlagEstado("1");
        documentoOrigen.setDetalles(new ArrayList<>());

        origenes = Arrays.asList(documentoOrigen);
        destinos = new ArrayList<>();

        OrigenCanjeRequest origenReq = new OrigenCanjeRequest();
        origenReq.setCntasPagarId(1L);
        origenReq.setMontoCanjeado(new BigDecimal("700.00"));

        DestinoCanjeRequest destino1 = new DestinoCanjeRequest();
        destino1.setDocTipoId(40L);
        destino1.setSerie("LT01");
        destino1.setNumero("000001");
        destino1.setFechaEmision(LocalDate.now());
        destino1.setFechaVencimiento(LocalDate.now().plusMonths(1));
        destino1.setMonedaId(1L);
        destino1.setTotal(new BigDecimal("350.00"));

        DestinoCanjeRequest destino2 = new DestinoCanjeRequest();
        destino2.setDocTipoId(40L);
        destino2.setSerie("LT01");
        destino2.setNumero("000002");
        destino2.setFechaEmision(LocalDate.now());
        destino2.setFechaVencimiento(LocalDate.now().plusMonths(2));
        destino2.setMonedaId(1L);
        destino2.setTotal(new BigDecimal("350.00"));

        canjeRequest = new LetraCanjeRequest();
        canjeRequest.setProveedorId(100L);
        canjeRequest.setFechaCanje(LocalDate.now());
        canjeRequest.setReferencia("CANJE-2026-001");
        canjeRequest.setOrigenes(Arrays.asList(origenReq));
        canjeRequest.setDestinos(Arrays.asList(destino1, destino2));

        ConceptoFinanciero cfCanje = new ConceptoFinanciero();
        cfCanje.setId(4L);
        cfCanje.setCodigo("CF004");
        lenient().when(conceptoFinancieroRepository.findByCodigoIgnoreCase("CF004")).thenReturn(Optional.of(cfCanje));
        lenient().when(detImpService.listarPorDetalle(anyLong())).thenReturn(List.of());
        lenient().doNothing().when(detImpService).guardarImpuestos(any(), any());
    }


    // ==== ejecutarCanje — escenarios felices ====

    @Test
    void ejecutarCanje_ConDatosValidos_RetornaExito() {
        when(cntasPagarRepository.existsByDetalles_Referencia(anyString())).thenReturn(false);
        when(cntasPagarRepository.findById(1L)).thenReturn(Optional.of(documentoOrigen));
        when(cntasPagarRepository.save(any(CntasPagar.class))).thenAnswer(i -> i.getArgument(0));
        when(cntasPagarDetRepository.save(any(CntasPagarDet.class))).thenAnswer(i -> i.getArgument(0));
        // Mock para findByCntasPagarIdOrderByFechaMovAsc (el servicio requiere detalles del origen)
        CntasPagarDet detalleOrigen = new CntasPagarDet();
        detalleOrigen.setId(1L);
        detalleOrigen.setItem(1);
        detalleOrigen.setConceptoFinancieroId(1L);
        detalleOrigen.setCentrosCostoId(1L);
        detalleOrigen.setCantidad(BigDecimal.ONE);
        detalleOrigen.setPrecioUnitario(BigDecimal.ONE);
        detalleOrigen.setMonto(new BigDecimal("1000.00"));
        detalleOrigen.setDescripcion("Detalle origen");
        when(cntasPagarDetRepository.findByCntasPagarIdOrderByFechaMovAsc(anyLong()))
                .thenReturn(List.of(detalleOrigen));
        // Mock para NumeradorDocumentoService (el servicio ahora genera números automáticos)
        when(numeradorDocumentoService.siguienteNroDocumentoSunat(anyLong(), anyString(), any()))
                .thenReturn(new DocumentoSerieNumero("LT01", "00001", "LT01-00001"));
        
        LetraCanjeDetalleResponse expectedResponse = new LetraCanjeDetalleResponse();
        when(mapper.toDetalleResponse(anyString(), anyList(), anyList())).thenReturn(expectedResponse);

        LetraCanjeDetalleResponse resultado = service.ejecutarCanje(canjeRequest);

        assertThat(resultado).isNotNull();
        verify(cntasPagarRepository, atLeastOnce()).save(any(CntasPagar.class));
        verify(cntasPagarDetRepository, atLeastOnce()).save(any(CntasPagarDet.class));
    }


    // ==== ejecutarCanje — otros ====

    @Test
    void ejecutarCanje_ConProveedorIncoherente_LanzaExcepcion() {
        documentoOrigen.setProveedorId(200L);
        
        when(cntasPagarRepository.existsByDetalles_Referencia(anyString())).thenReturn(false);
        when(cntasPagarRepository.findById(1L)).thenReturn(Optional.of(documentoOrigen));

        assertThatThrownBy(() -> service.ejecutarCanje(canjeRequest))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> assertThat(((BusinessException) ex).getErrorCode()).isEqualTo(FinanzasErrorCodes.CANJE_PROVEEDOR_INCOHERENTE));
    }

    @Test
    void ejecutarCanje_ConMonedaIncoherente_LanzaExcepcion() {
        documentoOrigen.setMonedaId(2L);
        
        when(cntasPagarRepository.existsByDetalles_Referencia(anyString())).thenReturn(false);
        when(cntasPagarRepository.findById(1L)).thenReturn(Optional.of(documentoOrigen));

        assertThatThrownBy(() -> service.ejecutarCanje(canjeRequest))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> assertThat(((BusinessException) ex).getErrorCode()).isEqualTo(FinanzasErrorCodes.CANJE_MONEDA_INCOHERENTE));
    }

    @Test
    void ejecutarCanje_ConMontosNoCoinciden_LanzaExcepcion() {
        canjeRequest.getDestinos().get(0).setTotal(new BigDecimal("400.00"));
        
        when(cntasPagarRepository.existsByDetalles_Referencia(anyString())).thenReturn(false);
        when(cntasPagarRepository.findById(1L)).thenReturn(Optional.of(documentoOrigen));

        assertThatThrownBy(() -> service.ejecutarCanje(canjeRequest))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> assertThat(((BusinessException) ex).getErrorCode()).isEqualTo(FinanzasErrorCodes.CANJE_MONTO_NO_COINCIDE));
    }

    @Test
    void ejecutarCanje_ConSaldoInsuficiente_LanzaExcepcion() {
        documentoOrigen.setSaldo(new BigDecimal("500.00"));
        
        when(cntasPagarRepository.existsByDetalles_Referencia(anyString())).thenReturn(false);
        when(cntasPagarRepository.findById(1L)).thenReturn(Optional.of(documentoOrigen));

        assertThatThrownBy(() -> service.ejecutarCanje(canjeRequest))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> assertThat(((BusinessException) ex).getErrorCode()).isEqualTo(FinanzasErrorCodes.CANJE_SALDO_INSUFICIENTE));
    }


    // ==== ejecutarCanje — edge cases ====

    @Test
    void ejecutarCanje_ConEstadoInvalido_LanzaExcepcion() {
        documentoOrigen.setFlagEstado("0");
        
        when(cntasPagarRepository.existsByDetalles_Referencia(anyString())).thenReturn(false);
        when(cntasPagarRepository.findById(1L)).thenReturn(Optional.of(documentoOrigen));

        assertThatThrownBy(() -> service.ejecutarCanje(canjeRequest))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> assertThat(((BusinessException) ex).getErrorCode()).isEqualTo(FinanzasErrorCodes.CANJE_ESTADO_INVALIDO));
    }


    // ==== ejecutarCanje — escenarios felices ====

    @Test
    void ejecutarCanje_ConReferenciaExistente_LanzaExcepcion() {
        when(cntasPagarRepository.existsByDetalles_Referencia(anyString())).thenReturn(true);

        assertThatThrownBy(() -> service.ejecutarCanje(canjeRequest))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> assertThat(((BusinessException) ex).getErrorCode()).isEqualTo(FinanzasErrorCodes.CANJE_REFERENCIA_DUPLICADA));
    }


    // ==== anularCanje — escenarios felices ====

    @Test
    void anularCanje_ConCanjeValido_RetornaExito() {
        CntasPagar destino = new CntasPagar();
        destino.setId(2L);
        destino.setTotal(new BigDecimal("350.00"));
        destino.setSaldo(new BigDecimal("350.00"));
        destino.setFlagEstado("1");
        
        List<CntasPagar> destinos = Arrays.asList(destino);
        
        CntasPagarDet detalleCanje = new CntasPagarDet();
        detalleCanje.setCntasPagar(documentoOrigen);
        detalleCanje.setMonto(new BigDecimal("700.00"));
        detalleCanje.setReferencia("CANJE-2026-001");
        detalleCanje.setTipoMov("CANJE_ORIGEN");
        
        when(cntasPagarRepository.findDestinosCanjeByReferencia(anyString())).thenReturn(destinos);
        when(cntasPagarRepository.findOrigenesCanjeByReferencia(anyString())).thenReturn(origenes);
        when(cntasPagarDetRepository.findByCntasPagarIdOrderByFechaMovAsc(anyLong())).thenReturn(new ArrayList<>());
        when(cntasPagarDetRepository.findByReferenciaAndTipoMov(anyString(), anyString()))
            .thenReturn(Arrays.asList(detalleCanje));
        when(cntasPagarRepository.save(any(CntasPagar.class))).thenAnswer(i -> i.getArgument(0));
        when(cntasPagarDetRepository.save(any(CntasPagarDet.class))).thenAnswer(i -> i.getArgument(0));
        
        LetraCanjeDetalleResponse expectedResponse = new LetraCanjeDetalleResponse();
        when(mapper.toDetalleResponse(anyString(), anyList(), anyList())).thenReturn(expectedResponse);

        LetraCanjeDetalleResponse resultado = service.anularCanje("CANJE-2026-001");

        assertThat(resultado).isNotNull();
        verify(cntasPagarRepository, atLeastOnce()).save(any(CntasPagar.class));
    }


    // ==== anularCanje — otros ====

    @Test
    void anularCanje_ConPagosAplicados_LanzaExcepcion() {
        CntasPagar destino = new CntasPagar();
        destino.setId(2L);
        destino.setTotal(new BigDecimal("350.00"));
        destino.setSaldo(new BigDecimal("100.00"));
        destino.setSerie("LT01");
        destino.setNumero("000001");
        
        List<CntasPagar> destinos = Arrays.asList(destino);
        
        when(cntasPagarRepository.findDestinosCanjeByReferencia(anyString())).thenReturn(destinos);

        assertThatThrownBy(() -> service.anularCanje("CANJE-2026-001"))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> assertThat(((BusinessException) ex).getErrorCode()).isEqualTo(FinanzasErrorCodes.CANJE_NO_REVERSIBLE));
    }


    // ==== listarCanjes — otros ====

    @Test
    void listarCanjes_ConFiltros_RetornaPaginado() {
        Pageable pageable = PageRequest.of(0, 10);
        
        // Cuando referencia es null, se llama a findByTipoMov
        when(cntasPagarDetRepository.findByTipoMov(anyString()))
            .thenReturn(new ArrayList<>());

        Page<LetraCanjeResponse> resultado = service.listarCanjes(null, null, null, null, pageable);

        assertThat(resultado).isNotNull();
        verify(cntasPagarDetRepository).findByTipoMov(anyString());
    }


    // ==== obtenerCanjePorReferencia — escenarios felices ====

    @Test
    void obtenerCanjePorReferencia_Existente_RetornaDetalle() {
        when(cntasPagarRepository.findOrigenesCanjeByReferencia(anyString())).thenReturn(origenes);
        when(cntasPagarRepository.findDestinosCanjeByReferencia(anyString())).thenReturn(destinos);
        
        LetraCanjeDetalleResponse expectedResponse = new LetraCanjeDetalleResponse();
        when(mapper.toDetalleResponse(anyString(), anyList(), anyList())).thenReturn(expectedResponse);

        LetraCanjeDetalleResponse resultado = service.obtenerCanjePorReferencia("CANJE-2026-001");

        assertThat(resultado).isNotNull();
        verify(mapper).toDetalleResponse(anyString(), anyList(), anyList());
    }


    // ==== obtenerCanjePorReferencia — otros ====

    @Test
    void obtenerCanjePorReferencia_NoExistente_LanzaExcepcion() {
        when(cntasPagarRepository.findOrigenesCanjeByReferencia(anyString())).thenReturn(new ArrayList<>());
        when(cntasPagarRepository.findDestinosCanjeByReferencia(anyString())).thenReturn(new ArrayList<>());

        assertThatThrownBy(() -> service.obtenerCanjePorReferencia("CANJE-INEXISTENTE")).isInstanceOf(ResourceNotFoundException.class);
    }

    // ==== obtenerCanjePorReferencia — edge cases ====

    @Test
    @DisplayName("obtenerCanjePorReferencia() con solo destinos (sin orígenes) -> retorna detalle")
    void obtenerCanjePorReferencia_conSoloDestinos_retornaDetalle() {
        // Arrange
        CntasPagar destino = new CntasPagar();
        destino.setId(10L);
        List<CntasPagar> destinos = Arrays.asList(destino);
        List<CntasPagar> origenesVacios = new ArrayList<>();

        when(cntasPagarRepository.findOrigenesCanjeByReferencia("CANJE-SOLO-DESTINOS"))
                .thenReturn(origenesVacios);
        when(cntasPagarRepository.findDestinosCanjeByReferencia("CANJE-SOLO-DESTINOS"))
                .thenReturn(destinos);

        LetraCanjeDetalleResponse expected = new LetraCanjeDetalleResponse();
        when(mapper.toDetalleResponse(eq("CANJE-SOLO-DESTINOS"), eq(origenesVacios), eq(destinos)))
                .thenReturn(expected);

        // Act
        LetraCanjeDetalleResponse resultado = service.obtenerCanjePorReferencia("CANJE-SOLO-DESTINOS");

        // Assert
        assertThat(resultado).isNotNull();
        verify(mapper).toDetalleResponse(eq("CANJE-SOLO-DESTINOS"), eq(origenesVacios), eq(destinos));
    }

    // ==== listarCanjes — escenarios felices ====

    @Test
    @DisplayName("listarCanjes() con referencia no vacía -> usa findByReferenciaAndTipoMov en vez de findByTipoMov")
    void listarCanjes_conReferencia_filtraPorReferenciaYTipoMov() {
        // Arrange
        Pageable pageable = PageRequest.of(0, 10);
        String ref = "CANJE-2026-001";
        when(cntasPagarDetRepository.findByReferenciaAndTipoMov(ref, "CANJE_ORIGEN"))
                .thenReturn(new ArrayList<>());

        // Act
        Page<LetraCanjeResponse> resultado = service.listarCanjes(ref, null, null, null, pageable);

        // Assert
        assertThat(resultado).isNotNull();
        assertThat(resultado.getContent()).isEmpty();
        verify(cntasPagarDetRepository).findByReferenciaAndTipoMov(ref, "CANJE_ORIGEN");
        verify(cntasPagarDetRepository, never()).findByTipoMov(anyString());
    }

    @Test
    @DisplayName("listarCanjes() con detalles existentes -> agrupa por referencia y mapea a response")
    void listarCanjes_conDetallesExistentes_agrupaPorReferencia() {
        // Arrange
        Pageable pageable = PageRequest.of(0, 10);

        CntasPagarDet detalle1 = new CntasPagarDet();
        detalle1.setReferencia("CANJE-2026-A");
        CntasPagarDet detalle2 = new CntasPagarDet();
        detalle2.setReferencia("CANJE-2026-B");

        when(cntasPagarDetRepository.findByTipoMov("CANJE_ORIGEN"))
                .thenReturn(Arrays.asList(detalle1, detalle2));

        CntasPagar origenA = new CntasPagar();
        origenA.setId(1L);
        origenA.setProveedorId(100L);
        CntasPagar origenB = new CntasPagar();
        origenB.setId(2L);
        origenB.setProveedorId(100L);

        when(cntasPagarRepository.findOrigenesCanjeByReferencia("CANJE-2026-A"))
                .thenReturn(Arrays.asList(origenA));
        when(cntasPagarRepository.findOrigenesCanjeByReferencia("CANJE-2026-B"))
                .thenReturn(Arrays.asList(origenB));
        when(cntasPagarRepository.findDestinosCanjeByReferencia(anyString()))
                .thenReturn(new ArrayList<>());

        LetraCanjeResponse respA = new LetraCanjeResponse();
        respA.setReferencia("CANJE-2026-A");
        LetraCanjeResponse respB = new LetraCanjeResponse();
        respB.setReferencia("CANJE-2026-B");

        when(mapper.toResponse(eq("CANJE-2026-A"), anyList(), anyList())).thenReturn(respA);
        when(mapper.toResponse(eq("CANJE-2026-B"), anyList(), anyList())).thenReturn(respB);

        // Act
        Page<LetraCanjeResponse> resultado = service.listarCanjes(null, null, null, null, pageable);

        // Assert
        assertThat(resultado).isNotNull();
        assertThat(resultado.getContent()).hasSize(2);
        assertThat(resultado.getTotalElements()).isEqualTo(2);
        verify(cntasPagarRepository).findDestinosCanjeByReferencia("CANJE-2026-A");
        verify(cntasPagarRepository).findDestinosCanjeByReferencia("CANJE-2026-B");
    }

    @Test
    @DisplayName("listarCanjes() con proveedorId no coincidente -> excluye el grupo del resultado")
    void listarCanjes_conProveedorIdDistinto_excluyeOrigen() {
        // Arrange
        Pageable pageable = PageRequest.of(0, 10);

        CntasPagarDet detalle = new CntasPagarDet();
        detalle.setReferencia("CANJE-2026-X");

        when(cntasPagarDetRepository.findByTipoMov("CANJE_ORIGEN"))
                .thenReturn(Arrays.asList(detalle));

        CntasPagar origen = new CntasPagar();
        origen.setId(1L);
        origen.setProveedorId(999L); // distinto al filtro
        when(cntasPagarRepository.findOrigenesCanjeByReferencia("CANJE-2026-X"))
                .thenReturn(Arrays.asList(origen));

        // Act
        Page<LetraCanjeResponse> resultado = service.listarCanjes(null, 100L,
                null, null, pageable);

        // Assert
        assertThat(resultado).isNotNull();
        assertThat(resultado.getContent()).isEmpty();
        verify(cntasPagarRepository, never()).findDestinosCanjeByReferencia(anyString());
    }

    // ==== listarCanjes — edge cases ====

    @Test
    @DisplayName("listarCanjes() con página fuera de rango -> retorna PageImpl vacía")
    void listarCanjes_conPaginaFueraDeRango_retornaPaginaVacia() {
        // Arrange
        Pageable pageable = PageRequest.of(5, 10); // offset=50
        when(cntasPagarDetRepository.findByTipoMov("CANJE_ORIGEN"))
                .thenReturn(new ArrayList<>());

        // Act
        Page<LetraCanjeResponse> resultado = service.listarCanjes(null, null, null, null, pageable);

        // Assert
        assertThat(resultado).isNotNull();
        assertThat(resultado.getContent()).isEmpty();
        assertThat(resultado.getTotalElements()).isZero();
    }

    // ==== ejecutarCanje — errors de validación ====

    @Test
    @DisplayName("ejecutarCanje() con documento origen no encontrado en BD -> lanza ResourceNotFoundException")
    void ejecutarCanje_conDocumentoOrigenNoEncontrado_lanzaResourceNotFoundException() {
        // Arrange
        when(cntasPagarRepository.existsByDetalles_Referencia(anyString())).thenReturn(false);
        when(cntasPagarRepository.findById(1L)).thenReturn(Optional.empty());

        // Act & Assert
        assertThatThrownBy(() -> service.ejecutarCanje(canjeRequest))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Documento origen no encontrado");
    }

    @Test
    @DisplayName("ejecutarCanje() con orígenes de distinta moneda -> lanza BusinessException CANJE_MONEDA_INCOHERENTE")
    void ejecutarCanje_conOrigenesDistintaMoneda_lanzaExcepcion() {
        // Arrange
        CntasPagar origen2 = new CntasPagar();
        origen2.setId(2L);
        origen2.setProveedorId(100L);
        origen2.setMonedaId(2L); // moneda distinta
        origen2.setSerie("F002");
        origen2.setNumero("00002");
        origen2.setTotal(new BigDecimal("500.00"));
        origen2.setSaldo(new BigDecimal("500.00"));
        origen2.setFlagEstado("1");

        OrigenCanjeRequest origenReq2 = new OrigenCanjeRequest();
        origenReq2.setCntasPagarId(2L);
        origenReq2.setMontoCanjeado(new BigDecimal("300.00"));

        canjeRequest.setOrigenes(Arrays.asList(
                canjeRequest.getOrigenes().get(0), origenReq2));
        // Ajustar destinos para que cuadre el balance: 700+300=1000
        canjeRequest.getDestinos().get(0).setTotal(new BigDecimal("500.00"));
        canjeRequest.getDestinos().get(1).setTotal(new BigDecimal("500.00"));

        when(cntasPagarRepository.existsByDetalles_Referencia(anyString())).thenReturn(false);
        when(cntasPagarRepository.findById(1L)).thenReturn(Optional.of(documentoOrigen));
        when(cntasPagarRepository.findById(2L)).thenReturn(Optional.of(origen2));

        // Act & Assert
        assertThatThrownBy(() -> service.ejecutarCanje(canjeRequest))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> assertThat(((BusinessException) ex).getErrorCode())
                        .isEqualTo(FinanzasErrorCodes.CANJE_MONEDA_INCOHERENTE));
    }

    @Test
    @DisplayName("ejecutarCanje() con fecha de vencimiento anterior a fecha de canje -> lanza BusinessException CANJE_FECHA_INVALIDA")
    void ejecutarCanje_conFechaVencimientoAnteriorAFechaCanje_lanzaExcepcion() {
        // Arrange
        canjeRequest.getDestinos().get(0).setFechaVencimiento(LocalDate.now().minusDays(1));

        when(cntasPagarRepository.existsByDetalles_Referencia(anyString())).thenReturn(false);
        when(cntasPagarRepository.findById(1L)).thenReturn(Optional.of(documentoOrigen));

        // Act & Assert
        assertThatThrownBy(() -> service.ejecutarCanje(canjeRequest))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> assertThat(((BusinessException) ex).getErrorCode())
                        .isEqualTo(FinanzasErrorCodes.CANJE_FECHA_INVALIDA));
    }

    @Test
    @DisplayName("ejecutarCanje() con documento origen sin detalles -> lanza BusinessException CANJE_DOCUMENTO_SIN_DETALLES")
    void ejecutarCanje_conDocumentoSinDetalles_lanzaExcepcion() {
        // Arrange: findByCntasPagarIdOrderByFechaMovAsc NO stubbed → Mockito default empty list
        // Se lanza en procesarOrigenCanje ANTES de llegar a crearDestinoDocumento ni a los save()
        when(cntasPagarRepository.existsByDetalles_Referencia(anyString())).thenReturn(false);
        when(cntasPagarRepository.findById(1L)).thenReturn(Optional.of(documentoOrigen));

        // Act & Assert
        assertThatThrownBy(() -> service.ejecutarCanje(canjeRequest))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> assertThat(((BusinessException) ex).getErrorCode())
                        .isEqualTo(FinanzasErrorCodes.CANJE_DOCUMENTO_SIN_DETALLES));
    }

    // ==== ejecutarCanje — edge cases ====

    @Test
    @DisplayName("ejecutarCanje() con destino sin moneda (null) -> omite validación de coherencia de moneda y ejecuta con éxito")
    void ejecutarCanje_conDestinoMonedaNula_procesaExitosamente() {
        // Arrange
        canjeRequest.getDestinos().get(0).setMonedaId(null);

        when(cntasPagarRepository.existsByDetalles_Referencia(anyString())).thenReturn(false);
        when(cntasPagarRepository.findById(1L)).thenReturn(Optional.of(documentoOrigen));
        when(cntasPagarRepository.save(any(CntasPagar.class))).thenAnswer(i -> i.getArgument(0));
        when(cntasPagarDetRepository.save(any(CntasPagarDet.class))).thenAnswer(i -> i.getArgument(0));

        CntasPagarDet detalleOrigen = new CntasPagarDet();
        detalleOrigen.setId(1L);
        detalleOrigen.setItem(1);
        detalleOrigen.setConceptoFinancieroId(1L);
        detalleOrigen.setCentrosCostoId(1L);
        detalleOrigen.setCantidad(BigDecimal.ONE);
        detalleOrigen.setPrecioUnitario(BigDecimal.ONE);
        detalleOrigen.setMonto(new BigDecimal("1000.00"));
        detalleOrigen.setDescripcion("Detalle origen");
        when(cntasPagarDetRepository.findByCntasPagarIdOrderByFechaMovAsc(anyLong()))
                .thenReturn(List.of(detalleOrigen));
        when(numeradorDocumentoService.siguienteNroDocumentoSunat(anyLong(), anyString(), any()))
                .thenReturn(new DocumentoSerieNumero("LT01", "00001", "LT01-00001"));

        LetraCanjeDetalleResponse expectedResponse = new LetraCanjeDetalleResponse();
        when(mapper.toDetalleResponse(anyString(), anyList(), anyList())).thenReturn(expectedResponse);

        // Act
        LetraCanjeDetalleResponse resultado = service.ejecutarCanje(canjeRequest);

        // Assert
        assertThat(resultado).isNotNull();
        verify(cntasPagarRepository, atLeastOnce()).save(any(CntasPagar.class));
    }

    // ==== anularCanje — edge cases ====

    @Test
    @DisplayName("anularCanje() con referencia inexistente (sin orígenes ni destinos) -> lanza ResourceNotFoundException")
    void anularCanje_conReferenciaInexistente_lanzaResourceNotFoundException() {
        // Arrange
        when(cntasPagarRepository.findDestinosCanjeByReferencia("REF-INEXISTENTE"))
                .thenReturn(new ArrayList<>());
        when(cntasPagarRepository.findOrigenesCanjeByReferencia("REF-INEXISTENTE"))
                .thenReturn(new ArrayList<>());

        // Act & Assert
        assertThatThrownBy(() -> service.anularCanje("REF-INEXISTENTE"))
                .isInstanceOf(ResourceNotFoundException.class);
    }
}
