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
import pe.restaurant.activos.entity.AfClase;
import pe.restaurant.activos.repository.AfClaseRepository;
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
class AfClaseServiceImplTest {

    @Mock
    private AfClaseRepository repository;
    @InjectMocks
    private AfClaseServiceImpl service;

    @Test
    void findAllReturnsPageData() {
        AfClase entity = new AfClase();
        entity.setId(1L);
        entity.setCodigo("CL001");
        entity.setNombre("Clase Test");
        entity.setMetodoDepreciacion("LINEAL");
        entity.setVidaUtilMeses(60);
        when(repository.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        Page<AfClase> result = service.findAll(PageRequest.of(0, 10));
        assertEquals(1, result.getContent().size());
        assertEquals("CL001", result.getContent().get(0).getCodigo());
    }

    @Test
    void findByIdReturnsEntity() {
        AfClase entity = new AfClase();
        entity.setId(1L);
        entity.setCodigo("CL001");
        entity.setNombre("Clase Test");
        entity.setMetodoDepreciacion("LINEAL");
        entity.setVidaUtilMeses(60);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        AfClase result = service.findById(1L);
        assertEquals("CL001", result.getCodigo());
        assertEquals(1L, result.getId());
    }

    @Test
    void findByIdThrowsNotFound() {
        when(repository.findById(9L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.findById(9L));
    }

    @Test
    void createSavesEntity() {
        AfClase entity = new AfClase();
        entity.setCodigo("CL001");
        entity.setNombre("Clase Test");
        entity.setMetodoDepreciacion("LINEAL");
        entity.setVidaUtilMeses(60);
        
        AfClase saved = new AfClase();
        saved.setId(1L);
        saved.setCodigo("CL001");
        saved.setNombre("Clase Test");
        saved.setMetodoDepreciacion("LINEAL");
        saved.setVidaUtilMeses(60);
        saved.setFlagEstado("1");
        
        when(repository.existsByCodigoIgnoreCase("CL001")).thenReturn(false);
        when(repository.save(any(AfClase.class))).thenReturn(saved);
        
        AfClase result = service.create(entity);
        assertEquals("CL001", result.getCodigo());
        assertEquals("1", result.getFlagEstado());
        assertEquals(1L, result.getId());
    }

    @Test
    void createThrowsConflictWhenCodigoExists() {
        AfClase entity = new AfClase();
        entity.setCodigo("CL001");
        entity.setNombre("Clase Test");
        entity.setMetodoDepreciacion("LINEAL");
        entity.setVidaUtilMeses(60);
        
        when(repository.existsByCodigoIgnoreCase("CL001")).thenReturn(true);
        
        BusinessException exception = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.CLASE_CODIGO_DUPLICADO, exception.getErrorCode());
        assertTrue(exception.getMessage().contains("CL001"));
    }

    @Test
    void updateModifiesEntity() {
        AfClase existing = new AfClase();
        existing.setId(1L);
        existing.setCodigo("CL001");
        existing.setNombre("Clase Original");
        existing.setMetodoDepreciacion("LINEAL");
        existing.setVidaUtilMeses(60);
        
        AfClase updateData = new AfClase();
        updateData.setCodigo("CL001");
        updateData.setNombre("Clase Actualizada");
        updateData.setMetodoDepreciacion("DEGRADACION");
        updateData.setVidaUtilMeses(48);
        
        AfClase updated = new AfClase();
        updated.setId(1L);
        updated.setCodigo("CL001");
        updated.setNombre("Clase Actualizada");
        updated.setMetodoDepreciacion("DEGRADACION");
        updated.setVidaUtilMeses(48);
        
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.existsByCodigoIgnoreCaseAndIdNot("CL001", 1L)).thenReturn(false);
        when(repository.save(any(AfClase.class))).thenReturn(updated);
        
        AfClase result = service.update(1L, updateData);
        assertEquals("Clase Actualizada", result.getNombre());
        assertEquals("DEGRADACION", result.getMetodoDepreciacion());
        assertEquals(48, result.getVidaUtilMeses());
    }

    @Test
    void updateThrowsConflictWhenCodigoExistsInOtherEntity() {
        AfClase existing = new AfClase();
        existing.setId(1L);
        existing.setCodigo("CL001");
        existing.setNombre("Clase Original");
        existing.setMetodoDepreciacion("LINEAL");
        existing.setVidaUtilMeses(60);

        AfClase updateData = new AfClase();
        updateData.setCodigo("CL002");
        updateData.setNombre("Clase Actualizada");
        updateData.setMetodoDepreciacion("DEGRADACION");
        updateData.setVidaUtilMeses(48);
        
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.existsByCodigoIgnoreCaseAndIdNot("CL002", 1L)).thenReturn(true);
        
        BusinessException exception = assertThrows(BusinessException.class, () -> service.update(1L, updateData));
        assertEquals(ActivosErrorCodes.CLASE_CODIGO_DUPLICADO, exception.getErrorCode());
    }

    @Test
    void activateSetsEstadoToActive() {
        AfClase entity = new AfClase();
        entity.setId(1L);
        entity.setCodigo("CL001");
        entity.setNombre("Clase Test");
        entity.setMetodoDepreciacion("LINEAL");
        entity.setVidaUtilMeses(60);
        entity.setFlagEstado("0");
        
        AfClase activated = new AfClase();
        activated.setId(1L);
        activated.setCodigo("CL001");
        activated.setNombre("Clase Test");
        activated.setMetodoDepreciacion("LINEAL");
        activated.setVidaUtilMeses(60);
        activated.setFlagEstado("1");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(AfClase.class))).thenReturn(activated);
        
        AfClase result = service.activate(1L);
        assertEquals("1", result.getFlagEstado());
    }

    @Test
    void deactivateSetsEstadoToInactive() {
        AfClase entity = new AfClase();
        entity.setId(1L);
        entity.setCodigo("CL001");
        entity.setNombre("Clase Test");
        entity.setMetodoDepreciacion("LINEAL");
        entity.setVidaUtilMeses(60);
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        
        AfClase deactivated = new AfClase();
        deactivated.setId(1L);
        deactivated.setCodigo("CL001");
        deactivated.setNombre("Clase Test");
        deactivated.setMetodoDepreciacion("LINEAL");
        deactivated.setVidaUtilMeses(60);
        deactivated.setFlagEstado("0");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(AfClase.class))).thenReturn(deactivated);
        
        AfClase result = service.deactivate(1L);
        assertEquals("0", result.getFlagEstado());
    }

    @Test
    void deleteRemovesEntity() {
        AfClase entity = new AfClase();
        entity.setId(1L);
        entity.setCodigo("CL001");
        entity.setNombre("Clase Test");
        entity.setMetodoDepreciacion("LINEAL");
        entity.setVidaUtilMeses(60);
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.existsSubClasesByAfClaseId(1L)).thenReturn(false);
        
        assertDoesNotThrow(() -> service.delete(1L));
        verify(repository).delete(entity);
    }

    @Test
    void deleteThrowsConflictWhenHasDependencies() {
        AfClase entity = new AfClase();
        entity.setId(1L);
        entity.setCodigo("CL001");
        entity.setNombre("Clase Test");
        entity.setMetodoDepreciacion("LINEAL");
        entity.setVidaUtilMeses(60);
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.existsSubClasesByAfClaseId(1L)).thenReturn(true);
        
        BusinessException exception = assertThrows(BusinessException.class, () -> service.delete(1L));
        assertEquals(ActivosErrorCodes.CLASE_CON_DEPENDENCIAS, exception.getErrorCode());
        assertTrue(exception.getMessage().contains("sub-clases asociadas"));
    }
}
