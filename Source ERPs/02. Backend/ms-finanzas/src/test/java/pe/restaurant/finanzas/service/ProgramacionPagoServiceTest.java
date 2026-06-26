package pe.restaurant.finanzas.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.security.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.finanzas.client.CoreMaestrosClient;
import pe.restaurant.finanzas.dto.request.ProgramacionPagoDetalleRequest;
import pe.restaurant.finanzas.dto.request.ProgramacionPagoRequest;
import pe.restaurant.finanzas.dto.response.DocTipoResponse;
import pe.restaurant.finanzas.dto.response.EjecucionProgramacionResponse;
import pe.restaurant.finanzas.dto.response.EntidadContribuyenteResponse;
import pe.restaurant.finanzas.dto.response.ProgramacionPagoDetalleResponse;
import pe.restaurant.finanzas.dto.response.ProgramacionPagoListResponse;
import pe.restaurant.finanzas.dto.response.ProgramacionPagoResponse;
import pe.restaurant.finanzas.entity.CntasPagar;
import pe.restaurant.finanzas.entity.Pago;
import pe.restaurant.finanzas.entity.ProgramacionPago;
import pe.restaurant.finanzas.entity.ProgramacionPagoDet;
import pe.restaurant.finanzas.mapper.ProgramacionPagoDetMapper;
import pe.restaurant.finanzas.mapper.ProgramacionPagoMapper;
import pe.restaurant.finanzas.repository.CntasPagarRepository;
import pe.restaurant.finanzas.repository.PagoRepository;
import pe.restaurant.finanzas.repository.ProgramacionPagoRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ProgramacionPagoServiceTest {

    @Mock
    private ProgramacionPagoRepository repository;

    @Mock
    private CntasPagarRepository cntasPagarRepository;

    @Mock
    private PagoRepository pagoRepository;

    @Mock
    private ProgramacionPagoMapper mapper;

    @Mock
    private ProgramacionPagoDetMapper detMapper;

    @Mock
    private CoreMaestrosClient coreMaestrosClient;

    @InjectMocks
    private ProgramacionPagoService service;

    private ProgramacionPago programacion;
    private ProgramacionPagoRequest request;
    private ProgramacionPagoResponse response;
    private ProgramacionPagoListResponse listResponse;
    private CntasPagar cntasPagar;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        TenantContext.setSucursalId(1L);
        TenantContext.setEmpresaId(1L);
        programacion = new ProgramacionPago();
        programacion.setId(1L);
        programacion.setFechaProgramada(LocalDate.of(2026, 5, 15));
        programacion.setFlagEstado("1");
        programacion.setDetalles(new ArrayList<>());

        cntasPagar = new CntasPagar();
        cntasPagar.setId(1001L);
        cntasPagar.setProveedorId(100L);
        cntasPagar.setDocTipoId(1L);
        cntasPagar.setSerie("F001");
        cntasPagar.setNumero("00012345");
        cntasPagar.setTotal(new BigDecimal("1180.00"));
        cntasPagar.setSaldo(new BigDecimal("1180.00"));
        cntasPagar.setFlagEstado("1");

        request = new ProgramacionPagoRequest();
        request.setFechaProgramada(LocalDate.of(2026, 5, 15));
        
        List<ProgramacionPagoDetalleRequest> detalles = new ArrayList<>();
        ProgramacionPagoDetalleRequest det1 = new ProgramacionPagoDetalleRequest();
        det1.setCntasPagarId(1001L);
        det1.setMontoProgramado(new BigDecimal("500.00"));
        detalles.add(det1);
        
        request.setDetalles(detalles);

        response = new ProgramacionPagoResponse();
        response.setId(1L);
        response.setFechaProgramada(LocalDate.of(2026, 5, 15));
        response.setFlagEstado("1");

        listResponse = new ProgramacionPagoListResponse();
        listResponse.setId(1L);
        listResponse.setFechaProgramada(LocalDate.of(2026, 5, 15));
        listResponse.setTotalProgramado(new BigDecimal("500.00"));
        listResponse.setCantidadDocumentos(1);
    }


    // ==== listar — otros ====

    @Test
    void listar_DebeRetornarPaginaConProgramaciones() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<ProgramacionPago> page = new PageImpl<>(List.of(programacion));
        
        when(repository.buscarConFiltros(any(), any(), any(), eq(pageable))).thenReturn(page);
        when(mapper.toListResponse(any())).thenReturn(listResponse);

        Page<ProgramacionPagoListResponse> resultado = service.listar(null, null, null, pageable);

        assertThat(resultado).isNotNull();
        assertThat(resultado.getTotalElements()).isEqualTo(1);
        verify(repository).buscarConFiltros(any(), any(), any(), eq(pageable));
    }


    // ==== obtenerPorId — escenarios felices ====

    @Test
    void obtenerPorId_DebeRetornarProgramacion() {
        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(mapper.toResponse(any())).thenReturn(response);

        ProgramacionPagoResponse resultado = service.obtenerPorId(1L);

        assertThat(resultado).isNotNull();
        assertThat(resultado.getId()).isEqualTo(1L);
        verify(repository).findById(eq(1L));
    }

    // ==== obtenerPorId — enriquecimiento de detalles ====

    @Test
    void obtenerPorId_ConDetalles_DebeEnriquecerDatosCxP() {
        // Arrange
        ProgramacionPagoDetalleResponse detalleResp = new ProgramacionPagoDetalleResponse();
        detalleResp.setCntasPagarId(1001L);

        ProgramacionPagoResponse respuestaConDetalles = new ProgramacionPagoResponse();
        respuestaConDetalles.setId(1L);
        respuestaConDetalles.setDetalles(List.of(detalleResp));

        EntidadContribuyenteResponse entidadResp = new EntidadContribuyenteResponse();
        entidadResp.setRazonSocial("PROVEEDOR SAC");
        ApiResponse<EntidadContribuyenteResponse> apiEntidad = ApiResponse.ok(entidadResp);

        DocTipoResponse docTipoResp = new DocTipoResponse();
        docTipoResp.setCodigo("01");
        ApiResponse<DocTipoResponse> apiDocTipo = ApiResponse.ok(docTipoResp);

        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(mapper.toResponse(any())).thenReturn(respuestaConDetalles);
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.of(cntasPagar));
        when(coreMaestrosClient.obtenerEntidadPorId(eq(100L))).thenReturn(apiEntidad);
        when(coreMaestrosClient.obtenerDocTipoPorId(eq(1L))).thenReturn(apiDocTipo);

        // Act
        ProgramacionPagoResponse resultado = service.obtenerPorId(1L);

        // Assert
        assertThat(resultado).isNotNull();
        assertThat(resultado.getDetalles()).isNotEmpty();
        ProgramacionPagoDetalleResponse detalleEnriquecido = resultado.getDetalles().get(0);
        assertThat(detalleEnriquecido.getSerie()).isEqualTo("F001");
        assertThat(detalleEnriquecido.getNumero()).isEqualTo("00012345");
        assertThat(detalleEnriquecido.getTotalCxP()).isEqualTo(new BigDecimal("1180.00"));
        assertThat(detalleEnriquecido.getSaldoCxP()).isEqualTo(new BigDecimal("1180.00"));
        assertThat(detalleEnriquecido.getProveedorRazonSocial()).isEqualTo("PROVEEDOR SAC");
        assertThat(detalleEnriquecido.getDocTipoCodigo()).isEqualTo("01");
        verify(coreMaestrosClient).obtenerEntidadPorId(eq(100L));
        verify(coreMaestrosClient).obtenerDocTipoPorId(eq(1L));
    }

    @Test
    void obtenerPorId_ConDetalleSinCntasPagarId_NoDebeFallar() {
        // Arrange — detalle con cntasPagarId null, el enriquecimiento hace early return
        ProgramacionPagoDetalleResponse detalleResp = new ProgramacionPagoDetalleResponse();
        detalleResp.setCntasPagarId(null);

        ProgramacionPagoResponse respuestaConDetalles = new ProgramacionPagoResponse();
        respuestaConDetalles.setId(1L);
        respuestaConDetalles.setDetalles(List.of(detalleResp));

        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(mapper.toResponse(any())).thenReturn(respuestaConDetalles);

        // Act
        ProgramacionPagoResponse resultado = service.obtenerPorId(1L);

        // Assert
        assertThat(resultado).isNotNull();
        assertThat(resultado.getDetalles()).isNotEmpty();
        verify(cntasPagarRepository, never()).findById(anyLong());
    }

    @Test
    void obtenerPorId_ConDetalleCxPNoEncontrada_NoDebeFallar() {
        // Arrange — CxP no existe en BD, el enriquecimiento maneja el optional vacío
        ProgramacionPagoDetalleResponse detalleResp = new ProgramacionPagoDetalleResponse();
        detalleResp.setCntasPagarId(9999L);

        ProgramacionPagoResponse respuestaConDetalles = new ProgramacionPagoResponse();
        respuestaConDetalles.setId(1L);
        respuestaConDetalles.setDetalles(List.of(detalleResp));

        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(mapper.toResponse(any())).thenReturn(respuestaConDetalles);
        when(cntasPagarRepository.findById(eq(9999L))).thenReturn(Optional.empty());

        // Act
        ProgramacionPagoResponse resultado = service.obtenerPorId(1L);

        // Assert
        assertThat(resultado).isNotNull();
        verify(coreMaestrosClient, never()).obtenerEntidadPorId(anyLong());
    }

    @Test
    void obtenerPorId_ConFeignEntidadFallando_DebeContinuarSinProveedor() {
        // Arrange — el Feign del proveedor lanza excepción, el enriquecimiento la captura y sigue
        ProgramacionPagoDetalleResponse detalleResp = new ProgramacionPagoDetalleResponse();
        detalleResp.setCntasPagarId(1001L);

        ProgramacionPagoResponse respuestaConDetalles = new ProgramacionPagoResponse();
        respuestaConDetalles.setId(1L);
        respuestaConDetalles.setDetalles(List.of(detalleResp));

        DocTipoResponse docTipoResp = new DocTipoResponse();
        docTipoResp.setCodigo("01");
        ApiResponse<DocTipoResponse> apiDocTipo = ApiResponse.ok(docTipoResp);

        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(mapper.toResponse(any())).thenReturn(respuestaConDetalles);
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.of(cntasPagar));
        when(coreMaestrosClient.obtenerEntidadPorId(eq(100L)))
                .thenThrow(new RuntimeException("Feign error"));
        when(coreMaestrosClient.obtenerDocTipoPorId(eq(1L))).thenReturn(apiDocTipo);

        // Act & Assert — no debe lanzar excepción
        ProgramacionPagoResponse resultado = service.obtenerPorId(1L);

        assertThat(resultado).isNotNull();
        ProgramacionPagoDetalleResponse detalleEnriquecido = resultado.getDetalles().get(0);
        // proveedorRazonSocial queda null (no se setea por el catch)
        assertThat(detalleEnriquecido.getProveedorRazonSocial()).isNull();
        // docTipo sí se enriquece (el segundo try no falló)
        assertThat(detalleEnriquecido.getDocTipoCodigo()).isEqualTo("01");
    }

    @Test
    void obtenerPorId_ConFeignDocTipoFallando_DebeContinuarSinDocTipo() {
        // Arrange — el Feign del tipo de documento falla
        ProgramacionPagoDetalleResponse detalleResp = new ProgramacionPagoDetalleResponse();
        detalleResp.setCntasPagarId(1001L);

        ProgramacionPagoResponse respuestaConDetalles = new ProgramacionPagoResponse();
        respuestaConDetalles.setId(1L);
        respuestaConDetalles.setDetalles(List.of(detalleResp));

        EntidadContribuyenteResponse entidadResp = new EntidadContribuyenteResponse();
        entidadResp.setRazonSocial("PROVEEDOR SAC");
        ApiResponse<EntidadContribuyenteResponse> apiEntidad = ApiResponse.ok(entidadResp);

        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(mapper.toResponse(any())).thenReturn(respuestaConDetalles);
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.of(cntasPagar));
        when(coreMaestrosClient.obtenerEntidadPorId(eq(100L))).thenReturn(apiEntidad);
        when(coreMaestrosClient.obtenerDocTipoPorId(eq(1L)))
                .thenThrow(new RuntimeException("Feign doc tipo error"));

        // Act
        ProgramacionPagoResponse resultado = service.obtenerPorId(1L);

        // Assert
        assertThat(resultado).isNotNull();
        ProgramacionPagoDetalleResponse detalleEnriquecido = resultado.getDetalles().get(0);
        assertThat(detalleEnriquecido.getProveedorRazonSocial()).isEqualTo("PROVEEDOR SAC");
        assertThat(detalleEnriquecido.getDocTipoCodigo()).isNull();
    }

    // ==== obtenerPorId — enriquecimiento ramas nulas de Feign ====

    @Test
    void obtenerPorId_ConFeignEntidadDataNull_DebeContinuarSinRazonSocial() {
        // Arrange — rama L328: entidadResponse != null pero data == null
        ProgramacionPagoDetalleResponse detalleResp = new ProgramacionPagoDetalleResponse();
        detalleResp.setCntasPagarId(1001L);

        ProgramacionPagoResponse respuestaConDetalles = new ProgramacionPagoResponse();
        respuestaConDetalles.setId(1L);
        respuestaConDetalles.setDetalles(List.of(detalleResp));

        ApiResponse<EntidadContribuyenteResponse> apiEntidad = ApiResponse.ok(null);
        DocTipoResponse docTipoResp = new DocTipoResponse();
        docTipoResp.setCodigo("01");
        ApiResponse<DocTipoResponse> apiDocTipo = ApiResponse.ok(docTipoResp);

        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(mapper.toResponse(any())).thenReturn(respuestaConDetalles);
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.of(cntasPagar));
        when(coreMaestrosClient.obtenerEntidadPorId(eq(100L))).thenReturn(apiEntidad);
        when(coreMaestrosClient.obtenerDocTipoPorId(eq(1L))).thenReturn(apiDocTipo);

        // Act
        ProgramacionPagoResponse resultado = service.obtenerPorId(1L);

        // Assert
        assertThat(resultado).isNotNull();
        ProgramacionPagoDetalleResponse detalleEnriquecido = resultado.getDetalles().get(0);
        assertThat(detalleEnriquecido.getProveedorRazonSocial()).isNull();
        assertThat(detalleEnriquecido.getDocTipoCodigo()).isEqualTo("01");
    }

    @Test
    void obtenerPorId_ConFeignEntidadNull_DebeContinuarSinRazonSocial() {
        // Arrange — rama L328: entidadResponse == null
        ProgramacionPagoDetalleResponse detalleResp = new ProgramacionPagoDetalleResponse();
        detalleResp.setCntasPagarId(1001L);

        ProgramacionPagoResponse respuestaConDetalles = new ProgramacionPagoResponse();
        respuestaConDetalles.setId(1L);
        respuestaConDetalles.setDetalles(List.of(detalleResp));

        DocTipoResponse docTipoResp = new DocTipoResponse();
        docTipoResp.setCodigo("01");
        ApiResponse<DocTipoResponse> apiDocTipo = ApiResponse.ok(docTipoResp);

        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(mapper.toResponse(any())).thenReturn(respuestaConDetalles);
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.of(cntasPagar));
        when(coreMaestrosClient.obtenerEntidadPorId(eq(100L))).thenReturn(null);
        when(coreMaestrosClient.obtenerDocTipoPorId(eq(1L))).thenReturn(apiDocTipo);

        // Act
        ProgramacionPagoResponse resultado = service.obtenerPorId(1L);

        // Assert
        assertThat(resultado).isNotNull();
        ProgramacionPagoDetalleResponse detalleEnriquecido = resultado.getDetalles().get(0);
        assertThat(detalleEnriquecido.getProveedorRazonSocial()).isNull();
        assertThat(detalleEnriquecido.getDocTipoCodigo()).isEqualTo("01");
    }

    @Test
    void obtenerPorId_ConFeignDocTipoDataNull_DebeContinuarSinDocTipo() {
        // Arrange — rama L337: docTipoResponse != null pero data == null
        ProgramacionPagoDetalleResponse detalleResp = new ProgramacionPagoDetalleResponse();
        detalleResp.setCntasPagarId(1001L);

        ProgramacionPagoResponse respuestaConDetalles = new ProgramacionPagoResponse();
        respuestaConDetalles.setId(1L);
        respuestaConDetalles.setDetalles(List.of(detalleResp));

        EntidadContribuyenteResponse entidadResp = new EntidadContribuyenteResponse();
        entidadResp.setRazonSocial("PROVEEDOR SAC");
        ApiResponse<EntidadContribuyenteResponse> apiEntidad = ApiResponse.ok(entidadResp);
        ApiResponse<DocTipoResponse> apiDocTipo = ApiResponse.ok(null);

        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(mapper.toResponse(any())).thenReturn(respuestaConDetalles);
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.of(cntasPagar));
        when(coreMaestrosClient.obtenerEntidadPorId(eq(100L))).thenReturn(apiEntidad);
        when(coreMaestrosClient.obtenerDocTipoPorId(eq(1L))).thenReturn(apiDocTipo);

        // Act
        ProgramacionPagoResponse resultado = service.obtenerPorId(1L);

        // Assert
        assertThat(resultado).isNotNull();
        ProgramacionPagoDetalleResponse detalleEnriquecido = resultado.getDetalles().get(0);
        assertThat(detalleEnriquecido.getProveedorRazonSocial()).isEqualTo("PROVEEDOR SAC");
        assertThat(detalleEnriquecido.getDocTipoCodigo()).isNull();
    }

    @Test
    void obtenerPorId_ConFeignDocTipoNull_DebeContinuarSinDocTipo() {
        // Arrange — rama L337: docTipoResponse == null
        ProgramacionPagoDetalleResponse detalleResp = new ProgramacionPagoDetalleResponse();
        detalleResp.setCntasPagarId(1001L);

        ProgramacionPagoResponse respuestaConDetalles = new ProgramacionPagoResponse();
        respuestaConDetalles.setId(1L);
        respuestaConDetalles.setDetalles(List.of(detalleResp));

        EntidadContribuyenteResponse entidadResp = new EntidadContribuyenteResponse();
        entidadResp.setRazonSocial("PROVEEDOR SAC");
        ApiResponse<EntidadContribuyenteResponse> apiEntidad = ApiResponse.ok(entidadResp);

        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(mapper.toResponse(any())).thenReturn(respuestaConDetalles);
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.of(cntasPagar));
        when(coreMaestrosClient.obtenerEntidadPorId(eq(100L))).thenReturn(apiEntidad);
        when(coreMaestrosClient.obtenerDocTipoPorId(eq(1L))).thenReturn(null);

        // Act
        ProgramacionPagoResponse resultado = service.obtenerPorId(1L);

        // Assert
        assertThat(resultado).isNotNull();
        ProgramacionPagoDetalleResponse detalleEnriquecido = resultado.getDetalles().get(0);
        assertThat(detalleEnriquecido.getProveedorRazonSocial()).isEqualTo("PROVEEDOR SAC");
        assertThat(detalleEnriquecido.getDocTipoCodigo()).isNull();
    }

    @Test
    void obtenerPorId_ConRepositoryException_DebeContinuarSinDatosCxP() {
        // Arrange — rama L344-L345: catch externo cuando findById lanza RuntimeException
        ProgramacionPagoDetalleResponse detalleResp = new ProgramacionPagoDetalleResponse();
        detalleResp.setCntasPagarId(1001L);

        ProgramacionPagoResponse respuestaConDetalles = new ProgramacionPagoResponse();
        respuestaConDetalles.setId(1L);
        respuestaConDetalles.setDetalles(List.of(detalleResp));

        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(mapper.toResponse(any())).thenReturn(respuestaConDetalles);
        when(cntasPagarRepository.findById(eq(1001L)))
                .thenThrow(new RuntimeException("Error de conexión a BD"));

        // Act & Assert — no debe lanzar, el catch externo lo traga
        ProgramacionPagoResponse resultado = service.obtenerPorId(1L);

        assertThat(resultado).isNotNull();
        // Los datos de CxP no se enriquecieron porque el findById falló
        ProgramacionPagoDetalleResponse detalleSinEnriquecer = resultado.getDetalles().get(0);
        assertThat(detalleSinEnriquecer.getSerie()).isNull();
        assertThat(detalleSinEnriquecer.getNumero()).isNull();
        verify(coreMaestrosClient, never()).obtenerEntidadPorId(anyLong());
    }


    // ==== obtenerPorId — edge cases ====

    @Test
    void obtenerPorId_NoExiste_DebeLanzarExcepcion() {
        when(repository.findById(eq(999L))).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L)).isInstanceOf(ResourceNotFoundException.class);
    }


    // ==== crear — escenarios felices ====

    @Test
    void crear_DebeCrearProgramacion() {
        when(mapper.toEntity(any())).thenReturn(programacion);
        when(repository.save(any())).thenReturn(programacion);
        when(detMapper.toEntity(any())).thenReturn(new ProgramacionPagoDet());
        when(mapper.toResponse(any())).thenReturn(response);
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.of(cntasPagar));

        ProgramacionPagoResponse resultado = service.crear(request);

        assertThat(resultado).isNotNull();
        assertThat(resultado.getFlagEstado()).isEqualTo("1");
        verify(repository, times(2)).save(any());
    }


    // ==== crear — validaciones ====

    @Test
    void crear_SinFechaProgramada_DebeLanzarExcepcion() {
        request.setFechaProgramada(null);

        assertThatThrownBy(() -> service.crear(request)).isInstanceOf(BusinessException.class);
    }

    @Test
    void crear_SinDetalles_DebeLanzarExcepcion() {
        request.setDetalles(new ArrayList<>());

        assertThatThrownBy(() -> service.crear(request)).isInstanceOf(BusinessException.class);
    }

    @Test
    void crear_DetallesNull_DebeLanzarExcepcion() {
        // Arrange — rama L228: detalles == null (no cubierta por test de lista vacía)
        request.setDetalles(null);

        // Act & Assert
        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void crear_MontoExcedeSaldo_DebeLanzarExcepcion() {
        request.getDetalles().get(0).setMontoProgramado(new BigDecimal("2000.00"));
        when(mapper.toEntity(any())).thenReturn(new ProgramacionPago());
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.of(cntasPagar));

        assertThatThrownBy(() -> service.crear(request)).isInstanceOf(BusinessException.class);
    }

    @Test
    void crear_CxPNoExiste_DebeLanzarExcepcion() {
        when(mapper.toEntity(any())).thenReturn(new ProgramacionPago());
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.crear(request)).isInstanceOf(BusinessException.class);
    }

    @Test
    void crear_CntasPagarIdNull_DebeLanzarExcepcion() {
        // Arrange — rama L238: detalle.getCntasPagarId() == null
        request.getDetalles().get(0).setCntasPagarId(null);
        when(mapper.toEntity(any())).thenReturn(new ProgramacionPago());

        // Act & Assert
        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void crear_MontoProgramadoNull_DebeLanzarExcepcion() {
        // Arrange — rama L246: montoProgramado == null; lanza antes de consultar CxP
        request.getDetalles().get(0).setMontoProgramado(null);
        when(mapper.toEntity(any())).thenReturn(new ProgramacionPago());

        // Act & Assert
        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void crear_MontoProgramadoCero_DebeLanzarExcepcion() {
        // Arrange — rama L246: montoProgramado.compareTo(BigDecimal.ZERO) <= 0
        request.getDetalles().get(0).setMontoProgramado(BigDecimal.ZERO);
        when(mapper.toEntity(any())).thenReturn(new ProgramacionPago());

        // Act & Assert
        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void crear_CxPNoActiva_DebeLanzarExcepcion() {
        // Arrange — rama L261: CxP con flag_estado != "1"
        cntasPagar.setFlagEstado("0");
        when(mapper.toEntity(any())).thenReturn(new ProgramacionPago());
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.of(cntasPagar));

        // Act & Assert
        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class);
    }


    // ==== actualizar — escenarios felices ====

    @Test
    void actualizar_DebeActualizarProgramacion() {
        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(repository.save(any())).thenReturn(programacion);
        when(detMapper.toEntity(any())).thenReturn(new ProgramacionPagoDet());
        when(mapper.toResponse(any())).thenReturn(response);
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.of(cntasPagar));

        ProgramacionPagoResponse resultado = service.actualizar(1L, request);

        assertThat(resultado).isNotNull();
        verify(repository).save(any());
    }

    @Test
    void actualizar_EstadoEjecutado_DebeLanzarExcepcion() {
        programacion.setFlagEstado("2");
        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));

        assertThatThrownBy(() -> service.actualizar(1L, request)).isInstanceOf(BusinessException.class);
    }


    // ==== ejecutar — escenarios felices ====

    @Test
    void ejecutar_DebeGenerarPagosYActualizarSaldos() {
        ProgramacionPagoDet detalle = new ProgramacionPagoDet();
        detalle.setId(1L);
        detalle.setCntasPagarId(1001L);
        detalle.setMontoProgramado(new BigDecimal("500.00"));
        detalle.setFlagEstado("1");
        detalle.setProgramacionPago(programacion);
        programacion.getDetalles().add(detalle);

        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.of(cntasPagar));
        when(pagoRepository.save(any())).thenReturn(new Pago());
        when(cntasPagarRepository.save(any())).thenReturn(cntasPagar);
        when(repository.save(any())).thenReturn(programacion);

        EjecucionProgramacionResponse resultado = service.ejecutar(1L);

        assertThat(resultado).isNotNull();
        assertThat(resultado.getFlagEstado()).isEqualTo("2");
        assertThat(resultado.getPagosGenerados()).isEqualTo(1);
        assertThat(resultado.getTotalPagado()).isEqualTo(new BigDecimal("500.00"));
        verify(pagoRepository).save(any());
        verify(cntasPagarRepository).save(any());
    }

    @Test
    void ejecutar_ConSaldoExacto_DebeCerrarCxP() {
        // Arrange — monto programado exactamente igual al saldo, nuevoSaldo == 0 (L165-L166)
        CntasPagar cxpSaldoExacto = new CntasPagar();
        cxpSaldoExacto.setId(1001L);
        cxpSaldoExacto.setProveedorId(100L);
        cxpSaldoExacto.setSaldo(new BigDecimal("500.00"));
        cxpSaldoExacto.setFlagEstado("1");

        ProgramacionPagoDet detalle = new ProgramacionPagoDet();
        detalle.setId(1L);
        detalle.setCntasPagarId(1001L);
        detalle.setMontoProgramado(new BigDecimal("500.00"));
        detalle.setFlagEstado("1");
        detalle.setProgramacionPago(programacion);
        programacion.getDetalles().add(detalle);

        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.of(cxpSaldoExacto));
        when(pagoRepository.save(any())).thenReturn(new Pago());
        when(cntasPagarRepository.save(any())).thenReturn(cxpSaldoExacto);
        when(repository.save(any())).thenReturn(programacion);

        // Act
        EjecucionProgramacionResponse resultado = service.ejecutar(1L);

        // Assert
        assertThat(resultado).isNotNull();
        assertThat(resultado.getTotalPagado()).isEqualTo(new BigDecimal("500.00"));
        // Verificamos que el saldo quedó en 0 y el flag cambió a "5"
        assertThat(cxpSaldoExacto.getSaldo()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(cxpSaldoExacto.getFlagEstado()).isEqualTo("5");
    }


    // ==== ejecutar — edge cases ====

    @Test
    void ejecutar_EstadoNoPermitido_DebeLanzarExcepcion() {
        programacion.setFlagEstado("2");
        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));

        assertThatThrownBy(() -> service.ejecutar(1L)).isInstanceOf(BusinessException.class);
    }

    @Test
    void ejecutar_ConDetalleInactivo_DebeSaltarlo() {
        // Arrange — un detalle inactivo (flag "0") + uno activo (flag "1")
        // El inactivo se saltea (continue L137), solo se procesa el activo
        ProgramacionPagoDet detInactivo = new ProgramacionPagoDet();
        detInactivo.setId(1L);
        detInactivo.setCntasPagarId(9999L);
        detInactivo.setMontoProgramado(new BigDecimal("100.00"));
        detInactivo.setFlagEstado("0"); // inactivo → se saltea
        detInactivo.setProgramacionPago(programacion);

        ProgramacionPagoDet detActivo = new ProgramacionPagoDet();
        detActivo.setId(2L);
        detActivo.setCntasPagarId(1001L);
        detActivo.setMontoProgramado(new BigDecimal("500.00"));
        detActivo.setFlagEstado("1"); // activo → se procesa
        detActivo.setProgramacionPago(programacion);

        programacion.getDetalles().add(detInactivo);
        programacion.getDetalles().add(detActivo);

        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.of(cntasPagar));
        when(pagoRepository.save(any())).thenReturn(new Pago());
        when(cntasPagarRepository.save(any())).thenReturn(cntasPagar);
        when(repository.save(any())).thenReturn(programacion);

        // Act
        EjecucionProgramacionResponse resultado = service.ejecutar(1L);

        // Assert — solo se generó 1 pago (el del detalle activo)
        assertThat(resultado.getPagosGenerados()).isEqualTo(1);
        assertThat(resultado.getTotalPagado()).isEqualTo(new BigDecimal("500.00"));
        // El detalle inactivo nunca llamó al repo de CxP
        verify(cntasPagarRepository, never()).findById(eq(9999L));
    }

    @Test
    void ejecutar_CxPNoEncontrada_DebeLanzarExcepcion() {
        // Arrange — cntasPagarRepository.findById lanza, el catch (L188) lo envuelve
        ProgramacionPagoDet detalle = new ProgramacionPagoDet();
        detalle.setId(1L);
        detalle.setCntasPagarId(1001L);
        detalle.setMontoProgramado(new BigDecimal("500.00"));
        detalle.setFlagEstado("1");
        detalle.setProgramacionPago(programacion);
        programacion.getDetalles().add(detalle);

        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.empty());

        // Act & Assert — el catch envuelve en BusinessException con INTERNAL_SERVER_ERROR
        assertThatThrownBy(() -> service.ejecutar(1L))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void ejecutar_ConErrorInterno_DebeLanzarBusinessException() {
        // Arrange — simula un error durante el guardado del pago (catch L188-L195)
        ProgramacionPagoDet detalle = new ProgramacionPagoDet();
        detalle.setId(1L);
        detalle.setCntasPagarId(1001L);
        detalle.setMontoProgramado(new BigDecimal("500.00"));
        detalle.setFlagEstado("1");
        detalle.setProgramacionPago(programacion);
        programacion.getDetalles().add(detalle);

        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.of(cntasPagar));
        when(pagoRepository.save(any())).thenThrow(new RuntimeException("Error de BD"));

        // Act & Assert
        assertThatThrownBy(() -> service.ejecutar(1L))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void ejecutar_MultiplesDetalles_DebeGenerarMultiplesPagos() {
        // Arrange — 2 detalles activos con 2 CxP distintas
        CntasPagar cxp2 = new CntasPagar();
        cxp2.setId(2002L);
        cxp2.setProveedorId(200L);
        cxp2.setSaldo(new BigDecimal("800.00"));
        cxp2.setFlagEstado("1");

        ProgramacionPagoDet det1 = new ProgramacionPagoDet();
        det1.setId(1L);
        det1.setCntasPagarId(1001L);
        det1.setMontoProgramado(new BigDecimal("300.00"));
        det1.setFlagEstado("1");
        det1.setProgramacionPago(programacion);

        ProgramacionPagoDet det2 = new ProgramacionPagoDet();
        det2.setId(2L);
        det2.setCntasPagarId(2002L);
        det2.setMontoProgramado(new BigDecimal("400.00"));
        det2.setFlagEstado("1");
        det2.setProgramacionPago(programacion);

        programacion.getDetalles().add(det1);
        programacion.getDetalles().add(det2);

        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(cntasPagarRepository.findById(eq(1001L))).thenReturn(Optional.of(cntasPagar));
        when(cntasPagarRepository.findById(eq(2002L))).thenReturn(Optional.of(cxp2));
        when(pagoRepository.save(any())).thenReturn(new Pago());
        when(cntasPagarRepository.save(any())).thenReturn(cntasPagar, cxp2);
        when(repository.save(any())).thenReturn(programacion);

        // Act
        EjecucionProgramacionResponse resultado = service.ejecutar(1L);

        // Assert
        assertThat(resultado.getPagosGenerados()).isEqualTo(2);
        assertThat(resultado.getTotalPagado()).isEqualTo(new BigDecimal("700.00"));
        verify(pagoRepository, times(2)).save(any());
    }


    // ==== anular — escenarios felices ====

    @Test
    void anular_DebeAnularProgramacion() {
        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(repository.save(any())).thenReturn(programacion);
        when(mapper.toResponse(any())).thenReturn(response);

        ProgramacionPagoResponse resultado = service.anular(1L);

        assertThat(resultado).isNotNull();
        verify(repository).save(any());
    }


    // ==== anular — edge cases ====

    @Test
    void anular_EstadoEjecutado_DebeLanzarExcepcion() {
        programacion.setFlagEstado("2");
        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));

        assertThatThrownBy(() -> service.anular(1L)).isInstanceOf(BusinessException.class);
    }

    @Test
    void anular_EstadoAnulado_DebePermitirReanular() {
        // Arrange — una programación ya anulada ("0"), no es "2" (ejecutada),
        // por lo que validarEstadoParaAnulacion no lanza excepción
        programacion.setFlagEstado("0");
        when(repository.findById(eq(1L))).thenReturn(Optional.of(programacion));
        when(repository.save(any())).thenReturn(programacion);
        when(mapper.toResponse(any())).thenReturn(response);

        // Act
        ProgramacionPagoResponse resultado = service.anular(1L);

        // Assert — no lanza excepción, se puede reanular
        assertThat(resultado).isNotNull();
        verify(repository).save(any());
    }
}
