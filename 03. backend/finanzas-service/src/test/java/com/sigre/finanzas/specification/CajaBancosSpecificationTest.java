package com.sigre.finanzas.specification;

import static org.assertj.core.api.Assertions.assertThat;
import jakarta.persistence.criteria.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.finanzas.entity.CajaBancos;

import java.time.LocalDate;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;
import static org.mockito.Mockito.lenient;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - CajaBancosSpecification")
class CajaBancosSpecificationTest {

    @Mock
    private Root<CajaBancos> root;

    @Mock
    private CriteriaQuery<?> query;

    @Mock
    private CriteriaBuilder cb;

    @Mock
    private Predicate predicate;

    @Mock
    private Path<Object> path;

    @BeforeEach
    void setUp() {
        lenient().when(cb.equal(any(Expression.class), any(Object.class))).thenReturn(predicate);
        lenient().when(cb.and(any(Predicate.class), any(Predicate.class))).thenReturn(predicate);
        lenient().when(cb.greaterThanOrEqualTo(any(Expression.class), any(LocalDate.class))).thenReturn(predicate);
        lenient().when(cb.lessThanOrEqualTo(any(Expression.class), any(LocalDate.class))).thenReturn(predicate);
        lenient().when(cb.isNull(any(Expression.class))).thenReturn(predicate);
        lenient().when(cb.isNotNull(any(Expression.class))).thenReturn(predicate);
        lenient().when(cb.conjunction()).thenReturn(predicate);
        lenient().when(root.get(anyString())).thenReturn(path);
    }


    // ==== conFlagTipoTransaccion — otros ====

    @Test
    @DisplayName("conFlagTipoTransaccion debe crear filtro por tipo de transacción")
    void conFlagTipoTransaccion_debeCrearFiltro() {
        Specification<CajaBancos> spec = CajaBancosSpecification.conFlagTipoTransaccion("C");
        assertThat(spec).isNotNull();
        Predicate result = spec.toPredicate(root, query, cb);
        assertThat(result).isNotNull();
        verify(cb).equal(any(), eq("C"));
    }


    // ==== conBancoCntaId — otros ====

    @Test
    @DisplayName("conBancoCntaId debe crear filtro por cuenta bancaria")
    void conBancoCntaId_debeCrearFiltro() {
        Specification<CajaBancos> spec = CajaBancosSpecification.conBancoCntaId(1L);
        assertThat(spec).isNotNull();
        spec.toPredicate(root, query, cb);
        verify(cb).equal(any(), eq(1L));
    }


    // ==== conFechaEmisionDesde — otros ====

    @Test
    @DisplayName("conFechaEmisionDesde debe crear filtro por fecha desde")
    void conFechaEmisionDesde_debeCrearFiltro() {
        LocalDate fecha = LocalDate.of(2026, 5, 1);

        Specification<CajaBancos> spec = CajaBancosSpecification.conFechaEmisionDesde(fecha);
        assertThat(spec).isNotNull();
        spec.toPredicate(root, query, cb);
        verify(cb).greaterThanOrEqualTo(any(Expression.class), eq(fecha));
    }


    // ==== conFechaEmisionHasta — otros ====

    @Test
    @DisplayName("conFechaEmisionHasta debe crear filtro por fecha hasta")
    void conFechaEmisionHasta_debeCrearFiltro() {
        LocalDate fecha = LocalDate.of(2026, 5, 31);

        Specification<CajaBancos> spec = CajaBancosSpecification.conFechaEmisionHasta(fecha);
        assertThat(spec).isNotNull();
        spec.toPredicate(root, query, cb);
        verify(cb).lessThanOrEqualTo(any(Expression.class), eq(fecha));
    }


    // ==== conEstado — otros ====

    @Test
    @DisplayName("conEstado con 'REGISTRADO' debe filtrar por activos no ejecutados")
    void conEstado_REGISTRADO_debeFiltrarActivosNoEjecutados() {
        when(cb.isNull(any())).thenReturn(predicate);

        Specification<CajaBancos> spec = CajaBancosSpecification.conEstado("REGISTRADO");
        assertThat(spec).isNotNull();
        spec.toPredicate(root, query, cb);
        verify(cb).equal(any(), eq("1"));
        verify(cb).isNull(any());
    }

    @Test
    @DisplayName("conEstado con 'EJECUTADO' debe filtrar por activos ejecutados")
    void conEstado_EJECUTADO_debeFiltrarActivosEjecutados() {
        when(cb.isNotNull(any())).thenReturn(predicate);

        Specification<CajaBancos> spec = CajaBancosSpecification.conEstado("EJECUTADO");
        assertThat(spec).isNotNull();
        spec.toPredicate(root, query, cb);
        verify(cb).equal(any(), eq("1"));
        verify(cb).isNotNull(any());
    }

    @Test
    @DisplayName("conEstado con 'ANULADO' debe filtrar por anulados")
    void conEstado_ANULADO_debeFiltrarAnulados() {
        Specification<CajaBancos> spec = CajaBancosSpecification.conEstado("ANULADO");
        assertThat(spec).isNotNull();
        spec.toPredicate(root, query, cb);
        verify(cb).equal(any(), eq("0"));
    }

    @Test
    @DisplayName("conEstado con valor desconocido debe retornar conjunción (sin filtro)")
    void conEstado_valorDesconocido_debeRetornarConjuncion() {
        Specification<CajaBancos> spec = CajaBancosSpecification.conEstado("OTRO");
        assertThat(spec).isNotNull();
        spec.toPredicate(root, query, cb);
        verify(cb).conjunction();
    }


    // ==== conEntidadContribuyenteId — otros ====

    @Test
    @DisplayName("conEntidadContribuyenteId debe crear filtro por entidad")
    void conEntidadContribuyenteId_debeCrearFiltro() {
        Specification<CajaBancos> spec = CajaBancosSpecification.conEntidadContribuyenteId(1L);
        assertThat(spec).isNotNull();
        spec.toPredicate(root, query, cb);
        verify(cb).equal(any(), eq(1L));
    }
}
