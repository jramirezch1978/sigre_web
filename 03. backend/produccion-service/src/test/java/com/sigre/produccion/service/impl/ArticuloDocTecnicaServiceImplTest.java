package com.sigre.produccion.service.impl;

import feign.FeignException;
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
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.produccion.ProduccionTestFixtures;
import com.sigre.produccion.client.CoreArticuloClient;
import com.sigre.produccion.client.CoreUnidadMedidaClient;
import com.sigre.produccion.client.dto.ArticuloResponse;
import com.sigre.produccion.client.dto.UnidadMedidaResponse;
import com.sigre.produccion.dto.response.CaractDetResponse;
import com.sigre.produccion.entity.ArticuloDocTecnica;
import com.sigre.produccion.entity.ArticuloDocTecnicaCaractDet;
import com.sigre.produccion.repository.ArticuloDocTecnicaRepository;
import com.sigre.produccion.repository.CaractDetRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import jakarta.persistence.criteria.*;
import org.mockito.ArgumentCaptor;

@ExtendWith(MockitoExtension.class)
@DisplayName("ArticuloDocTecnicaServiceImpl — Pruebas Unitarias")
class ArticuloDocTecnicaServiceImplTest {

    @Mock private ArticuloDocTecnicaRepository repository;
    @Mock private CaractDetRepository caractDetRepository;
    @Mock private CoreArticuloClient coreArticuloClient;
    @Mock private CoreUnidadMedidaClient coreUnidadMedidaClient;
    @Mock private EntityManager entityManager;
    @Mock private Query query;

    private ArticuloDocTecnicaServiceImpl service;
    private ArticuloResponse articuloActivo;

    @BeforeEach
    void setUp() {
        service = new ArticuloDocTecnicaServiceImpl(repository, caractDetRepository,
                coreArticuloClient, coreUnidadMedidaClient);
        ReflectionTestUtils.setField(service, "entityManager", entityManager);

        articuloActivo = ArticuloResponse.builder()
                .id(1L).codigo("ART-TEST").nombre("Test").flagEstado("1").build();
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
        var entity = new ArticuloDocTecnica();
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
        var entity = new ArticuloDocTecnica();
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of(entity)));

        Page<ArticuloDocTecnica> result = service.findAll(1L, "doc", "1", 1L, pageable);

        assertThat(result).hasSize(1);
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }

    @Test
    void findAll_sinFiltros_retornaPage() {
        var pageable = PageRequest.of(0, 10);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        Page<ArticuloDocTecnica> result = service.findAll(null, null, null, null, pageable);

        assertThat(result).isEmpty();
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }

    // ==================== findCaracteristicas ====================

    @Test
    void findCaracteristicas_retornaLista() {
        var det = new ArticuloDocTecnicaCaractDet();
        when(caractDetRepository.findByArticuloDocTecnicaIdOrderByIdAsc(1L))
                .thenReturn(List.of(det));

        var result = service.findCaracteristicas(1L);

        assertThat(result).hasSize(1);
        verify(caractDetRepository).findByArticuloDocTecnicaIdOrderByIdAsc(1L);
    }

    // ==================== create ====================

    @Test
    void create_conDatosValidos_guardaYRetorna() {
        var entity = new ArticuloDocTecnica();
        entity.setArticuloId(1L);
        entity.setDocTipoId(1L);
        entity.setNombreDocumento("  Documento  ");
        entity.setDocumentoExtension("  PDF  ");
        var apiResp = ApiResponse.<ArticuloResponse>builder().success(true).data(articuloActivo).build();
        when(coreArticuloClient.obtenerPorId(1L)).thenReturn(apiResp);
        when(repository.save(any(ArticuloDocTecnica.class))).thenAnswer(inv -> {
            ArticuloDocTecnica saved = inv.getArgument(0);
            saved.setId(1L);
            return saved;
        });

        var result = service.create(entity, null);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getNombreDocumento()).isEqualTo("Documento");
        assertThat(result.getDocumentoExtension()).isEqualTo("pdf");
        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(result.getCreatedBy()).isEqualTo(1L);
        verify(repository).save(any(ArticuloDocTecnica.class));
    }

    @Test
    void create_conFlagEstadoExistente_noSobrescribe() {
        var entity = new ArticuloDocTecnica();
        entity.setArticuloId(1L);
        entity.setFlagEstado("0");
        var apiResp = ApiResponse.<ArticuloResponse>builder().success(true).data(articuloActivo).build();
        when(coreArticuloClient.obtenerPorId(1L)).thenReturn(apiResp);
        when(repository.save(any(ArticuloDocTecnica.class))).thenAnswer(inv -> inv.getArgument(0));

        service.create(entity, null);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(repository).save(entity);
    }

    @Test
    void create_cuandoArticuloInactivo_lanzaBusinessException() {
        var entity = new ArticuloDocTecnica();
        entity.setArticuloId(1L);
        var artInactivo = ArticuloResponse.builder().id(1L).flagEstado("0").build();
        var apiResp = ApiResponse.<ArticuloResponse>builder().success(true).data(artInactivo).build();
        when(coreArticuloClient.obtenerPorId(1L)).thenReturn(apiResp);

        assertThatThrownBy(() -> service.create(entity, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("artículo no existe");
    }

    @Test
    void create_cuandoArticuloInexistente_lanzaBusinessException() {
        var entity = new ArticuloDocTecnica();
        entity.setArticuloId(999L);
        var apiResp = ApiResponse.<ArticuloResponse>builder().success(true).data(null).build();
        when(coreArticuloClient.obtenerPorId(999L)).thenReturn(apiResp);

        assertThatThrownBy(() -> service.create(entity, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("artículo no existe");
    }

    @Test
    void create_cuandoFeignFalla_lanzaBusinessException() {
        var entity = new ArticuloDocTecnica();
        entity.setArticuloId(1L);
        when(coreArticuloClient.obtenerPorId(1L)).thenThrow(mock(FeignException.class));

        assertThatThrownBy(() -> service.create(entity, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("artículo no existe");
    }

    @Test
    void create_conCaracteristicas_guardaDetalles() {
        var entity = new ArticuloDocTecnica();
        entity.setArticuloId(1L);
        var apiResp = ApiResponse.<ArticuloResponse>builder().success(true).data(articuloActivo).build();
        when(coreArticuloClient.obtenerPorId(1L)).thenReturn(apiResp);
        when(repository.save(any(ArticuloDocTecnica.class))).thenAnswer(inv -> {
            ArticuloDocTecnica saved = inv.getArgument(0);
            saved.setId(1L);
            return saved;
        });

        var caract = new ArticuloDocTecnicaCaractDet();
        caract.setCaracteristica("Color");
        caract.setValor("Rojo");

        service.create(entity, List.of(caract));

        assertThat(caract.getArticuloDocTecnicaId()).isEqualTo(1L);
        assertThat(caract.getCreatedBy()).isEqualTo(1L);
        verify(caractDetRepository).save(caract);
    }

    @Test
    void create_conCaracteristicaConUnidadMedida_validaUM() {
        var entity = new ArticuloDocTecnica();
        entity.setArticuloId(1L);
        var apiResp = ApiResponse.<ArticuloResponse>builder().success(true).data(articuloActivo).build();
        when(coreArticuloClient.obtenerPorId(1L)).thenReturn(apiResp);
        when(repository.save(any(ArticuloDocTecnica.class))).thenAnswer(inv -> {
            ArticuloDocTecnica saved = inv.getArgument(0);
            saved.setId(1L);
            return saved;
        });

        var umResp = ApiResponse.<UnidadMedidaResponse>builder()
                .success(true).data(UnidadMedidaResponse.builder().id(1L).build()).build();
        when(coreUnidadMedidaClient.obtenerPorId(1L)).thenReturn(umResp);

        var caract = new ArticuloDocTecnicaCaractDet();
        caract.setCaracteristica("Peso");
        caract.setValor("10");
        caract.setUnidadMedidaId(1L);

        service.create(entity, List.of(caract));

        verify(coreUnidadMedidaClient).obtenerPorId(1L);
        verify(caractDetRepository).save(caract);
    }

    @Test
    void create_conCaracteristicaUMInexistente_lanzaBusinessException() {
        var entity = new ArticuloDocTecnica();
        entity.setArticuloId(1L);
        var apiResp = ApiResponse.<ArticuloResponse>builder().success(true).data(articuloActivo).build();
        when(coreArticuloClient.obtenerPorId(1L)).thenReturn(apiResp);
        when(repository.save(any(ArticuloDocTecnica.class))).thenAnswer(inv -> {
            ArticuloDocTecnica saved = inv.getArgument(0);
            saved.setId(1L);
            return saved;
        });

        var umResp = ApiResponse.<UnidadMedidaResponse>builder().success(true).data(null).build();
        when(coreUnidadMedidaClient.obtenerPorId(1L)).thenReturn(umResp);

        var caract = new ArticuloDocTecnicaCaractDet();
        caract.setCaracteristica("Peso");
        caract.setValor("10");
        caract.setUnidadMedidaId(1L);

        assertThatThrownBy(() -> service.create(entity, List.of(caract)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("unidad de medida no existe");
    }

    // ==================== update ====================

    @Test
    void update_conDatosValidos_actualizaYRetorna() {
        var existing = new ArticuloDocTecnica();
        existing.setId(1L);
        existing.setFlagEstado("1");

        var entity = new ArticuloDocTecnica();
        entity.setArticuloId(2L);
        entity.setDocTipoId(2L);
        entity.setNombreDocumento("  Actualizado  ");
        entity.setDocumentoExtension("  DOCX  ");

        var apiResp = ApiResponse.<ArticuloResponse>builder().success(true)
                .data(ArticuloResponse.builder().id(2L).flagEstado("1").build()).build();
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(coreArticuloClient.obtenerPorId(2L)).thenReturn(apiResp);
        when(repository.save(any(ArticuloDocTecnica.class))).thenAnswer(inv -> inv.getArgument(0));

        var result = service.update(1L, entity, null);

        assertThat(result.getNombreDocumento()).isEqualTo("Actualizado");
        assertThat(result.getDocumentoExtension()).isEqualTo("docx");
        assertThat(result.getArticuloId()).isEqualTo(2L);
        verify(repository).save(existing);
    }

    @Test
    void update_cuandoDocumentoInactivo_lanzaBusinessException() {
        var existing = new ArticuloDocTecnica();
        existing.setId(1L);
        existing.setFlagEstado("0");

        when(repository.findById(1L)).thenReturn(Optional.of(existing));

        assertThatThrownBy(() -> service.update(1L, new ArticuloDocTecnica(), null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("documento inactivo");
    }

    @Test
    void update_conCaracteristicas_sincronizaDetalles() {
        var existing = new ArticuloDocTecnica();
        existing.setId(1L);
        existing.setFlagEstado("1");

        var entity = new ArticuloDocTecnica();
        entity.setArticuloId(1L);
        var apiResp = ApiResponse.<ArticuloResponse>builder().success(true).data(articuloActivo).build();
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(coreArticuloClient.obtenerPorId(1L)).thenReturn(apiResp);
        when(repository.save(any(ArticuloDocTecnica.class))).thenAnswer(inv -> inv.getArgument(0));

        var caract = new ArticuloDocTecnicaCaractDet();
        caract.setCaracteristica("Nueva");
        caract.setValor("Valor");

        service.update(1L, entity, List.of(caract));

        verify(caractDetRepository).deleteByArticuloDocTecnicaId(1L);
        verify(caractDetRepository).save(caract);
    }

    // ==================== activate / deactivate / delete ====================

    @Test
    void activate_cuandoExisteId_activa() {
        var entity = new ArticuloDocTecnica();
        entity.setId(1L);
        entity.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(ArticuloDocTecnica.class))).thenAnswer(inv -> inv.getArgument(0));

        var result = service.activate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
        verify(repository).save(entity);
    }

    @Test
    void deactivate_cuandoExisteId_desactiva() {
        var entity = new ArticuloDocTecnica();
        entity.setId(1L);
        entity.setFlagEstado("1");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(ArticuloDocTecnica.class))).thenAnswer(inv -> inv.getArgument(0));

        var result = service.deactivate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
        verify(repository).save(entity);
    }

    @Test
    void delete_cuandoExisteId_desactivaLogico() {
        var entity = new ArticuloDocTecnica();
        entity.setId(1L);
        entity.setFlagEstado("1");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(ArticuloDocTecnica.class))).thenAnswer(inv -> inv.getArgument(0));

        service.delete(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(repository).save(entity);
    }

    // ==================== enrichCaractDetResponses ====================

    @Test
    void enrichCaractDetResponses_cuandoListaVacia_noHaceNada() {
        service.enrichCaractDetResponses(List.of());
        verifyNoInteractions(entityManager);
    }

    @Test
    void enrichCaractDetResponses_cuandoNull_noHaceNada() {
        service.enrichCaractDetResponses(null);
        verifyNoInteractions(entityManager);
    }

    @Test
    void enrichCaractDetResponses_sinUnidadMedida_noHaceQuery() {
        var resp = CaractDetResponse.builder().id(1L).build();
        resp.setUnidadMedidaId(null);

        service.enrichCaractDetResponses(List.of(resp));

        verifyNoInteractions(entityManager);
    }

    @Test
    void enrichCaractDetResponses_conUnidadMedida_enriquece() {
        var resp = CaractDetResponse.builder().id(1L).unidadMedidaId(1L).build();

        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        @SuppressWarnings("rawtypes")
        List rawSingle = List.of((Object) new Object[]{1L, "KG"});
        when(query.getResultList()).thenReturn(rawSingle);

        service.enrichCaractDetResponses(List.of(resp));

        assertThat(resp.getUnidadMedidaCodigo()).isEqualTo("KG");
    }

    @Test
    void enrichCaractDetResponses_conMultiplesUM_enriqueceTodas() {
        var resp1 = CaractDetResponse.builder().id(1L).unidadMedidaId(1L).build();
        var resp2 = CaractDetResponse.builder().id(2L).unidadMedidaId(2L).build();

        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        @SuppressWarnings("rawtypes")
        List rawMulti = List.of(
                (Object) new Object[]{1L, "KG"},
                (Object) new Object[]{2L, "LT"});
        when(query.getResultList()).thenReturn(rawMulti);

        service.enrichCaractDetResponses(List.of(resp1, resp2));

        assertThat(resp1.getUnidadMedidaCodigo()).isEqualTo("KG");
        assertThat(resp2.getUnidadMedidaCodigo()).isEqualTo("LT");
    }

    @Test
    void create_cuandoFlagEstadoBlank_asignaActivo() {
        var entity = new ArticuloDocTecnica();
        entity.setArticuloId(1L);
        entity.setFlagEstado("");
        var apiResp = ApiResponse.<ArticuloResponse>builder().success(true).data(articuloActivo).build();
        when(coreArticuloClient.obtenerPorId(1L)).thenReturn(apiResp);
        when(repository.save(any(ArticuloDocTecnica.class))).thenAnswer(inv -> inv.getArgument(0));

        var result = service.create(entity, null);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void create_conCaracteristicaConUMFeignFalla_lanzaBusinessException() {
        var entity = new ArticuloDocTecnica();
        entity.setArticuloId(1L);
        var apiResp = ApiResponse.<ArticuloResponse>builder().success(true).data(articuloActivo).build();
        when(coreArticuloClient.obtenerPorId(1L)).thenReturn(apiResp);
        when(repository.save(any(ArticuloDocTecnica.class))).thenAnswer(inv -> {
            ArticuloDocTecnica saved = inv.getArgument(0);
            saved.setId(1L);
            return saved;
        });
        when(coreUnidadMedidaClient.obtenerPorId(1L)).thenThrow(mock(FeignException.class));

        var caract = new ArticuloDocTecnicaCaractDet();
        caract.setCaracteristica("Peso");
        caract.setValor("10");
        caract.setUnidadMedidaId(1L);

        assertThatThrownBy(() -> service.create(entity, List.of(caract)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("unidad de medida");
    }

    // ─── Tests de Specification (ejecutan toPredicate) ───

    @Test
    @SuppressWarnings({"rawtypes", "unchecked"})
    void spec_conTodosLosFiltros_ejecutaToPredicate() {
        var pageable = PageRequest.of(0, 10);
        lenient().when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        service.findAll(1L, "Documento", "1", 1L, pageable);

        ArgumentCaptor<Specification<ArticuloDocTecnica>> cap = ArgumentCaptor.forClass(Specification.class);
        verify(repository).findAll(cap.capture(), eq(pageable));

        Root root = mock(Root.class);
        CriteriaQuery query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Path path = mock(Path.class);
        Expression upper = mock(Expression.class);
        Predicate predicate = mock(Predicate.class);
        when(root.get(anyString())).thenReturn(path);
        when(cb.upper(any(Expression.class))).thenReturn(upper);
        when(cb.like(any(Expression.class), anyString())).thenReturn(predicate);
        lenient().when(cb.equal(any(Expression.class), any())).thenReturn(predicate);
        when(cb.and(any(Predicate[].class))).thenReturn(predicate);

        Predicate result = cap.getValue().toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }

    @Test
    @SuppressWarnings({"rawtypes", "unchecked"})
    void spec_conFiltrosNull_ejecutaToPredicate() {
        var pageable = PageRequest.of(0, 10);
        lenient().when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        service.findAll(null, null, null, null, pageable);

        ArgumentCaptor<Specification<ArticuloDocTecnica>> cap = ArgumentCaptor.forClass(Specification.class);
        verify(repository).findAll(cap.capture(), eq(pageable));

        Root root = mock(Root.class);
        CriteriaQuery query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Predicate predicate = mock(Predicate.class);
        when(cb.and(any(Predicate[].class))).thenReturn(predicate);

        Predicate result = cap.getValue().toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }

    @Test
    @SuppressWarnings({"rawtypes", "unchecked"})
    void spec_conNombreBlank_omitePredicadoNombre() {
        var pageable = PageRequest.of(0, 10);
        lenient().when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        service.findAll(1L, "", null, null, pageable);

        ArgumentCaptor<Specification<ArticuloDocTecnica>> cap = ArgumentCaptor.forClass(Specification.class);
        verify(repository).findAll(cap.capture(), eq(pageable));

        Root root = mock(Root.class);
        CriteriaQuery query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Path path = mock(Path.class);
        Predicate predicate = mock(Predicate.class);
        when(root.get(anyString())).thenReturn(path);
        lenient().when(cb.equal(any(Expression.class), any())).thenReturn(predicate);
        when(cb.and(any(Predicate[].class))).thenReturn(predicate);

        Predicate result = cap.getValue().toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }
}
