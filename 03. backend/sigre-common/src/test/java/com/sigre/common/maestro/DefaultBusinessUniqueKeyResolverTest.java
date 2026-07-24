package com.sigre.common.maestro;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class DefaultBusinessUniqueKeyResolverTest {

    private final DefaultBusinessUniqueKeyResolver resolver = new DefaultBusinessUniqueKeyResolver();

    @Test
    void resuelveAnnotationBusinessUniqueKey() {
        assertEquals("tipoMov", resolver.resolveProperty(ConAnnotation.class).orElseThrow());
    }

    @Test
    void resuelveColumnUnique() {
        assertEquals("codigo", resolver.resolveProperty(ConColumnUnique.class).orElseThrow());
    }

    @Test
    void resuelveUniqueConstraintSaltandoFk() {
        assertEquals("codigo", resolver.resolveProperty(ConConstraintCompuesto.class).orElseThrow());
    }

    @Test
    void resuelveConvencionTipoMov() {
        assertEquals("tipoMov", resolver.resolveProperty(ConConvencion.class).orElseThrow());
    }

    @Test
    void respetaOptOut() {
        assertTrue(resolver.resolveProperty(ConOptOut.class).isEmpty());
    }

    @Entity
    static class ConAnnotation {
        @Id
        Long id;
        @BusinessUniqueKey
        String tipoMov;
        String nombre;
    }

    @Entity
    static class ConColumnUnique {
        @Id
        Long id;
        @Column(unique = true)
        String codigo;
        String nombre;
    }

    @Entity
    @Table(uniqueConstraints = @UniqueConstraint(columnNames = {"sucursal_id", "codigo"}))
    static class ConConstraintCompuesto {
        @Id
        Long id;
        @Column(name = "sucursal_id")
        Long sucursalId;
        @Column(name = "codigo")
        String codigo;
    }

    @Entity
    static class ConConvencion {
        @Id
        Long id;
        String tipoMov;
        String nombre;
    }

    @Entity
    @NoDefaultBusinessSort
    static class ConOptOut {
        @Id
        Long id;
        @Column(unique = true)
        String codigo;
    }
}
