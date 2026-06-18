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
import pe.restaurant.activos.entity.AfDocumento;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.repository.AfDocumentoRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfDocumentoServiceImplTest {

    @Mock
    private AfDocumentoRepository repository;
    @Mock
    private AfMaestroRepository maestroRepository;
    @InjectMocks
    private AfDocumentoServiceImpl service;

    @Test
    void findAllReturnsPageData() {
        AfDocumento entity = new AfDocumento();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setTipoDocumento("PDF");
        entity.setNombreArchivo("documento.pdf");
        
        when(repository.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        Page<AfDocumento> result = service.findAll(PageRequest.of(0, 10));
        assertEquals(1, result.getContent().size());
        assertEquals("PDF", result.getContent().get(0).getTipoDocumento());
    }

    @Test
    void findByIdReturnsEntity() {
        AfDocumento entity = new AfDocumento();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setTipoDocumento("PDF");
        entity.setNombreArchivo("documento.pdf");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        AfDocumento result = service.findById(1L);
        assertEquals("PDF", result.getTipoDocumento());
        assertEquals(1L, result.getId());
    }

    @Test
    void findByIdThrowsNotFound() {
        when(repository.findById(9L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.findById(9L));
    }

    @Test
    void createSavesEntity() {
        AfDocumento entity = new AfDocumento();
        entity.setAfMaestroId(1L);
        entity.setTipoDocumento("PDF");
        entity.setNombreArchivo("documento.pdf");
        entity.setRutaArchivo("/ruta/documento.pdf");
        entity.setDescripcion("Descripción");
        entity.setTamanioBytes(1024L);
        entity.setExtension("pdf");
        entity.setUsuarioCargaId(1L);
        
        AfMaestro maestro = new AfMaestro();
        maestro.setId(1L);
        
        AfDocumento saved = new AfDocumento();
        saved.setId(1L);
        saved.setAfMaestroId(1L);
        saved.setTipoDocumento("PDF");
        saved.setNombreArchivo("documento.pdf");
        saved.setRutaArchivo("/ruta/documento.pdf");
        saved.setDescripcion("Descripción");
        saved.setTamanioBytes(1024L);
        saved.setExtension("pdf");
        saved.setUsuarioCargaId(1L);
        saved.setFechaCarga(LocalDate.now());
        
        when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));
        when(repository.save(any(AfDocumento.class))).thenReturn(saved);
        
        AfDocumento result = service.create(entity);
        assertEquals("PDF", result.getTipoDocumento());
        assertEquals(LocalDate.now(), result.getFechaCarga());
        assertEquals(1L, result.getId());
    }

    @Test
    void createSetsFechaCargaWhenNull() {
        AfDocumento entity = new AfDocumento();
        entity.setAfMaestroId(1L);
        entity.setTipoDocumento("PDF");
        entity.setNombreArchivo("documento.pdf");
        entity.setFechaCarga(null);
        
        AfMaestro maestro = new AfMaestro();
        maestro.setId(1L);
        
        when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));
        when(repository.save(any(AfDocumento.class))).thenAnswer(invocation -> {
            AfDocumento saved = invocation.getArgument(0);
            saved.setId(1L);
            return saved;
        });
        
        AfDocumento result = service.create(entity);
        assertEquals(LocalDate.now(), result.getFechaCarga());
    }

    @Test
    void createThrowsNotFoundWhenActivoNotExists() {
        AfDocumento entity = new AfDocumento();
        entity.setAfMaestroId(999L);
        entity.setTipoDocumento("PDF");
        entity.setNombreArchivo("documento.pdf");
        
        when(maestroRepository.findById(999L)).thenReturn(Optional.empty());
        
        BusinessException exception = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.MAESTRO_NO_ENCONTRADO, exception.getErrorCode());
        assertTrue(exception.getMessage().contains("999"));
    }

    @Test
    void updateModifiesEntity() {
        AfDocumento existing = new AfDocumento();
        existing.setId(1L);
        existing.setAfMaestroId(1L);
        existing.setTipoDocumento("PDF");
        existing.setNombreArchivo("documento.pdf");
        existing.setDescripcion("Descripción original");
        
        AfDocumento updateData = new AfDocumento();
        updateData.setTipoDocumento("DOCX");
        updateData.setNombreArchivo("documento_actualizado.docx");
        updateData.setDescripcion("Descripción actualizada");
        
        AfDocumento updated = new AfDocumento();
        updated.setId(1L);
        updated.setAfMaestroId(1L);
        updated.setTipoDocumento("DOCX");
        updated.setNombreArchivo("documento_actualizado.docx");
        updated.setDescripcion("Descripción actualizada");
        
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(any(AfDocumento.class))).thenReturn(updated);
        
        AfDocumento result = service.update(1L, updateData);
        assertEquals("DOCX", result.getTipoDocumento());
        assertEquals("documento_actualizado.docx", result.getNombreArchivo());
        assertEquals("Descripción actualizada", result.getDescripcion());
    }

    @Test
    void deleteRemovesEntity() {
        AfDocumento entity = new AfDocumento();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setTipoDocumento("PDF");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        
        assertDoesNotThrow(() -> service.delete(1L));
        verify(repository).delete(entity);
    }

    @Test
    void findByActivoReturnsList() {
        AfDocumento entity1 = new AfDocumento();
        entity1.setId(1L);
        entity1.setAfMaestroId(1L);
        entity1.setTipoDocumento("PDF");
        entity1.setFechaCarga(LocalDate.now());
        
        AfDocumento entity2 = new AfDocumento();
        entity2.setId(2L);
        entity2.setAfMaestroId(1L);
        entity2.setTipoDocumento("DOCX");
        entity2.setFechaCarga(LocalDate.now().minusDays(1));
        
        when(repository.findByAfMaestroIdOrderByFechaCargaDesc(1L)).thenReturn(List.of(entity1, entity2));
        List<AfDocumento> result = service.findByActivo(1L);
        assertEquals(2, result.size());
        assertEquals("PDF", result.get(0).getTipoDocumento());
        assertEquals("DOCX", result.get(1).getTipoDocumento());
    }

    @Test
    void findByTipoReturnsPage() {
        AfDocumento entity = new AfDocumento();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setTipoDocumento("PDF");
        
        when(repository.findByTipoDocumento("PDF", Pageable.unpaged())).thenReturn(new PageImpl<>(List.of(entity)));
        Page<AfDocumento> result = service.findByTipo("PDF", Pageable.unpaged());
        assertEquals(1, result.getContent().size());
        assertEquals("PDF", result.getContent().get(0).getTipoDocumento());
    }

}
