package pe.restaurant.finanzas.service.impl;

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
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.service.NumeradorDocumentoService;
import pe.restaurant.finanzas.dto.request.DetraccionRequest;
import pe.restaurant.finanzas.dto.response.DetraccionResponse;
import pe.restaurant.finanzas.entity.Detraccion;
import pe.restaurant.finanzas.mapper.DetraccionMapper;
import pe.restaurant.finanzas.repository.CntasPagarRepository;
import pe.restaurant.finanzas.repository.DetraccionRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - DetraccionServiceImpl")
class DetraccionServiceImplTest {

    @Mock private DetraccionRepository repository;
    @Mock private CntasPagarRepository cntasPagarRepository;
    @Mock private DetraccionMapper mapper;
    @Mock private NumeradorDocumentoService numeradorDocumentoService;

    @InjectMocks
    private DetraccionServiceImpl service;

    private Detraccion detraccion;
    private DetraccionResponse response;
    private DetraccionRequest request;
    private DetraccionRequest updateRequest;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        TenantContext.setSucursalId(1L);

        detraccion = new Detraccion();
        detraccion.setId(1L);
        detraccion.setNroDetraccion("DTR-00001");
        detraccion.setCntasPagarId(1001L);
        detraccion.setFlagEstado("1");
        detraccion.setImporte(new java.math.BigDecimal("100.00"));

        response = new DetraccionResponse();
        response.setId(1L);
        response.setNroDetraccion("DTR-00001");
        response.setFlagEstado("1");

        request = new DetraccionRequest();
        request.setCntasPagarId(1001L);
        request.setImporte(new java.math.BigDecimal("100.00"));
        request.setFechaRegistro(LocalDate.now());
        request.setFechaDeposito(LocalDate.now());

        updateRequest = new DetraccionRequest();
        updateRequest.setCntasPagarId(1001L);
        updateRequest.setNroDetraccion("DTR-00002");
        updateRequest.setImporte(new java.math.BigDecimal("150.00"));
        updateRequest.setFechaRegistro(LocalDate.now());
        updateRequest.setFechaDeposito(LocalDate.now());
    }


    // ==== listar ====

    @Test
    @DisplayName("listar - Sin filtros debe retornar página")
    void listar_SinFiltros_DebeRetornarPagina() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<Detraccion> page = new PageImpl<>(List.of(detraccion), pageable, 1);
        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<DetraccionResponse> result = service.listar(null, null, null, pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("listar - Con filtro nroDetraccion debe filtrar")
    void listar_ConFiltroNroDetraccion_DebeFiltrar() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<Detraccion> page = new PageImpl<>(List.of(detraccion), pageable, 1);
        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<DetraccionResponse> result = service.listar("DTR-00001", null, null, pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("listar - Con filtro cntasPagarId debe filtrar")
    void listar_ConFiltroCntasPagarId_DebeFiltrar() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<Detraccion> page = new PageImpl<>(List.of(detraccion), pageable, 1);
        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<DetraccionResponse> result = service.listar(null, 1001L, null, pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("listar - Con flagEstado específico debe filtrar por estado")
    void listar_ConFlagEstado_DebeFiltrarPorEstado() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<Detraccion> page = new PageImpl<>(List.of(detraccion), pageable, 1);
        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<DetraccionResponse> result = service.listar(null, null, "0", pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }


    // ==== obtenerPorId ====

    @Test
    @DisplayName("obtenerPorId - Debe retornar detracción")
    void obtenerPorId_DebeRetornarDetraccion() {
        when(repository.findById(1L)).thenReturn(Optional.of(detraccion));
        when(mapper.toResponse(detraccion)).thenReturn(response);

        DetraccionResponse result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("obtenerPorId - Debe lanzar excepción si no existe")
    void obtenerPorId_NoExiste_DebeLanzarExcepcion() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }


    // ==== crear ====

    @Test
    @DisplayName("crear - Con número auto-generado debe crear detracción")
    void crear_ConNumeroAutoGenerado_DebeCrearDetraccion() {
        Detraccion newDetraccion = new Detraccion();
        newDetraccion.setId(2L);
        newDetraccion.setNroDetraccion(null);
        newDetraccion.setCntasPagarId(1001L);
        newDetraccion.setImporte(new java.math.BigDecimal("100.00"));

        when(cntasPagarRepository.existsById(1001L)).thenReturn(true);
        when(mapper.toEntity(request)).thenReturn(newDetraccion);

        Detraccion saved = new Detraccion();
        saved.setId(2L);
        saved.setNroDetraccion("DTR-00002");
        saved.setCntasPagarId(1001L);
        saved.setFlagEstado("1");
        saved.setImporte(new java.math.BigDecimal("100.00"));

        when(numeradorDocumentoService.siguienteNroDocumento(
                "finanzas.detraccion", 1L, LocalDate.now().getYear()))
                .thenReturn("DTR-00002");
        when(repository.save(any())).thenReturn(saved);

        DetraccionResponse createdResponse = new DetraccionResponse();
        createdResponse.setId(2L);
        createdResponse.setNroDetraccion("DTR-00002");
        createdResponse.setFlagEstado("1");
        when(mapper.toResponse(saved)).thenReturn(createdResponse);

        DetraccionResponse result = service.crear(request);

        assertThat(result).isNotNull();
        assertThat(result.getNroDetraccion()).isEqualTo("DTR-00002");
        verify(numeradorDocumentoService).siguienteNroDocumento(anyString(), anyLong(), anyInt());
    }

    @Test
    @DisplayName("crear - Con número proporcionado debe crear detracción")
    void crear_ConNumeroProporcionado_DebeCrearDetraccion() {
        request.setNroDetraccion("DTR-00005");
        Detraccion detraccionConNro = new Detraccion();
        detraccionConNro.setId(1L);
        detraccionConNro.setNroDetraccion("DTR-00005");
        detraccionConNro.setCntasPagarId(1001L);
        detraccionConNro.setFlagEstado("1");
        detraccionConNro.setImporte(new java.math.BigDecimal("100.00"));

        when(cntasPagarRepository.existsById(1001L)).thenReturn(true);
        when(mapper.toEntity(request)).thenReturn(detraccionConNro);
        when(repository.existsByNroDetraccionAndFlagEstado("DTR-00005", "1")).thenReturn(false);
        when(repository.save(any())).thenReturn(detraccionConNro);
        when(mapper.toResponse(detraccionConNro)).thenReturn(response);

        DetraccionResponse result = service.crear(request);

        assertThat(result).isNotNull();
        verify(numeradorDocumentoService, never()).siguienteNroDocumento(anyString(), anyLong(), anyInt());
    }

    @Test
    @DisplayName("crear - Cuando cntasPagar no existe debe lanzar BusinessException")
    void crear_CuandoCntasPagarNoExiste_DebeLanzarExcepcion() {
        when(cntasPagarRepository.existsById(999L)).thenReturn(false);
        request.setCntasPagarId(999L);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("cuenta por pagar");
    }

    @Test
    @DisplayName("crear - Cuando nro duplicado debe lanzar BusinessException")
    void crear_CuandoNroDuplicado_DebeLanzarExcepcion() {
        request.setNroDetraccion("DTR-00001");

        when(cntasPagarRepository.existsById(1001L)).thenReturn(true);
        when(mapper.toEntity(request)).thenReturn(detraccion);
        when(repository.existsByNroDetraccionAndFlagEstado("DTR-00001", "1")).thenReturn(true);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe una detracción activa");
    }


    // ==== actualizar ====

    @Test
    @DisplayName("actualizar - Con datos válidos debe actualizar detracción")
    void actualizar_ConDatosValidos_DebeActualizar() {
        when(repository.findById(1L)).thenReturn(Optional.of(detraccion));
        when(cntasPagarRepository.existsById(1001L)).thenReturn(true);
        when(repository.save(any())).thenReturn(detraccion);
        when(mapper.toResponse(detraccion)).thenReturn(response);

        DetraccionResponse result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }

    @Test
    @DisplayName("actualizar - Cuando no existe debe lanzar ResourceNotFoundException")
    void actualizar_CuandoNoExiste_DebeLanzarExcepcion() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, request))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("actualizar - Cuando entidad inactiva debe lanzar BusinessException")
    void actualizar_CuandoInactiva_DebeLanzarExcepcion() {
        detraccion.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(detraccion));

        assertThatThrownBy(() -> service.actualizar(1L, request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No se puede actualizar una detracción inactiva");
    }

    @Test
    @DisplayName("actualizar - Con nuevo nro detracción debe validar unicidad")
    void actualizar_ConNuevoNro_DebeValidarUnicidad() {
        detraccion.setNroDetraccion("DTR-ORIGINAL");

        when(repository.findById(1L)).thenReturn(Optional.of(detraccion));
        when(cntasPagarRepository.existsById(1001L)).thenReturn(true);
        when(repository.existsByNroDetraccionAndFlagEstado("DTR-00002", "1")).thenReturn(false);
        when(repository.save(any())).thenReturn(detraccion);
        when(mapper.toResponse(detraccion)).thenReturn(response);

        DetraccionResponse result = service.actualizar(1L, updateRequest);

        assertThat(result).isNotNull();
        verify(repository).existsByNroDetraccionAndFlagEstado("DTR-00002", "1");
    }


    // ==== activar ====

    @Test
    @DisplayName("activar - Debe activar detracción inactiva")
    void activar_DebeActivarDetraccion() {
        detraccion.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(detraccion));
        when(repository.save(any())).thenReturn(detraccion);
        when(mapper.toResponse(any())).thenReturn(response);

        DetraccionResponse result = service.activar(1L);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }

    @Test
    @DisplayName("activar - Cuando ya está activa debe lanzar BusinessException")
    void activar_CuandoYaEstaActiva_DebeLanzarExcepcion() {
        when(repository.findById(1L)).thenReturn(Optional.of(detraccion));

        assertThatThrownBy(() -> service.activar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ya está activa");
    }


    // ==== desactivar ====

    @Test
    @DisplayName("desactivar - Debe desactivar detracción activa")
    void desactivar_DebeDesactivarDetraccion() {
        when(repository.findById(1L)).thenReturn(Optional.of(detraccion));
        when(repository.save(any())).thenReturn(detraccion);
        when(mapper.toResponse(any())).thenReturn(response);

        DetraccionResponse result = service.desactivar(1L);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }

    @Test
    @DisplayName("desactivar - Cuando ya está inactiva debe lanzar BusinessException")
    void desactivar_CuandoYaEstaInactiva_DebeLanzarExcepcion() {
        detraccion.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(detraccion));

        assertThatThrownBy(() -> service.desactivar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ya está inactiva");
    }
}
