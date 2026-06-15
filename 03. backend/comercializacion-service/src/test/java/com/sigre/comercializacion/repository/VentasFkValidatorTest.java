package com.sigre.comercializacion.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class VentasFkValidatorTest {

    @Mock
    private EntityManager entityManager;
    @Mock
    private Query query;

    private VentasFkValidator validator;

    @BeforeEach
    void setUp() {
        validator = new VentasFkValidator();
        ReflectionTestUtils.setField(validator, "entityManager", entityManager);
    }

    @Test
    void existsSucursalActiva_nullId_noConsulta() {
        assertThat(validator.existsSucursalActiva(null)).isFalse();
        verifyNoInteractions(entityManager);
    }

    @Test
    void existsSucursalActiva_positivo() {
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1L);
        assertThat(validator.existsSucursalActiva(5L)).isTrue();
    }

    @Test
    void existsPuntoVentaActivo_null_noConsulta() {
        assertThat(validator.existsPuntoVentaActivo(null, 1L)).isFalse();
        assertThat(validator.existsPuntoVentaActivo(1L, null)).isFalse();
        verifyNoInteractions(entityManager);
    }

    @Test
    void existsFsFacturaSimplNoAnulada_null_noConsulta() {
        assertThat(validator.existsFsFacturaSimplNoAnulada(null)).isFalse();
        verifyNoInteractions(entityManager);
    }

    @Test
    void existsFsFacturaSimplNoAnulada_countCero_false() {
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(0L);
        assertThat(validator.existsFsFacturaSimplNoAnulada(100L)).isFalse();
    }

    @Test
    void existsFsFacturaSimplNoAnulada_countPositivo_true() {
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1L);
        assertThat(validator.existsFsFacturaSimplNoAnulada(42L)).isTrue();
    }
}
