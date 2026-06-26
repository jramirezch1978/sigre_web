package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfAseguradora;
import pe.restaurant.activos.repository.AfAseguradoraRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfAseguradoraServiceImplTest {

    @Mock
    private AfAseguradoraRepository repository;
    @InjectMocks
    private AfAseguradoraServiceImpl service;

    @Test
    void findAllReturnsPageData() {
        AfAseguradora entity = new AfAseguradora();
        entity.setId(1L);
        entity.setNombre("Aseguradora Test");
        entity.setRuc("12345678901");
        entity.setContacto("Contacto Test");
        
        when(repository.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        Page<AfAseguradora> result = service.findAll(PageRequest.of(0, 10));
        assertEquals(1, result.getContent().size());
        assertEquals("Aseguradora Test", result.getContent().get(0).getNombre());
    }

    @Test
    void findByIdReturnsEntity() {
        AfAseguradora entity = new AfAseguradora();
        entity.setId(1L);
        entity.setNombre("Aseguradora Test");
        entity.setRuc("12345678901");
        entity.setContacto("Contacto Test");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        AfAseguradora result = service.findById(1L);
        assertEquals("Aseguradora Test", result.getNombre());
        assertEquals(1L, result.getId());
    }

    @Test
    void findByIdThrowsNotFound() {
        when(repository.findById(9L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.findById(9L));
    }

    @Test
    void createSavesEntity() {
        AfAseguradora entity = new AfAseguradora();
        entity.setNombre("Aseguradora Test");
        entity.setRuc("12345678901");
        entity.setContacto("Contacto Test");
        
        AfAseguradora saved = new AfAseguradora();
        saved.setId(1L);
        saved.setNombre("Aseguradora Test");
        saved.setRuc("12345678901");
        saved.setContacto("Contacto Test");
        saved.setFlagEstado("1");
        
        when(repository.existsByNombreIgnoreCase("Aseguradora Test")).thenReturn(false);
        when(repository.existsByRucIgnoreCase("12345678901")).thenReturn(false);
        when(repository.save(any(AfAseguradora.class))).thenReturn(saved);
        
        AfAseguradora result = service.create(entity);
        assertEquals("Aseguradora Test", result.getNombre());
        assertEquals("1", result.getFlagEstado());
        assertEquals(1L, result.getId());
    }

    @Test
    void createSavesEntityWithNullRuc() {
        AfAseguradora entity = new AfAseguradora();
        entity.setNombre("Aseguradora Test");
        entity.setRuc(null);
        entity.setContacto("Contacto Test");
        
        AfAseguradora saved = new AfAseguradora();
        saved.setId(1L);
        saved.setNombre("Aseguradora Test");
        saved.setRuc(null);
        saved.setContacto("Contacto Test");
        saved.setFlagEstado("1");
        
        when(repository.existsByNombreIgnoreCase("Aseguradora Test")).thenReturn(false);
        when(repository.save(any(AfAseguradora.class))).thenReturn(saved);
        
        AfAseguradora result = service.create(entity);
        assertEquals("Aseguradora Test", result.getNombre());
        assertEquals("1", result.getFlagEstado());
        assertNull(result.getRuc());
    }

    @Test
    void createSavesEntityWithEmptyRuc() {
        AfAseguradora entity = new AfAseguradora();
        entity.setNombre("Aseguradora Test");
        entity.setRuc("");
        entity.setContacto("Contacto Test");
        
        AfAseguradora saved = new AfAseguradora();
        saved.setId(1L);
        saved.setNombre("Aseguradora Test");
        saved.setRuc("");
        saved.setContacto("Contacto Test");
        saved.setFlagEstado("1");
        
        when(repository.existsByNombreIgnoreCase("Aseguradora Test")).thenReturn(false);
        when(repository.save(any(AfAseguradora.class))).thenReturn(saved);
        
        AfAseguradora result = service.create(entity);
        assertEquals("Aseguradora Test", result.getNombre());
        assertEquals("1", result.getFlagEstado());
        assertEquals("", result.getRuc());
    }

    @Test
    void createThrowsConflictWhenNombreExists() {
        AfAseguradora entity = new AfAseguradora();
        entity.setNombre("Aseguradora Existente");
        entity.setRuc("12345678901");
        entity.setContacto("Contacto Test");
        
        when(repository.existsByNombreIgnoreCase("Aseguradora Existente")).thenReturn(true);
        
        BusinessException exception = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.ASEGURADORA_NOMBRE_DUPLICADO, exception.getErrorCode());
        assertTrue(exception.getMessage().contains("Aseguradora Existente"));
    }

    @Test
    void createThrowsConflictWhenRucExists() {
        AfAseguradora entity = new AfAseguradora();
        entity.setNombre("Aseguradora Test");
        entity.setRuc("12345678901");
        entity.setContacto("Contacto Test");
        
        when(repository.existsByNombreIgnoreCase("Aseguradora Test")).thenReturn(false);
        when(repository.existsByRucIgnoreCase("12345678901")).thenReturn(true);
        
        BusinessException exception = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.ASEGURADORA_RUC_DUPLICADO, exception.getErrorCode());
        assertTrue(exception.getMessage().contains("12345678901"));
    }

    @Test
    void updateModifiesEntity() {
        AfAseguradora existing = new AfAseguradora();
        existing.setId(1L);
        existing.setNombre("Aseguradora Original");
        existing.setRuc("12345678901");
        existing.setContacto("Contacto Original");
        
        AfAseguradora updateData = new AfAseguradora();
        updateData.setNombre("Aseguradora Actualizada");
        updateData.setRuc("98765432109");
        updateData.setContacto("Contacto Actualizado");
        
        AfAseguradora updated = new AfAseguradora();
        updated.setId(1L);
        updated.setNombre("Aseguradora Actualizada");
        updated.setRuc("98765432109");
        updated.setContacto("Contacto Actualizado");
        
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.existsByNombreIgnoreCaseAndIdNot("Aseguradora Actualizada", 1L)).thenReturn(false);
        when(repository.existsByRucIgnoreCaseAndIdNot("98765432109", 1L)).thenReturn(false);
        when(repository.save(any(AfAseguradora.class))).thenReturn(updated);
        
        AfAseguradora result = service.update(1L, updateData);
        assertEquals("Aseguradora Actualizada", result.getNombre());
        assertEquals("98765432109", result.getRuc());
        assertEquals("Contacto Actualizado", result.getContacto());
    }

    @Test
    void updateThrowsConflictWhenNombreExistsInOtherEntity() {
        AfAseguradora existing = new AfAseguradora();
        existing.setId(1L);
        existing.setNombre("Aseguradora Original");
        existing.setRuc("12345678901");
        
        AfAseguradora updateData = new AfAseguradora();
        updateData.setNombre("Otra Aseguradora");
        updateData.setRuc("12345678901");
        
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.existsByNombreIgnoreCaseAndIdNot("Otra Aseguradora", 1L)).thenReturn(true);
        
        BusinessException exception = assertThrows(BusinessException.class, () -> service.update(1L, updateData));
        assertEquals(ActivosErrorCodes.ASEGURADORA_NOMBRE_DUPLICADO, exception.getErrorCode());
    }

    @Test
    void updateThrowsConflictWhenRucExistsInOtherEntity() {
        AfAseguradora existing = new AfAseguradora();
        existing.setId(1L);
        existing.setNombre("Aseguradora Original");
        existing.setRuc("12345678901");
        
        AfAseguradora updateData = new AfAseguradora();
        updateData.setNombre("Aseguradora Actualizada");
        updateData.setRuc("98765432109");
        
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.existsByNombreIgnoreCaseAndIdNot("Aseguradora Actualizada", 1L)).thenReturn(false);
        when(repository.existsByRucIgnoreCaseAndIdNot("98765432109", 1L)).thenReturn(true);
        
        BusinessException exception = assertThrows(BusinessException.class, () -> service.update(1L, updateData));
        assertEquals(ActivosErrorCodes.ASEGURADORA_RUC_DUPLICADO, exception.getErrorCode());
    }

    @Test
    void activateSetsEstadoToActive() {
        AfAseguradora entity = new AfAseguradora();
        entity.setId(1L);
        entity.setNombre("Aseguradora Test");
        entity.setFlagEstado("0");
        
        AfAseguradora activated = new AfAseguradora();
        activated.setId(1L);
        activated.setNombre("Aseguradora Test");
        activated.setFlagEstado("1");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(AfAseguradora.class))).thenReturn(activated);
        
        AfAseguradora result = service.activate(1L);
        assertEquals("1", result.getFlagEstado());
    }

    @Test
    void deactivateSetsEstadoToInactive() {
        AfAseguradora entity = new AfAseguradora();
        entity.setId(1L);
        entity.setNombre("Aseguradora Test");
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        
        AfAseguradora deactivated = new AfAseguradora();
        deactivated.setId(1L);
        deactivated.setNombre("Aseguradora Test");
        deactivated.setFlagEstado("0");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(AfAseguradora.class))).thenReturn(deactivated);
        
        AfAseguradora result = service.deactivate(1L);
        assertEquals("0", result.getFlagEstado());
    }

    @Test
    void deleteRemovesEntity() {
        AfAseguradora entity = new AfAseguradora();
        entity.setId(1L);
        entity.setNombre("Aseguradora Test");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        
        assertDoesNotThrow(() -> service.delete(1L));
        verify(repository).delete(entity);
    }
}
