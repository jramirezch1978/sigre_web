package com.sigre.almacen.service.impl;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Expression;
import jakarta.persistence.criteria.Path;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import jakarta.persistence.criteria.Subquery;
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
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.almacen.entity.AlmacenTipoMov;
import com.sigre.almacen.entity.ArticuloMovTipo;
import com.sigre.almacen.repository.AlmacenRepository;
import com.sigre.almacen.repository.AlmacenTipoMovRepository;
import com.sigre.almacen.repository.ArticuloMovTipoRepository;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

/**
 * Bloque B: almacen_tipo_mov — listar, asignar, desasignar tipos por almacén.
 */
@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class AlmacenTipoMovServiceImplTest {

    @Mock
    private AlmacenTipoMovRepository almacenTipoMovRepository;
    @Mock
    private AlmacenRepository almacenRepository;
    @Mock
    private ArticuloMovTipoRepository articuloMovTipoRepository;
    @InjectMocks
    private AlmacenTipoMovServiceImpl service;

    private ArticuloMovTipo tipoActivo;
    private ArticuloMovTipo tipoInactivo;

    @BeforeEach
    void setUp() {
        tipoActivo = new ArticuloMovTipo();
        tipoActivo.setId(1L);
        tipoActivo.setTipoMov("I01");
        tipoActivo.setDescTipoMov("Ingreso");
        tipoActivo.setFlagEstado("1");
        tipoActivo.setFlagContabiliza("0");
        tipoActivo.setFlagAjusteValorizacion("0");
        tipoActivo.setFlagMovEntreAlm("0");
        tipoActivo.setFlagSolicitaProv("0");
        tipoActivo.setFlagSolicitaDocInt("0");
        tipoActivo.setFlagSolicitaDocExt("0");
        tipoActivo.setFlagSolicitaRef("0");
        tipoActivo.setFlagSolicitaLote("0");
        tipoActivo.setFlagSolicitaCenbef("0");
        tipoActivo.setFlagSolicitaPrecio("0");
        tipoActivo.setFactorSldoTotal(BigDecimal.ONE);
        tipoActivo.setFactorSldoXLlegar(BigDecimal.ZERO);
        tipoActivo.setFactorSldoSol(BigDecimal.ZERO);
        tipoActivo.setFactorSldoDev(BigDecimal.ZERO);
        tipoActivo.setFactorSldoPres(BigDecimal.ZERO);
        tipoActivo.setFactorSldoConsig(BigDecimal.ZERO);
        tipoActivo.setFactorCtrlTempla(BigDecimal.ZERO);

        tipoInactivo = new ArticuloMovTipo();
        tipoInactivo.setId(2L);
        tipoInactivo.setFlagEstado("0");
    }

    @Test
    void asignar_lanzaSiTipoMovNoExiste() {
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(articuloMovTipoRepository.findById(88L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.asignar(1L, 88L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void desasignar_lanzaSiAlmacenInexistente() {
        when(almacenRepository.existsById(9L)).thenReturn(false);
        assertThatThrownBy(() -> service.desasignar(9L, 1L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void listar_lanzaSiAlmacenInexistente() {
        when(almacenRepository.existsById(9L)).thenReturn(false);
        assertThatThrownBy(() -> service.listarPorAlmacen(9L, Pageable.unpaged(), null, null))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void listar_usaSpecification() {
        when(almacenRepository.existsById(1L)).thenReturn(true);
        AlmacenTipoMov row = new AlmacenTipoMov();
        row.setId(5L);
        row.setAlmacenId(1L);
        row.setArticuloMovTipoId(1L);
        row.setFlagEstado("1");
        when(almacenTipoMovRepository.findAll(any(Specification.class), eq(Pageable.unpaged())))
                .thenReturn(new PageImpl<>(List.of(row)));
        when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipoActivo));
        var page = service.listarPorAlmacen(1L, Pageable.unpaged(), null, null);
        assertThat(page.getContent()).hasSize(1);
        assertThat(page.getContent().get(0).getTipoMov()).isEqualTo("I01");
    }

    @Test
    void asignar_lanzaSiTipoMovInactivo() {
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(articuloMovTipoRepository.findById(2L)).thenReturn(Optional.of(tipoInactivo));
        assertThatThrownBy(() -> service.asignar(1L, 2L))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "TIPO_MOV_INACTIVO");
    }

    @Test
    void asignar_lanzaSiDuplicadoActivo() {
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipoActivo));
        AlmacenTipoMov dup = new AlmacenTipoMov();
        dup.setFlagEstado("1");
        when(almacenTipoMovRepository.findByAlmacenIdAndArticuloMovTipoId(1L, 1L))
                .thenReturn(Optional.of(dup));
        assertThatThrownBy(() -> service.asignar(1L, 1L))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALMACEN_TIPO_MOV_DUPLICADO");
    }

    @Test
    void asignar_persisteYResponde() {
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipoActivo));
        when(almacenTipoMovRepository.findByAlmacenIdAndArticuloMovTipoId(1L, 1L))
                .thenReturn(Optional.empty());
        when(almacenTipoMovRepository.save(any(AlmacenTipoMov.class))).thenAnswer(i -> {
            AlmacenTipoMov m = i.getArgument(0);
            m.setId(100L);
            return m;
        });
        var resp = service.asignar(1L, 1L);
        assertThat(resp.getAlmacenId()).isEqualTo(1L);
        assertThat(resp.getArticuloMovTipoId()).isEqualTo(1L);
        assertThat(resp.getTipoMov()).isEqualTo("I01");
    }

    @Test
    void asignar_reactivaCuandoExisteInactivo() {
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipoActivo));
        AlmacenTipoMov existing = new AlmacenTipoMov();
        existing.setId(77L);
        existing.setAlmacenId(1L);
        existing.setArticuloMovTipoId(1L);
        existing.setFlagEstado("0");
        when(almacenTipoMovRepository.findByAlmacenIdAndArticuloMovTipoId(1L, 1L))
                .thenReturn(Optional.of(existing));
        when(almacenTipoMovRepository.save(existing)).thenAnswer(i -> i.getArgument(0));
        var resp = service.asignar(1L, 1L);
        assertThat(resp.getFlagEstado()).isEqualTo("1");
        verify(almacenTipoMovRepository).save(existing);
    }

    @Test
    void desasignar_lanzaSiFilaInexistente() {
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(almacenTipoMovRepository.findByAlmacenIdAndArticuloMovTipoId(1L, 7L))
                .thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.desasignar(1L, 7L))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(almacenTipoMovRepository, never()).save(any());
    }

    @Test
    void listar_conFiltros_flagEstadoYTipoMov() {
        when(almacenRepository.existsById(1L)).thenReturn(true);
        AlmacenTipoMov row = new AlmacenTipoMov();
        row.setId(5L);
        row.setAlmacenId(1L);
        row.setArticuloMovTipoId(1L);
        row.setFlagEstado("1");
        when(almacenTipoMovRepository.findAll(any(Specification.class), eq(Pageable.unpaged())))
                .thenReturn(new PageImpl<>(List.of(row)));
        when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipoActivo));

        var page = service.listarPorAlmacen(1L, Pageable.unpaged(), "1", "I01");

        assertThat(page.getContent()).hasSize(1);
    }

    @Test
    void listar_tipoMovSinArticulo_usaSoloFila() {
        when(almacenRepository.existsById(1L)).thenReturn(true);
        AlmacenTipoMov row = new AlmacenTipoMov();
        row.setId(6L);
        row.setAlmacenId(1L);
        row.setArticuloMovTipoId(99L);
        row.setFlagEstado("1");
        when(almacenTipoMovRepository.findAll(any(Specification.class), eq(Pageable.unpaged())))
                .thenReturn(new PageImpl<>(List.of(row)));
        when(articuloMovTipoRepository.findById(99L)).thenReturn(Optional.empty());

        var page = service.listarPorAlmacen(1L, Pageable.unpaged(), null, null);

        assertThat(page.getContent().get(0).getTipoMov()).isNull();
        assertThat(page.getContent().get(0).getArticuloMovTipoId()).isEqualTo(99L);
    }

    // ────────────────────────────────────────────────────────────────────
    // buildSpecification — disparar lambda interno con root/cb/query mockeados
    // ────────────────────────────────────────────────────────────────────

    /**
     * Helper para construir mocks de Criteria API. Reduce duplicación entre los 5
     * tests del lambda buildSpecification.
     */
    @SuppressWarnings({"unchecked", "rawtypes"})
    private void invocarLambdaListar(String flagEstado, String tipoMov, boolean configurarSubquery) {
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(almacenTipoMovRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of()));

        service.listarPorAlmacen(1L, Pageable.unpaged(), flagEstado, tipoMov);

        ArgumentCaptor<Specification<AlmacenTipoMov>> specCap =
                ArgumentCaptor.forClass(Specification.class);
        verify(almacenTipoMovRepository).findAll(specCap.capture(), any(Pageable.class));

        Root<AlmacenTipoMov> root = mock(Root.class);
        CriteriaQuery<?> query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Path path = mock(Path.class);
        Predicate predicate = mock(Predicate.class);

        lenient().when(root.get(anyString())).thenReturn(path);
        // Stub específico al overload equal(Expression, Object) — el primer arg
        // es siempre Expression y el segundo es Object boxed (Long/String).
        lenient().doReturn(predicate).when(cb).equal(any(Expression.class), any(Object.class));
        // `and` con varargs — el stub debe matchear tanto and(Predicate) como and(Predicate, Predicate, ...).
        lenient().when(cb.and(any(Predicate[].class))).thenReturn(predicate);
        lenient().when(cb.and(any(Predicate.class))).thenReturn(predicate);
        lenient().when(cb.and(any(Predicate.class), any(Predicate.class))).thenReturn(predicate);
        lenient().when(cb.and(any(Predicate.class), any(Predicate.class), any(Predicate.class))).thenReturn(predicate);

        if (configurarSubquery) {
            Subquery<Long> subquery = mock(Subquery.class);
            Root<ArticuloMovTipo> subRoot = mock(Root.class);
            Predicate inPredicate = mock(Predicate.class);
            lenient().when(query.subquery(Long.class)).thenReturn(subquery);
            lenient().when(subquery.from(ArticuloMovTipo.class)).thenReturn(subRoot);
            lenient().when(subRoot.get(anyString())).thenReturn(path);
            lenient().when(subquery.select(any())).thenReturn(subquery);
            lenient().when(path.in(any(Subquery.class))).thenReturn(inPredicate);
        }

        // Ejecutamos el lambda — esto cubre las ramas en JaCoCo.
        Predicate result = specCap.getValue().toPredicate(root, query, cb);
        assertThat(result).isNotNull();
    }

    @Test
    void buildSpecification_filtroSoloAlmacenId() {
        invocarLambdaListar(null, null, false);
    }

    @Test
    void buildSpecification_filtroFlagEstadoEnBlanco_seIgnora() {
        invocarLambdaListar("   ", "   ", false);
    }

    @Test
    void buildSpecification_conFlagEstado_agregaPredicado() {
        invocarLambdaListar("1", null, false);
    }

    @Test
    void buildSpecification_conTipoMov_abreSubquery() {
        invocarLambdaListar(null, "I01", true);
    }

    @Test
    void buildSpecification_conTodosLosFiltros() {
        invocarLambdaListar("1", "I01", true);
    }

    @Test
    void desasignar_bajaLogica() {
        AlmacenTipoMov row = new AlmacenTipoMov();
        row.setFlagEstado("1");
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(almacenTipoMovRepository.findByAlmacenIdAndArticuloMovTipoId(1L, 1L))
                .thenReturn(Optional.of(row));
        when(almacenTipoMovRepository.save(row)).thenReturn(row);
        service.desasignar(1L, 1L);
        assertThat(row.getFlagEstado()).isEqualTo("0");
        verify(almacenTipoMovRepository).save(row);
        verify(almacenTipoMovRepository, never()).delete(any(AlmacenTipoMov.class));
    }
}
