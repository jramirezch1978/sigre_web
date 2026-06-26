package pe.restaurant.produccion.service.impl;

import feign.FeignException;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.test.util.ReflectionTestUtils;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.produccion.ProduccionTestFixtures;
import pe.restaurant.produccion.client.CoreArticuloClient;
import pe.restaurant.produccion.dto.response.OperacionDetResponse;
import pe.restaurant.produccion.dto.response.OperacionResponse;
import pe.restaurant.produccion.entity.Operacion;
import pe.restaurant.produccion.entity.OperacionesDet;
import pe.restaurant.produccion.entity.OrdenTrabajo;
import pe.restaurant.produccion.repository.OperacionRepository;
import pe.restaurant.produccion.repository.OperacionesDetRepository;
import pe.restaurant.produccion.repository.OrdenTrabajoRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("OperacionServiceImpl — Pruebas Unitarias")
class OperacionServiceImplTest {

    @Mock private OperacionRepository repository;
    @Mock private OperacionesDetRepository detRepository;
    @Mock private OrdenTrabajoRepository otRepository;
    @Mock private CoreArticuloClient coreArticuloClient;
    @Mock private EntityManager entityManager;
    @Mock private Query query;

    private OperacionServiceImpl service;
    private Operacion entity;
    private List<OperacionesDet> detalles;

    @BeforeEach
    void setUp() {
        service = new OperacionServiceImpl(repository, detRepository, otRepository, coreArticuloClient);
        ReflectionTestUtils.setField(service, "entityManager", entityManager);
        entity = ProduccionTestFixtures.operacion(1L, "1");
        detalles = List.of(ProduccionTestFixtures.operacionesDet(1L));

        TenantContext.setEmpresaId(1L);
        TenantContext.setSucursalId(1L);
        TenantContext.setUsuarioId(1L);

        lenient().when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        lenient().when(query.setParameter(anyString(), any())).thenReturn(query);
        lenient().when(query.getSingleResult()).thenReturn(1);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    private OrdenTrabajo otActiva() {
        return ProduccionTestFixtures.ordenTrabajo(1L, "1");
    }

    private void mockArticuloOk() {
        var artResp = ApiResponse.<pe.restaurant.produccion.client.dto.ArticuloResponse>builder()
                .success(true)
                .data(ProduccionTestFixtures.articuloResponse())
                .build();
        lenient().when(coreArticuloClient.obtenerPorId(anyLong())).thenReturn(artResp);
    }

    // ==================== findById ====================

    @Test
    void findById_cuandoExisteId_retornaEntidad() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        Operacion result = service.findById(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    void findById_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ==================== findAll ====================

    @Test
    void findAll_conFiltros_retornaPage() {
        var pageable = PageRequest.of(0, 10);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of(entity)));

        Page<Operacion> result = service.findAll(1L, LocalDate.now(), LocalDate.now(), "1", pageable);

        assertThat(result).hasSize(1);
    }

    @Test
    void findAll_sinFiltros_retornaPage() {
        var pageable = PageRequest.of(0, 10);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        Page<Operacion> result = service.findAll(null, null, null, null, pageable);

        assertThat(result).isEmpty();
    }

    // ==================== findDetalles ====================

    @Test
    void findDetalles_retornaLista() {
        when(detRepository.findByOperacionIdOrderByIdAsc(1L)).thenReturn(detalles);

        var result = service.findDetalles(1L);

        assertThat(result).hasSize(1);
        verify(detRepository).findByOperacionIdOrderByIdAsc(1L);
    }

    // ==================== create ====================

    @Test
    void create_conDatosValidos_guardaTodo() {
        mockArticuloOk();
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        when(query.getSingleResult()).thenReturn(0);
        when(repository.save(any(Operacion.class))).thenAnswer(i -> i.getArgument(0));

        Operacion result = service.create(entity, detalles);

        assertThat(result).isNotNull();
        assertThat(result.getCreatedBy()).isEqualTo(1L);
        assertThat(result.getFlagEstado()).isEqualTo("1");
        verify(repository).save(any(Operacion.class));
        verify(detRepository).save(any(OperacionesDet.class));
    }

    @Test
    void create_sinFlagEstado_asignaActivo() {
        mockArticuloOk();
        entity.setFlagEstado(null);
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        when(query.getSingleResult()).thenReturn(0);
        when(repository.save(any(Operacion.class))).thenAnswer(i -> i.getArgument(0));

        Operacion result = service.create(entity, detalles);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void create_sinDetalles_noGuardaDetalles() {
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        when(query.getSingleResult()).thenReturn(0);
        when(repository.save(any(Operacion.class))).thenAnswer(i -> i.getArgument(0));

        service.create(entity, null);

        verify(detRepository, never()).save(any());
    }

    @Test
    void create_cuandoOTInexistente_lanzaBusinessException() {
        when(otRepository.findById(anyLong())).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.create(entity, detalles))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("orden de trabajo");
    }

    @Test
    void create_cuandoOTInactiva_lanzaBusinessException() {
        when(otRepository.findById(anyLong()))
                .thenReturn(Optional.of(ProduccionTestFixtures.ordenTrabajo(1L, "0")));

        assertThatThrownBy(() -> service.create(entity, detalles))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("orden de trabajo");
    }

    @Test
    void create_cuandoNroOperacionDuplicado_lanzaBusinessException() {
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        when(query.getSingleResult()).thenReturn(1);

        assertThatThrownBy(() -> service.create(entity, detalles))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("nro de operación");
    }

    @Test
    void create_cuandoFechaFinAntesFechaInicio_lanzaBusinessException() {
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        reset(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(0);
        entity.setFecInicio(LocalDate.of(2025, 6, 10));
        entity.setFecFin(LocalDate.of(2025, 6, 5));

        assertThatThrownBy(() -> service.create(entity, detalles))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("fecha de fin");
    }

    @Test
    void create_cuandoCostoUnitarioNegativo_lanzaBusinessException() {
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        reset(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(0);
        entity.setCostoUnitario(BigDecimal.valueOf(-1));

        assertThatThrownBy(() -> service.create(entity, detalles))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Costo unitario");
    }

    @Test
    void create_cuandoCostoProyectadoNegativo_lanzaBusinessException() {
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        reset(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(0);
        entity.setCostoProyectado(BigDecimal.valueOf(-5));

        assertThatThrownBy(() -> service.create(entity, detalles))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Costo proyectado");
    }

    @Test
    void create_cuandoCantidadProyectadaNegativa_lanzaBusinessException() {
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        reset(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(0);
        entity.setCantidadProyectada(BigDecimal.valueOf(-1));

        assertThatThrownBy(() -> service.create(entity, detalles))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Cantidad proyectada");
    }

    @Test
    void create_cuandoCantidadRealNegativa_lanzaBusinessException() {
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        reset(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(0);
        entity.setCantidadReal(BigDecimal.valueOf(-1));

        assertThatThrownBy(() -> service.create(entity, detalles))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Cantidad real");
    }

    // ==================== update ====================

    @Test
    void update_conDatosValidos_actualizaYRetorna() {
        mockArticuloOk();
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        when(query.getSingleResult()).thenReturn(0);
        when(repository.save(any(Operacion.class))).thenAnswer(i -> i.getArgument(0));

        Operacion input = new Operacion();
        input.setOrdenTrabajoId(1L);
        input.setNroOperacion(2);
        input.setDescripcion("Actualizada");
        input.setFecInicio(LocalDate.of(2025, 5, 1));

        var result = service.update(1L, input, detalles);

        assertThat(result.getNroOperacion()).isEqualTo(2);
        assertThat(result.getDescripcion()).isEqualTo("Actualizada");
        verify(detRepository).deleteByOperacionId(1L);
        verify(detRepository, atLeastOnce()).save(any(OperacionesDet.class));
    }

    @Test
    void update_conNroOperacionNull_noValidaDuplicado() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        when(repository.save(any(Operacion.class))).thenAnswer(i -> i.getArgument(0));

        Operacion input = new Operacion();
        input.setOrdenTrabajoId(1L);
        input.setNroOperacion(null);
        input.setFecInicio(LocalDate.of(2025, 5, 1));

        service.update(1L, input, null);

        verify(query, never()).getSingleResult();
    }

    // ==================== activate ====================

    @Test
    void activate_cuandoInactiva_cambiaFlagEstado() {
        Operacion inactive = ProduccionTestFixtures.operacion(1L, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(inactive));
        when(repository.save(any(Operacion.class))).thenAnswer(i -> i.getArgument(0));

        Operacion result = service.activate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void activate_cuandoActiva_lanzaBusinessException() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.activate(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ya se encuentra activa");
    }

    // ==================== deactivate ====================

    @Test
    void deactivate_cambiaFlagEstado() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(Operacion.class))).thenAnswer(i -> i.getArgument(0));

        Operacion result = service.deactivate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    @Test
    void deactivate_cuandoInactiva_lanzaBusinessException() {
        Operacion inactive = ProduccionTestFixtures.operacion(1L, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(inactive));

        assertThatThrownBy(() -> service.deactivate(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ya se encuentra inactiva");
    }

    // ==================== delete ====================

    @Test
    void delete_desactiva() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(Operacion.class))).thenReturn(entity);

        service.delete(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
    }

    // ==================== addDetalles ====================

    @Test
    void addDetalles_conDatosValidos_guardaYRetorna() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(detRepository.findByOperacionIdOrderByIdAsc(1L)).thenReturn(detalles);
        mockArticuloOk();

        var result = service.addDetalles(1L, detalles);

        assertThat(result).hasSize(1);
        verify(detRepository).save(any(OperacionesDet.class));
        verify(detRepository).findByOperacionIdOrderByIdAsc(1L);
    }

    // ==================== enrich (single) ====================

    @Test
    void enrich_cuandoResponseNull_noHaceNada() {
        service.enrich((OperacionResponse) null);
        verifyNoInteractions(otRepository, coreArticuloClient);
    }

    @Test
    void enrich_conOrdenTrabajoId_seteaCodigo() {
        var resp = OperacionResponse.builder().ordenTrabajoId(1L).build();
        var ot = otActiva();
        ot.setCodigo("OT-2025-0001");
        when(otRepository.findById(1L)).thenReturn(Optional.of(ot));

        service.enrich(resp);

        assertThat(resp.getOrdenTrabajoCodigo()).isEqualTo("OT-2025-0001");
    }

    @Test
    void enrich_sinOrdenTrabajoId_noSeteaCodigo() {
        var resp = OperacionResponse.builder().build();
        resp.setOrdenTrabajoId(null);

        service.enrich(resp);

        verifyNoInteractions(otRepository);
    }

    @Test
    void enrich_conDetalles_enriqueceArticulos() {
        var det = OperacionDetResponse.builder().articuloId(1L).build();
        var resp = OperacionResponse.builder()
                .ordenTrabajoId(1L)
                .detalles(List.of(det))
                .build();
        when(otRepository.findById(1L)).thenReturn(Optional.of(otActiva()));
        var artResp = ApiResponse.<pe.restaurant.produccion.client.dto.ArticuloResponse>builder()
                .success(true)
                .data(pe.restaurant.produccion.client.dto.ArticuloResponse.builder()
                        .id(1L).codigo("ART1").nombre("Articulo 1").build())
                .build();
        when(coreArticuloClient.obtenerPorId(1L)).thenReturn(artResp);

        service.enrich(resp);

        assertThat(det.getArticuloCodigo()).isEqualTo("ART1");
        assertThat(det.getArticuloDescripcion()).isEqualTo("Articulo 1");
    }

    @Test
    void enrich_conDetallesSinArticulo_skpea() {
        var det = OperacionDetResponse.builder().build();
        det.setArticuloId(null);
        var resp = OperacionResponse.builder()
                .ordenTrabajoId(1L)
                .detalles(List.of(det))
                .build();
        when(otRepository.findById(1L)).thenReturn(Optional.of(otActiva()));

        service.enrich(resp);

        verifyNoInteractions(coreArticuloClient);
    }

    @Test
    void enrich_conDetalleFeignFallo_noLanza() {
        var det = OperacionDetResponse.builder().articuloId(1L).build();
        var resp = OperacionResponse.builder()
                .ordenTrabajoId(1L)
                .detalles(List.of(det))
                .build();
        when(otRepository.findById(1L)).thenReturn(Optional.of(otActiva()));
        when(coreArticuloClient.obtenerPorId(1L)).thenThrow(mock(FeignException.class));

        service.enrich(resp);

        assertThat(det.getArticuloCodigo()).isNull();
    }

    // ==================== enrich (list) ====================

    @Test
    void enrichList_cuandoNull_noHaceNada() {
        service.enrich((List<OperacionResponse>) null);
        verifyNoInteractions(otRepository);
    }

    @Test
    void enrichList_conLista_enriqueceCadaUno() {
        var resp = OperacionResponse.builder().ordenTrabajoId(1L).build();
        when(otRepository.findById(1L)).thenReturn(Optional.of(otActiva()));

        service.enrich(List.of(resp));

        assertThat(resp.getOrdenTrabajoCodigo()).isNotNull();
    }

    // ==================== enrichDetalles ====================

    @Test
    void enrichDetalles_cuandoNull_noHaceNada() {
        service.enrichDetalles(null);
        verifyNoInteractions(coreArticuloClient);
    }

    @Test
    void enrichDetalles_conLista_enriqueceArticulos() {
        var det = OperacionDetResponse.builder().articuloId(1L).build();
        var artResp = ApiResponse.<pe.restaurant.produccion.client.dto.ArticuloResponse>builder()
                .success(true)
                .data(pe.restaurant.produccion.client.dto.ArticuloResponse.builder()
                        .id(1L).codigo("ART1").nombre("A1").build())
                .build();
        when(coreArticuloClient.obtenerPorId(1L)).thenReturn(artResp);

        service.enrichDetalles(List.of(det));

        assertThat(det.getArticuloCodigo()).isEqualTo("ART1");
    }

    // ==================== validarArticuloExiste failure paths ====================

    @Test
    void create_cuandoArticuloFeignFalla_lanzaBusinessException() {
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        when(query.getSingleResult()).thenReturn(0);
        entity.setFecInicio(LocalDate.now());
        when(coreArticuloClient.obtenerPorId(anyLong())).thenThrow(mock(FeignException.class));

        assertThatThrownBy(() -> service.create(entity, detalles))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("artículo");
    }

    @Test
    void create_cuandoArticuloInexistente_lanzaBusinessException() {
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        when(query.getSingleResult()).thenReturn(0);
        entity.setFecInicio(LocalDate.now());
        var failResp = ApiResponse.<pe.restaurant.produccion.client.dto.ArticuloResponse>builder()
                .success(false).build();
        when(coreArticuloClient.obtenerPorId(anyLong())).thenReturn(failResp);

        assertThatThrownBy(() -> service.create(entity, detalles))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("artículo");
    }

    @Test
    void create_conFlagEstadoBlank_asignaActivo() {
        mockArticuloOk();
        entity.setFlagEstado("");
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        when(query.getSingleResult()).thenReturn(0);
        when(repository.save(any(Operacion.class))).thenAnswer(i -> i.getArgument(0));

        Operacion result = service.create(entity, detalles);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    // ==================== validarLaborExiste, validarEjecutorExiste, etc ====================

    @Test
    void create_cuandoLaborInexistente_lanzaBusinessException() {
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        when(query.getSingleResult()).thenReturn(0, 0);
        entity.setFecInicio(LocalDate.now());
        entity.setLaborId(999L);

        assertThatThrownBy(() -> service.create(entity, detalles))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("labor");
    }

    @Test
    void create_cuandoEjecutorInexistente_lanzaBusinessException() {
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        when(query.getSingleResult()).thenReturn(0, 0);
        entity.setFecInicio(LocalDate.now());
        entity.setEjecutorId(999L);

        assertThatThrownBy(() -> service.create(entity, detalles))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ejecutor");
    }

    @Test
    void create_cuandoEntidadContribuyenteInexistente_lanzaBusinessException() {
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        when(query.getSingleResult()).thenReturn(0, 0);
        entity.setFecInicio(LocalDate.now());
        entity.setEntidadContribuyenteId(999L);

        assertThatThrownBy(() -> service.create(entity, detalles))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("entidad");
    }

    @Test
    void create_cuandoCentroCostoInexistente_lanzaBusinessException() {
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        when(query.getSingleResult()).thenReturn(0, 0);
        entity.setFecInicio(LocalDate.now());
        entity.setCentrosCostoId(999L);

        assertThatThrownBy(() -> service.create(entity, detalles))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("centro de costo");
    }

    @Test
    void create_cuandoUnidadMedidaInexistente_lanzaBusinessException() {
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        when(query.getSingleResult()).thenReturn(0, 0);
        entity.setFecInicio(LocalDate.now());
        entity.setUnidadMedidaId(999L);

        assertThatThrownBy(() -> service.create(entity, detalles))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("unidad de medida");
    }

    // ==================== validarCantidadPositiva ====================

    @Test
    void create_cuandoDetalleCantidadInvalida_lanzaBusinessException() {
        mockArticuloOk();
        when(otRepository.findById(anyLong())).thenReturn(Optional.of(otActiva()));
        when(query.getSingleResult()).thenReturn(0);
        entity.setFecInicio(LocalDate.now());

        var detInvalido = ProduccionTestFixtures.operacionesDet(1L);
        detInvalido.setCantidadRequerida(BigDecimal.ZERO);

        assertThatThrownBy(() -> service.create(entity, List.of(detInvalido)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("cantidad");
    }

    // ==================== enrichArticulo silent skip ====================

    @Test
    void enrich_cuandoArticuloResponseNoExitoso_noSeteaDatos() {
        var det = OperacionDetResponse.builder().articuloId(1L).build();
        var resp = OperacionResponse.builder().ordenTrabajoId(1L).detalles(List.of(det)).build();
        when(otRepository.findById(1L)).thenReturn(Optional.of(otActiva()));
        var failResp = ApiResponse.<pe.restaurant.produccion.client.dto.ArticuloResponse>builder()
                .success(false).build();
        when(coreArticuloClient.obtenerPorId(1L)).thenReturn(failResp);

        service.enrich(resp);

        assertThat(det.getArticuloCodigo()).isNull();
    }

    @Test
    void enrich_cuandoArticuloResponseDataNull_noSeteaDatos() {
        var det = OperacionDetResponse.builder().articuloId(1L).build();
        var resp = OperacionResponse.builder().ordenTrabajoId(1L).detalles(List.of(det)).build();
        when(otRepository.findById(1L)).thenReturn(Optional.of(otActiva()));
        var nullDataResp = ApiResponse.<pe.restaurant.produccion.client.dto.ArticuloResponse>builder()
                .success(true).data(null).build();
        when(coreArticuloClient.obtenerPorId(1L)).thenReturn(nullDataResp);

        service.enrich(resp);

        assertThat(det.getArticuloCodigo()).isNull();
    }
}
