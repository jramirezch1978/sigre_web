package com.sigre.comercializacion.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Collections;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;

/**
 * Tests de Branch Coverage para VentasFkValidator
 * Cubre todos los branches condicionales de los métodos de validación
 */
@ExtendWith(MockitoExtension.class)
class VentasFkValidatorBranchTest {

    @Mock
    private EntityManager entityManager;

    @Mock
    private Query query;

    private VentasFkValidator validator;

    @BeforeEach
    void setUp() {
        validator = new VentasFkValidator();
        // Inyectar el mock de EntityManager usando reflexión
        try {
            var field = VentasFkValidator.class.getDeclaredField("entityManager");
            field.setAccessible(true);
            field.set(validator, entityManager);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // ==================== TESTS DE existsSucursalActiva ====================

    @Test
    void existsSucursalActiva_conIdNull_retornaFalse() {
        boolean result = validator.existsSucursalActiva(null);
        assertThat(result).isFalse();
    }

    @Test
    void existsSucursalActiva_conIdValido_retornaTrue() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1L);

        // When
        boolean result = validator.existsSucursalActiva(1L);

        // Then
        assertThat(result).isTrue();
    }

    // ==================== TESTS DE existsPuntoVentaActivo ====================

    @Test
    void existsPuntoVentaActivo_conIdNull_retornaFalse() {
        boolean result = validator.existsPuntoVentaActivo(null, 1L);
        assertThat(result).isFalse();
    }

    @Test
    void existsPuntoVentaActivo_conSucursalIdNull_retornaFalse() {
        boolean result = validator.existsPuntoVentaActivo(1L, null);
        assertThat(result).isFalse();
    }

    @Test
    void existsPuntoVentaActivo_conAmbosNull_retornaFalse() {
        boolean result = validator.existsPuntoVentaActivo(null, null);
        assertThat(result).isFalse();
    }

    @Test
    void existsPuntoVentaActivo_conIdsValidos_retornaTrue() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1L);

        // When
        boolean result = validator.existsPuntoVentaActivo(1L, 1L);

        // Then
        assertThat(result).isTrue();
    }

    // ==================== TESTS DE existsFacturaTriplet ====================

    @Test
    void existsFacturaTriplet_conExcludeIdNull_retornaTrue() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1L);

        // When
        boolean result = validator.existsFacturaTriplet(1L, "F001", "12345", null);

        // Then
        assertThat(result).isTrue();
    }

    @Test
    void existsFacturaTriplet_conExcludeIdValido_retornaTrue() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1L);

        // When
        boolean result = validator.existsFacturaTriplet(1L, "F001", "12345", 100L);

        // Then
        assertThat(result).isTrue();
    }

    // ==================== TESTS DE findSucursalNombre ====================

    @Test
    void findSucursalNombre_conIdNull_retornaNull() {
        String result = validator.findSucursalNombre(null);
        assertThat(result).isNull();
    }

    @Test
    void findSucursalNombre_conListaVacia_retornaNull() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getResultList()).thenReturn(Collections.emptyList());

        // When
        String result = validator.findSucursalNombre(999L);

        // Then
        assertThat(result).isNull();
    }

    @Test
    void findSucursalNombre_conResultado_retornaNombre() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getResultList()).thenReturn(Collections.singletonList("SUCURSAL PRINCIPAL"));

        // When
        String result = validator.findSucursalNombre(1L);

        // Then
        assertThat(result).isEqualTo("SUCURSAL PRINCIPAL");
    }

    // ==================== TESTS DE findEntidadRazonSocial ====================

    @Test
    void findEntidadRazonSocial_conIdNull_retornaNull() {
        String result = validator.findEntidadRazonSocial(null);
        assertThat(result).isNull();
    }

    @Test
    void findEntidadRazonSocial_conListaVacia_retornaNull() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getResultList()).thenReturn(Collections.emptyList());

        // When
        String result = validator.findEntidadRazonSocial(999L);

        // Then
        assertThat(result).isNull();
    }

    @Test
    void findEntidadRazonSocial_conResultado_retornaRazonSocial() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getResultList()).thenReturn(Collections.singletonList("EMPRESA SAC"));

        // When
        String result = validator.findEntidadRazonSocial(1L);

        // Then
        assertThat(result).isEqualTo("EMPRESA SAC");
    }

    // ==================== TESTS DE findEntidadRuc ====================

    @Test
    void findEntidadRuc_conIdNull_retornaNull() {
        String result = validator.findEntidadRuc(null);
        assertThat(result).isNull();
    }

    @Test
    void findEntidadRuc_conListaVacia_retornaNull() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getResultList()).thenReturn(Collections.emptyList());

        // When
        String result = validator.findEntidadRuc(999L);

        // Then
        assertThat(result).isNull();
    }

    @Test
    void findEntidadRuc_conResultado_retornaRuc() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getResultList()).thenReturn(Collections.singletonList("123456789"));

        // When
        String result = validator.findEntidadRuc(1L);

        // Then
        assertThat(result).isEqualTo("123456789");
    }

    // ==================== TESTS DE findMonedaSimbolo ====================

    @Test
    void findMonedaSimbolo_conIdNull_retornaNull() {
        String result = validator.findMonedaSimbolo(null);
        assertThat(result).isNull();
    }

    @Test
    void findMonedaSimbolo_conListaVacia_retornaNull() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getResultList()).thenReturn(Collections.emptyList());

        // When
        String result = validator.findMonedaSimbolo(999L);

        // Then
        assertThat(result).isNull();
    }

    @Test
    void findMonedaSimbolo_conResultado_retornaSimbolo() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getResultList()).thenReturn(Collections.singletonList("S/"));

        // When
        String result = validator.findMonedaSimbolo(1L);

        // Then
        assertThat(result).isEqualTo("S/");
    }

    // ==================== TESTS DE OTROS MÉTODOS ====================

    @Test
    void existsEntidadContribuyenteActiva_conIdValido_retornaTrue() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1L);

        // When
        boolean result = validator.existsEntidadContribuyenteActiva(1L);

        // Then
        assertThat(result).isTrue();
    }

    @Test
    void existsDocTipoActivo_conIdValido_retornaTrue() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1L);

        // When
        boolean result = validator.existsDocTipoActivo(1L);

        // Then
        assertThat(result).isTrue();
    }

    @Test
    void existsMonedaActiva_conIdValido_retornaTrue() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1L);

        // When
        boolean result = validator.existsMonedaActiva(1L);

        // Then
        assertThat(result).isTrue();
    }

    @Test
    void existsUnidadMedidaActiva_conIdValido_retornaTrue() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1L);

        // When
        boolean result = validator.existsUnidadMedidaActiva(1L);

        // Then
        assertThat(result).isTrue();
    }

    @Test
    void existsTrabajadorActivo_conIdValido_retornaTrue() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1L);

        // When
        boolean result = validator.existsTrabajadorActivo(1L);

        // Then
        assertThat(result).isTrue();
    }

    @Test
    void existsMesaActiva_conIdValido_retornaTrue() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1L);

        // When
        boolean result = validator.existsMesaActiva(1L);

        // Then
        assertThat(result).isTrue();
    }

    @Test
    void existsFsFacturaSimplNoAnulada_conIdValido_retornaTrue() {
        // Given
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1L);

        // When
        boolean result = validator.existsFsFacturaSimplNoAnulada(1L);

        // Then
        assertThat(result).isTrue();
    }
}
