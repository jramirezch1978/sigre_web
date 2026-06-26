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
import pe.restaurant.produccion.client.CoreSucursalClient;
import pe.restaurant.produccion.client.CoreUnidadMedidaClient;
import pe.restaurant.produccion.client.dto.SucursalResponse;
import pe.restaurant.produccion.dto.response.*;
import pe.restaurant.produccion.entity.*;
import pe.restaurant.produccion.event.publisher.ProduccionEventPublisher;
import pe.restaurant.produccion.repository.*;
import pe.restaurant.produccion.service.ProduccionErrorCodes;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("OrdenTrabajoServiceImpl — Pruebas Unitarias")
class OrdenTrabajoServiceImplTest {

    @Mock private OrdenTrabajoRepository repository;
    @Mock private CoreSucursalClient coreSucursalClient;
    @Mock private CoreArticuloClient coreArticuloClient;
    @Mock private CoreUnidadMedidaClient coreUnidadMedidaClient;
    @Mock private OtTipoRepository otTipoRepository;
    @Mock private OtAdministracionRepository otAdministracionRepository;
    @Mock private OperacionRepository operacionRepository;
    @Mock private OperacionesDetRepository operacionesDetRepository;
    @Mock private LaborRepository laborRepository;
    @Mock private ProduccionEventPublisher eventPublisher;
    @Mock private EntityManager entityManager;
    @Mock private Query query;

    private OrdenTrabajoServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new OrdenTrabajoServiceImpl(repository, coreSucursalClient,
                coreArticuloClient, coreUnidadMedidaClient, otTipoRepository,
                otAdministracionRepository, operacionRepository, operacionesDetRepository,
                laborRepository, eventPublisher);
        ReflectionTestUtils.setField(service, "entityManager", entityManager);
        TenantContext.setEmpresaId(1L);
        TenantContext.setSucursalId(1L);
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    private OrdenTrabajo entity(String flagEstado) {
        return ProduccionTestFixtures.ordenTrabajo(1L, flagEstado);
    }

    private void mockSucursalOk() {
        var sucursal = SucursalResponse.builder().id(1L).nombre("Test").flagEstado("1").build();
        var resp = ApiResponse.<SucursalResponse>builder().success(true).data(sucursal).build();
        when(coreSucursalClient.obtenerPorId(anyLong())).thenReturn(resp);
    }

    private void mockOtTipoOk() {
        when(entityManager.createNativeQuery(contains("ot_tipo"))).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1);
    }

    private void mockOtAdminOk() {
        when(entityManager.createNativeQuery(contains("ot_administracion"))).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1);
    }

    private void mockValidacionesOk() {
        mockSucursalOk();
        mockOtTipoOk();
        mockOtAdminOk();
    }

    // ==================== findById ====================

    @Test
    void findById_cuandoExisteId_retornaEntidad() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity("1")));

        OrdenTrabajo result = service.findById(1L);

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
                .thenReturn(new PageImpl<>(List.of(entity("1"))));

        Page<OrdenTrabajo> result = service.findAll("OT-", 1L, 1L, 1L,
                LocalDate.now(), LocalDate.now(), "1", pageable);

        assertThat(result).hasSize(1);
    }

    @Test
    void findAll_sinFiltros_retornaPage() {
        var pageable = PageRequest.of(0, 10);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        Page<OrdenTrabajo> result = service.findAll(null, null, null, null,
                null, null, null, pageable);

        assertThat(result).isEmpty();
    }

    // ==================== create ====================

    @Test
    void create_conDatosValidos_guardaYRetorna() {
        mockValidacionesOk();
        when(repository.save(any(OrdenTrabajo.class))).thenAnswer(i -> i.getArgument(0));

        OrdenTrabajo result = service.create(entity("1"));

        assertThat(result).isNotNull();
        assertThat(result.getCreatedBy()).isEqualTo(1L);
        verify(repository).save(any(OrdenTrabajo.class));
    }

    @Test
    void create_sinFlagEstado_asignaActivo() {
        mockValidacionesOk();
        when(repository.save(any(OrdenTrabajo.class))).thenAnswer(i -> i.getArgument(0));

        OrdenTrabajo entity = entity("1");
        entity.setFlagEstado(null);
        OrdenTrabajo result = service.create(entity);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void create_conCodigoGenerado_autoAsigna() {
        mockValidacionesOk();
        OrdenTrabajo entity = entity("1");
        entity.setCodigo(null);
        when(repository.maxSecuenciaByAnio(anyString())).thenReturn(0);
        when(repository.save(any(OrdenTrabajo.class))).thenAnswer(i -> i.getArgument(0));

        OrdenTrabajo result = service.create(entity);

        assertThat(result.getCodigo()).startsWith("OT-");
    }

    @Test
    void create_conCodigoDuplicado_lanzaBusinessException() {
        mockValidacionesOk();
        when(repository.existsByCodigo(anyString())).thenReturn(true);

        assertThatThrownBy(() -> service.create(entity("1")))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("código");
    }

    @Test
    void create_cuandoSucursalInvalida_lanzaBusinessException() {
        var resp = ApiResponse.<SucursalResponse>builder().success(false).build();
        when(coreSucursalClient.obtenerPorId(anyLong())).thenReturn(resp);

        assertThatThrownBy(() -> service.create(entity("1")))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("sucursal");
    }

    @Test
    void create_cuandoSucursalFeignFalla_lanzaBusinessException() {
        when(coreSucursalClient.obtenerPorId(anyLong())).thenThrow(mock(FeignException.class));

        assertThatThrownBy(() -> service.create(entity("1")))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("sucursal");
    }

    @Test
    void create_cuandoOtTipoNoExiste_lanzaBusinessException() {
        mockSucursalOk();
        when(entityManager.createNativeQuery(contains("ot_tipo"))).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(0);

        assertThatThrownBy(() -> service.create(entity("1")))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("tipo de OT");
    }

    @Test
    void create_cuandoOtAdminNoExiste_lanzaBusinessException() {
        mockSucursalOk();
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1, 0);

        assertThatThrownBy(() -> service.create(entity("1")))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("administración de OT");
    }

    @Test
    void create_cuandoFechaInicioNull_lanzaBusinessException() {
        mockSucursalOk();
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1, 1);
        OrdenTrabajo entity = entity("1");
        entity.setFechaInicio(null);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("fecha de inicio");
    }

    @Test
    void create_cuandoFechaFinAntesFechaInicio_lanzaBusinessException() {
        mockValidacionesOk();
        OrdenTrabajo entity = entity("1");
        entity.setFechaInicio(LocalDate.of(2025, 6, 15));
        entity.setFechaFin(LocalDate.of(2025, 6, 10));

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("fecha fin");
    }

    // ==================== update ====================

    @Test
    void update_conDatosValidos_actualizaYRetorna() {
        OrdenTrabajo existing = entity("1");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        mockValidacionesOk();
        when(repository.save(any(OrdenTrabajo.class))).thenAnswer(i -> i.getArgument(0));

        OrdenTrabajo entity = entity("1");
        entity.setFechaInicio(LocalDate.of(2025, 5, 1));
        entity.setFechaFin(LocalDate.of(2025, 5, 15));
        OrdenTrabajo result = service.update(1L, entity);

        assertThat(result.getFechaInicio()).isEqualTo(LocalDate.of(2025, 5, 1));
        assertThat(result.getFechaFin()).isEqualTo(LocalDate.of(2025, 5, 15));
        verify(repository).save(existing);
    }

    @Test
    void update_cuandoOTInactiva_lanzaBusinessException() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity("0")));

        assertThatThrownBy(() -> service.update(1L, entity("1")))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("no está en estado activa");
    }

    // ==================== activate ====================

    @Test
    void activate_cuandoInactiva_cambiaFlagEstado() {
        OrdenTrabajo inactive = entity("0");
        when(repository.findById(1L)).thenReturn(Optional.of(inactive));
        when(repository.save(any(OrdenTrabajo.class))).thenAnswer(i -> i.getArgument(0));

        OrdenTrabajo result = service.activate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void activate_cuandoYaActiva_lanzaBusinessException() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity("1")));

        assertThatThrownBy(() -> service.activate(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ya se encuentra activa");
    }

    @Test
    void activate_cuandoCerrada_lanzaBusinessException() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity("2")));

        assertThatThrownBy(() -> service.activate(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("cerrada");
    }

    // ==================== deactivate ====================

    @Test
    void deactivate_cambiaFlagEstado() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity("1")));
        when(repository.save(any(OrdenTrabajo.class))).thenAnswer(i -> i.getArgument(0));

        OrdenTrabajo result = service.deactivate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    @Test
    void deactivate_cuandoYaInactiva_lanzaBusinessException() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity("0")));

        assertThatThrownBy(() -> service.deactivate(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("no está en estado activa");
    }

    // ==================== cerrar ====================

    @Test
    void cerrar_cambiaEstado() {
        OrdenTrabajo ot = entity("1");
        ot.setFechaFin(null);
        when(repository.findById(1L)).thenReturn(Optional.of(ot));
        when(operacionRepository.countByOrdenTrabajoIdAndFlagEstado(1L, "1")).thenReturn(1L);
        when(repository.save(any(OrdenTrabajo.class))).thenAnswer(i -> i.getArgument(0));

        OrdenTrabajo result = service.cerrar(1L);

        assertThat(result.getFlagEstado()).isEqualTo("2");
        assertThat(result.getFechaFin()).isNotNull();
        verify(eventPublisher).publicarOrdenCompletada(any(OrdenTrabajo.class));
    }

    @Test
    @DisplayName("cerrar() sin operaciones activas -> PRD-OT-015")
    void cerrar_sinOperaciones_lanzaBusinessException() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity("1")));
        when(operacionRepository.countByOrdenTrabajoIdAndFlagEstado(1L, "1")).thenReturn(0L);

        assertThatThrownBy(() -> service.cerrar(1L))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", ProduccionErrorCodes.OT_SIN_OPERACIONES);
    }

    @Test
    void cerrar_cuandoTieneFechaFin_noSobrescribe() {
        OrdenTrabajo ot = entity("1");
        ot.setFechaFin(LocalDate.of(2025, 5, 1));
        when(repository.findById(1L)).thenReturn(Optional.of(ot));
        when(operacionRepository.countByOrdenTrabajoIdAndFlagEstado(1L, "1")).thenReturn(1L);
        when(repository.save(any(OrdenTrabajo.class))).thenAnswer(i -> i.getArgument(0));

        OrdenTrabajo result = service.cerrar(1L);

        assertThat(result.getFlagEstado()).isEqualTo("2");
        assertThat(result.getFechaFin()).isEqualTo(LocalDate.of(2025, 5, 1));
    }

    // ==================== anular ====================

    @Test
    void anular_cambiaEstado() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity("1")));
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(0L);
        when(repository.save(any(OrdenTrabajo.class))).thenAnswer(i -> i.getArgument(0));

        OrdenTrabajo result = service.anular(1L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
        verify(eventPublisher).publicarOrdenCancelada(any(OrdenTrabajo.class));
    }

    @Test
    @DisplayName("anular() con vales vinculados -> PRD-OT-ANULAR-VALE")
    void anular_conVales_lanzaBusinessException() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity("1")));
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1L, 0L, 0L);

        assertThatThrownBy(() -> service.anular(1L))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", ProduccionErrorCodes.OT_ANULAR_VALE);
    }

    // ==================== delete ====================

    @Test
    void delete_desactivaLogico() {
        OrdenTrabajo ot = entity("1");
        when(repository.findById(1L)).thenReturn(Optional.of(ot));
        when(repository.save(any(OrdenTrabajo.class))).thenAnswer(i -> i.getArgument(0));

        service.delete(1L);

        assertThat(ot.getFlagEstado()).isEqualTo("0");
        verify(repository).save(ot);
    }

    // ==================== enrich ====================

    @Test
    void enrich_cuandoResponseNull_noHaceNada() {
        service.enrich(null);
        verifyNoInteractions(coreSucursalClient, otTipoRepository, otAdministracionRepository);
    }

    @Test
    void enrich_conSucursalValida_seteaNombre() {
        var resp = OrdenTrabajoResponse.builder()
                .sucursal(SucursalInfo.builder().id(1L).build())
                .otTipo(OtTipoInfo.builder().id(1L).build())
                .otAdministracion(OtAdministracionInfo.builder().id(1L).build())
                .build();
        var sucResp = ApiResponse.<SucursalResponse>builder().success(true)
                .data(SucursalResponse.builder().id(1L).nombre("Sucursal Test").build()).build();
        when(coreSucursalClient.obtenerPorId(1L)).thenReturn(sucResp);
        when(otTipoRepository.findById(1L)).thenReturn(Optional.of(ProduccionTestFixtures.otTipo(1L, "1")));
        when(otAdministracionRepository.findById(1L))
                .thenReturn(Optional.of(ProduccionTestFixtures.otAdministracion(1L, "1")));

        service.enrich(resp);

        assertThat(resp.getSucursal().getNombre()).isEqualTo("Sucursal Test");
        verify(otTipoRepository).findById(1L);
        verify(otAdministracionRepository).findById(1L);
    }

    @Test
    void enrich_conSucursalFalloFeign_noLanzaExcepcion() {
        var resp = OrdenTrabajoResponse.builder()
                .sucursal(SucursalInfo.builder().id(1L).build())
                .build();
        when(coreSucursalClient.obtenerPorId(1L)).thenThrow(mock(FeignException.class));

        service.enrich(resp);

        assertThat(resp.getSucursal().getNombre()).isNull();
    }

    @Test
    void enrich_cuandoSucursalNull_skpea() {
        var resp = OrdenTrabajoResponse.builder().build();
        resp.setSucursal(null);

        service.enrich(resp);

        verifyNoInteractions(coreSucursalClient);
    }

    @Test
    void enrich_cuandoSucursalSinId_skpea() {
        var resp = OrdenTrabajoResponse.builder()
                .sucursal(SucursalInfo.builder().build())
                .build();

        service.enrich(resp);

        verifyNoInteractions(coreSucursalClient);
    }

    // ==================== enrichDetail ====================

    @Test
    void enrichDetail_sinOperaciones_noAgregaOperaciones() {
        var resp = OrdenTrabajoResponse.builder()
                .id(1L)
                .sucursal(SucursalInfo.builder().id(1L).build())
                .build();
        var sucResp = ApiResponse.<SucursalResponse>builder().success(true)
                .data(SucursalResponse.builder().id(1L).nombre("Suc Test").build()).build();
        when(coreSucursalClient.obtenerPorId(1L)).thenReturn(sucResp);
        when(operacionRepository.findByOrdenTrabajoIdOrderByIdAsc(1L)).thenReturn(List.of());

        service.enrichDetail(resp);

        assertThat(resp.getOperaciones()).isNull();
    }

    @Test
    void enrichDetail_conOperaciones_pueblaOperaciones() {
        var resp = OrdenTrabajoResponse.builder().id(1L).build();

        var op = new Operacion();
        op.setId(10L);
        op.setNroOperacion(1);
        op.setOrdenTrabajoId(1L);
        op.setDescripcion("Op test");

        var det = new OperacionesDet();
        det.setId(100L);
        det.setOperacionId(10L);
        det.setArticuloId(1L);
        det.setCantidadRequerida(BigDecimal.TEN);

        when(operacionRepository.findByOrdenTrabajoIdOrderByIdAsc(1L)).thenReturn(List.of(op));
        when(operacionesDetRepository.findByOperacionIdOrderByIdAsc(10L)).thenReturn(List.of(det));
        when(coreArticuloClient.obtenerPorId(1L))
                .thenReturn(ApiResponse.<pe.restaurant.produccion.client.dto.ArticuloResponse>builder()
                        .success(true)
                        .data(pe.restaurant.produccion.client.dto.ArticuloResponse.builder()
                                .id(1L).nombre("Art Test").build())
                        .build());

        service.enrichDetail(resp);

        assertThat(resp.getOperaciones()).hasSize(1);
        assertThat(resp.getOperaciones().getFirst().getDetalles()).hasSize(1);
    }

    @Test
    void enrichDetail_conOperacionConEjecutor_enriqueceEjecutor() {
        var resp = OrdenTrabajoResponse.builder().id(1L).build();

        var op = new Operacion();
        op.setId(10L);
        op.setNroOperacion(1);
        op.setEjecutorId(1L);

        when(operacionRepository.findByOrdenTrabajoIdOrderByIdAsc(1L)).thenReturn(List.of(op));
        when(operacionesDetRepository.findByOperacionIdOrderByIdAsc(10L)).thenReturn(List.of());
        when(entityManager.createNativeQuery(contains("ejecutor"))).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn("Ejecutor Test");

        service.enrichDetail(resp);

        assertThat(resp.getOperaciones().getFirst().getEjecutor().getNombre())
                .isEqualTo("Ejecutor Test");
    }

    @Test
    void enrichDetail_conArticuloFalloFeign_noLanzaExcepcion() {
        var resp = OrdenTrabajoResponse.builder().id(1L).build();

        var op = new Operacion();
        op.setId(10L);
        op.setNroOperacion(1);

        var det = new OperacionesDet();
        det.setId(100L);
        det.setOperacionId(10L);
        det.setArticuloId(1L);

        when(operacionRepository.findByOrdenTrabajoIdOrderByIdAsc(1L)).thenReturn(List.of(op));
        when(operacionesDetRepository.findByOperacionIdOrderByIdAsc(10L)).thenReturn(List.of(det));
        when(coreArticuloClient.obtenerPorId(1L)).thenThrow(mock(FeignException.class));

        service.enrichDetail(resp);

        assertThat(resp.getOperaciones().getFirst().getDetalles().getFirst().getArticulo())
                .isNull();
    }

    @Test
    void enrichDetail_conOperacionConLabor_enriqueceLabor() {
        var resp = OrdenTrabajoResponse.builder().id(1L).build();

        var op = new Operacion();
        op.setId(10L);
        op.setNroOperacion(1);
        op.setLaborId(1L);

        when(operacionRepository.findByOrdenTrabajoIdOrderByIdAsc(1L)).thenReturn(List.of(op));
        when(operacionesDetRepository.findByOperacionIdOrderByIdAsc(10L)).thenReturn(List.of());
        var labor = new Labor();
        labor.setId(1L);
        labor.setNombre("Labor Test");
        when(laborRepository.findById(1L)).thenReturn(Optional.of(labor));

        service.enrichDetail(resp);

        assertThat(resp.getOperaciones().getFirst().getLabor().getNombre())
                .isEqualTo("Labor Test");
    }

    @Test
    void enrichDetail_conOperacionConEntidadContribuyente_enriquece() {
        var resp = OrdenTrabajoResponse.builder().id(1L).build();

        var op = new Operacion();
        op.setId(10L);
        op.setNroOperacion(1);
        op.setEntidadContribuyenteId(1L);

        when(operacionRepository.findByOrdenTrabajoIdOrderByIdAsc(1L)).thenReturn(List.of(op));
        when(operacionesDetRepository.findByOperacionIdOrderByIdAsc(10L)).thenReturn(List.of());
        when(entityManager.createNativeQuery(contains("entidad_contribuyente"))).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(new Object[]{1L, "Entidad Test"});

        service.enrichDetail(resp);

        assertThat(resp.getOperaciones().getFirst().getEntidadContribuyente().getRazonSocial())
                .isEqualTo("Entidad Test");
    }

    @Test
    void enrichDetail_conOperacionConCentrosCosto_enriquece() {
        var resp = OrdenTrabajoResponse.builder().id(1L).build();

        var op = new Operacion();
        op.setId(10L);
        op.setNroOperacion(1);
        op.setCentrosCostoId(1L);

        when(operacionRepository.findByOrdenTrabajoIdOrderByIdAsc(1L)).thenReturn(List.of(op));
        when(operacionesDetRepository.findByOperacionIdOrderByIdAsc(10L)).thenReturn(List.of());
        when(entityManager.createNativeQuery(contains("centros_costo"))).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn("CC Test");

        service.enrichDetail(resp);

        assertThat(resp.getOperaciones().getFirst().getCentrosCosto().getNombre())
                .isEqualTo("CC Test");
    }

    @Test
    void enrichDetail_conOperacionConUnidadMedida_enriquece() {
        var resp = OrdenTrabajoResponse.builder().id(1L).build();

        var op = new Operacion();
        op.setId(10L);
        op.setNroOperacion(1);
        op.setUnidadMedidaId(1L);

        when(operacionRepository.findByOrdenTrabajoIdOrderByIdAsc(1L)).thenReturn(List.of(op));
        when(operacionesDetRepository.findByOperacionIdOrderByIdAsc(10L)).thenReturn(List.of());
        var umResp = ApiResponse.<pe.restaurant.produccion.client.dto.UnidadMedidaResponse>builder()
                .success(true)
                .data(pe.restaurant.produccion.client.dto.UnidadMedidaResponse.builder()
                        .id(1L).nombre("KG").abreviatura("kg").build())
                .build();
        when(coreUnidadMedidaClient.obtenerPorId(1L)).thenReturn(umResp);

        service.enrichDetail(resp);

        assertThat(resp.getOperaciones().getFirst().getUnidadMedida().getNombre())
                .isEqualTo("KG");
    }
}
