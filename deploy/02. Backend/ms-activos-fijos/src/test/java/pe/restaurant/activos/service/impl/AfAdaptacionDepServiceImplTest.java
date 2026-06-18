package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.entity.AfAdaptacion;
import pe.restaurant.activos.entity.AfAdaptacionDep;
import pe.restaurant.activos.repository.AfAdaptacionDepRepository;
import pe.restaurant.activos.repository.AfAdaptacionRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfAdaptacionDepServiceImplTest {

    @Mock
    private AfAdaptacionDepRepository repository;
    @Mock
    private AfAdaptacionRepository adaptacionRepository;
    @InjectMocks
    private AfAdaptacionDepServiceImpl service;

    @Test
    void findByIdReturnsEntity() {
        AfAdaptacionDep entity = new AfAdaptacionDep();
        entity.setId(1L);
        entity.setAnio(2026);
        entity.setMes(5);

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        AfAdaptacionDep result = service.findById(1L);
        assertEquals(2026, result.getAnio());
    }

    @Test
    void findByIdThrowsNotFound() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.findById(99L));
    }

    @Test
    void createSavesEntity() {
        AfAdaptacionDep entity = new AfAdaptacionDep();
        entity.setAfAdaptacionId(10L);
        entity.setAnio(2026);
        entity.setMes(3);
        entity.setDepreciacionPeriodo(new BigDecimal("100.0000"));
        entity.setDepreciacionAcumulada(new BigDecimal("300.0000"));

        AfAdaptacion adaptacion = new AfAdaptacion();
        adaptacion.setId(10L);

        AfAdaptacionDep saved = new AfAdaptacionDep();
        saved.setId(1L);
        saved.setAfAdaptacionId(10L);
        saved.setFlagEstado("1");

        when(adaptacionRepository.findById(10L)).thenReturn(Optional.of(adaptacion));
        when(repository.existsByAfAdaptacionIdAndAnioAndMes(10L, 2026, 3)).thenReturn(false);
        when(repository.save(any(AfAdaptacionDep.class))).thenReturn(saved);

        AfAdaptacionDep result = service.create(entity);
        assertEquals("1", result.getFlagEstado());
    }

    @Test
    void createThrowsWhenAdaptacionNotFound() {
        AfAdaptacionDep entity = new AfAdaptacionDep();
        entity.setAfAdaptacionId(99L);
        entity.setAnio(2026);
        entity.setMes(1);

        when(adaptacionRepository.findById(99L)).thenReturn(Optional.empty());
        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.ADAPTACION_NO_ENCONTRADA, ex.getErrorCode());
    }

    @Test
    void createThrowsWhenPeriodoDuplicated() {
        AfAdaptacionDep entity = new AfAdaptacionDep();
        entity.setAfAdaptacionId(10L);
        entity.setAnio(2026);
        entity.setMes(3);

        AfAdaptacion adaptacion = new AfAdaptacion();
        adaptacion.setId(10L);

        AfAdaptacionDep existing = new AfAdaptacionDep();
        existing.setId(5L);

        when(adaptacionRepository.findById(10L)).thenReturn(Optional.of(adaptacion));
        when(repository.existsByAfAdaptacionIdAndAnioAndMes(10L, 2026, 3)).thenReturn(true);
        when(repository.findByAdaptacionAndPeriodo(10L, 2026, 3)).thenReturn(Optional.of(existing));

        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.DEPRECIACION_ADAPTACION_DUPLICADA, ex.getErrorCode());
    }

    @Test
    void updateModifiesEntity() {
        AfAdaptacionDep existing = new AfAdaptacionDep();
        existing.setId(1L);
        existing.setAfAdaptacionId(10L);
        existing.setAnio(2026);
        existing.setMes(3);
        existing.setDepreciacionPeriodo(new BigDecimal("100.0000"));
        existing.setDepreciacionAcumulada(new BigDecimal("300.0000"));

        AfAdaptacionDep updateData = new AfAdaptacionDep();
        updateData.setAnio(2026);
        updateData.setMes(4);
        updateData.setDepreciacionPeriodo(new BigDecimal("120.0000"));
        updateData.setDepreciacionAcumulada(new BigDecimal("420.0000"));

        AfAdaptacionDep updated = new AfAdaptacionDep();
        updated.setId(1L);
        updated.setAnio(2026);
        updated.setMes(4);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.existsByAfAdaptacionIdAndAnioAndMes(10L, 2026, 4)).thenReturn(false);
        when(repository.save(any(AfAdaptacionDep.class))).thenReturn(updated);

        AfAdaptacionDep result = service.update(1L, updateData);
        assertEquals(4, result.getMes());
    }

    @Test
    void updateSkipsPeriodoValidationWhenSamePeriod() {
        AfAdaptacionDep existing = new AfAdaptacionDep();
        existing.setId(1L);
        existing.setAfAdaptacionId(10L);
        existing.setAnio(2026);
        existing.setMes(3);
        existing.setDepreciacionPeriodo(new BigDecimal("100.0000"));
        existing.setDepreciacionAcumulada(new BigDecimal("300.0000"));

        AfAdaptacionDep updateData = new AfAdaptacionDep();
        updateData.setAnio(2026);
        updateData.setMes(3);
        updateData.setDepreciacionPeriodo(new BigDecimal("150.0000"));
        updateData.setDepreciacionAcumulada(new BigDecimal("350.0000"));

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(any(AfAdaptacionDep.class))).thenReturn(existing);

        assertDoesNotThrow(() -> service.update(1L, updateData));
        verify(repository, never()).existsByAfAdaptacionIdAndAnioAndMes(anyLong(), anyInt(), anyInt());
    }

    @Test
    void updateThrowsWhenNewPeriodoDuplicated() {
        AfAdaptacionDep existing = new AfAdaptacionDep();
        existing.setId(1L);
        existing.setAfAdaptacionId(10L);
        existing.setAnio(2026);
        existing.setMes(3);

        AfAdaptacionDep updateData = new AfAdaptacionDep();
        updateData.setAnio(2026);
        updateData.setMes(5);

        AfAdaptacionDep other = new AfAdaptacionDep();
        other.setId(7L);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.existsByAfAdaptacionIdAndAnioAndMes(10L, 2026, 5)).thenReturn(true);
        when(repository.findByAdaptacionAndPeriodo(10L, 2026, 5)).thenReturn(Optional.of(other));

        BusinessException ex = assertThrows(BusinessException.class, () -> service.update(1L, updateData));
        assertEquals(ActivosErrorCodes.DEPRECIACION_ADAPTACION_DUPLICADA, ex.getErrorCode());
    }

    @Test
    void deleteRemovesEntity() {
        AfAdaptacionDep entity = new AfAdaptacionDep();
        entity.setId(1L);

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        assertDoesNotThrow(() -> service.delete(1L));
        verify(repository).delete(entity);
    }

    @Test
    void deleteThrowsNotFound() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.delete(99L));
    }

    @Test
    void findByAdaptacionReturnsList() {
        AfAdaptacionDep dep = new AfAdaptacionDep();
        dep.setId(1L);
        dep.setAfAdaptacionId(10L);

        when(repository.findByAfAdaptacionId(10L)).thenReturn(List.of(dep));
        List<AfAdaptacionDep> result = service.findByAdaptacion(10L);
        assertEquals(1, result.size());
    }

    @Test
    void findByPeriodoReturnsList() {
        AfAdaptacionDep dep = new AfAdaptacionDep();
        dep.setId(1L);
        dep.setAnio(2026);
        dep.setMes(5);

        when(repository.findByAnioAndMes(2026, 5)).thenReturn(List.of(dep));
        List<AfAdaptacionDep> result = service.findByPeriodo(2026, 5);
        assertEquals(1, result.size());
    }

    @Test
    void calcularDepreciacionCreatesNewRecord() {
        AfAdaptacion adaptacion = new AfAdaptacion();
        adaptacion.setId(10L);

        when(adaptacionRepository.findById(10L)).thenReturn(Optional.of(adaptacion));
        when(repository.existsByAfAdaptacionIdAndAnioAndMes(10L, 2026, 6)).thenReturn(false);
        when(repository.findByAdaptacionOrderByPeriodoDesc(10L)).thenReturn(List.of());
        when(repository.save(any(AfAdaptacionDep.class))).thenAnswer(inv -> {
            AfAdaptacionDep arg = inv.getArgument(0);
            arg.setId(1L);
            return arg;
        });

        AfAdaptacionDep result = service.calcularDepreciacion(10L, 2026, 6);
        assertNotNull(result.getId());
        assertEquals("1", result.getFlagEstado());
    }

    @Test
    void calcularDepreciacionUsesAcumuladaAnterior() {
        AfAdaptacion adaptacion = new AfAdaptacion();
        adaptacion.setId(10L);

        AfAdaptacionDep anterior = new AfAdaptacionDep();
        anterior.setDepreciacionAcumulada(new BigDecimal("500.0000"));

        when(adaptacionRepository.findById(10L)).thenReturn(Optional.of(adaptacion));
        when(repository.existsByAfAdaptacionIdAndAnioAndMes(10L, 2026, 7)).thenReturn(false);
        when(repository.findByAdaptacionOrderByPeriodoDesc(10L)).thenReturn(List.of(anterior));
        when(repository.save(any(AfAdaptacionDep.class))).thenAnswer(inv -> {
            AfAdaptacionDep arg = inv.getArgument(0);
            arg.setId(2L);
            return arg;
        });

        AfAdaptacionDep result = service.calcularDepreciacion(10L, 2026, 7);
        assertEquals(new BigDecimal("500.0000"), result.getDepreciacionAcumulada());
    }

    @Test
    void calcularDepreciacionThrowsWhenAdaptacionNotFound() {
        when(adaptacionRepository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.calcularDepreciacion(99L, 2026, 1));
    }

    @Test
    void calcularDepreciacionThrowsWhenPeriodoDuplicated() {
        AfAdaptacion adaptacion = new AfAdaptacion();
        adaptacion.setId(10L);

        AfAdaptacionDep existing = new AfAdaptacionDep();
        existing.setId(5L);

        when(adaptacionRepository.findById(10L)).thenReturn(Optional.of(adaptacion));
        when(repository.existsByAfAdaptacionIdAndAnioAndMes(10L, 2026, 3)).thenReturn(true);
        when(repository.findByAdaptacionAndPeriodo(10L, 2026, 3)).thenReturn(Optional.of(existing));

        BusinessException ex = assertThrows(BusinessException.class, () -> service.calcularDepreciacion(10L, 2026, 3));
        assertEquals(ActivosErrorCodes.DEPRECIACION_ADAPTACION_DUPLICADA, ex.getErrorCode());
    }
}
