package pe.restaurant.core.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.entity.Marca;
import pe.restaurant.core.repository.MarcaRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class MarcaServiceImplTest {

    @Mock private MarcaRepository repository;
    @InjectMocks private MarcaServiceImpl service;

    private Marca entity;

    @BeforeEach
    void setUp() {
        entity = new Marca();
        entity.setId(1L);
        entity.setCodigo("M001");
        entity.setNombre("Marca uno");
        entity.setFlagEstado("1");
    }

    @Test void findAll() {
        when(repository.findAll(PageRequest.of(0, 20))).thenReturn(new PageImpl<>(List.of(entity)));
        assertThat(service.findAll(PageRequest.of(0, 20)).getContent()).hasSize(1);
    }

    @Test void findByIdFound() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        assertThat(service.findById(1L).getCodigo()).isEqualTo("M001");
    }

    @Test void findByIdNotFound() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.findById(99L)).isInstanceOf(ResourceNotFoundException.class);
    }

    @Test void create() {
        when(repository.save(entity)).thenReturn(entity);
        assertThat(service.create(entity)).isNotNull();
    }

    @Test void update() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any())).thenReturn(entity);
        assertThat(service.update(1L, entity)).isNotNull();
    }

    @Test void activate() {
        entity.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any())).thenReturn(entity);
        service.activate(1L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
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
