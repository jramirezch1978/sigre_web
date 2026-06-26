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
import pe.restaurant.core.entity.NumTablas;
import pe.restaurant.core.repository.NumTablasRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class NumTablasServiceImplTest {

    @Mock private NumTablasRepository repository;
    @InjectMocks private NumTablasServiceImpl service;

    private NumTablas entity;

    @BeforeEach
    void setUp() {
        entity = new NumTablas();
        entity.setNombreTabla("orden_compra");
        entity.setCodOrigen("XX");
        entity.setUltimoNumero(0L);
    }

    private NumTablas.NumTablasId id() {
        NumTablas.NumTablasId id = new NumTablas.NumTablasId();
        id.setNombreTabla("orden_compra");
        id.setCodOrigen("XX");
        return id;
    }

    @Test void findAll() {
        when(repository.findAll(PageRequest.of(0, 20))).thenReturn(new PageImpl<>(List.of(entity)));
        assertThat(service.findAll(PageRequest.of(0, 20)).getContent()).hasSize(1);
    }

    @Test void findByIdNotFound() {
        when(repository.findById(any())).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.findById(id())).isInstanceOf(ResourceNotFoundException.class);
    }

    @Test void createSuccess() {
        when(repository.findById(any())).thenReturn(Optional.empty());
        when(repository.save(entity)).thenReturn(entity);
        assertThat(service.create(entity)).isNotNull();
    }

    @Test void createDuplicate() {
        when(repository.findById(any())).thenReturn(Optional.of(entity));
        assertThatThrownBy(() -> service.create(entity)).isInstanceOf(BusinessException.class);
    }

    @Test void update() {
        when(repository.save(entity)).thenReturn(entity);
        assertThat(service.update(entity)).isNotNull();
    }

    @Test void delete() {
        when(repository.findById(any())).thenReturn(Optional.of(entity));
        service.delete(id());
    }
}
