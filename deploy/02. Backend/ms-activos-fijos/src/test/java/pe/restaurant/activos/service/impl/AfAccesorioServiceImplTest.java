package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.entity.AfAccesorio;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.repository.AfAccesorioRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfAccesorioServiceImplTest {

    @Mock
    private AfAccesorioRepository repository;
    @Mock
    private AfMaestroRepository maestroRepository;
    @InjectMocks
    private AfAccesorioServiceImpl service;

    @Test
    void findByIdReturnsEntity() {
        AfAccesorio entity = new AfAccesorio();
        entity.setId(1L);
        entity.setDescripcion("Teclado");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        AfAccesorio result = service.findById(1L);
        assertEquals("Teclado", result.getDescripcion());
    }

    @Test
    void findByIdThrowsNotFound() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.findById(99L));
    }

    @Test
    void findByMaestroReturnsList() {
        AfMaestro maestro = new AfMaestro();
        maestro.setId(10L);

        AfAccesorio a1 = new AfAccesorio();
        a1.setId(1L);
        a1.setAfMaestroId(10L);

        when(maestroRepository.findById(10L)).thenReturn(Optional.of(maestro));
        when(repository.findByAfMaestroIdOrderByFechaInstalacionDesc(10L)).thenReturn(List.of(a1));

        List<AfAccesorio> result = service.findByMaestro(10L);
        assertEquals(1, result.size());
    }

    @Test
    void findByMaestroThrowsNotFoundWhenMaestroMissing() {
        when(maestroRepository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.findByMaestro(99L));
    }

    @Test
    void createSavesEntity() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfMaestro maestro = new AfMaestro();
            maestro.setId(10L);

            AfAccesorio entity = new AfAccesorio();
            entity.setAfMaestroId(10L);
            entity.setDescripcion("Mouse");
            entity.setCosto(new BigDecimal("50.0000"));
            entity.setFechaInstalacion(LocalDate.of(2026, 1, 15));

            AfAccesorio saved = new AfAccesorio();
            saved.setId(1L);
            saved.setAfMaestroId(10L);
            saved.setDescripcion("Mouse");
            saved.setFlagEstado("1");

            when(maestroRepository.findById(10L)).thenReturn(Optional.of(maestro));
            when(repository.save(any(AfAccesorio.class))).thenReturn(saved);

            AfAccesorio result = service.create(entity);
            assertEquals("1", result.getFlagEstado());
            assertEquals(1L, result.getId());
        }
    }

    @Test
    void createThrowsNotFoundWhenMaestroMissing() {
        AfAccesorio entity = new AfAccesorio();
        entity.setAfMaestroId(99L);

        when(maestroRepository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.create(entity));
    }

    @Test
    void updateModifiesEntity() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfAccesorio existing = new AfAccesorio();
            existing.setId(1L);
            existing.setDescripcion("Mouse antiguo");
            existing.setCosto(new BigDecimal("30.0000"));
            existing.setFechaInstalacion(LocalDate.of(2025, 6, 1));

            AfAccesorio updateData = new AfAccesorio();
            updateData.setDescripcion("Mouse nuevo");
            updateData.setCosto(new BigDecimal("60.0000"));
            updateData.setFechaInstalacion(LocalDate.of(2026, 3, 1));

            AfAccesorio updated = new AfAccesorio();
            updated.setId(1L);
            updated.setDescripcion("Mouse nuevo");
            updated.setCosto(new BigDecimal("60.0000"));

            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(repository.save(any(AfAccesorio.class))).thenReturn(updated);

            AfAccesorio result = service.update(1L, updateData);
            assertEquals("Mouse nuevo", result.getDescripcion());
        }
    }

    @Test
    void updateThrowsNotFoundWhenIdMissing() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.update(99L, new AfAccesorio()));
    }

    @Test
    void deleteRemovesEntity() {
        AfAccesorio entity = new AfAccesorio();
        entity.setId(1L);

        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertDoesNotThrow(() -> service.delete(1L));
        verify(repository).delete(entity);
    }

    @Test
    void deleteThrowsNotFoundWhenIdMissing() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.delete(99L));
    }
}
