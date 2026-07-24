package com.sigre.common.maestro;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import org.junit.jupiter.api.Test;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class UniqueKeyPageablesTest {

    @Test
    void aplicaSortCuandoPageableNoTieneOrden() {
        Pageable pageable = PageRequest.of(0, 20);
        Pageable ensured = UniqueKeyPageables.ensure(EntidadCodigo.class, pageable);

        assertTrue(ensured.getSort().isSorted());
        assertEquals("codigo", ensured.getSort().iterator().next().getProperty());
        assertEquals(Sort.Direction.ASC, ensured.getSort().iterator().next().getDirection());
    }

    @Test
    void respetaSortDelCliente() {
        Pageable pageable = PageRequest.of(0, 20, Sort.by(Sort.Direction.DESC, "nombre"));
        Pageable ensured = UniqueKeyPageables.ensure(EntidadCodigo.class, pageable);

        assertEquals("nombre", ensured.getSort().iterator().next().getProperty());
        assertEquals(Sort.Direction.DESC, ensured.getSort().iterator().next().getDirection());
    }

    @Test
    void sortOfDevuelveUniqueKey() {
        Sort sort = UniqueKeyPageables.sortOf(EntidadCodigo.class);
        assertEquals("codigo", sort.iterator().next().getProperty());
    }

    @Test
    void noAlteraSiEntidadConOptOut() {
        Pageable pageable = PageRequest.of(0, 20);
        Pageable ensured = UniqueKeyPageables.ensure(EntidadOptOut.class, pageable);
        assertTrue(ensured.getSort().isUnsorted());
    }

    @Entity
    static class EntidadCodigo {
        @Id
        Long id;
        @Column(unique = true)
        String codigo;
    }

    @Entity
    @NoDefaultBusinessSort
    static class EntidadOptOut {
        @Id
        Long id;
        @Column(unique = true)
        String codigo;
    }
}
