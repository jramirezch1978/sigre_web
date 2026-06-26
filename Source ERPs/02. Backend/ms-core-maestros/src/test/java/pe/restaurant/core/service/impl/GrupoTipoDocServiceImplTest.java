package pe.restaurant.core.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.entity.GrupoTipoDoc;
import pe.restaurant.core.repository.GrupoTipoDocRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class GrupoTipoDocServiceImplTest {

    @Mock private GrupoTipoDocRepository repository;
    @InjectMocks private GrupoTipoDocServiceImpl service;

    private GrupoTipoDoc entity;

    @BeforeEach
    void setUp() {
        entity = new GrupoTipoDoc();
        entity.setId(1L);
        entity.setCodigo("GTD01");
        entity.setNombre("Grupo");
        entity.setFlagEstado("1");
    }

    @Test void findAll() {
        when(repository.findAll(PageRequest.of(0, 20))).thenReturn(new PageImpl<>(List.of(entity)));
        assertThat(service.findAll(PageRequest.of(0, 20)).getContent()).hasSize(1);
    }

    @Test void findByIdNotFound() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.findById(99L)).isInstanceOf(ResourceNotFoundException.class);
    }

    @Test void createSuccess() {
        when(repository.findByCodigo("GTD01")).thenReturn(Optional.empty());
        when(repository.save(entity)).thenReturn(entity);
        assertThat(service.create(entity)).isNotNull();
    }

    @Test void createDuplicate() {
        when(repository.findByCodigo("GTD01")).thenReturn(Optional.of(entity));
        GrupoTipoDoc dup = new GrupoTipoDoc();
        dup.setId(2L);
        dup.setCodigo("GTD01");
        assertThatThrownBy(() -> service.create(dup)).isInstanceOf(BusinessException.class);
    }

    @Test void deactivate() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any())).thenReturn(entity);
        service.deactivate(1L);
        assertThat(entity.getFlagEstado()).isEqualTo("0");
    }

    @Test void delete() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        service.delete(1L);
    }
}
