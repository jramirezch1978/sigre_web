package pe.restaurant.produccion.service.impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.produccion.ProduccionTestFixtures;
import pe.restaurant.produccion.dto.response.EjecutorResponse;
import pe.restaurant.produccion.entity.Ejecutor;
import pe.restaurant.produccion.repository.EjecutorRepository;

import java.util.List;
import java.util.Optional;

import org.springframework.test.util.ReflectionTestUtils;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("EjecutorServiceImpl — Pruebas Unitarias")
class EjecutorServiceImplTest {

    @Mock private EjecutorRepository repository;
    @Mock private EntityManager entityManager;
    @Mock private Query query;
    private EjecutorServiceImpl service;

    private Ejecutor entity;

    @BeforeEach
    void setUp() {
        service = new EjecutorServiceImpl(repository);
        ReflectionTestUtils.setField(service, "entityManager", entityManager);
        entity = ProduccionTestFixtures.ejecutor(1L, "1");
    }

    private void mockEntityManager(int count) {
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(count);
    }

    @Test
    @DisplayName("findById() con ID existente -> retorna entidad")
    void findById_cuandoExisteId_retornaEntidad() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        Ejecutor result = service.findById(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("findById() con ID inexistente -> lanza ResourceNotFoundException")
    void findById_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("create() con codigo unico y centrosCostoId valido -> guarda y retorna")
    void create_cuandoCodigoUnicoYCentrosCostoValido_guardaYRetorna() {
        entity.setCentrosCostoId(1L);
        mockEntityManager(1);
        when(repository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(false);
        when(repository.save(any(Ejecutor.class))).thenReturn(entity);

        Ejecutor result = service.create(entity);

        assertThat(result).isNotNull();
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("create() con codigo duplicado -> lanza BusinessException")
    void create_cuandoCodigoDuplicado_lanzaBusinessException() {
        when(repository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(true);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe");
    }

    @Test
    @DisplayName("create() con centrosCostoId invalido -> lanza BusinessException")
    void create_cuandoCentrosCostoNoExiste_lanzaBusinessException() {
        entity.setCentrosCostoId(999L);
        mockEntityManager(0);
        when(repository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(false);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("centro de costo");
    }

    @Test
    @DisplayName("activate() -> cambia flagEstado a 1")
    void activate_cambiaFlagEstado() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(Ejecutor.class))).thenReturn(entity);

        Ejecutor result = service.activate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("deactivate() -> cambia flagEstado a 0")
    void deactivate_cambiaFlagEstado() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(Ejecutor.class))).thenReturn(entity);

        Ejecutor result = service.deactivate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("delete() sin referencias -> desactiva (baja logica)")
    void delete_sinReferencias_desactiva() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        mockEntityManager(0);
        when(repository.save(any(Ejecutor.class))).thenReturn(entity);

        service.delete(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("delete() con referencias -> lanza BusinessException")
    void delete_cuandoTieneReferencias_lanzaBusinessException() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        mockEntityManager(1);

        assertThatThrownBy(() -> service.delete(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("labor_ejecutor");
    }

    @Test
    void findAll_conFiltros_retornaPage() {
        var pageable = org.springframework.data.domain.PageRequest.of(0, 10);
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable)))
                .thenReturn(new org.springframework.data.domain.PageImpl<>(List.of(entity)));

        var result = service.findAll("COD", "Nombre", "1", "0", pageable);

        assertThat(result).hasSize(1);
    }

    @Test
    void create_sinFlagEstado_asignaActivo() {
        entity.setFlagEstado(null);
        entity.setCentrosCostoId(null);
        when(repository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(false);
        when(repository.save(any(Ejecutor.class))).thenAnswer(i -> i.getArgument(0));

        var result = service.create(entity);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void create_sinFlagExterno_asignaCero() {
        entity.setFlagExterno(null);
        entity.setCentrosCostoId(null);
        when(repository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(false);
        when(repository.save(any(Ejecutor.class))).thenAnswer(i -> i.getArgument(0));

        var result = service.create(entity);

        assertThat(result.getFlagExterno()).isEqualTo("0");
    }

    @Test
    void update_conDatosValidos_actualizaYRetorna() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.existsByCodigoIgnoreCaseAndIdNot(anyString(), eq(1L))).thenReturn(false);
        when(repository.save(any(Ejecutor.class))).thenAnswer(i -> i.getArgument(0));

        var result = service.update(1L, entity);

        assertThat(result).isNotNull();
        verify(repository).save(any(Ejecutor.class));
    }

    @Test
    void enrich_cuandoListaNull_noHaceNada() {
        service.enrich(null);
        verifyNoInteractions(entityManager);
    }

    @Test
    void enrich_cuandoListaVacia_noHaceNada() {
        service.enrich(List.of());
        verifyNoInteractions(entityManager);
    }

    @Test
    void enrich_sinCentrosCostoId_noHaceQuery() {
        var resp = pe.restaurant.produccion.dto.response.EjecutorResponse.builder().id(1L).build();
        service.enrich(List.of(resp));
        verifyNoInteractions(entityManager);
    }

    @Test
    void enrich_conCentrosCostoId_enriquece() {
        var resp = pe.restaurant.produccion.dto.response.EjecutorResponse.builder()
                .id(1L).centrosCostoId(10L).build();
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        @SuppressWarnings("rawtypes")
        List rows = List.of((Object) new Object[]{10L, "CC Test"});
        lenient().when(query.getResultList()).thenReturn(rows);

        service.enrich(List.of(resp));

        assertThat(resp.getCentrosCostoNombre()).isEqualTo("CC Test");
    }
}