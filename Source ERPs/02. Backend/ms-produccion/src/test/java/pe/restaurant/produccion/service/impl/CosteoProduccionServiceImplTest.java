package pe.restaurant.produccion.service.impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
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
import pe.restaurant.produccion.client.CoreSucursalClient;
import pe.restaurant.produccion.client.dto.SucursalResponse;
import pe.restaurant.produccion.dto.response.CosteoProduccionResponse;
import pe.restaurant.produccion.dto.response.ProcesarCosteoResponse;
import pe.restaurant.produccion.entity.CosteoProduccion;
import pe.restaurant.produccion.event.publisher.ProduccionEventPublisher;
import pe.restaurant.produccion.mapper.CosteoProduccionMapper;
import pe.restaurant.produccion.repository.CosteoProduccionRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CosteoProduccionServiceImpl — Pruebas Unitarias")
class CosteoProduccionServiceImplTest {

    @Mock private CosteoProduccionRepository repository;
    @Mock private CoreSucursalClient coreSucursalClient;
    @Mock private CosteoProduccionMapper mapper;
    @Mock private ProduccionEventPublisher eventPublisher;
    @Mock private EntityManager entityManager;
    @Mock private Query query;

    private CosteoProduccionServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new CosteoProduccionServiceImpl(repository, coreSucursalClient, mapper, eventPublisher);
        ReflectionTestUtils.setField(service, "entityManager", entityManager);
        TenantContext.setEmpresaId(1L);
        TenantContext.setSucursalId(1L);
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ==================== findById ====================

    @Test
    void findById_cuandoExisteId_retornaEntidad() {
        var entity = new CosteoProduccion();
        entity.setId(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        var result = service.findById(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository).findById(1L);
    }

    @Test
    void findById_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(999L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("999");
        verify(repository).findById(999L);
    }

    // ==================== findAll ====================

    @Test
    void findAll_conFiltros_retornaPage() {
        var pageable = PageRequest.of(0, 10);
        var entity = new CosteoProduccion();
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of(entity)));

        Page<CosteoProduccion> result = service.findAll(1L, 2025, 5, pageable);

        assertThat(result).hasSize(1);
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }

    @Test
    void findAll_sinFiltros_retornaPage() {
        var pageable = PageRequest.of(0, 10);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        Page<CosteoProduccion> result = service.findAll(null, null, null, pageable);

        assertThat(result).isEmpty();
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }

    // ==================== findByPeriodo ====================

    @Test
    void findByPeriodo_conPeriodoValido_retornaLista() {
        var entity = new CosteoProduccion();
        lenient().when(repository.findAllByAnioAndMes(2025, 5)).thenReturn(List.of(entity));

        var result = service.findByPeriodo(2025, 5);

        assertThat(result).hasSize(1);
        verify(repository).findAllByAnioAndMes(2025, 5);
    }

    @Test
    void findByPeriodo_cuandoAnioNull_lanzaBusinessException() {
        assertThatThrownBy(() -> service.findByPeriodo(null, 5))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("año es obligatorio");
    }

    @Test
    void findByPeriodo_cuandoMesNull_lanzaBusinessException() {
        assertThatThrownBy(() -> service.findByPeriodo(2025, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("mes es obligatorio");
    }

    @Test
    void findByPeriodo_cuandoAnioMenor2020_lanzaBusinessException() {
        assertThatThrownBy(() -> service.findByPeriodo(2019, 5))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("año debe ser mayor o igual a 2020");
    }

    @Test
    void findByPeriodo_cuandoMesInvalido_lanzaBusinessException() {
        assertThatThrownBy(() -> service.findByPeriodo(2025, 13))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("mes debe estar entre 1 y 12");
    }

    // ==================== guardar ====================

    @Test
    void guardar_cuandoAnioYMesNull_asignaFechaActual() {
        var entity = new CosteoProduccion();
        entity.setOrdenTrabajoId(1L);
        entity.setCostoTotal(BigDecimal.valueOf(100));

        when(repository.findByOrdenTrabajoIdAndAnioAndMes(anyLong(), anyInt(), anyInt()))
                .thenReturn(Optional.empty());
        when(repository.save(any(CosteoProduccion.class))).thenAnswer(inv -> inv.getArgument(0));

        var result = service.guardar(entity);

        assertThat(result.getAnio()).isEqualTo(LocalDate.now().getYear());
        assertThat(result.getMes()).isEqualTo(LocalDate.now().getMonthValue());
        verify(repository).save(entity);
    }

    @Test
    void guardar_cuandoExisteRegistro_actualizaExistente() {
        var entity = new CosteoProduccion();
        entity.setOrdenTrabajoId(1L);
        entity.setAnio(2025);
        entity.setMes(5);
        entity.setCostoTotal(BigDecimal.valueOf(100));

        var existing = new CosteoProduccion();
        existing.setId(1L);
        existing.setOrdenTrabajoId(1L);

        when(repository.findByOrdenTrabajoIdAndAnioAndMes(1L, 2025, 5))
                .thenReturn(Optional.of(existing));
        when(repository.save(any(CosteoProduccion.class))).thenAnswer(inv -> inv.getArgument(0));

        var result = service.guardar(entity);

        assertThat(result.getCostoTotal()).isEqualByComparingTo(BigDecimal.valueOf(100));
        verify(repository).save(existing);
    }

    @Test
    void guardar_cuandoNoExisteRegistro_creaNuevo() {
        var entity = new CosteoProduccion();
        entity.setOrdenTrabajoId(1L);
        entity.setAnio(2025);
        entity.setMes(5);
        entity.setCostoTotal(BigDecimal.valueOf(100));

        when(repository.findByOrdenTrabajoIdAndAnioAndMes(1L, 2025, 5))
                .thenReturn(Optional.empty());
        when(repository.save(any(CosteoProduccion.class))).thenAnswer(inv -> inv.getArgument(0));

        var result = service.guardar(entity);

        assertThat(result.getCreatedBy()).isEqualTo(1L);
        verify(repository).save(entity);
    }

    @Test
    void guardar_cuandoAnioInvalido_lanzaBusinessException() {
        var entity = new CosteoProduccion();
        entity.setOrdenTrabajoId(1L);
        entity.setAnio(2019);
        entity.setMes(5);

        assertThatThrownBy(() -> service.guardar(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("año debe ser mayor o igual a 2020");
    }

    // ==================== procesar ====================

    @Test
    void procesar_cuandoAnioNull_lanzaBusinessException() {
        assertThatThrownBy(() -> service.procesar(null, 5, null, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("año es obligatorio");
    }

    @Test
    void procesar_cuandoMesNull_lanzaBusinessException() {
        assertThatThrownBy(() -> service.procesar(2025, null, null, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("mes es obligatorio");
    }

    @Test
    void procesar_cuandoAnioMenor2020_lanzaBusinessException() {
        assertThatThrownBy(() -> service.procesar(2019, 5, null, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("año debe ser mayor o igual a 2020");
    }

    @Test
    void procesar_cuandoMesInvalido_lanzaBusinessException() {
        assertThatThrownBy(() -> service.procesar(2025, 0, null, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("mes debe estar entre 1 y 12");
    }

    @Test
    void procesar_cuandoSucursalInvalida_lanzaBusinessException() {
        var response = mock(ApiResponse.class);
        when(response.isSuccess()).thenReturn(false);
        when(coreSucursalClient.obtenerPorId(999L)).thenReturn(response);

        assertThatThrownBy(() -> service.procesar(2025, 5, 999L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("sucursal no existe");
    }

    @Test
    void procesar_cuandoSucursalInactiva_lanzaBusinessException() {
        var sucursal = SucursalResponse.builder().id(1L).flagEstado("0").build();
        var response = ApiResponse.<SucursalResponse>builder().success(true).data(sucursal).build();
        when(coreSucursalClient.obtenerPorId(1L)).thenReturn(response);

        assertThatThrownBy(() -> service.procesar(2025, 5, 1L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("sucursal no existe");
    }

    @Test
    void procesar_cuandoSucursalDataNull_lanzaBusinessException() {
        var response = ApiResponse.<SucursalResponse>builder().success(true).data(null).build();
        when(coreSucursalClient.obtenerPorId(1L)).thenReturn(response);

        assertThatThrownBy(() -> service.procesar(2025, 5, 1L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("sucursal no existe");
    }

    @Test
    void procesar_cuandoSinOtsEnPeriodo_lanzaBusinessException() {
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getResultList()).thenReturn(List.of());

        assertThatThrownBy(() -> service.procesar(2025, 5, null, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No se encontraron órdenes de trabajo");
    }

    private void setupNativeQueryMocks(Object[] row, Object... singleResults) {
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        @SuppressWarnings("rawtypes")
        List rawResultList = List.of((Object) row);
        when(query.getResultList()).thenReturn(rawResultList);
        if (singleResults.length > 0) {
            when(query.getSingleResult())
                    .thenReturn(singleResults[0],
                            java.util.Arrays.copyOfRange(singleResults, 1, singleResults.length));
        }
    }

    @Test
    void procesar_conDatosValidos_retornaResponse() {
        setupNativeQueryMocks(
                new Object[]{1L, BigDecimal.valueOf(100), BigDecimal.valueOf(80)},
                BigDecimal.TEN, BigDecimal.valueOf(5));
        when(repository.findByOrdenTrabajoIdAndAnioAndMes(1L, 2025, 5))
                .thenReturn(Optional.empty());
        when(repository.save(any(CosteoProduccion.class))).thenAnswer(inv -> inv.getArgument(0));

        var detalleResponse = CosteoProduccionResponse.builder()
                .id(1L).costoMateriaPrima(BigDecimal.valueOf(100))
                .costoManoObra(BigDecimal.TEN).costoIndirecto(BigDecimal.valueOf(5))
                .costoTotal(BigDecimal.valueOf(115)).build();
        when(mapper.toResponseList(anyList())).thenReturn(List.of(detalleResponse));

        ProcesarCosteoResponse result = service.procesar(2025, 5, null, null);

        assertThat(result).isNotNull();
        assertThat(result.getAnio()).isEqualTo(2025);
        assertThat(result.getMes()).isEqualTo(5);
        assertThat(result.getTotalOtsProcesadas()).isEqualTo(1);
        assertThat(result.getCostoMateriaPrimaTotal()).isEqualByComparingTo(BigDecimal.valueOf(100));
        assertThat(result.getCostoManoObraTotal()).isEqualByComparingTo(BigDecimal.TEN);
        assertThat(result.getCostoIndirectoTotal()).isEqualByComparingTo(BigDecimal.valueOf(5));
        assertThat(result.getCostoGranTotal()).isEqualByComparingTo(BigDecimal.valueOf(115));
        assertThat(result.getDetalle()).hasSize(1);
        verify(mapper).toResponseList(anyList());
    }

    @Test
    void procesar_conSucursalValida_filtraPorSucursal() {
        var sucursal = SucursalResponse.builder().id(1L).flagEstado("1").build();
        var response = ApiResponse.<SucursalResponse>builder().success(true).data(sucursal).build();
        when(coreSucursalClient.obtenerPorId(1L)).thenReturn(response);

        setupNativeQueryMocks(
                new Object[]{1L, BigDecimal.valueOf(50), BigDecimal.valueOf(30)},
                BigDecimal.ZERO, BigDecimal.ZERO);
        when(repository.findByOrdenTrabajoIdAndAnioAndMes(1L, 2025, 5))
                .thenReturn(Optional.empty());
        when(repository.save(any(CosteoProduccion.class))).thenAnswer(inv -> inv.getArgument(0));
        when(mapper.toResponseList(anyList())).thenReturn(List.of());

        service.procesar(2025, 5, 1L, null);

        verify(coreSucursalClient).obtenerPorId(1L);
    }

    @Test
    void procesar_calculaCostoUnitarioCorrectamente() {
        setupNativeQueryMocks(
                new Object[]{1L, BigDecimal.valueOf(100), BigDecimal.valueOf(20)},
                BigDecimal.TEN, BigDecimal.valueOf(5));
        when(repository.findByOrdenTrabajoIdAndAnioAndMes(1L, 2025, 5))
                .thenReturn(Optional.empty());
        when(repository.save(any(CosteoProduccion.class))).thenAnswer(inv -> {
            CosteoProduccion saved = inv.getArgument(0);
            saved.setId(1L);
            return saved;
        });
        var detalle = CosteoProduccionResponse.builder()
                .id(1L).costoUnitario(BigDecimal.valueOf(5.7500))
                .porcentajeMermaReal(BigDecimal.valueOf(80))
                .build();
        when(mapper.toResponseList(anyList())).thenReturn(List.of(detalle));

        ProcesarCosteoResponse result = service.procesar(2025, 5, null, null);

        assertThat(result.getDetalle().getFirst().getCostoUnitario())
                .isEqualByComparingTo(BigDecimal.valueOf(5.7500));
    }

    @Test
    void procesar_cuandoTotalProducidosCero_costoUnitarioCero() {
        setupNativeQueryMocks(
                new Object[]{1L, BigDecimal.valueOf(100), BigDecimal.ZERO},
                BigDecimal.TEN, BigDecimal.valueOf(5));
        when(repository.findByOrdenTrabajoIdAndAnioAndMes(1L, 2025, 5))
                .thenReturn(Optional.empty());
        when(repository.save(any(CosteoProduccion.class))).thenAnswer(inv -> inv.getArgument(0));
        when(mapper.toResponseList(anyList())).thenReturn(List.of());

        ProcesarCosteoResponse result = service.procesar(2025, 5, null, null);

        verify(repository, times(1)).save(any());
    }

    @Test
    void procesar_cuandoExisteCosteoPrev_actualizaExistente() {
        setupNativeQueryMocks(
                new Object[]{1L, BigDecimal.valueOf(100), BigDecimal.valueOf(80)},
                BigDecimal.TEN, BigDecimal.valueOf(5));

        var existing = new CosteoProduccion();
        existing.setId(1L);
        existing.setOrdenTrabajoId(1L);
        when(repository.findByOrdenTrabajoIdAndAnioAndMes(1L, 2025, 5))
                .thenReturn(Optional.of(existing));
        when(repository.save(any(CosteoProduccion.class))).thenAnswer(inv -> inv.getArgument(0));
        when(mapper.toResponseList(anyList())).thenReturn(List.of());

        service.procesar(2025, 5, null, null);

        assertThat(existing.getUpdatedBy()).isEqualTo(1L);
        verify(repository).save(existing);
    }

    @Test
    void procesar_cuandoTotalInsumosCero_porcentajeMermaCero() {
        setupNativeQueryMocks(
                new Object[]{1L, BigDecimal.ZERO, BigDecimal.ZERO},
                BigDecimal.ZERO, BigDecimal.ZERO);
        when(repository.findByOrdenTrabajoIdAndAnioAndMes(1L, 2025, 5))
                .thenReturn(Optional.empty());
        when(repository.save(any(CosteoProduccion.class))).thenAnswer(inv -> inv.getArgument(0));
        when(mapper.toResponseList(anyList())).thenReturn(List.of());

        ProcesarCosteoResponse result = service.procesar(2025, 5, null, null);

        assertThat(result.getTotalOtsProcesadas()).isEqualTo(1);
    }
}
