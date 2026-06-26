package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.entity.AfAdaptacion;
import pe.restaurant.activos.entity.AfAdaptacionDet;
import pe.restaurant.activos.repository.AfAdaptacionDetRepository;
import pe.restaurant.activos.repository.AfAdaptacionRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfAdaptacionDetServiceImplTest {

    @Mock
    private AfAdaptacionDetRepository repository;
    @Mock
    private AfAdaptacionRepository adaptacionRepository;
    @InjectMocks
    private AfAdaptacionDetServiceImpl service;

    @Test
    void findByIdReturnsEntity() {
        AfAdaptacionDet entity = new AfAdaptacionDet();
        entity.setId(1L);
        entity.setDescripcion("Detalle A");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        AfAdaptacionDet result = service.findById(1L);
        assertEquals("Detalle A", result.getDescripcion());
    }

    @Test
    void findByIdThrowsNotFound() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.findById(99L));
    }

    @Test
    void createSavesEntity() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfAdaptacion adaptacion = new AfAdaptacion();
            adaptacion.setId(10L);
            adaptacion.setMontoTotal(BigDecimal.ZERO);

            AfAdaptacionDet entity = new AfAdaptacionDet();
            entity.setAfAdaptacionId(10L);
            entity.setDescripcion("Trabajo X");
            entity.setMonto(new BigDecimal("500.0000"));

            AfAdaptacionDet saved = new AfAdaptacionDet();
            saved.setId(1L);
            saved.setFlagEstado("1");
            saved.setAfAdaptacionId(10L);

            when(adaptacionRepository.findById(10L)).thenReturn(Optional.of(adaptacion));
            when(repository.save(any(AfAdaptacionDet.class))).thenReturn(saved);
            when(repository.calcularTotalDetalles(10L)).thenReturn(new BigDecimal("500.0000"));
            when(adaptacionRepository.save(any(AfAdaptacion.class))).thenReturn(adaptacion);

            AfAdaptacionDet result = service.create(entity);
            assertEquals("1", result.getFlagEstado());
        }
    }

    @Test
    void createThrowsWhenAdaptacionNotFound() {
        AfAdaptacionDet entity = new AfAdaptacionDet();
        entity.setAfAdaptacionId(99L);
        entity.setMonto(new BigDecimal("100.0000"));

        when(adaptacionRepository.findById(99L)).thenReturn(Optional.empty());
        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.ADAPTACION_NO_ENCONTRADA, ex.getErrorCode());
    }

    @Test
    void createThrowsWhenMontoZero() {
        AfAdaptacionDet entity = new AfAdaptacionDet();
        entity.setAfAdaptacionId(10L);
        entity.setMonto(BigDecimal.ZERO);

        AfAdaptacion adaptacion = new AfAdaptacion();
        adaptacion.setId(10L);

        when(adaptacionRepository.findById(10L)).thenReturn(Optional.of(adaptacion));

        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals("ACT-038", ex.getErrorCode());
    }

    @Test
    void createThrowsWhenMontoNull() {
        AfAdaptacionDet entity = new AfAdaptacionDet();
        entity.setAfAdaptacionId(10L);
        entity.setMonto(null);

        AfAdaptacion adaptacion = new AfAdaptacion();
        adaptacion.setId(10L);

        when(adaptacionRepository.findById(10L)).thenReturn(Optional.of(adaptacion));

        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals("ACT-038", ex.getErrorCode());
    }

    @Test
    void createThrowsWhenMontoNegative() {
        AfAdaptacionDet entity = new AfAdaptacionDet();
        entity.setAfAdaptacionId(10L);
        entity.setMonto(new BigDecimal("-10.0000"));

        AfAdaptacion adaptacion = new AfAdaptacion();
        adaptacion.setId(10L);

        when(adaptacionRepository.findById(10L)).thenReturn(Optional.of(adaptacion));

        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals("ACT-038", ex.getErrorCode());
    }

    @Test
    void updateModifiesEntity() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfAdaptacionDet existing = new AfAdaptacionDet();
            existing.setId(1L);
            existing.setAfAdaptacionId(10L);
            existing.setDescripcion("Original");
            existing.setMonto(new BigDecimal("300.0000"));

            AfAdaptacion adaptacion = new AfAdaptacion();
            adaptacion.setId(10L);

            AfAdaptacionDet updateData = new AfAdaptacionDet();
            updateData.setDescripcion("Modificado");
            updateData.setMonto(new BigDecimal("400.0000"));
            updateData.setUnidadMedidaId(2L);

            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(adaptacionRepository.findById(10L)).thenReturn(Optional.of(adaptacion));
            when(repository.save(any(AfAdaptacionDet.class))).thenReturn(existing);
            when(repository.calcularTotalDetalles(10L)).thenReturn(new BigDecimal("400.0000"));
            when(adaptacionRepository.save(any(AfAdaptacion.class))).thenReturn(adaptacion);

            AfAdaptacionDet result = service.update(1L, updateData);
            assertNotNull(result);
        }
    }

    @Test
    void updateThrowsWhenMontoInvalid() {
        AfAdaptacionDet existing = new AfAdaptacionDet();
        existing.setId(1L);
        existing.setAfAdaptacionId(10L);

        AfAdaptacion adaptacion = new AfAdaptacion();
        adaptacion.setId(10L);

        AfAdaptacionDet updateData = new AfAdaptacionDet();
        updateData.setMonto(BigDecimal.ZERO);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(adaptacionRepository.findById(10L)).thenReturn(Optional.of(adaptacion));

        BusinessException ex = assertThrows(BusinessException.class, () -> service.update(1L, updateData));
        assertEquals("ACT-038", ex.getErrorCode());
    }

    @Test
    void deleteRemovesEntity() {
        AfAdaptacionDet existing = new AfAdaptacionDet();
        existing.setId(1L);
        existing.setAfAdaptacionId(10L);

        AfAdaptacion adaptacion = new AfAdaptacion();
        adaptacion.setId(10L);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(adaptacionRepository.findById(10L)).thenReturn(Optional.of(adaptacion));
        when(repository.calcularTotalDetalles(10L)).thenReturn(BigDecimal.ZERO);
        when(adaptacionRepository.save(any(AfAdaptacion.class))).thenReturn(adaptacion);

        assertDoesNotThrow(() -> service.delete(1L));
        verify(repository).delete(existing);
    }

    @Test
    void deleteThrowsNotFound() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.delete(99L));
    }

    @Test
    void findByAdaptacionReturnsList() {
        AfAdaptacionDet det = new AfAdaptacionDet();
        det.setId(1L);

        when(repository.findByAfAdaptacionId(10L)).thenReturn(List.of(det));
        List<AfAdaptacionDet> result = service.findByAdaptacion(10L);
        assertEquals(1, result.size());
    }

    @Test
    void calcularTotalReturnsSum() {
        when(repository.calcularTotalDetalles(10L)).thenReturn(new BigDecimal("1500.0000"));
        BigDecimal result = service.calcularTotal(10L);
        assertEquals(new BigDecimal("1500.0000"), result);
    }

    @Test
    void calcularTotalReturnsZeroWhenNull() {
        when(repository.calcularTotalDetalles(10L)).thenReturn(null);
        BigDecimal result = service.calcularTotal(10L);
        assertEquals(BigDecimal.ZERO, result);
    }
}
