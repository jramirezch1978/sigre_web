package com.sigre.produccion.service.impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Expression;
import jakarta.persistence.criteria.Path;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.jdbc.core.JdbcTemplate;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.produccion.client.CoreArticuloClient;
import com.sigre.produccion.client.dto.ArticuloResponse;
import com.sigre.produccion.dto.response.LaborEjecutorResponse;
import com.sigre.produccion.entity.Labor;
import com.sigre.produccion.entity.LaborEjecutor;
import com.sigre.produccion.entity.LaborInsumo;
import com.sigre.produccion.entity.LaborProduccion;
import com.sigre.produccion.mapper.LaborEjecutorMapper;
import com.sigre.produccion.repository.LaborEjecutorRepository;
import com.sigre.produccion.repository.LaborInsumoRepository;
import com.sigre.produccion.repository.LaborProduccionRepository;
import com.sigre.produccion.repository.LaborRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class LaborServiceImplTest {

    @Mock private LaborRepository laborRepository;
    @Mock private LaborInsumoRepository insumoRepository;
    @Mock private LaborProduccionRepository produccionRepository;
    @Mock private LaborEjecutorRepository ejecutorRepository;
    @Mock private LaborEjecutorMapper ejecutorMapper;
    @Mock private CoreArticuloClient coreArticuloClient;
    @Mock private JdbcTemplate jdbcTemplate;
    @Mock private EntityManager entityManager;
    @Mock private Query query;
    private LaborServiceImpl service;

    private Labor laborBase;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        service = new LaborServiceImpl(laborRepository, insumoRepository,
                produccionRepository, ejecutorRepository, ejecutorMapper, coreArticuloClient);
        org.springframework.test.util.ReflectionTestUtils.setField(service, "entityManager", entityManager);

        laborBase = new Labor();
        laborBase.setId(1L);
        laborBase.setCodigo("LAB-COSECHA");
        laborBase.setNombre("Labor de cosecha");
        laborBase.setFlagEstado("1");

        var articleResponse = mock(ApiResponse.class);
        lenient().when(articleResponse.isSuccess()).thenReturn(true);
        lenient().when(articleResponse.getData()).thenReturn(
                ArticuloResponse.builder().id(1L).flagEstado("1").build());
        lenient().when(coreArticuloClient.obtenerPorId(anyLong())).thenReturn(articleResponse);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ─────────────── findAll ───────────────

    @Test
    @SuppressWarnings("unchecked")
    void findAll_sinFiltros_delegaAlRepositorio() {
        Pageable pageable = PageRequest.of(0, 20);
        when(laborRepository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of(laborBase)));
        assertThat(service.findAll(null, null, null, pageable).getContent()).hasSize(1);
    }

    @Test
    @SuppressWarnings({"unchecked", "rawtypes"})
    void findAll_conTodosLosFiltros_aplicaPredicados() {
        Pageable pageable = PageRequest.of(0, 10);
        when(laborRepository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of()));

        service.findAll("LAB", "cosecha", "1", pageable);

        ArgumentCaptor<Specification<Labor>> specCap = ArgumentCaptor.forClass(Specification.class);
        verify(laborRepository).findAll(specCap.capture(), eq(pageable));

        Root<Labor> root = mock(Root.class);
        CriteriaQuery<?> query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Path path = mock(Path.class);
        Expression upper = mock(Expression.class);
        Predicate predicate = mock(Predicate.class);

        when(root.get(anyString())).thenReturn(path);
        when(cb.upper(any())).thenReturn(upper);
        when(cb.like(any(Expression.class), anyString())).thenReturn(predicate);
        doReturn(predicate).when(cb).equal(any(Expression.class), any(Object.class));
        when(cb.and(any(Predicate[].class))).thenReturn(predicate);

        Predicate result = specCap.getValue().toPredicate(root, query, cb);
        assertThat(result).isNotNull();
        verify(cb, times(2)).like(any(Expression.class), anyString());
        verify(cb, times(1)).equal(any(Expression.class), any(Object.class));
    }

    @Test
    @SuppressWarnings("unchecked")
    void findAll_filtrosBlancos_seIgnoran() {
        Pageable pageable = PageRequest.of(0, 10);
        when(laborRepository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of()));

        service.findAll("  ", "  ", "  ", pageable);

        ArgumentCaptor<Specification<Labor>> specCap = ArgumentCaptor.forClass(Specification.class);
        verify(laborRepository).findAll(specCap.capture(), eq(pageable));

        Root<Labor> root = mock(Root.class);
        CriteriaQuery<?> query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Predicate predicate = mock(Predicate.class);
        when(cb.and(any(Predicate[].class))).thenReturn(predicate);

        specCap.getValue().toPredicate(root, query, cb);
        verify(cb, never()).like(any(Expression.class), anyString());
        verify(cb, never()).equal(any(Expression.class), any(Object.class));
    }

    // ─────────────── findById ───────────────

    @Test
    void findById_retornaCuandoExiste() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        assertThat(service.findById(1L)).isSameAs(laborBase);
    }

    @Test
    void findById_lanzaResourceNotFound() {
        when(laborRepository.findById(99L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.findById(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Labor");
    }

    // ─────────────── create ───────────────

    @Test
    void create_persisteCuandoCodigoUnico_normalizaCodigoYNombre() {
        Labor in = new Labor();
        in.setCodigo("  lab  ");
        in.setNombre("  Labor  ");
        when(laborRepository.existsByCodigoIgnoreCase("LAB")).thenReturn(false);
        when(laborRepository.save(any(Labor.class))).thenAnswer(inv -> {
            Labor e = inv.getArgument(0);
            e.setId(20L);
            return e;
        });

        Labor out = service.create(in);
        assertThat(out.getId()).isEqualTo(20L);
        assertThat(out.getCodigo()).isEqualTo("LAB");
        assertThat(out.getNombre()).isEqualTo("Labor");
        assertThat(out.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void create_flagEstadoBlancoAplicaUnoPorDefecto() {
        Labor in = new Labor();
        in.setCodigo("X");
        in.setNombre("X");
        in.setFlagEstado("   ");
        when(laborRepository.existsByCodigoIgnoreCase("X")).thenReturn(false);
        when(laborRepository.save(any(Labor.class))).thenAnswer(inv -> inv.getArgument(0));
        assertThat(service.create(in).getFlagEstado()).isEqualTo("1");
    }

    @Test
    void create_codigoDuplicadoLanzaPrdLb003() {
        Labor in = new Labor();
        in.setCodigo("DUP");
        in.setNombre("X");
        when(laborRepository.existsByCodigoIgnoreCase("DUP")).thenReturn(true);
        assertThatThrownBy(() -> service.create(in))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe una labor")
                .hasFieldOrPropertyWithValue("errorCode", "PRD-LB-003");
        verify(laborRepository, never()).save(any());
    }

    // ─────────────── update ───────────────

    @Test
    void update_aplicaCambiosCuandoCodigoUnico() {
        Labor existing = new Labor();
        existing.setId(1L);
        existing.setCodigo("OLD");
        existing.setNombre("Viejo");

        Labor patch = new Labor();
        patch.setCodigo(" new ");
        patch.setNombre(" Nuevo ");

        when(laborRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(laborRepository.existsByCodigoIgnoreCaseAndIdNot("NEW", 1L)).thenReturn(false);
        when(laborRepository.save(existing)).thenReturn(existing);

        Labor out = service.update(1L, patch);
        assertThat(out.getCodigo()).isEqualTo("NEW");
        assertThat(out.getNombre()).isEqualTo("Nuevo");
    }

    @Test
    void update_codigoDuplicadoEnOtroIdLanzaPrdLb003() {
        Labor existing = new Labor();
        existing.setId(1L);
        Labor patch = new Labor();
        patch.setCodigo("DUP");
        patch.setNombre("X");
        when(laborRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(laborRepository.existsByCodigoIgnoreCaseAndIdNot("DUP", 1L)).thenReturn(true);
        assertThatThrownBy(() -> service.update(1L, patch))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "PRD-LB-003");
        verify(laborRepository, never()).save(any());
    }

    // ─────────────── activate / deactivate ───────────────

    @Test
    void activate_seteaFlagEstado1() {
        laborBase.setFlagEstado("0");
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(laborRepository.save(laborBase)).thenReturn(laborBase);
        assertThat(service.activate(1L).getFlagEstado()).isEqualTo("1");
    }

    @Test
    void deactivate_seteaFlagEstado0() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(laborRepository.save(laborBase)).thenReturn(laborBase);
        assertThat(service.deactivate(1L).getFlagEstado()).isEqualTo("0");
    }

    // ─────────────── delete (baja logica con bloqueo) ───────────────

    @Test
    void delete_bajaLogicaCuandoNoHayReferencias() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(laborRepository.existsReferenciaByLaborId(1L)).thenReturn(false);
        when(laborRepository.save(laborBase)).thenReturn(laborBase);

        service.delete(1L);

        assertThat(laborBase.getFlagEstado()).isEqualTo("0");
        verify(laborRepository).save(laborBase);
        verify(laborRepository, never()).delete(any(Labor.class));
    }

    @Test
    void delete_lanzaPrdLb005CuandoHayReferencias() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(laborRepository.existsReferenciaByLaborId(1L)).thenReturn(true);
        assertThatThrownBy(() -> service.delete(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("referencias asociadas")
                .hasFieldOrPropertyWithValue("errorCode", "PRD-LB-005");
        verify(laborRepository, never()).save(any());
    }

    // ─────────────── Sub-recurso insumos ───────────────

    @Test
    void findInsumos_validaLaborYRetornaLista() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        LaborInsumo i = new LaborInsumo();
        i.setId(50L);
        i.setLaborId(1L);
        i.setArticuloId(100L);
        when(insumoRepository.findByLaborIdOrderByIdAsc(1L)).thenReturn(List.of(i));
        var out = service.findInsumos(1L);
        assertThat(out).hasSize(1);
        assertThat(out.get(0).getArticuloId()).isEqualTo(100L);
    }

    @Test
    void findInsumos_laborInexistenteLanza404() {
        when(laborRepository.findById(99L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.findInsumos(99L))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(insumoRepository, never()).findByLaborIdOrderByIdAsc(anyLong());
    }

    @Test
    void asignarInsumo_persisteCuandoArticuloExisteYNoAsignado() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(100L))).thenReturn(1);
        when(insumoRepository.existsByLaborIdAndArticuloId(1L, 100L)).thenReturn(false);
        when(insumoRepository.save(any(LaborInsumo.class))).thenAnswer(inv -> {
            LaborInsumo e = inv.getArgument(0);
            e.setId(77L);
            return e;
        });

        LaborInsumo out = service.asignarInsumo(1L, 100L);
        assertThat(out.getId()).isEqualTo(77L);
        assertThat(out.getLaborId()).isEqualTo(1L);
        assertThat(out.getArticuloId()).isEqualTo(100L);
    }

    @Test
    void asignarInsumo_articuloInexistenteLanzaPrdLb002() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        var failResp = mock(ApiResponse.class);
        when(failResp.isSuccess()).thenReturn(false);
        when(coreArticuloClient.obtenerPorId(99L)).thenReturn(failResp);
        assertThatThrownBy(() -> service.asignarInsumo(1L, 99L))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "PRD-LB-002");
    }

    @Test
    void asignarInsumo_jdbcRetornaNullLanzaPrdLb002() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        var failResp = mock(ApiResponse.class);
        when(failResp.isSuccess()).thenReturn(true);
        when(failResp.getData()).thenReturn(null);
        when(coreArticuloClient.obtenerPorId(88L)).thenReturn(failResp);
        assertThatThrownBy(() -> service.asignarInsumo(1L, 88L))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "PRD-LB-002");
    }

    @Test
    void asignarInsumo_articuloYaAsignadoLanzaPrdLb003() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(100L))).thenReturn(1);
        when(insumoRepository.existsByLaborIdAndArticuloId(1L, 100L)).thenReturn(true);
        assertThatThrownBy(() -> service.asignarInsumo(1L, 100L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ya esta asignado como insumo")
                .hasFieldOrPropertyWithValue("errorCode", "PRD-LB-003");
        verify(insumoRepository, never()).save(any());
    }

    @Test
    void desasignarInsumo_eliminaCuandoExiste() {
        LaborInsumo i = new LaborInsumo();
        i.setId(50L);
        i.setLaborId(1L);
        i.setArticuloId(100L);
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(insumoRepository.findByLaborIdAndArticuloId(1L, 100L)).thenReturn(Optional.of(i));

        service.desasignarInsumo(1L, 100L);
        verify(insumoRepository).delete(i);
    }

    @Test
    void desasignarInsumo_lanzaResourceNotFoundCuandoNoExiste() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(insumoRepository.findByLaborIdAndArticuloId(1L, 999L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.desasignarInsumo(1L, 999L))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(insumoRepository, never()).delete(any(LaborInsumo.class));
    }

    // ─────────────── Sub-recurso producidos ───────────────

    @Test
    void findProducidos_validaLaborYRetornaLista() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        LaborProduccion p = new LaborProduccion();
        p.setId(60L);
        p.setLaborId(1L);
        p.setArticuloId(200L);
        when(produccionRepository.findByLaborIdOrderByIdAsc(1L)).thenReturn(List.of(p));
        var out = service.findProducidos(1L);
        assertThat(out).hasSize(1);
        assertThat(out.get(0).getArticuloId()).isEqualTo(200L);
    }

    @Test
    void asignarProducido_persisteCuandoArticuloExisteYNoAsignado() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(200L))).thenReturn(1);
        when(produccionRepository.existsByLaborIdAndArticuloId(1L, 200L)).thenReturn(false);
        when(produccionRepository.save(any(LaborProduccion.class))).thenAnswer(inv -> {
            LaborProduccion e = inv.getArgument(0);
            e.setId(88L);
            return e;
        });

        LaborProduccion out = service.asignarProducido(1L, 200L);
        assertThat(out.getId()).isEqualTo(88L);
        assertThat(out.getLaborId()).isEqualTo(1L);
        assertThat(out.getArticuloId()).isEqualTo(200L);
    }

    @Test
    void asignarProducido_articuloInexistenteLanzaPrdLb002() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        var failResp = mock(ApiResponse.class);
        when(failResp.isSuccess()).thenReturn(false);
        when(coreArticuloClient.obtenerPorId(99L)).thenReturn(failResp);
        assertThatThrownBy(() -> service.asignarProducido(1L, 99L))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "PRD-LB-002");
        verify(produccionRepository, never()).save(any());
    }

    @Test
    void asignarProducido_articuloYaAsignadoLanzaPrdLb003() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(200L))).thenReturn(1);
        when(produccionRepository.existsByLaborIdAndArticuloId(1L, 200L)).thenReturn(true);
        assertThatThrownBy(() -> service.asignarProducido(1L, 200L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ya esta asignado como producido")
                .hasFieldOrPropertyWithValue("errorCode", "PRD-LB-003");
        verify(produccionRepository, never()).save(any());
    }

    @Test
    void desasignarProducido_eliminaCuandoExiste() {
        LaborProduccion p = new LaborProduccion();
        p.setId(60L);
        p.setLaborId(1L);
        p.setArticuloId(200L);
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(produccionRepository.findByLaborIdAndArticuloId(1L, 200L)).thenReturn(Optional.of(p));

        service.desasignarProducido(1L, 200L);
        verify(produccionRepository).delete(p);
    }

    @Test
    void desasignarProducido_lanzaResourceNotFoundCuandoNoExiste() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(produccionRepository.findByLaborIdAndArticuloId(1L, 999L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.desasignarProducido(1L, 999L))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(produccionRepository, never()).delete(any(LaborProduccion.class));
    }

    // ─────────────── Sub-recurso ejecutores ───────────────

    @Test
    void asignarEjecutor_cuandoYaExiste_lanzaBusinessException() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(ejecutorRepository.existsByLaborIdAndEjecutorId(1L, 10L)).thenReturn(true);

        assertThatThrownBy(() -> service.asignarEjecutor(1L, 10L, new LaborEjecutor()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe");
        verify(ejecutorRepository, never()).save(any());
    }

    @Test
    void asignarEjecutor_cuandoNoExiste_guardaYRetorna() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(ejecutorRepository.existsByLaborIdAndEjecutorId(1L, 10L)).thenReturn(false);

        var data = new LaborEjecutor();
        data.setCostoUnitario(BigDecimal.valueOf(100));
        data.setNroPersonas(2);

        when(ejecutorRepository.save(any(LaborEjecutor.class))).thenAnswer(i -> {
            LaborEjecutor le = i.getArgument(0);
            le.setId(1L);
            return le;
        });

        var result = service.asignarEjecutor(1L, 10L, data);

        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getFlagEstado()).isEqualTo("1");
        verify(ejecutorRepository).save(any(LaborEjecutor.class));
    }

    @Test
    void actualizarEjecutor_cuandoExiste_actualizaYRetorna() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        var existing = new LaborEjecutor();
        existing.setId(1L);
        existing.setNroPersonas(1);
        when(ejecutorRepository.findByLaborIdAndEjecutorId(1L, 10L)).thenReturn(Optional.of(existing));

        var data = new LaborEjecutor();
        data.setNroPersonas(5);
        data.setCostoUnitario(BigDecimal.valueOf(200));
        when(ejecutorRepository.save(any(LaborEjecutor.class))).thenAnswer(i -> i.getArgument(0));

        var result = service.actualizarEjecutor(1L, 10L, data);

        assertThat(result.getNroPersonas()).isEqualTo(5);
        assertThat(result.getCostoUnitario()).isEqualByComparingTo(BigDecimal.valueOf(200));
    }

    @Test
    void actualizarEjecutor_cuandoNoExiste_lanzaResourceNotFound() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(ejecutorRepository.findByLaborIdAndEjecutorId(1L, 999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizarEjecutor(1L, 999L, new LaborEjecutor()))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(ejecutorRepository, never()).save(any());
    }

    @Test
    void desasignarEjecutor_cuandoExiste_elimina() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        var le = new LaborEjecutor();
        le.setId(1L);
        when(ejecutorRepository.findByLaborIdAndEjecutorId(1L, 10L)).thenReturn(Optional.of(le));

        service.desasignarEjecutor(1L, 10L);

        verify(ejecutorRepository).delete(le);
    }

    @Test
    void desasignarEjecutor_cuandoNoExiste_lanzaResourceNotFound() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(ejecutorRepository.findByLaborIdAndEjecutorId(1L, 999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.desasignarEjecutor(1L, 999L))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(ejecutorRepository, never()).delete(any());
    }

    // ─────────────── enrichEjecutores ───────────────

    @Test
    void enrichEjecutores_cuandoNull_noHaceNada() {
        service.enrichEjecutores(null);
        verifyNoInteractions(entityManager);
    }

    @Test
    void enrichEjecutores_cuandoListaVacia_noHaceNada() {
        service.enrichEjecutores(List.of());
        verifyNoInteractions(entityManager);
    }

    @Test
    void enrichEjecutores_sinIds_noHaceQueries() {
        var resp = LaborEjecutorResponse.builder().id(1L).build();

        service.enrichEjecutores(List.of(resp));

        verifyNoInteractions(entityManager);
    }

    @Test
    void enrichEjecutores_conLaborId_enriqueceLaborNombre() {
        var resp = LaborEjecutorResponse.builder().id(1L).laborId(10L).build();
        lenient().when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        lenient().when(query.setParameter(anyString(), any())).thenReturn(query);
        @SuppressWarnings("rawtypes")
        List rowList = List.of((Object) new Object[]{10L, "Labor 1"});
        lenient().when(query.getResultList()).thenReturn(rowList);

        service.enrichEjecutores(List.of(resp));

        assertThat(resp.getLaborNombre()).isEqualTo("Labor 1");
    }

    @Test
    void enrichEjecutores_conEjecutorId_enriqueceEjecutorNombre() {
        var resp = LaborEjecutorResponse.builder().id(1L).ejecutorId(20L).build();
        lenient().when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        lenient().when(query.setParameter(anyString(), any())).thenReturn(query);
        @SuppressWarnings("rawtypes")
        List rowList = List.of((Object) new Object[]{20L, "Ejecutor X"});
        lenient().when(query.getResultList()).thenReturn(rowList);

        service.enrichEjecutores(List.of(resp));

        assertThat(resp.getEjecutorNombre()).isEqualTo("Ejecutor X");
    }

    // ─────────────── delete con referencias ───────────────

    @Test
    void delete_cuandoTieneReferencias_lanzaBusinessException() {
        when(laborRepository.findById(1L)).thenReturn(Optional.of(laborBase));
        when(laborRepository.existsReferenciaByLaborId(1L)).thenReturn(true);

        assertThatThrownBy(() -> service.delete(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("referencias");
        verify(laborRepository, never()).save(any());
    }

    // ─────────────── normalizar ───────────────

    @Test
    void create_sinFlagEstado_asignaActivo() {
        laborBase.setFlagEstado(null);
        when(laborRepository.existsByCodigoIgnoreCase(anyString())).thenReturn(false);
        when(laborRepository.save(any(Labor.class))).thenAnswer(i -> i.getArgument(0));

        var result = service.create(laborBase);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }
}
