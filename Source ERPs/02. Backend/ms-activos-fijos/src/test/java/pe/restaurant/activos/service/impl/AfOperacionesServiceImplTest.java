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
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfOperaciones;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfOperacionesRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.common.exception.BusinessException;
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
class AfOperacionesServiceImplTest {

    @Mock
    private AfOperacionesRepository repository;
    @Mock
    private AfMaestroRepository maestroRepository;
    @InjectMocks
    private AfOperacionesServiceImpl service;

    @Test
    void findAllReturnsPage() {
        AfOperaciones op = new AfOperaciones();
        op.setId(1L);
        op.setTipo("MANTENIMIENTO");

        when(repository.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(op)));
        Page<AfOperaciones> result = service.findAll(PageRequest.of(0, 10));
        assertEquals(1, result.getContent().size());
    }

    @Test
    void findByIdReturnsEntity() {
        AfOperaciones entity = new AfOperaciones();
        entity.setId(1L);
        entity.setTipo("REPARACION");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        AfOperaciones result = service.findById(1L);
        assertEquals("REPARACION", result.getTipo());
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

            AfMaestro maestro = new AfMaestro();
            maestro.setId(10L);

            AfOperaciones entity = new AfOperaciones();
            entity.setAfMaestroId(10L);
            entity.setTipo("MANTENIMIENTO");

            AfOperaciones saved = new AfOperaciones();
            saved.setId(1L);
            saved.setAfMaestroId(10L);

            when(maestroRepository.findById(10L)).thenReturn(Optional.of(maestro));
            when(repository.save(any(AfOperaciones.class))).thenReturn(saved);

            AfOperaciones result = service.create(entity);
            assertEquals(1L, result.getId());
        }
    }

    @Test
    void createThrowsWhenActivoNotFound() {
        AfOperaciones entity = new AfOperaciones();
        entity.setAfMaestroId(99L);

        when(maestroRepository.findById(99L)).thenReturn(Optional.empty());
        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.MAESTRO_NO_ENCONTRADO, ex.getErrorCode());
    }

    @Test
    void updateModifiesEntity() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfOperaciones existing = new AfOperaciones();
            existing.setId(1L);
            existing.setAfMaestroId(10L);
            existing.setTipo("MANTENIMIENTO");

            AfOperaciones updateData = new AfOperaciones();
            updateData.setTipo("REPARACION");
            updateData.setFechaProgramada(LocalDate.of(2026, 7, 1));
            updateData.setCosto(new BigDecimal("1500.0000"));
            updateData.setProveedorServicio("Proveedor X");

            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(repository.save(any(AfOperaciones.class))).thenReturn(existing);

            AfOperaciones result = service.update(1L, updateData);
            assertNotNull(result);
        }
    }

    @Test
    void updateThrowsNotFound() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.update(99L, new AfOperaciones()));
    }

    @Test
    void deleteRemovesEntity() {
        AfOperaciones entity = new AfOperaciones();
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
    void findByActivoReturnsList() {
        AfOperaciones op = new AfOperaciones();
        op.setId(1L);

        when(repository.findByAfMaestroId(10L)).thenReturn(List.of(op));
        List<AfOperaciones> result = service.findByActivo(10L);
        assertEquals(1, result.size());
    }

    @Test
    void findProgramadasReturnsList() {
        AfOperaciones op = new AfOperaciones();
        op.setId(1L);
        op.setFechaProgramada(LocalDate.now().plusDays(5));

        when(repository.findProgramadas(any(LocalDate.class))).thenReturn(List.of(op));
        List<AfOperaciones> result = service.findProgramadas();
        assertEquals(1, result.size());
    }

    @Test
    void ejecutarSetsDateAndSaves() {
        AfOperaciones entity = new AfOperaciones();
        entity.setId(1L);
        entity.setTipo("MANTENIMIENTO");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(AfOperaciones.class))).thenAnswer(inv -> inv.getArgument(0));

        AfOperaciones result = service.ejecutar(1L);
        assertEquals(LocalDate.now(), result.getFechaEjecucion());
    }

    @Test
    void ejecutarThrowsNotFound() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.ejecutar(99L));
    }
}
