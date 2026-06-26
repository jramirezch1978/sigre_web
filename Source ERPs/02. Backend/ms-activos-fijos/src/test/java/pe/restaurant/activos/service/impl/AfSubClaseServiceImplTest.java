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
import pe.restaurant.activos.entity.AfSubClase;
import pe.restaurant.activos.repository.AfClaseRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfSubClaseRepository;
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
class AfSubClaseServiceImplTest {

    @Mock
    private AfSubClaseRepository repository;
    @Mock
    private AfClaseRepository afClaseRepository;
    @Mock
    private AfMaestroRepository maestroRepository;
    @InjectMocks
    private AfSubClaseServiceImpl service;

    private AfClase claseConEstado(long id, String flagEstado) {
        AfClase c = new AfClase();
        c.setId(id);
        c.setFlagEstado(flagEstado);
        return c;
    }

    @Test
    void findAllReturnsPageData() {
        AfSubClase entity = new AfSubClase();
        entity.setId(1L);
        entity.setAfClaseId(1L);
        entity.setCodigo("SUB001");
        entity.setNombre("Subclase Test");
        entity.setVidaUtilMeses(48);
        
        when(repository.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        Page<AfSubClase> result = service.findAll(PageRequest.of(0, 10));
        assertEquals(1, result.getContent().size());
        assertEquals("SUB001", result.getContent().get(0).getCodigo());
    }

    @Test
    void findByIdReturnsEntity() {
        AfSubClase entity = new AfSubClase();
        entity.setId(1L);
        entity.setAfClaseId(1L);
        entity.setCodigo("SUB001");
        entity.setNombre("Subclase Test");
        entity.setVidaUtilMeses(48);
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        AfSubClase result = service.findById(1L);
        assertEquals("SUB001", result.getCodigo());
        assertEquals(1L, result.getId());
    }

    @Test
    void findByIdThrowsNotFound() {
        when(repository.findById(9L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.findById(9L));
    }

    @Test
    void createSavesEntity() {
        AfSubClase entity = new AfSubClase();
        entity.setAfClaseId(1L);
        entity.setCodigo("SUB001");
        entity.setNombre("Subclase Test");
        entity.setVidaUtilMeses(48);
        
        AfSubClase saved = new AfSubClase();
        saved.setId(1L);
        saved.setAfClaseId(1L);
        saved.setCodigo("SUB001");
        saved.setNombre("Subclase Test");
        saved.setVidaUtilMeses(48);
        saved.setFlagEstado("1");
        
        when(afClaseRepository.findById(1L)).thenReturn(Optional.of(claseConEstado(1L, ActivosFlagEstado.ACTIVO)));
        when(repository.existsByAfClaseIdAndCodigoIgnoreCase(1L, "SUB001")).thenReturn(false);
        when(repository.save(any(AfSubClase.class))).thenReturn(saved);
        
        AfSubClase result = service.create(entity);
        assertEquals("SUB001", result.getCodigo());
        assertEquals("1", result.getFlagEstado());
        assertEquals(1L, result.getId());
    }

    @Test
    void createThrowsNotFoundWhenAfClaseNotExists() {
        AfSubClase entity = new AfSubClase();
        entity.setAfClaseId(999L);
        entity.setCodigo("SUB001");
        entity.setNombre("Subclase Test");
        entity.setVidaUtilMeses(48);
        
        when(afClaseRepository.findById(999L)).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class, () -> service.create(entity));
    }

    @Test
    void createThrowsConflictWhenCodigoExists() {
        AfSubClase entity = new AfSubClase();
        entity.setAfClaseId(1L);
        entity.setCodigo("SUB001");
        entity.setNombre("Subclase Test");
        entity.setVidaUtilMeses(48);
        
        when(afClaseRepository.findById(1L)).thenReturn(Optional.of(claseConEstado(1L, ActivosFlagEstado.ACTIVO)));
        when(repository.existsByAfClaseIdAndCodigoIgnoreCase(1L, "SUB001")).thenReturn(true);
        
        BusinessException exception = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.SUB_CLASE_CODIGO_DUPLICADO, exception.getErrorCode());
        assertTrue(exception.getMessage().contains("SUB001"));
    }

    @Test
    void createThrowsWhenAfClaseInactive() {
        AfSubClase entity = new AfSubClase();
        entity.setAfClaseId(1L);
        entity.setCodigo("SUB001");
        entity.setNombre("Subclase Test");
        entity.setVidaUtilMeses(48);

        when(afClaseRepository.findById(1L)).thenReturn(Optional.of(claseConEstado(1L, ActivosFlagEstado.INACTIVO)));

        BusinessException exception = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.CLASE_INACTIVA, exception.getErrorCode());
    }

    @Test
    void updateModifiesEntity() {
        AfSubClase existing = new AfSubClase();
        existing.setId(1L);
        existing.setAfClaseId(1L);
        existing.setCodigo("SUB001");
        existing.setNombre("Subclase Original");
        existing.setVidaUtilMeses(60);

        AfSubClase updateData = new AfSubClase();
        updateData.setAfClaseId(1L);
        updateData.setCodigo("SUB001");
        updateData.setNombre("Subclase Actualizada");
        updateData.setVidaUtilMeses(48);

        AfSubClase updated = new AfSubClase();
        updated.setId(1L);
        updated.setAfClaseId(1L);
        updated.setCodigo("SUB001");
        updated.setNombre("Subclase Actualizada");
        updated.setVidaUtilMeses(48);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(afClaseRepository.findById(1L)).thenReturn(Optional.of(claseConEstado(1L, ActivosFlagEstado.ACTIVO)));
        when(repository.existsByAfClaseIdAndCodigoIgnoreCaseAndIdNot(1L, "SUB001", 1L)).thenReturn(false);
        when(repository.save(any(AfSubClase.class))).thenReturn(updated);

        AfSubClase result = service.update(1L, updateData);
        assertEquals("Subclase Actualizada", result.getNombre());
        assertEquals(48, result.getVidaUtilMeses());
    }

    @Test
    void updateThrowsWhenAfClaseInactive() {
        AfSubClase existing = new AfSubClase();
        existing.setId(1L);
        existing.setAfClaseId(1L);
        existing.setCodigo("SUB001");

        AfSubClase updateData = new AfSubClase();
        updateData.setAfClaseId(1L);
        updateData.setCodigo("SUB001");
        updateData.setNombre("X");

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(afClaseRepository.findById(1L)).thenReturn(Optional.of(claseConEstado(1L, ActivosFlagEstado.INACTIVO)));

        BusinessException exception = assertThrows(BusinessException.class, () -> service.update(1L, updateData));
        assertEquals(ActivosErrorCodes.CLASE_INACTIVA, exception.getErrorCode());
    }

    @Test
    void updateThrowsNotFoundWhenAfClaseNotExists() {
        AfSubClase existing = new AfSubClase();
        existing.setId(1L);
        existing.setAfClaseId(1L);
        existing.setCodigo("SUB001");
        
        AfSubClase updateData = new AfSubClase();
        updateData.setAfClaseId(999L);
        updateData.setCodigo("SUB001");
        
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(afClaseRepository.findById(999L)).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class, () -> service.update(1L, updateData));
    }

    @Test
    void updateThrowsConflictWhenCodigoExistsInOtherEntity() {
        AfSubClase existing = new AfSubClase();
        existing.setId(1L);
        existing.setAfClaseId(1L);
        existing.setCodigo("SUB001");
        
        AfSubClase updateData = new AfSubClase();
        updateData.setAfClaseId(1L);
        updateData.setCodigo("SUB002");
        
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(afClaseRepository.findById(1L)).thenReturn(Optional.of(claseConEstado(1L, ActivosFlagEstado.ACTIVO)));
        when(repository.existsByAfClaseIdAndCodigoIgnoreCaseAndIdNot(1L, "SUB002", 1L)).thenReturn(true);
        
        BusinessException exception = assertThrows(BusinessException.class, () -> service.update(1L, updateData));
        assertEquals(ActivosErrorCodes.SUB_CLASE_CODIGO_DUPLICADO, exception.getErrorCode());
    }

    @Test
    void activateSetsEstadoToActive() {
        AfSubClase entity = new AfSubClase();
        entity.setId(1L);
        entity.setAfClaseId(1L);
        entity.setCodigo("SUB001");
        entity.setFlagEstado("0");
        
        AfSubClase activated = new AfSubClase();
        activated.setId(1L);
        activated.setAfClaseId(1L);
        activated.setCodigo("SUB001");
        activated.setFlagEstado("1");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(AfSubClase.class))).thenReturn(activated);
        
        AfSubClase result = service.activate(1L);
        assertEquals("1", result.getFlagEstado());
    }

    @Test
    void deactivateSetsEstadoToInactive() {
        AfSubClase entity = new AfSubClase();
        entity.setId(1L);
        entity.setAfClaseId(1L);
        entity.setCodigo("SUB001");
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        
        AfSubClase deactivated = new AfSubClase();
        deactivated.setId(1L);
        deactivated.setAfClaseId(1L);
        deactivated.setCodigo("SUB001");
        deactivated.setFlagEstado("0");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(AfSubClase.class))).thenReturn(deactivated);
        
        AfSubClase result = service.deactivate(1L);
        assertEquals("0", result.getFlagEstado());
    }

    @Test
    void deleteRemovesEntity() {
        AfSubClase entity = new AfSubClase();
        entity.setId(1L);
        entity.setAfClaseId(1L);
        entity.setCodigo("SUB001");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(maestroRepository.existsByAfSubClaseId(1L)).thenReturn(false);

        assertDoesNotThrow(() -> service.delete(1L));
        verify(repository).delete(entity);
    }

    @Test
    void deleteThrowsWhenMaestroExists() {
        AfSubClase entity = new AfSubClase();
        entity.setId(1L);
        entity.setAfClaseId(1L);
        entity.setCodigo("SUB001");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(maestroRepository.existsByAfSubClaseId(1L)).thenReturn(true);

        BusinessException exception = assertThrows(BusinessException.class, () -> service.delete(1L));
        assertEquals(ActivosErrorCodes.SUB_CLASE_CON_MAESTROS, exception.getErrorCode());
    }
}
