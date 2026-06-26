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
import pe.restaurant.produccion.dto.response.RecetaConsumibleResponse;
import pe.restaurant.produccion.dto.response.RecetaLaborResponse;
import pe.restaurant.produccion.dto.response.RecetaResponse;
import pe.restaurant.produccion.entity.FichaTecnica;
import pe.restaurant.produccion.entity.Receta;
import pe.restaurant.produccion.entity.RecetaLabor;
import pe.restaurant.produccion.entity.RecetaLaborConsumible;
import pe.restaurant.produccion.repository.FichaTecnicaRepository;
import pe.restaurant.produccion.repository.RecetaLaborConsumibleRepository;
import pe.restaurant.produccion.repository.RecetaLaborRepository;
import pe.restaurant.produccion.repository.RecetaRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("RecetaServiceImpl — Pruebas Unitarias")
class RecetaServiceImplTest {

    @Mock private RecetaRepository recetaRepository;
    @Mock private RecetaLaborRepository recetaLaborRepository;
    @Mock private RecetaLaborConsumibleRepository consumibleRepository;
    @Mock private FichaTecnicaRepository fichaTecnicaRepository;
    @Mock private CoreArticuloClient coreArticuloClient;
    @Mock private EntityManager entityManager;
    @Mock private Query query;

    private RecetaServiceImpl service;
    private Receta entity;
    private List<RecetaLabor> labores;
    private FichaTecnica fichaTecnica;

    @BeforeEach
    void setUp() {
        service = new RecetaServiceImpl(recetaRepository, recetaLaborRepository,
                consumibleRepository, fichaTecnicaRepository, coreArticuloClient);
        ReflectionTestUtils.setField(service, "entityManager", entityManager);
        entity = ProduccionTestFixtures.receta(1L, "1");
        labores = List.of(ProduccionTestFixtures.recetaLabor(1L));
        fichaTecnica = ProduccionTestFixtures.fichaTecnica(1L);

        TenantContext.setEmpresaId(1L);
        TenantContext.setSucursalId(1L);
        TenantContext.setUsuarioId(1L);

        var articleResponse = ApiResponse.<pe.restaurant.produccion.client.dto.ArticuloResponse>builder()
                .success(true)
                .data(ProduccionTestFixtures.articuloResponse())
                .build();
        lenient().when(coreArticuloClient.obtenerPorId(anyLong())).thenReturn(articleResponse);

        lenient().when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        lenient().when(query.setParameter(anyString(), any())).thenReturn(query);
        lenient().when(query.getSingleResult()).thenReturn(1);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ==================== findById ====================

    @Test
    void findById_cuandoExisteId_retornaEntidad() {
        when(recetaRepository.findById(1L)).thenReturn(Optional.of(entity));

        Receta result = service.findById(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    void findById_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(recetaRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ==================== findAll ====================

    @Test
    void findAll_conFiltros_retornaPage() {
        var pageable = PageRequest.of(0, 10);
        when(recetaRepository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of(entity)));

        Page<Receta> result = service.findAll("REC-", "Test", "P", "1", 1L, pageable);

        assertThat(result).hasSize(1);
    }

    @Test
    void findAll_sinFiltros_retornaPage() {
        var pageable = PageRequest.of(0, 10);
        when(recetaRepository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        Page<Receta> result = service.findAll(null, null, null, null, null, pageable);

        assertThat(result).isEmpty();
    }

    // ==================== create ====================

    @Test
    void create_conDatosValidos_guardaTodo() {
        when(recetaRepository.existsByNroRecetaIgnoreCase(entity.getNroReceta())).thenReturn(false);
        when(recetaRepository.save(any(Receta.class))).thenReturn(entity);

        Receta result = service.create(entity, labores, List.of(), fichaTecnica);

        assertThat(result).isNotNull();
        assertThat(result.getCreatedBy()).isEqualTo(1L);
        verify(recetaRepository).save(any(Receta.class));
        verify(recetaLaborRepository).save(any(RecetaLabor.class));
        verify(fichaTecnicaRepository).save(any(FichaTecnica.class));
    }

    @Test
    void create_conNroRecetaDuplicado_lanzaBusinessException() {
        when(recetaRepository.existsByNroRecetaIgnoreCase(entity.getNroReceta())).thenReturn(true);

        assertThatThrownBy(() -> service.create(entity, labores, List.of(), fichaTecnica))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe");
        verify(recetaRepository, never()).save(any());
    }

    @Test
    void create_conSecuenciaDuplicada_lanzaBusinessException() {
        when(recetaRepository.existsByNroRecetaIgnoreCase(entity.getNroReceta())).thenReturn(false);
        when(recetaRepository.save(any(Receta.class))).thenReturn(entity);
        RecetaLabor labor1 = ProduccionTestFixtures.recetaLabor(1L);
        RecetaLabor labor2 = ProduccionTestFixtures.recetaLabor(2L);
        labor2.setSecuencia(1);

        assertThatThrownBy(() -> service.create(entity, List.of(labor1, labor2), List.of(), fichaTecnica))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Secuencia duplicada");
    }

    @Test
    void create_sinFlagEstado_asignaActivo() {
        entity.setFlagEstado(null);
        when(recetaRepository.existsByNroRecetaIgnoreCase(entity.getNroReceta())).thenReturn(false);
        when(recetaRepository.save(any(Receta.class))).thenAnswer(i -> i.getArgument(0));

        Receta result = service.create(entity, null, null, null);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void create_sinVersion_asignaUno() {
        entity.setVersion(null);
        when(recetaRepository.existsByNroRecetaIgnoreCase(entity.getNroReceta())).thenReturn(false);
        when(recetaRepository.save(any(Receta.class))).thenAnswer(i -> i.getArgument(0));

        Receta result = service.create(entity, null, null, null);

        assertThat(result.getVersion()).isEqualTo(1);
    }

    @Test
    void create_sinLaboresConsumiblesNiFicha_noGuardaColecciones() {
        when(recetaRepository.existsByNroRecetaIgnoreCase(entity.getNroReceta())).thenReturn(false);
        when(recetaRepository.save(any(Receta.class))).thenReturn(entity);

        service.create(entity, null, null, null);

        verify(recetaLaborRepository, never()).save(any());
        verify(consumibleRepository, never()).save(any());
        verify(fichaTecnicaRepository, never()).save(any());
    }

    @Test
    void create_cuandoArticuloFeignFalla_lanzaBusinessException() {
        when(coreArticuloClient.obtenerPorId(anyLong())).thenThrow(mock(FeignException.class));

        assertThatThrownBy(() -> service.create(entity, labores, List.of(), fichaTecnica))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("articulo producido");
    }

    // ==================== update ====================

    @Test
    void update_conRecetaActiva_actualizaYSincroniza() {
        Receta existing = ProduccionTestFixtures.receta(1L, "1");
        when(recetaRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(recetaRepository.existsByNroRecetaIgnoreCaseAndIdNot(entity.getNroReceta(), 1L)).thenReturn(false);
        when(recetaRepository.save(any(Receta.class))).thenReturn(existing);

        Receta result = service.update(1L, entity, labores, List.of(), fichaTecnica);

        assertThat(result).isNotNull();
        verify(recetaLaborRepository).deleteByRecetaId(1L);
        verify(fichaTecnicaRepository).deleteByRecetaId(1L);
    }

    @Test
    void update_conRecetaInactiva_lanzaBusinessException() {
        Receta inactive = ProduccionTestFixtures.receta(1L, "0");
        when(recetaRepository.findById(1L)).thenReturn(Optional.of(inactive));

        assertThatThrownBy(() -> service.update(1L, entity, labores, List.of(), fichaTecnica))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("inactiva");
    }

    // ==================== activate / deactivate ====================

    @Test
    void activate_cambiaFlagEstado() {
        when(recetaRepository.findById(1L)).thenReturn(Optional.of(entity));
        when(recetaRepository.save(any(Receta.class))).thenReturn(entity);

        Receta result = service.activate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void deactivate_sinProgramaciones_cambiaFlagEstado() {
        reset(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(0);
        when(recetaRepository.findById(1L)).thenReturn(Optional.of(entity));
        when(recetaRepository.save(any(Receta.class))).thenReturn(entity);

        Receta result = service.deactivate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    @Test
    void deactivate_conProgramaciones_lanzaBusinessException() {
        when(recetaRepository.findById(1L)).thenReturn(Optional.of(entity));
        when(query.getSingleResult()).thenReturn(2);

        assertThatThrownBy(() -> service.deactivate(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("programacion");
    }

    // ==================== delete ====================

    @Test
    void delete_desactiva() {
        when(recetaRepository.findById(1L)).thenReturn(Optional.of(entity));
        when(recetaRepository.save(any(Receta.class))).thenReturn(entity);

        service.delete(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
    }

    // ==================== nuevaVersion ====================

    @Test
    void nuevaVersion_copiaTodoYDesactivaOriginal() {
        Receta source = ProduccionTestFixtures.receta(1L, "1");
        source.setVersion(1);
        when(recetaRepository.findById(1L)).thenReturn(Optional.of(source));
        when(recetaRepository.save(any(Receta.class))).thenAnswer(i -> i.getArgument(0));

        RecetaLabor labor = ProduccionTestFixtures.recetaLabor(1L);
        when(recetaLaborRepository.findByRecetaIdOrderBySecuenciaAsc(1L)).thenReturn(List.of(labor));

        RecetaLaborConsumible cons = new RecetaLaborConsumible();
        cons.setArticuloId(100L);
        cons.setCantidad(java.math.BigDecimal.TEN);
        when(consumibleRepository.findByRecetaPadreIdOrderByIdAsc(1L)).thenReturn(List.of(cons));

        FichaTecnica ft = ProduccionTestFixtures.fichaTecnica(1L);
        when(fichaTecnicaRepository.findByRecetaId(1L)).thenReturn(Optional.of(ft));

        Receta result = service.nuevaVersion(1L);

        assertThat(result.getVersion()).isEqualTo(2);
        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(source.getFlagEstado()).isEqualTo("0");
        verify(recetaLaborRepository).save(any(RecetaLabor.class));
        verify(consumibleRepository).save(any(RecetaLaborConsumible.class));
        verify(fichaTecnicaRepository).save(any(FichaTecnica.class));
    }

    @Test
    void nuevaVersion_sinFichaTecnica_noCopia() {
        Receta source = ProduccionTestFixtures.receta(1L, "1");
        source.setVersion(1);
        when(recetaRepository.findById(1L)).thenReturn(Optional.of(source));
        when(recetaRepository.save(any(Receta.class))).thenAnswer(i -> i.getArgument(0));
        when(recetaLaborRepository.findByRecetaIdOrderBySecuenciaAsc(1L)).thenReturn(List.of());
        when(consumibleRepository.findByRecetaPadreIdOrderByIdAsc(1L)).thenReturn(List.of());
        when(fichaTecnicaRepository.findByRecetaId(1L)).thenReturn(Optional.empty());

        Receta result = service.nuevaVersion(1L);

        assertThat(result.getVersion()).isEqualTo(2);
        verify(fichaTecnicaRepository, never()).save(any());
    }

    // ==================== sub-recursos ====================

    @Test
    void findLabores_retornaLista() {
        when(recetaLaborRepository.findByRecetaIdOrderBySecuenciaAsc(1L)).thenReturn(labores);

        var result = service.findLabores(1L);

        assertThat(result).hasSize(1);
    }

    @Test
    void findConsumibles_retornaLista() {
        when(consumibleRepository.findByRecetaPadreIdOrderByIdAsc(1L)).thenReturn(List.of());

        var result = service.findConsumibles(1L);

        assertThat(result).isEmpty();
    }

    @Test
    void findFichaTecnica_cuandoExiste_retorna() {
        when(fichaTecnicaRepository.findByRecetaId(1L)).thenReturn(Optional.of(fichaTecnica));

        var result = service.findFichaTecnica(1L);

        assertThat(result).isNotNull();
    }

    @Test
    void findFichaTecnica_cuandoNoExiste_retornaNull() {
        when(fichaTecnicaRepository.findByRecetaId(1L)).thenReturn(Optional.empty());

        var result = service.findFichaTecnica(1L);

        assertThat(result).isNull();
    }

    // ==================== enrichRecetaResponses ====================

    @Test
    void enrichRecetaResponses_cuandoNull_noHaceNada() {
        service.enrichRecetaResponses(null);
        verifyNoInteractions(entityManager);
    }

    @Test
    void enrichRecetaResponses_cuandoVacia_noHaceNada() {
        service.enrichRecetaResponses(List.of());
        verifyNoInteractions(entityManager);
    }

    @Test
    void enrichRecetaResponses_conDatos_enriquece() {
        var resp = RecetaResponse.builder().articuloProducidoId(1L).build();
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        @SuppressWarnings("rawtypes")
        List raw = List.of((Object) new Object[]{1L, "ART1", "Articulo 1"});
        when(query.getResultList()).thenReturn(raw);

        service.enrichRecetaResponses(List.of(resp));

        assertThat(resp.getArticuloCodigo()).isEqualTo("ART1");
        assertThat(resp.getArticuloDescripcion()).isEqualTo("Articulo 1");
    }

    // ==================== enrichLaborResponses ====================

    @Test
    void enrichLaborResponses_cuandoNull_noHaceNada() {
        service.enrichLaborResponses(null);
        verifyNoInteractions(entityManager);
    }

    @Test
    void enrichLaborResponses_conDatos_enriquece() {
        var resp = RecetaLaborResponse.builder().laborId(1L).build();
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        @SuppressWarnings("rawtypes")
        List raw = List.of((Object) new Object[]{1L, "LAB1", "Labor 1"});
        when(query.getResultList()).thenReturn(raw);

        service.enrichLaborResponses(List.of(resp));

        assertThat(resp.getLaborCodigo()).isEqualTo("LAB1");
        assertThat(resp.getLaborNombre()).isEqualTo("Labor 1");
    }

    // ==================== enrichConsumibleResponses ====================

    @Test
    void enrichConsumibleResponses_cuandoNull_noHaceNada() {
        service.enrichConsumibleResponses(null);
        verifyNoInteractions(entityManager);
    }

    @Test
    void enrichConsumibleResponses_conDatos_enriquece() {
        var resp = RecetaConsumibleResponse.builder().articuloId(1L).build();
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        @SuppressWarnings("rawtypes")
        List raw = List.of((Object) new Object[]{1L, "ART1", "Consumible 1"});
        when(query.getResultList()).thenReturn(raw);

        service.enrichConsumibleResponses(List.of(resp));

        assertThat(resp.getArticuloCodigo()).isEqualTo("ART1");
        assertThat(resp.getArticuloDescripcion()).isEqualTo("Consumible 1");
    }

    // ==================== missing branch tests ====================

    @Test
    void create_conConsumiblesValidos_guardaConsumibles() {
        when(recetaRepository.existsByNroRecetaIgnoreCase(entity.getNroReceta())).thenReturn(false);
        when(recetaRepository.save(any(Receta.class))).thenReturn(entity);

        var cons = new RecetaLaborConsumible();
        cons.setArticuloId(1L);
        cons.setCantidad(java.math.BigDecimal.TEN);

        service.create(entity, null, List.of(cons), null);

        verify(consumibleRepository).save(any(RecetaLaborConsumible.class));
    }

    @Test
    void create_conArticuloConsumibleFeignFalla_lanzaBusinessException() {
        when(recetaRepository.existsByNroRecetaIgnoreCase(entity.getNroReceta())).thenReturn(false);
        when(recetaRepository.save(any(Receta.class))).thenReturn(entity);
        var artOk = ApiResponse.<pe.restaurant.produccion.client.dto.ArticuloResponse>builder()
                .success(true).data(ProduccionTestFixtures.articuloResponse()).build();
        when(coreArticuloClient.obtenerPorId(1L)).thenReturn(artOk);
        when(coreArticuloClient.obtenerPorId(100L)).thenThrow(mock(FeignException.class));

        var cons = new RecetaLaborConsumible();
        cons.setArticuloId(100L);
        cons.setCantidad(java.math.BigDecimal.TEN);

        assertThatThrownBy(() -> service.create(entity, null, List.of(cons), null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("consumible");
    }

    @Test
    void create_conLaborInexistente_lanzaBusinessException() {
        when(recetaRepository.existsByNroRecetaIgnoreCase(entity.getNroReceta())).thenReturn(false);
        when(recetaRepository.save(any(Receta.class))).thenReturn(entity);
        reset(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(0);

        assertThatThrownBy(() -> service.create(entity, labores, null, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("labor");
    }

    @Test
    void create_conFlagEstadoBlank_asignaActivo() {
        entity.setFlagEstado("");
        when(recetaRepository.existsByNroRecetaIgnoreCase(entity.getNroReceta())).thenReturn(false);
        when(recetaRepository.save(any(Receta.class))).thenAnswer(i -> i.getArgument(0));

        var result = service.create(entity, null, null, null);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void enrichRecetaResponses_cuandoInfoNull_noSeteaNada() {
        var resp = RecetaResponse.builder().articuloProducidoId(999L).build();
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        @SuppressWarnings("rawtypes")
        List raw = List.of((Object) new Object[]{1L, "ART1", "Articulo 1"});
        when(query.getResultList()).thenReturn(raw);

        service.enrichRecetaResponses(List.of(resp));

        assertThat(resp.getArticuloCodigo()).isNull();
    }
}
