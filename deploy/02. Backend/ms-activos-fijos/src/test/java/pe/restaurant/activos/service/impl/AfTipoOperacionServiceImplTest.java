package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfTipoOperacion;
import pe.restaurant.activos.repository.AfMatrizSubClaseRepository;
import pe.restaurant.activos.repository.AfOperacionesRepository;
import pe.restaurant.activos.repository.AfTipoOperacionRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfTipoOperacionServiceImplTest {

    @Mock
    private AfTipoOperacionRepository repository;
    @Mock
    private AfOperacionesRepository operacionesRepository;
    @Mock
    private AfMatrizSubClaseRepository matrizRepository;
    @InjectMocks
    private AfTipoOperacionServiceImpl service;

    @Test
    void findAllReturnsPage() {
        AfTipoOperacion tipo = new AfTipoOperacion();
        tipo.setId(1L);
        tipo.setCodigo("DEP");

        when(repository.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(tipo)));
        Page<AfTipoOperacion> result = service.findAll(PageRequest.of(0, 10));
        assertEquals(1, result.getContent().size());
    }

    @Test
    void findByIdReturnsEntity() {
        AfTipoOperacion entity = new AfTipoOperacion();
        entity.setId(1L);
        entity.setCodigo("DEP");
        entity.setDescripcion("Depreciación");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        AfTipoOperacion result = service.findById(1L);
        assertEquals("DEP", result.getCodigo());
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

            AfTipoOperacion entity = new AfTipoOperacion();
            entity.setCodigo("MNT");
            entity.setDescripcion("Mantenimiento");
            entity.setNaturaleza("GASTO");
            entity.setTipoCalculo("LINEAL");
            entity.setCuentaContableId(100L);
            entity.setAfectaContabilidad(true);

            AfTipoOperacion saved = new AfTipoOperacion();
            saved.setId(1L);
            saved.setCodigo("MNT");
            saved.setFlagEstado("1");

            when(repository.existsByCodigoIgnoreCase("MNT")).thenReturn(false);
            when(matrizRepository.countPlanContableDetActivo(100L)).thenReturn(1L);
            when(repository.save(any(AfTipoOperacion.class))).thenReturn(saved);

            AfTipoOperacion result = service.create(entity);
            assertEquals("1", result.getFlagEstado());
        }
    }

    @Test
    void createThrowsWhenCodigoDuplicated() {
        AfTipoOperacion entity = new AfTipoOperacion();
        entity.setCodigo("DEP");
        entity.setCuentaContableId(null);

        when(repository.existsByCodigoIgnoreCase("DEP")).thenReturn(true);

        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.TIPO_OPERACION_CODIGO_DUPLICADO, ex.getErrorCode());
    }

    @Test
    void createThrowsWhenCuentaNoActiva() {
        AfTipoOperacion entity = new AfTipoOperacion();
        entity.setCodigo("MNT");
        entity.setCuentaContableId(200L);

        when(repository.existsByCodigoIgnoreCase("MNT")).thenReturn(false);
        when(matrizRepository.countPlanContableDetActivo(200L)).thenReturn(0L);

        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.CUENTA_PLAN_NO_ACTIVA, ex.getErrorCode());
    }

    @Test
    void createSkipsCuentaValidationWhenNull() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfTipoOperacion entity = new AfTipoOperacion();
            entity.setCodigo("OTR");
            entity.setCuentaContableId(null);

            AfTipoOperacion saved = new AfTipoOperacion();
            saved.setId(1L);
            saved.setFlagEstado("1");

            when(repository.existsByCodigoIgnoreCase("OTR")).thenReturn(false);
            when(repository.save(any(AfTipoOperacion.class))).thenReturn(saved);

            AfTipoOperacion result = service.create(entity);
            assertNotNull(result);
            verify(matrizRepository, never()).countPlanContableDetActivo(anyLong());
        }
    }

    @Test
    void updateModifiesEntity() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfTipoOperacion existing = new AfTipoOperacion();
            existing.setId(1L);
            existing.setCodigo("DEP");

            AfTipoOperacion updateData = new AfTipoOperacion();
            updateData.setCodigo("DEP-V2");
            updateData.setDescripcion("Depreciación V2");
            updateData.setNaturaleza("GASTO");
            updateData.setTipoCalculo("ACELERADA");
            updateData.setCuentaContableId(100L);
            updateData.setCentroCostoId(50L);
            updateData.setAfectaContabilidad(true);
            updateData.setMetodoCalculo("DOBLE_SALDO");
            updateData.setObservaciones("Actualizado");

            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(repository.existsByCodigoIgnoreCaseAndIdNot("DEP-V2", 1L)).thenReturn(false);
            when(matrizRepository.countPlanContableDetActivo(100L)).thenReturn(1L);
            when(repository.save(any(AfTipoOperacion.class))).thenReturn(existing);

            AfTipoOperacion result = service.update(1L, updateData);
            assertNotNull(result);
        }
    }

    @Test
    void updateThrowsWhenCodigoDuplicated() {
        AfTipoOperacion existing = new AfTipoOperacion();
        existing.setId(1L);
        existing.setCodigo("DEP");

        AfTipoOperacion updateData = new AfTipoOperacion();
        updateData.setCodigo("MNT");
        updateData.setCuentaContableId(null);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.existsByCodigoIgnoreCaseAndIdNot("MNT", 1L)).thenReturn(true);

        BusinessException ex = assertThrows(BusinessException.class, () -> service.update(1L, updateData));
        assertEquals(ActivosErrorCodes.TIPO_OPERACION_CODIGO_DUPLICADO, ex.getErrorCode());
    }

    @Test
    void deleteRemovesEntity() {
        AfTipoOperacion entity = new AfTipoOperacion();
        entity.setId(1L);

        when(operacionesRepository.existsByAfTipoOperacionId(1L)).thenReturn(false);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertDoesNotThrow(() -> service.delete(1L));
        verify(repository).delete(entity);
    }

    @Test
    void deleteThrowsWhenInUse() {
        when(operacionesRepository.existsByAfTipoOperacionId(1L)).thenReturn(true);

        BusinessException ex = assertThrows(BusinessException.class, () -> service.delete(1L));
        assertEquals(ActivosErrorCodes.TIPO_OPERACION_EN_USO, ex.getErrorCode());
    }

    @Test
    void deleteThrowsNotFoundWhenIdMissing() {
        when(operacionesRepository.existsByAfTipoOperacionId(99L)).thenReturn(false);
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.delete(99L));
    }

    @Test
    void activateSetsEstadoToActive() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfTipoOperacion entity = new AfTipoOperacion();
            entity.setId(1L);
            entity.setFlagEstado("0");

            AfTipoOperacion activated = new AfTipoOperacion();
            activated.setId(1L);
            activated.setFlagEstado("1");

            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(repository.save(any(AfTipoOperacion.class))).thenReturn(activated);

            AfTipoOperacion result = service.activate(1L);
            assertEquals(ActivosFlagEstado.ACTIVO, result.getFlagEstado());
        }
    }

    @Test
    void deactivateSetsEstadoToInactive() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfTipoOperacion entity = new AfTipoOperacion();
            entity.setId(1L);
            entity.setFlagEstado("1");

            AfTipoOperacion deactivated = new AfTipoOperacion();
            deactivated.setId(1L);
            deactivated.setFlagEstado("0");

            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(repository.save(any(AfTipoOperacion.class))).thenReturn(deactivated);

            AfTipoOperacion result = service.deactivate(1L);
            assertEquals(ActivosFlagEstado.INACTIVO, result.getFlagEstado());
        }
    }
}
