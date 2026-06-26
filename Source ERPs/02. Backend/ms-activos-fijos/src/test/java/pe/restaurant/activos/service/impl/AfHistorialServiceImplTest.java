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
import pe.restaurant.activos.entity.AfHistorial;
import pe.restaurant.activos.repository.AfHistorialRepository;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfHistorialServiceImplTest {

    @Mock
    private AfHistorialRepository repository;
    @InjectMocks
    private AfHistorialServiceImpl service;

    @Test
    void findAllReturnsPageData() {
        AfHistorial entity = new AfHistorial();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setTipoEvento("CREACION");
        entity.setDescripcion("Creación de activo");
        entity.setFechaEvento(LocalDateTime.now());
        entity.setUsuarioId(1L);
        
        when(repository.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        Page<AfHistorial> result = service.findAll(PageRequest.of(0, 10));
        assertEquals(1, result.getContent().size());
        assertEquals("CREACION", result.getContent().get(0).getTipoEvento());
    }

    @Test
    void findByIdReturnsEntity() {
        AfHistorial entity = new AfHistorial();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setTipoEvento("CREACION");
        entity.setDescripcion("Creación de activo");
        entity.setFechaEvento(LocalDateTime.now());
        entity.setUsuarioId(1L);
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        AfHistorial result = service.findById(1L);
        assertEquals("CREACION", result.getTipoEvento());
        assertEquals(1L, result.getId());
    }

    @Test
    void findByIdThrowsNotFound() {
        when(repository.findById(9L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.findById(9L));
    }

    @Test
    void createSavesEntity() {
        AfHistorial entity = new AfHistorial();
        entity.setAfMaestroId(1L);
        entity.setTipoEvento("CREACION");
        entity.setDescripcion("Creación de activo");
        entity.setUsuarioId(1L);
        
        AfHistorial saved = new AfHistorial();
        saved.setId(1L);
        saved.setAfMaestroId(1L);
        saved.setTipoEvento("CREACION");
        saved.setDescripcion("Creación de activo");
        saved.setFechaEvento(LocalDateTime.now());
        saved.setUsuarioId(1L);
        
        when(repository.save(any(AfHistorial.class))).thenReturn(saved);
        
        AfHistorial result = service.create(entity);
        assertEquals("CREACION", result.getTipoEvento());
        assertNotNull(result.getFechaEvento());
        assertEquals(1L, result.getId());
    }

    @Test
    void createSetsFechaEventoWhenNull() {
        AfHistorial entity = new AfHistorial();
        entity.setAfMaestroId(1L);
        entity.setTipoEvento("CREACION");
        entity.setDescripcion("Creación de activo");
        entity.setUsuarioId(1L);
        entity.setFechaEvento(null);
        
        when(repository.save(any(AfHistorial.class))).thenAnswer(invocation -> {
            AfHistorial saved = invocation.getArgument(0);
            saved.setId(1L);
            return saved;
        });
        
        AfHistorial result = service.create(entity);
        assertNotNull(result.getFechaEvento());
        assertTrue(result.getFechaEvento().isAfter(LocalDateTime.now().minusSeconds(1)));
    }

    @Test
    void createPreservesFechaEventoWhenNotNull() {
        LocalDateTime customDate = LocalDateTime.of(2024, 1, 1, 12, 0, 0);
        
        AfHistorial entity = new AfHistorial();
        entity.setAfMaestroId(1L);
        entity.setTipoEvento("CREACION");
        entity.setDescripcion("Creación de activo");
        entity.setUsuarioId(1L);
        entity.setFechaEvento(customDate);
        
        when(repository.save(any(AfHistorial.class))).thenAnswer(invocation -> {
            AfHistorial saved = invocation.getArgument(0);
            saved.setId(1L);
            return saved;
        });
        
        AfHistorial result = service.create(entity);
        assertEquals(customDate, result.getFechaEvento());
    }

    @Test
    void deleteRemovesEntity() {
        AfHistorial entity = new AfHistorial();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setTipoEvento("CREACION");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        
        assertDoesNotThrow(() -> service.delete(1L));
        verify(repository).delete(entity);
    }

    @Test
    void findByActivoReturnsList() {
        AfHistorial entity1 = new AfHistorial();
        entity1.setId(1L);
        entity1.setAfMaestroId(1L);
        entity1.setTipoEvento("CREACION");
        entity1.setFechaEvento(LocalDateTime.now());
        
        AfHistorial entity2 = new AfHistorial();
        entity2.setId(2L);
        entity2.setAfMaestroId(1L);
        entity2.setTipoEvento("ACTUALIZACION");
        entity2.setFechaEvento(LocalDateTime.now().minusHours(1));
        
        when(repository.findByAfMaestroIdOrderByFechaEventoDesc(1L)).thenReturn(List.of(entity1, entity2));
        List<AfHistorial> result = service.findByActivo(1L);
        assertEquals(2, result.size());
        assertEquals("CREACION", result.get(0).getTipoEvento());
        assertEquals("ACTUALIZACION", result.get(1).getTipoEvento());
    }

    @Test
    void findByTipoEventoReturnsList() {
        AfHistorial entity = new AfHistorial();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setTipoEvento("CREACION");
        
        when(repository.findByTipoEvento("CREACION", Pageable.unpaged())).thenReturn(new PageImpl<>(List.of(entity)));
        List<AfHistorial> result = service.findByTipoEvento("CREACION");
        assertEquals(1, result.size());
        assertEquals("CREACION", result.get(0).getTipoEvento());
    }

    @Test
    void findByUsuarioReturnsList() {
        AfHistorial entity1 = new AfHistorial();
        entity1.setId(1L);
        entity1.setAfMaestroId(1L);
        entity1.setTipoEvento("CREACION");
        entity1.setUsuarioId(1L);
        
        AfHistorial entity2 = new AfHistorial();
        entity2.setId(2L);
        entity2.setAfMaestroId(2L);
        entity2.setTipoEvento("ACTUALIZACION");
        entity2.setUsuarioId(1L);
        
        when(repository.findByUsuarioId(1L)).thenReturn(List.of(entity1, entity2));
        List<AfHistorial> result = service.findByUsuario(1L);
        assertEquals(2, result.size());
        assertEquals(1L, result.get(0).getUsuarioId());
        assertEquals(1L, result.get(1).getUsuarioId());
    }

    @Test
    void findByFechaRangeReturnsList() {
        LocalDateTime fechaInicio = LocalDateTime.of(2024, 1, 1, 0, 0, 0);
        LocalDateTime fechaFin = LocalDateTime.of(2024, 1, 31, 23, 59, 59);
        
        AfHistorial entity1 = new AfHistorial();
        entity1.setId(1L);
        entity1.setAfMaestroId(1L);
        entity1.setTipoEvento("CREACION");
        entity1.setFechaEvento(LocalDateTime.of(2024, 1, 15, 12, 0, 0));
        
        AfHistorial entity2 = new AfHistorial();
        entity2.setId(2L);
        entity2.setAfMaestroId(2L);
        entity2.setTipoEvento("ACTUALIZACION");
        entity2.setFechaEvento(LocalDateTime.of(2024, 1, 20, 15, 30, 0));
        
        when(repository.findByFechaRange(fechaInicio, fechaFin)).thenReturn(List.of(entity1, entity2));
        List<AfHistorial> result = service.findByFechaRange(fechaInicio, fechaFin);
        assertEquals(2, result.size());
        assertTrue(result.get(0).getFechaEvento().isAfter(fechaInicio));
        assertTrue(result.get(1).getFechaEvento().isBefore(fechaFin));
    }
}
