package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.dao.QueryTimeoutException;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfMatrizSubClase;
import pe.restaurant.activos.entity.AfSubClase;
import pe.restaurant.activos.repository.AfMatrizSubClaseRepository;
import pe.restaurant.activos.repository.AfSubClaseRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfMatrizSubClaseServiceImplTest {

    @Mock
    private AfMatrizSubClaseRepository repository;
    @Mock
    private AfSubClaseRepository subClaseRepository;
    @InjectMocks
    private AfMatrizSubClaseServiceImpl service;

    @Test
    void findAllDelegatesToRepository() {
        AfMatrizSubClase row = new AfMatrizSubClase();
        row.setId(1L);
        row.setAfSubClaseId(10L);
        Pageable pageable = PageRequest.of(0, 10);
        when(repository.findAll(pageable)).thenReturn(new PageImpl<>(List.of(row)));
        var page = service.findAll(pageable);
        assertEquals(1, page.getContent().size());
        assertEquals(10L, page.getContent().get(0).getAfSubClaseId());
    }

    @Test
    void findByIdReturnsEntity() {
        AfMatrizSubClase row = new AfMatrizSubClase();
        row.setId(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(row));
        assertEquals(1L, service.findById(1L).getId());
    }

    @Test
    void findByIdThrowsWhenMissing() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.findById(99L));
    }

    @Test
    void findBySubClaseIdDelegates() {
        AfMatrizSubClase row = new AfMatrizSubClase();
        when(repository.findByAfSubClaseId(5L)).thenReturn(Optional.of(row));
        assertTrue(service.findBySubClaseId(5L).isPresent());
    }

    @Test
    void createSavesWhenSubClaseExistsAndNoDuplicateAndNoCuentas() {
        AfMatrizSubClase input = new AfMatrizSubClase();
        input.setAfSubClaseId(1L);

        AfSubClase sub = new AfSubClase();
        sub.setId(1L);
        when(subClaseRepository.findById(1L)).thenReturn(Optional.of(sub));
        when(repository.existsByAfSubClaseId(1L)).thenReturn(false);

        AfMatrizSubClase saved = new AfMatrizSubClase();
        saved.setId(10L);
        saved.setAfSubClaseId(1L);
        saved.setFlagEstado(ActivosFlagEstado.ACTIVO);
        when(repository.save(any(AfMatrizSubClase.class))).thenAnswer(inv -> inv.getArgument(0));

        AfMatrizSubClase result = service.create(input);
        assertEquals(ActivosFlagEstado.ACTIVO, result.getFlagEstado());
        verify(repository).save(input);
    }

    @Test
    void createThrowsWhenSubClaseMissing() {
        AfMatrizSubClase input = new AfMatrizSubClase();
        input.setAfSubClaseId(1L);
        when(subClaseRepository.findById(1L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.create(input));
        verify(repository, never()).save(any());
    }

    @Test
    void createThrowsConflictWhenMatrixExistsForSubClase() {
        AfMatrizSubClase input = new AfMatrizSubClase();
        input.setAfSubClaseId(1L);
        when(subClaseRepository.findById(1L)).thenReturn(Optional.of(new AfSubClase()));
        when(repository.existsByAfSubClaseId(1L)).thenReturn(true);
        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(input));
        assertEquals(ActivosErrorCodes.MATRIZ_SUB_CLASE_DUPLICADA, ex.getErrorCode());
    }

    @Test
    void createThrowsWhenCuentaNotInPlan() {
        AfMatrizSubClase input = new AfMatrizSubClase();
        input.setAfSubClaseId(1L);
        input.setCuentaActivoId(100L);
        when(subClaseRepository.findById(1L)).thenReturn(Optional.of(new AfSubClase()));
        when(repository.existsByAfSubClaseId(1L)).thenReturn(false);
        when(repository.countPlanContableDetActivo(100L)).thenReturn(0L);
        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(input));
        assertEquals(ActivosErrorCodes.CUENTA_PLAN_NO_ACTIVA, ex.getErrorCode());
    }

    @Test
    void createThrowsWhenPlanLookupFails() {
        AfMatrizSubClase input = new AfMatrizSubClase();
        input.setAfSubClaseId(1L);
        input.setCuentaActivoId(100L);
        when(subClaseRepository.findById(1L)).thenReturn(Optional.of(new AfSubClase()));
        when(repository.existsByAfSubClaseId(1L)).thenReturn(false);
        when(repository.countPlanContableDetActivo(100L)).thenThrow(new QueryTimeoutException("timeout", null));
        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(input));
        assertEquals(ActivosErrorCodes.CUENTA_PLAN_NO_ACTIVA, ex.getErrorCode());
    }

    @Test
    void updateSavesWhenValid() {
        AfMatrizSubClase existing = new AfMatrizSubClase();
        existing.setId(1L);
        existing.setAfSubClaseId(1L);
        existing.setCuentaActivoId(10L);

        AfMatrizSubClase payload = new AfMatrizSubClase();
        payload.setAfSubClaseId(1L);
        payload.setCuentaActivoId(20L);
        payload.setCuentaDepAcumId(null);
        payload.setCuentaGastoDepId(null);
        payload.setCuentaBajaId(null);
        payload.setCuentaResVentaId(null);
        payload.setCentroCostoId(null);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(subClaseRepository.findById(1L)).thenReturn(Optional.of(new AfSubClase()));
        when(repository.countPlanContableDetActivo(20L)).thenReturn(1L);
        when(repository.save(any(AfMatrizSubClase.class))).thenAnswer(inv -> inv.getArgument(0));

        AfMatrizSubClase result = service.update(1L, payload);
        assertEquals(20L, result.getCuentaActivoId());
    }

    @Test
    void updateThrowsConflictWhenTargetSubClaseHasOtherMatrix() {
        AfMatrizSubClase existing = new AfMatrizSubClase();
        existing.setId(1L);
        existing.setAfSubClaseId(1L);

        AfMatrizSubClase payload = new AfMatrizSubClase();
        payload.setAfSubClaseId(2L);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.existsByAfSubClaseId(2L)).thenReturn(true);

        BusinessException ex = assertThrows(BusinessException.class, () -> service.update(1L, payload));
        assertEquals(ActivosErrorCodes.MATRIZ_SUB_CLASE_DUPLICADA, ex.getErrorCode());
    }

    @Test
    void deleteRemovesWhenFound() {
        AfMatrizSubClase existing = new AfMatrizSubClase();
        existing.setId(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        assertDoesNotThrow(() -> service.delete(1L));
        verify(repository).delete(existing);
    }
}
